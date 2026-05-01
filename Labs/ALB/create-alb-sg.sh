#!/bin/bash

VPC_ID="$1"

if [ -z "$VPC_ID" ]; then
  echo "Usage: ./scripts/create_alb_sg.sh <VPC_ID>"
  exit 1
fi

SG_ID=$(aws ec2 create-security-group \
--group-name ALB-SG \
--description "Security Group for ALB - Allow HTTP" \
--vpc-id $VPC_ID \
--query 'GroupId' \
--output text)

echo "Security Group created with ID: $SG_ID"

aws ec2 authorize-security-group-ingress \
--group-id $SG_ID \
--protocol tcp \
--port 80 \
--cidr 0.0.0.0/0

echo "HTTP Port 80 enabled from anywhere (0.0.0.0/0)"
