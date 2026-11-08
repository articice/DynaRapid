#!/usr/bin/env bash
# Synthetic reproduction, from scratch, of Vivado rewiring a unit inside the pin-exposure harness.
#
# fixture/edr_probe.vhd computes the same function of different ports (req(k) = a_valid(k) and
# b_valid(k)) with many loads per copy. It is synthesized as the library build does, then exposed
# in one shape through the library build's own stage 1 (entry/ExposeShape) twice:
#   shared    the old harness (-Ddynarapid.test.sharedExposureInputs=true): every input exposure
#             flop on one signal. Expected: Vivado rewires and the shape no longer matches its
#             VHDL. If it does not, this test cannot detect the problem and fails as such.
#   distinct  the harness as DynaRapid builds it now. Expected: no rewiring, 0 mismatches.
#
# usage: run.sh [work dir] [clock period ns, default 2.5]      exit 0 when both behave as expected
set -o pipefail
T=$(realpath "$(dirname "$0")"); DR=$(realpath "$T/../../..")
W=$(realpath -m "${1:-$(mktemp -d /tmp/exposure_synthetic.XXXXXX)}"); mkdir -p "$W"
P=${2:-2.5}
U=edr_probe
CP="$DR/build/classes/java/main:$DR/../bin:$DR/../jars/*"
source ~/Xilinx/Vivado/2022.1/settings64.sh > /dev/null

# synthesis, as the library build does it (SynthesisTclGenerator): out of context, hierarchy kept
S=$W/synth; mkdir -p "$S"
if [ ! -f "$S/${U}_synth_0_metadata.txt" ]; then
    cat > "$S/synth.tcl" <<TCL
read_vhdl -vhdl2008 {$T/fixture/$U.vhd}
synth_design -mode out_of_context -flatten_hierarchy none -part xcvu9p-fsgd2104-2L-e -top $U
write_checkpoint -force {$S/${U}_synth.dcp}
report_utilization -packthru -file {$S/$U.util}
source $HOME/RapidWright/tcl/rapidwright.tcl
generate_metadata {$S/${U}_synth.dcp} {$S/} 0
TCL
    (cd "$S" && vivado -mode batch -nojournal -nolog -source synth.tcl > synth.log 2>&1) || { echo "synthesis failed: $S/synth.log"; exit 2; }
fi

status=0
for mode in shared distinct; do
    R=$W/$mode; rm -rf "$R"; mkdir -p "$R"
    flag=false; [ $mode = shared ] && flag=true
    (cd "$DR" && java -Xmx4G -Ddynarapid.test.sharedExposureInputs=$flag -Ddynarapid.test.exposureClockPeriod=$P \
        -cp "$CP" ch.agsl.dynarapid.entry.ExposeShape -part xcvu9p -m $U -shape 60 39 7 6 -synth "$S" -root "$R/root") \
        > "$R/expose.log" 2>&1
    dcp=$(sed -n 's/^SHAPE //p' "$R/expose.log")
    [ -n "$dcp" ] || { echo "$mode: the shape was not built (see $R/expose.log)"; exit 2; }
    report=$(ls "$R"/root/exposedDCPs/xcvu9p/$U/*.report)
    rew=$(grep -m1 '|  Equivalent Driver Rewiring' "$report" | awk -F'|' '{gsub(/ /,"",$3); gsub(/ /,"",$4); print $3"/"$4}')
    wns=$(grep 'Estimated Timing Summary' "$report" | tail -1 | grep -oE 'WNS=[-0-9.]+')
    c=$(python3 "$DR/scripts/shape_cosim.py" "$dcp" --unit $U --vhdl "$T/fixture/$U.vhd" --work "$R/cosim" 2>&1)
    [ $? = 2 ] && { echo "$mode: cosim could not run: $c"; exit 2; }
    mm=$(grep -oE '[0-9]+ mismatches' <<< "$c" | grep -oE '^[0-9]+')
    echo "$mode (clock ${P} ns): rewiring (added/removed cells) ${rew:-none}, $wns in harness, $mm mismatches"
    if [ $mode = shared ]; then
        { [ "${rew:-0/0}" != 0/0 ] && [ "$mm" != 0 ]; } || { echo "  NOT SENSITIVE: the old harness did not break this unit, so this test cannot catch the problem"; status=1; }
    else
        { [ "${rew:-0/0}" = 0/0 ] && [ "$mm" = 0 ]; } || { echo "  FAIL: the current harness let Vivado change the unit"; status=1; }
    fi
done
[ $status = 0 ] && echo "PASS exposure_synthetic" || echo "FAIL exposure_synthetic (work: $W)"
exit $status
