#!/bin/bash

# Enable scan on push for all aws repositories via aws cli
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html

for REPO in `aws ecr describe-repositories --page-size 1000 --output text | awk '{print $6}'`; do
	aws ecr put-image-scanning-configuration --repository-name $REPO --image-scanning-configuration scanOnPush=true --region us-east-2
done

# ---------------------------------------------------------

# Check results of images vulnerability scanning

TAGS="dev test prod"

for REPO in `aws ecr describe-repositories --page-size 1000 --output text | awk '{print $6}'`; do
	for TAG in $TAGS; do
		aws ecr describe-image-scan-findings --repository-name $REPO --image-id imageTag=$TAG --output text 2>/dev/null 1>/dev/null
		if [ $? -ne 0 ]; then
			# If no results - request scanning
			aws ecr start-image-scan --repository-name $REPO --image-id imageTag=$TAG --region us-east-2 2>/dev/null
		else
			# If there are results - show with formatting
			echo $REPO:$TAG Image Vulnerabilities:
			aws ecr describe-image-scan-findings --repository-name $REPO --image-id imageTag=$TAG --output text 2>/dev/null | \
				grep -oe 'CVE.*$' || echo '!!! CONGRATULATIONS! NO VULNERABILITIES HERE !!!'
			echo '------------------------------' && echo ''
		fi
	done
done
# --------------------------------------------------------
