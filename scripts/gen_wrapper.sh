#!/usr/bin/env bash
# Writes the per-variant VHDL wrapper DynaRapid's GenerateSynthesis needs (library/vhdlFiles/<variant>.vhd)
# for a one-input, one-output component, by renaming an existing wrapper of the same shape.
# DynaRapid's own wrappers come from an external tool (Dot2RapidWright) that is not in the repository.
# usage: gen_wrapper.sh <template variant> <new variant> <entity> <in width> <out width>
#   e.g. gen_wrapper.sh TEHB_1_1_32_32 OEHB_1_1_32_32 OEHB 32 32
#        gen_wrapper.sh sext_op_1_1_32_32 sext_op_1_1_1_32 sext_op 1 32
# Widths are the variant's; 0-bit (control) channels are 1 bit wide in the wrapper, as in DynaRapid's.
set -euo pipefail
dir=$(cd "$(dirname "$0")/.." && pwd)/library/vhdlFiles
tmpl=${1:?usage}; new=${2:?usage}; ent=${3:?usage}; win=${4:?usage}; wout=${5:?usage}
[ -e "$dir/$new.vhd" ] && { echo "gen_wrapper: $dir/$new.vhd exists, leaving it" >&2; exit 0; }
grep -q "^entity $ent is" "$dir/elastic_components.vhd" "$dir/arithmetic_units.vhd" ||
    { echo "gen_wrapper: no entity $ent in the library sources" >&2; exit 1; }
win=$(( win > 0 ? win : 1 )); wout=$(( wout > 0 ? wout : 1 ))
told=$(sed -n 's/^\([A-Za-z_]*\)_sub: entity work\.\([A-Za-z_]*\)(arch).*/\2/p' "$dir/$tmpl.vhd")
[ -n "$told" ] || { echo "gen_wrapper: $tmpl.vhd is not a single-entity wrapper" >&2; exit 1; }
sed -e "s/\b$tmpl\b/$new/g" \
    -e "s/^${told}_sub: entity work\.$told(arch) generic map ([0-9]*,[0-9]*,[0-9]*,[0-9]*)/${ent}_sub: entity work.$ent(arch) generic map (1,1,$win,$wout)/" \
    -e "s/^\(\tdataInArray_0 :  in std_logic_vector(\)[0-9]* downto 0)/\1$((win - 1)) downto 0)/" \
    -e "s/^\(\tdataOutArray_0 :  out std_logic_vector(\)[0-9]* downto 0)/\1$((wout - 1)) downto 0)/" \
    "$dir/$tmpl.vhd" > "$dir/$new.vhd"
grep -q "${ent}_sub: entity work.$ent(arch) generic map (1,1,$win,$wout)" "$dir/$new.vhd" ||
    { rm -f "$dir/$new.vhd"; echo "gen_wrapper: template $tmpl did not match the expected shape" >&2; exit 1; }
echo "wrote $dir/$new.vhd"
