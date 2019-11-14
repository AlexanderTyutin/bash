#!/bin/bash
SCAN_DIR=${PWD}
for i in "$@"
do
	case $i in
		-ir=*)
		SCAN_DIR=${PWD}/"${i#*=}"
		shift
		;;
	esac
done

echo ${SCAN_DIR}

docker run --rm -it -v ${SCAN_DIR}:/opt/mount:ro alexandertyutin/phpcs
