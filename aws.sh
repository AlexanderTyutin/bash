#!/bin/bash

# Enable scan on push for all aws repositories via aws cli
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html

for REPO in `aws ecr describe-repositories --page-size 1000 --output text | awk '{print $6}'`; do
	aws ecr put-image-scanning-configuration --repository-name $REPO --image-scanning-configuration scanOnPush=true --region us-east-2
done

# ---------------------------------------------------------
