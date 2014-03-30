#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

TEMPLATE="scripts/units.mk.template"
PACKAGE_FOLDER="de/sitl/dev/units/"
PACKAGE_JAVA="de.sitl.dev.units"
echo "DUMMY:=\$(print \$(shell mkdir --parent --verbose target/generated/${PACKAGE_FOLDER}))"

echo -n "ALL_UNITS:="
cat target/units \
| while read MEASURE UNIT TYPES; do
    for TYPE in ${TYPES//,/ }; do
        if [ "${TYPE}" == "Vector" ]; then
            echo -n "target/generated/${PACKAGE_FOLDER}${MEASURE}Vector3.java "
            echo -n "target/generated/${PACKAGE_FOLDER}${MEASURE}Vector2.java "
            echo -n "target/generated/${PACKAGE_FOLDER}${MEASURE}Vector1.java "
        else
            echo -n "target/generated/${PACKAGE_FOLDER}${MEASURE}Scalar.java "
        fi
    done
done
echo ""

doUnit() {
    MEASURE="$1"
    UNIT="$2"
    TYPE="$3"
    sed < ${TEMPLATE} --expression="s!#PACKAGE_FOLDER#!${PACKAGE_FOLDER}!g" \
                      --expression="s!#PACKAGE_JAVA#!${PACKAGE_JAVA}!g" \
                      --expression="s!#MEASURE#!${MEASURE}!g" \
                      --expression="s!#UNIT#!${UNIT}!g" \
                      --expression="s!#TYPE#!${TYPE}!g"
}

cat target/units \
| while read MEASURE UNIT TYPES; do
    for TYPE in ${TYPES//,/ }; do
        if [ "${TYPE}" == "Vector" ]; then
            doUnit ${MEASURE} ${UNIT} Vector3
            doUnit ${MEASURE} ${UNIT} Vector2
            doUnit ${MEASURE} ${UNIT} Vector1
        else
            doUnit ${MEASURE} ${UNIT} Scalar
        fi
    done
done
