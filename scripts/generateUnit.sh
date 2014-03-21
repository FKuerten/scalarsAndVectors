#!/usr/bin/env bash
MEASURE="$1"
UNIT="$2"
TYPE="$3"

findType() {
    MEASURE="$1"
    < target/units grep -E "^${MEASURE}" | awk '{print $3}'
}

MAIN_TEMPLATE="templates/${TYPE}.java"

TEMP_A=$(mktemp)
trap "rm ${TEMP_A}" EXIT

<${MAIN_TEMPLATE} \
sed --expression="s!Scalar<T>!${MEASURE}Scalar!g" \
    --expression="s!Vector3<T>!${MEASURE}Vector3!g" \
>${TEMP_A}

<${TEMP_A} awk '$0 ~ "// BEGIN_OPERATIONS" { exit } { print }'

<target/operations grep "${MEASURE}" | \
while read LHS RHS; do
    #echo $LHS $RHS >&2
    IFS="/" read POSITIVES NEGATIVES <<< "${RHS}"
    #echo $LHS $POSITIVES $NEGATIVES >&2
    if [ -z "${NEGATIVES}" ]; then
        # Must be one of positive
        if [[ ${POSITIVES} == *${MEASURE}* ]]; then
            POSITIVE=$(<<< "${POSITIVES}" sed --expression "s!${MEASURE}\*!!" --expression "s!\*${MEASURE}!!")
            #echo "Working with $LHS $RHS" >&2
            OTHER_TYPE=$(findType $POSITIVE)
            #echo "$TYPE $OTHER_TYPE" >&2
            if [ "${TYPE}" == "Vector3" ] && [ "${OTHER_TYPE}" == "Scalar" ]; then
                TEMPLATE="templates/multiplyVector3Scalar.java"
            elif [ "${TYPE}" == "Scalar" ] && [ "${OTHER_TYPE}" == "Vector3" ]; then
                TEMPLATE="templates/multiplyScalarVector3.java"
            elif [ "${TYPE}" == "Scalar" ] && [ "${OTHER_TYPE}" == "Scalar" ]; then
                TEMPLATE="templates/multiplyScalarScalar.java"
            else
                continue
            fi
            sed --expression="s!ReturnType!${LHS}${TYPE}!g" \
                --expression="s!OtherType!${POSITIVE}${OTHER_TYPE}!g" \
                --expression="s!^!    !" \
                ${TEMPLATE}
        fi
    elif [ "${POSITIVES}" == "${MEASURE}" ]; then
        echo "Have negative $NEGATIVES" >&2
        OTHER_TYPE=$(findType $NEGATIVES)
        echo "Own type: ${TYPE}, other type ${OTHER_TYPE}" >&2
        if [ "${TYPE}" == "Vector3" ] && [ "${OTHER_TYPE}" == "Scalar" ]; then
            TEMPLATE="templates/divideVector3Scalar.java"
        elif [ "${TYPE}" == "Scalar" ] && [ "${OTHER_TYPE}" == "Vector3" ]; then
            continue
        elif [ "${TYPE}" == "Scalar" ] && [ "${OTHER_TYPE}" == "Scalar" ]; then
            TEMPLATE="templates/divideScalarScalar.java"
        else
            continue
        fi
        echo "$TEMPLATE" >&2
        sed --expression="s!ReturnType!${LHS}${TYPE}!g" \
            --expression="s!OtherType!${NEGATIVES}${OTHER_TYPE}!g" \
            --expression="s!^!    !" \
            ${TEMPLATE}
    fi
done

<${TEMP_A} awk 'doPrint { print } $0 ~ "// END_OPERATIONS" { doPrint=1 }'
