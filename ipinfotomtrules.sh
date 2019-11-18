#!/bin/bash
IFILE=${PWD}
for i in "$@"
do
        case $i in
                -if=*)
                IFILE=${PWD}/"${i#*=}"
                shift
                ;;
                -list=*)
                LIST="${i#*=}"
                shift
                ;;
                -comment=*)
                COMMENT="${i#*=}"
                shift
                ;;
        esac
done

for i in `cat ${IFILE} | cut -d ' ' -f 1`; do
        echo /ip firewall address-list add list=${LIST} address=$i comment=\"${COMMENT}\"
done
