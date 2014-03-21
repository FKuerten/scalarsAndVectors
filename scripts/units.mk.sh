#!/usr/bin/env bash

echo 'DUMMY:=$(print $(shell mkdir --parent --verbose target/generated))'
TEMPLATE="scripts/units.mk.template"

while read MEASURE UNIT TYPE; do
    sed < ${TEMPLATE} --expression="s!#MEASURE#!${MEASURE}!g" \
                      --expression="s!#UNIT#!${UNIT}!g" \
                      --expression="s!#TYPE#!${TYPE}!g"
done < target/units
