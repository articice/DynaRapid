#!/usr/bin/env bash
# Compiles DynaRapid into build/classes/java/main (the class path of the scripts) against the
# RapidWright checkout one level up (../bin, ../jars). gradlew no longer works: it expects
# RapidWright as a submodule, which this fork doesn't carry.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$ROOT/build/classes/java/main"
javac -nowarn -encoding UTF-8 -d "$ROOT/build/classes/java/main" -cp "$ROOT/../bin:$ROOT/../jars/*" \
    $(find "$ROOT/src" -name '*.java') 2>&1 | grep -v '^Note:' || true
echo "compiled $(find "$ROOT/build/classes/java/main" -name '*.class' | wc -l) classes"
