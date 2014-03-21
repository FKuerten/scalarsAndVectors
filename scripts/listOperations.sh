#!/usr/bin/env bash

cat data/relations | \
while read LHS RHS; do
    #echo -e "\e[1mWorking on \"${LHS} ${RHS}\"\e[0m" >&2
    echo -en "${LHS}\t"
    echo "${RHS}"

    IFS="/" read POSITIVES NEGATIVES <<< "${RHS}"
    IFS="*" read -a POS <<< "${POSITIVES}"
    IFS="*" read -a NEG <<< "${NEGATIVES}"
    for POSITIVE in "${POS[@]}"; do
        echo -en "${POSITIVE}\t"
        echo -en "${LHS}"
        echo -en "*"
        echo -en "${NEGATIVES}"
        echo -en "/"
        for POSITIVE2 in "${POS[@]}"; do
            if [ "${POSITIVE2}" != "${POSITIVE}" ]; then
                echo -en "${POSITIVE2}"
            fi
        done
        echo
    done
    for NEGATIVE in "${NEG[@]}"; do
        echo -en "${NEGATIVE}\t"
        echo -en "${POSITIVES}"
        echo -en "/"
        echo -en "${LHS}*"
        for NEGATIVE2 in "${NEG[@]}"; do
            if [ "${NEGATIVE2}" != "${NEGATIVE}" ]; then
                echo -en "${NEGATIVE2}"
            fi
        done
    echo
    done
done | \
while read LHS RHS; do
    #echo -e "\e[1mWorking on \"${LHS} ${RHS}\"\e[0m" >&2
    echo -en "${LHS}\t"
    <<< ${RHS} sed --expression='s!\*/!/!' \
                   --expression='s!\*$!!' \
                   --expression='s!/$!!'
done | sort --unique
