#!/usr/bin/env bash
# Makes a legacy DOT written by Dynamatic cb9b2ee6b (export-dot --mode=legacy) parseable by DynaRapid.
# usage: fixup_dot.sh <in.dot> <out.dot>
#
# - style="filled, dotted": DynaRapid splits attributes on every comma, quotes or not, and dies on
#   this one (StringIndexOutOfBoundsException in DotString.removeQuotes). The style is cosmetic.
# - trunci: DynaRapid widens every data channel to 32 bits, so an integer truncation becomes the
#   identity. Its library's trunc_op is the floating-point truncf (an HLS core), not a bit
#   truncation, so the node is mapped to sext_op 32->32, which is the identity.
set -euo pipefail
in=${1:?usage: fixup_dot.sh <in.dot> <out.dot>}
out=${2:?usage: fixup_dot.sh <in.dot> <out.dot>}
sed -e 's/style="filled, dotted"/style="filled"/' \
    -e '/^ *"trunci[0-9]*" \[/s/op="trunc_op"/op="sext_op"/' "$in" > "$out"
if grep -q 'op="trunc_op"' "$out"; then echo "fixup_dot: a trunc_op is left in $out" >&2; exit 1; fi
