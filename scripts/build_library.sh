#!/usr/bin/env bash
#
# Builds the DynaRapid component library for one part, one component at a time.
#
#   scripts/build_library.sh <part> <variants.txt> [workers]
#
# Two passes over the variant list:
#   pass1: up to PASS1_SHAPES shapes per component, so a usable library exists early
#   pass2: the full shape sweep (as in the published xcvu13p library)
#
# Restartable: finished components are marked in libbuild/<part>/state/<pass>/<name>.done
# and are skipped on the next start. A component that is interrupted mid-way is redone.
# Stop gracefully with:  touch libbuild/<part>/STOP   (workers exit after their current component)
#
set -u

PART=${1:?usage: build_library.sh <part> <variants.txt> [workers]}
VARIANTS=${2:?usage: build_library.sh <part> <variants.txt> [workers]}
WORKERS=${3:-2}
PASS1_SHAPES=${PASS1_SHAPES:-3}
MIN_FREE_MEM_GB=${MIN_FREE_MEM_GB:-10}
JAVA_HEAP=${JAVA_HEAP:-6G}

ROOT=$(cd "$(dirname "$0")/.." && pwd)
BUILD=$ROOT/libbuild/$PART${BUILD_TAG:+-$BUILD_TAG}   # BUILD_TAG: separate state for a second build
CP="$ROOT/build/classes/java/main:$ROOT/../bin:$ROOT/../jars/*"
LIBDIR=$ROOT/library/placedRoutedDCPs/$PART-0.1.1

mkdir -p "$BUILD/state" "$BUILD/logs"
cp "$VARIANTS" "$BUILD/variants.txt"

log() { echo "$(date '+%F %T') $*" | tee -a "$BUILD/build.log"; }

java_run() { # <worker dir> <logfile> <class> <args...>
    local wdir=$1 logf=$2 cls=$3; shift 3
    (cd "$wdir" && java -Xmx$JAVA_HEAP -cp "$CP" "ch.agsl.dynarapid.entry.$cls" "$@" -part "$PART") >> "$logf" 2>&1
}

wait_for_memory() {
    while true; do
        local free_gb=$(( $(awk '/MemAvailable/ {print $2}' /proc/meminfo) / 1024 / 1024 ))
        [ "$free_gb" -ge "$MIN_FREE_MEM_GB" ] && return
        sleep 60
    done
}

# Picks the next component of a pass that is neither done nor claimed; prints nothing when the pass is exhausted
claim_next() { # <pass>
    local pass=$1
    (
        flock 9
        while read -r name; do
            [ -z "$name" ] && continue
            [ -e "$BUILD/state/$pass/$name.done" ] && continue
            [ -e "$BUILD/state/$pass/$name.claimed" ] && continue
            [ -e "$BUILD/state/$pass/$name.failed" ] && continue
            touch "$BUILD/state/$pass/$name.claimed"
            echo "$name"
            break
        done < "$BUILD/variants.txt"
    ) 9> "$BUILD/state/queue.lock"
}

cleanup_component() { # <name> <worker dir>
    local name=$1 wdir=$2
    rm -rf "$ROOT/exposedDCPs/$PART/$name" "$ROOT/library/pre-exposedDCPs/$PART/$name"
    rm -f "$LIBDIR/$name"/*.report
    # Vivado scratch in the worker directory (.Xil, hd_visual, journals)
    find "$wdir" -mindepth 1 -delete 2>/dev/null
}

build_component() { # <worker id> <pass> <name>
    local wid=$1 pass=$2 name=$3
    local wdir=$BUILD/work/w$wid logf=$BUILD/logs/$pass/$name.log
    mkdir -p "$wdir" "$BUILD/logs/$pass"
    : > "$logf"
    local t0=$(date +%s)

    if [ ! -e "$ROOT/library/vhdlSynthDCPs/$PART/${name}_synth.dcp" ] && [ ! -e "$ROOT/library/genericSynthDCPs/$PART/${name}_synth.dcp" ]; then
        java_run "$wdir" "$logf" GenerateSynthesis -m "$name" -vhdl
        if [ ! -e "$ROOT/library/vhdlSynthDCPs/$PART/${name}_synth.dcp" ]; then
            log "w$wid $pass $name FAILED synthesis (see $logf)"; return 1
        fi
    fi

    local num_args=()
    [ "$pass" = pass1 ] && num_args=(-num "$PASS1_SHAPES")
    java_run "$wdir" "$logf" GeneratePblocks -m "$name" -r "${num_args[@]}"

    local shapes=$(ls "$LIBDIR/$name"/*_placedRouted.dcp 2>/dev/null | wc -l)
    if [ "$shapes" -eq 0 ]; then
        cleanup_component "$name" "$wdir"
        log "w$wid $pass $name FAILED: no placed and routed shapes (see $logf)"; return 1
    fi

    java_run "$wdir" "$logf" GenerateDatabase -m "$name"
    if [ ! -e "$LIBDIR/$name.data" ]; then
        cleanup_component "$name" "$wdir"
        log "w$wid $pass $name FAILED database (see $logf)"; return 1
    fi

    cleanup_component "$name" "$wdir"
    gzip -f "$logf"
    log "w$wid $pass $name done: $shapes shapes in $(( ($(date +%s) - t0) / 60 )) min, library $(du -sh "$LIBDIR" | cut -f1), disk free $(df -h --output=avail "$ROOT" | tail -1 | tr -d ' ')"
}

worker() { # <worker id>
    local wid=$1
    for pass in pass1 pass2; do
        mkdir -p "$BUILD/state/$pass"
        while true; do
            [ -e "$BUILD/STOP" ] && { log "w$wid stopping (STOP file present)"; return; }
            wait_for_memory
            local name=$(claim_next "$pass")
            [ -z "$name" ] && break
            log "w$wid $pass $name started"
            if build_component "$wid" "$pass" "$name"; then
                touch "$BUILD/state/$pass/$name.done"
            else
                touch "$BUILD/state/$pass/$name.failed"
            fi
            rm -f "$BUILD/state/$pass/$name.claimed"
        done
        # pass2 starts only once every worker has finished pass1, so the early library is complete first
        while ls "$BUILD/state/$pass/"*.claimed >/dev/null 2>&1; do sleep 60; done
    done
    log "w$wid finished"
}

# Claims left over from an interrupted run are redone
rm -f "$BUILD"/state/pass*/*.claimed
rm -f "$BUILD/STOP"
log "build started: part=$PART workers=$WORKERS pass1_shapes=$PASS1_SHAPES variants=$(grep -c . "$BUILD/variants.txt")"
for w in $(seq 1 "$WORKERS"); do
    worker "$w" &
    sleep 5
done
wait
log "build finished"
