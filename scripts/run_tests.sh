#!/usr/bin/env bash
# Compiles DynaRapid and its unit tests (test/src) with javac and runs them with the JUnit 5 console
# launcher from RapidWright's jars. usage: scripts/run_tests.sh [ConsoleLauncher options]
set -eo pipefail
DR=$(realpath "$(dirname "$0")/..")
CP="$DR/build/classes/java/main:$DR/../bin:$DR/../jars/*"
cd "$DR"
find src -name '*.java' > build/srcs.txt
javac -nowarn -encoding UTF-8 -cp "$CP" -d build/classes/java/main @build/srcs.txt 2>&1 | grep -v '^Note:' || true
mkdir -p build/classes/java/test
javac -nowarn -encoding UTF-8 -cp "$CP" -d build/classes/java/test $(find test/src -name '*.java')
java -Ddynarapid.test.resources="$DR/test/resources" -cp "$CP:build/classes/java/test" \
    org.junit.platform.console.ConsoleLauncher --disable-banner --details=summary --scan-classpath build/classes/java/test "$@"
