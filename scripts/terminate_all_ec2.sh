#!/bin/bash

echo "Fetching all EC2 instances..."

INSTANCE_IDS=$(aws ec2 describe-instances \
  --query 'Reservations[].Instances[].InstanceId' \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
  echo "No EC2 instances found."
  exit 0
fi

echo "The following instances will be terminated:"
echo "$INSTANCE_IDS"
echo ""

read -p "Are you sure you want to terminate ALL instances? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Operation cancelled."
  exit 1
fi

echo "Terminating instances..."

aws ec2 terminate-instances --instance-ids $INSTANCE_IDS

echo "Termination command sent."
