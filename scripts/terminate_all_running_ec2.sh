# =============================================================
# 🧹 Script Name: terminate_all_running_ec2.sh
#
# 🎯 Purpose:
# This script will terminate ALL running EC2 instances in the
# configured AWS region using AWS CLI.
#
# ⚠ WARNING:
# This will terminate EVERY running EC2 instance in your AWS
# account within the configured region (ap-south-1).
#
# Use this script ONLY for LAB CLEANUP at the end of the session
# to avoid AWS usage charges.
#
# =============================================================

#!/bin/bash

# Get all running instance IDs
INSTANCE_IDS=$(aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].InstanceId" \
    --output text)

# Check if any running instances exist
if [ -z "$INSTANCE_IDS" ]; then
    echo "No running instances found."
else
    echo "Terminating the following running instances:"
    echo "$INSTANCE_IDS"

    aws ec2 terminate-instances --instance-ids $INSTANCE_IDS

    echo "Termination initiated."
fi
