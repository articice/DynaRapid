#!/usr/bin/env bash
# Regression test: the pin-exposure harness as DynaRapid builds it today.
#
# Builds netecho's 17-store MC in shape I60_J39_R7_C6 from its synthesized checkpoint through the
# library build's own stage 1 (entry/ExposeShape → Pblock: Circular harness, exposed place and
# route, repair), every file under a scratch root, then compares the shape with the MC's VHDL
# (scripts/shape_cosim.py). With a harness that ties all input exposure flops to one signal, Vivado
# rewired this shape and it lost store 16's arbiter request (2026-11-07, see ../exposure_rewiring).
# Pass: no equivalent driver rewiring in the exposed placement and 0 mismatches.
#
# usage: run.sh [work dir]      exit 0 on pass
set -o pipefail
T=$(realpath "$(dirname "$0")"); DR=$(realpath "$T/../../..")
W=$(realpath -m "${1:-$(mktemp -d /tmp/exposure_harness.XXXXXX)}"); rm -rf "$W/root"; mkdir -p "$W"
U=mem_controller_ADDR_TYPE_i4_DATA_TYPE_i32_NUM_CONTROLS_2_NUM_LOADS_1_NUM_STORES_17
CP="$DR/build/classes/java/main:$DR/../bin:$DR/../jars/*"

(cd "$DR" && java -Xmx6G -cp "$CP" ch.agsl.dynarapid.entry.ExposeShape -part xcvu9p -m $U \
    -shape 60 39 7 6 -synth "$T/fixture" -root "$W/root") > "$W/expose.log" 2>&1
dcp=$(sed -n 's/^SHAPE //p' "$W/expose.log")
[ -n "$dcp" ] || { echo "FAIL exposure_harness: the shape was not built (see $W/expose.log)"; exit 1; }
case "$dcp" in "$W"/root/*) ;; *) echo "FAIL exposure_harness: shape written outside the test root: $dcp"; exit 2;; esac

report=$(ls "$W"/root/exposedDCPs/xcvu9p/$U/*_I60_J39_R7_C6.report)
rew=$(grep -m1 '|  Equivalent Driver Rewiring' "$report" | awk -F'|' '{gsub(/ /,"",$3); gsub(/ /,"",$4); print $3"/"$4}')
c=$(python3 "$DR/scripts/shape_cosim.py" "$dcp" --unit $U --vhdl "$T/fixture/$U.vhd" --work "$W/cosim" 2>&1)
rc=$?
[ $rc = 2 ] && { echo "FAIL exposure_harness: cosim could not run: $c"; exit 2; }
mm=$(grep -oE '[0-9]+ mismatches' <<< "$c" | grep -oE '^[0-9]+')
echo "rewiring (added/removed cells) ${rew:-none}, ${mm} mismatches against the VHDL"
if [ "${rew:-0/0}" = 0/0 ] && [ "$mm" = 0 ]; then echo "PASS exposure_harness"; exit 0; fi
echo "FAIL exposure_harness (work: $W)"; exit 1
