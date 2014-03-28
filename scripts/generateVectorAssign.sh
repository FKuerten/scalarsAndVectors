#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail


COMBINATIONS="x y z xy xz yx yz zx zy xyz xzy yxz yzx zxy zyx"
for C1 in ${COMBINATIONS}; do
    if [[ ${C1} =~ z ]]; then
        N1="3"
    elif [[ ${C1} =~ y ]]; then
        N1="2"
    else
        N1="1"
    fi    
    echo "#if (#{N}>=${N1}) begin"
    L1="${#C1}"
    #echo "C1=${C1}; L1=${L1}; N1=${N1}" >&2
    notFirst=""
    for C2 in ${COMBINATIONS}; do
        if [[ ${C2} =~ z ]]; then
            N2="3"
        elif [[ ${C2} =~ y ]]; then
            N2="2"
        else
            N2="1"
        fi
        L2="${#C2}"
        if [[ ${L1} == ${L2} ]]; then
            if [ $notFirst ] ; then echo ""; fi
            echo "    // assign ${C2} to ${C1}"
            for (( j=N2; j <= 3; j++ )); do        
                echo "    public void assign$(tr "a-z" "A-Z" <<<${C2})To$(tr "a-z" "A-Z" <<<${C1})(Vector${j}<T> v) {"
                for (( i=0; i < L1; i++ )); do
                    echo -e "        this.${C1:$i:1} = v.${C2:$i:1};"
                done
                echo "    }"
                true
            done
            notFirst="1"
        fi
    done
    echo '#end'
    echo ""
done
