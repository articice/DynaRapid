#!/usr/bin/env bash
# Progress of scripts/build_library.sh:  scripts/library_status.sh <part>
PART=${1:-xcvu9p}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BUILD=$ROOT/libbuild/$PART
LIBDIR=$ROOT/library/placedRoutedDCPs/$PART-0.1.1
total=$(grep -c . "$BUILD/variants.txt" 2>/dev/null || echo 0)

for pass in pass1 pass2; do
    d=$BUILD/state/$pass
    printf '%s: %3d/%d done, %d failed, in progress: %s\n' "$pass" \
        "$(ls "$d"/*.done 2>/dev/null | wc -l)" "$total" \
        "$(ls "$d"/*.failed 2>/dev/null | wc -l)" \
        "$(ls "$d"/*.claimed 2>/dev/null | xargs -rn1 basename | sed 's/\.claimed$//' | tr '\n' ' ')"
done
echo "shapes built: $(ls "$LIBDIR"/*/*_placedRouted.dcp 2>/dev/null | wc -l)   library size: $(du -sh "$LIBDIR" 2>/dev/null | cut -f1)   disk free: $(df -h --output=avail "$ROOT" | tail -1 | tr -d ' ')"
echo "build scratch: $(du -sh "$ROOT/exposedDCPs/$PART" "$ROOT/library/pre-exposedDCPs/$PART" "$BUILD/work" 2>/dev/null | awk '{print $2": "$1}' | xargs)"
echo "running: $(pgrep -fc 'build_library.sh') build processes, $(pgrep -fc '^timeout -k 60 3600 vivado') vivado runs"
ls "$BUILD"/state/pass*/*.failed 2>/dev/null | xargs -rn1 basename | sed 's/\.failed$//' | sed 's/^/FAILED: /'
echo "--- last events"
tail -n 8 "$BUILD/build.log" 2>/dev/null
