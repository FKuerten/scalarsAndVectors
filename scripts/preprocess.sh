#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail
# expecting input on stdin, will output to stdout
TEMP_A=$(mktemp)
TEMP_B=$(mktemp)
trap "rm -f ${TEMP_A} ${TEMP_B} " EXIT INT ABRT

cat > ${TEMP_A}

for i in {1..10}; do
    < ${TEMP_A} \
    ./scripts/preprocess2.awk "$@" \
    > ${TEMP_B}
    if diff --brief ${TEMP_A} ${TEMP_B} >/dev/null ; then
        cat ${TEMP_B}
        exit 0
    else
        #echo "different" >&2
        #diff ${TEMP_A} ${TEMP_B} >&2
        cat ${TEMP_B} > ${TEMP_A}
    fi
done



