#!/usr/bin/env bash
# Regression test: Vivado's equivalent driver rewiring against the pin-exposure harness.
#
# Found 2026-11-07: Circular ties the D and CE of every input exposure flop to one shared
# inputPort, so to Vivado all of a unit's inputs are one signal. Logic computing the same function
# of different ports then looks equivalent, and place_design's Equivalent Driver Rewiring moves
# loads between the copies. Once the harness is removed the unit no longer matches its VHDL
# (netecho's 17-store MC lost store 16's arbiter request → kernel deadlock).
#
# Fixture: that MC's shape I60_J39_R7_C6 as the harness left it (_connected.dcp), with the build's
# own preRoute/postRoute scripts (file paths removed). Each arm is placed, routed and repaired as
# the library build does it, then compared with the MC's VHDL (scripts/shape_cosim.py):
#   shared    the harness as built. Expected: rewiring, and mismatches. If this arm comes out
#             clean, Vivado's behaviour changed and the test says so.
#   distinct  each input flop on its own input port. Expected: no rewiring, no mismatches.
#
# usage: run.sh [work dir]      exit 0 when both arms behave as expected
set -o pipefail
T=$(realpath "$(dirname "$0")"); DR=$(realpath "$T/../../..")
W=$(realpath -m "${1:-$(mktemp -d /tmp/exposure_rewiring.XXXXXX)}"); mkdir -p "$W"
case "$W/" in "$DR"/library/*|"$DR"/exposedDCPs/*) echo "refusing to work inside the library: $W"; exit 2;; esac
U=mem_controller_ADDR_TYPE_i4_DATA_TYPE_i32_NUM_CONTROLS_2_NUM_LOADS_1_NUM_STORES_17
CELL=${U}_I60_J39_R7_C6_cell
source ~/Xilinx/Vivado/2022.1/settings64.sh > /dev/null

arm() {   # arm <name>: place, route, repair, time; prints "<rewiring added/removed> <WNS in harness> <WNS final>"
    local a=$1 d=$W/$1; mkdir -p "$d"
    {
        echo "open_checkpoint {$T/fixture/connected.dcp}"
        if [ "$a" = distinct ]; then cat <<'TCL'
set n 0
foreach f [get_cells -filter {REF_NAME =~ FD*}] {
    set d [get_pins $f/D]
    if {[get_property NAME [get_nets -of $d]] ne "inputNet"} continue
    disconnect_net -objects $d
    create_port -direction IN distinct_in_$n
    create_net distinct_in_net_$n
    connect_net -net distinct_in_net_$n -objects [list [get_ports distinct_in_$n] $d]
    incr n
}
puts "DISTINCT INPUTS $n"
TCL
        fi
        cat "$T/fixture/preRoute.tcl"
        echo "report_timing_summary -no_header -no_detailed_paths -file {$d/exposed_timing.rpt}"
        sed -n '1,/^remove_port inputPort/p' "$T/fixture/postRoute.tcl"
        [ "$a" = distinct ] && echo 'remove_net [get_nets distinct_in_net_*]; remove_port [get_ports distinct_in_*]'
        sed '1,/^remove_port inputPort/d' "$T/fixture/postRoute.tcl"
        echo "report_timing_summary -no_header -no_detailed_paths -file {$d/final_timing.rpt}"
        echo "write_checkpoint -force {$d/final.dcp}"
    } > "$d/run.tcl"
    (cd "$d" && vivado -mode batch -nojournal -nolog -source run.tcl > vivado.log 2>&1) || { echo "vivado failed: $d/vivado.log"; return 2; }
    grep -q 'nets with routing errors.......... :           0' "$d/vivado.log" || { echo "routing errors: $d/vivado.log"; return 2; }
    wns() { grep -A2 'WNS(ns)' "$1" | sed -n 3p | awk '{print $1}'; }
    echo "$(grep -m1 '|  Equivalent Driver Rewiring' "$d/vivado.log" | awk -F'|' '{gsub(/ /,"",$3); gsub(/ /,"",$4); print $3"/"$4}') $(wns "$d/exposed_timing.rpt") $(wns "$d/final_timing.rpt")"
}

status=0
for a in shared distinct; do
    r=$(arm $a) || { echo "$a: could not run: $r"; exit 2; }
    read -r rew wns_x wns_f <<< "$r"
    c=$(python3 "$DR/scripts/shape_cosim.py" "$W/$a/final.dcp" --unit $U --vhdl "$T/fixture/$U.vhd" --work "$W/$a/cosim" 2>&1)
    rc=$?
    [ $rc = 2 ] && { echo "$a: cosim could not run: $c"; exit 2; }
    mm=$(grep -oE '[0-9]+ mismatches' <<< "$c" | grep -oE '^[0-9]+')
    echo "$a: rewiring (added/removed cells) ${rew:-none}, WNS in harness ${wns_x} ns, final ${wns_f} ns, ${mm} mismatches"
    if [ $a = shared ]; then
        { [ "${rew:-0/0}" != 0/0 ] && [ "$mm" != 0 ]; } || { echo "  UNEXPECTED: the shared harness no longer breaks this shape; Vivado's behaviour changed"; status=1; }
    else
        { [ "${rew:-0/0}" = 0/0 ] && [ "$mm" = 0 ]; } || { echo "  FAIL: distinct harness inputs did not keep the shape correct"; status=1; }
    fi
done
[ $status = 0 ] && echo "PASS exposure_rewiring" || echo "FAIL exposure_rewiring (work: $W)"
exit $status
