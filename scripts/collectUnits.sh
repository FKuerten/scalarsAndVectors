#!/usr/bin/env bash

export TEMP_FILE=$(mktemp)
trap "rm ${TEMP_FILE}" EXIT

cat data/baseUnits > ${TEMP_FILE}

getUnit() {
    MEASURE="$1"
    <${TEMP_FILE} grep -E "^${MEASURE}" | awk '{ print $2}'
}

getType() {
    MEASURE="$1"
    <${TEMP_FILE} grep -E "^${MEASURE}" | awk '{ print $3}'
}

< data/relations cat | \
while read LHS RHS; do
    POSITIVE_UNITS=""
    NEGATIVE_UNITS=""
    TYPE="Scalar"
    #echo "Working on $LHS $RHS" >&2
    IFS="/" read POSITIVES NEGATIVES <<< "${RHS}"
    IFS="*" read -a POS <<< "${POSITIVES}"
    IFS="*" read -a NEG <<< "${NEGATIVES}"
    for POSITIVE in "${POS[@]}"; do
        #echo -e "\t\tworking on ${POSITIVE}" >&2
        SUB_UNIT=$(getUnit ${POSITIVE})
        IFS="/" read SUB_UNIT_POSITIVES SUB_UNIT_NEGATIVES <<< "${SUB_UNIT}"
        POSITIVE_UNITS="${POSITIVE_UNITS}*${SUB_UNIT_POSITIVES}"
        NEGATIVE_UNITS="${NEGATIVE_UNITS}*${SUB_UNIT_NEGATIVES}"
        SUB_TYPE=$(getType ${POSITIVE})
        if [ "${TYPE}" == "Vector3" ] && [ "${SUB_TYPE}" == "Vector3" ]; then
            TYPE="Scalar"
        elif [ "${TYPE}" == "Scalar" ] && [ "${SUB_TYPE}" == "Vector3" ]; then
            TYPE="Vector3"
        elif [ "${TYPE}" == "Vector3" ] && [ "${SUB_TYPE}" == "Scalar" ]; then
            TYPE="Vector3"
        elif [ "${TYPE}" == "Scalar" ] && [ "${SUB_TYPE}" == "Scalar" ]; then
            TYPE="Scalar"
        fi
    done
    for NEGATIVE in "${NEG[@]}"; do
        #echo -e "\t\tworking on ${POSITIVE}" >&2
        SUB_UNIT=$(getUnit ${NEGATIVE})
        IFS="/" read SUB_UNIT_POSITIVES SUB_UNIT_NEGATIVES <<< "${SUB_UNIT}"
        POSITIVE_UNITS="${POSITIVE_UNITS}*${SUB_UNIT_NEGATIVES}"
        NEGATIVE_UNITS="${NEGATIVE_UNITS}*${SUB_UNIT_POSITIVES}"
        SUB_TYPE=$(getType ${NEGATIVE})
        if [ "${TYPE}" == "Vector3" ] && [ "${SUB_TYPE}" == "Vector3" ]; then
            exit 1
        elif [ "${TYPE}" == "Scalar" ] && [ "${SUB_TYPE}" == "Vector3" ]; then
            exit 1
        elif [ "${TYPE}" == "Vector3" ] && [ "${SUB_TYPE}" == "Scalar" ]; then
            TYPE="Vector3"
        elif [ "${TYPE}" == "Scalar" ] && [ "${SUB_TYPE}" == "Scalar" ]; then
            TYPE="Scalar"
        fi
    done

    POSITIVE_UNITS=$(<<<${POSITIVE_UNITS} sed --expression='s!\*\*!\*!g' --expression='s!^\*!!' --expression='s!\*$!!')
    NEGATIVE_UNITS=$(<<<${NEGATIVE_UNITS} sed --expression='s!\*\*!\*!g' --expression='s!^\*!!' --expression='s!\*$!!')
    echo -e "${LHS}\t${POSITIVE_UNITS}/${NEGATIVE_UNITS}\t${TYPE}" >>${TEMP_FILE}
done

cat ${TEMP_FILE}
