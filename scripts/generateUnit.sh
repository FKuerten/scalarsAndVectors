#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

PACKAGE_JAVA="$1"
MEASURE="$2"
UNIT="$3"
TYPE="$4"

findType() {
    MEASURE="$1"
    < target/units grep -E "^${MEASURE}" | awk '{print $3}'
}

MAIN_TEMPLATE="target/${TYPE}.java"

TEMP_A=$(mktemp)
trap "rm ${TEMP_A}" EXIT

<${MAIN_TEMPLATE} \
sed --expression="s!#PACKAGE_JAVA#!${PACKAGE_JAVA}!g" \
    --expression="s!Scalar<T>!${MEASURE}Scalar!g" \
    --expression="s!Vector1<T>!${MEASURE}Vector1!g" \
    --expression="s!Vector2<T>!${MEASURE}Vector2!g" \
    --expression="s!Vector3<T>!${MEASURE}Vector3!g" \
>${TEMP_A}

<${TEMP_A} awk '$0 ~ "// BEGIN_OPERATIONS" { exit } { print }'

printMethod() {
    R="$1"
    T="$2"
    S="$3"
    TEMPLATE="$4"
    if [[ ! -f ${TEMPLATE} ]]; then
        echo "File not found: ${TEMPLATE}" >&2
        exit 3
    fi
    sed --expression="s!Scalar<R>!${R}Scalar!g" \
        --expression="s!Vector1<R>!${R}Vector1!g" \
        --expression="s!Vector2<R>!${R}Vector2!g" \
        --expression="s!Vector3<R>!${R}Vector3!g" \
        --expression="s!Scalar<T>!${T}Scalar!g" \
        --expression="s!Vector1<T>!${T}Vector1!g" \
        --expression="s!Vector2<T>!${T}Vector2!g" \
        --expression="s!Vector3<T>!${T}Vector3!g" \
        --expression="s!Scalar<S>!${S}Scalar!g" \
        --expression="s!Vector1<S>!${S}Vector1!g" \
        --expression="s!Vector2<S>!${S}Vector2!g" \
        --expression="s!Vector3<S>!${S}Vector3!g" \
        --expression="s!^!    !" \
        ${TEMPLATE}
}

(<target/operations grep "${MEASURE}" || true) | \
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
            if   [[ ${TYPE} =~ Vector. ]]  && [ "${OTHER_TYPE}" == "Scalar" ]; then
                printMethod ${LHS} ${MEASURE} ${POSITIVE} "templates/multiply${TYPE}Scalar.java"
            elif [ "${TYPE}" == "Scalar" ] && [ "${OTHER_TYPE}" == "Vector" ]; then
                printMethod ${LHS} ${MEASURE} ${POSITIVE} "templates/multiplyScalarVector2.java"
                printMethod ${LHS} ${MEASURE} ${POSITIVE} "templates/multiplyScalarVector3.java"
            elif [ "${TYPE}" == "Scalar" ] && [ "${OTHER_TYPE}" == "Scalar" ]; then
                printMethod ${LHS} ${MEASURE} ${POSITIVE} "templates/multiplyScalarScalar.java"
            elif [[ ${TYPE} =~ Vector. ]]  && [ "${OTHER_TYPE}" == "Vector" ]; then
                #echo "Error (mult): Own type is ${TYPE} other type is Vector" >&2
                #echo "This can be done, with a scalar multiplication. >&2
                printMethod ${LHS} ${MEASURE} ${POSITIVE} "templates/dotMultiply${TYPE}${TYPE}.java"
            else
                echo "Error (mult): Own type is ${TYPE} other type is ${OTHER_TYPE}" >&2
                exit 1
            fi
        fi
    elif [ "${POSITIVES}" == "${MEASURE}" ]; then
        #echo "Have negative $NEGATIVES" >&2
        OTHER_TYPE=$(findType $NEGATIVES)
        #echo "Own type: ${TYPE}, other type ${OTHER_TYPE}" >&2
        if   [[ ${TYPE} =~ Vector. ]]  && [ "${OTHER_TYPE}" == "Scalar" ]; then
            printMethod ${LHS} ${MEASURE} ${NEGATIVES} "templates/divide${TYPE}Scalar.java"
        elif [[ ${TYPE} =~ Vector. ]]  && [ "${OTHER_TYPE}" == "Vector" ]; then
            #echo "Error (div): Own type is ${TYPE} other type is ${OTHER_TYPE}" >&2
            #echo "To be precise: We are talking about dividing a ${MEASURE} vector by a ${NEGATIVES} vector." >&2
            # This is only solvable if they are parallel
            true
        elif [ "${TYPE}" == "Scalar" ] && [ "${OTHER_TYPE}" == "Scalar" ]; then
            printMethod ${LHS} ${MEASURE} ${NEGATIVES} "templates/divideScalarScalar.java"
        elif [ "${TYPE}" == "Scalar" ] && [ "${OTHER_TYPE}" == "Vector" ]; then
            #echo "Error (div): Own type is Scalar other type is Vector" >&2
            #echo "To be precise: We are talking about dividing a ${MEASURE} scalar by a ${NEGATIVES} vector." >&2
            #echo "That can't be done, as the result is ambigous." >&2
            #exit 2
            true
        else
            echo "Error (div): Own type is ${TYPE} other type is ${OTHER_TYPE}" >&2
            exit 1
        fi
    fi
done

<${TEMP_A} awk 'doPrint { print } $0 ~ "// END_OPERATIONS" { doPrint=1 }'
