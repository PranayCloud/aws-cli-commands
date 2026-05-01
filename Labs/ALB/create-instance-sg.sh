#!/bin/bash

VPC_ID="$1"
ALB_SG_ID="$2"

if [ -z "$VPC_ID" ] || [ -z "$ALB_SG_ID" ]; then
  echo "Usage: ./create-instance-sg.sh <VPC_ID> <ALB_SG_ID>"
  exit 1
fi

SG_ID=$(aws ec2 create-security-group \
--group-name Instance-SG \
--description "Security Group for Instances - Allow HTTP from ALB only" \
--vpc-id $VPC_ID \
--query 'GroupId' \
--output text)

echo "Instance Security Group created with ID: $SG_ID"

aws ec2 authorize-security-group-ingress \
--group-id $SG_ID \
--protocol tcp \
--port 80 \
--source-group $ALB_SG_ID

echo "HTTP Port 80 enabled from ALB Security Group only"
echo $SG_ID
