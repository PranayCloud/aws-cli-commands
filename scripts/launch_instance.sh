#!/bin/bash

AMI_ID="ami-0157bd2f091f051ea"
INSTANCE_TYPE="t3.micro"
KEY_NAME="feb-key-2026"
SECURITY_GROUP_ID="sg-0101da3fd62783adb"
INSTANCE_NAME="$1"
# USERDATA_PATH="$3"

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SECURITY_GROUP_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE_NAME"},{Key=Purpose,Value=Training}]" \
    # --user-data file://$USERDATA_PATH \
    --output text --query 'Instances[0].InstanceId')

echo "Instance created with ID: $INSTANCE_ID"

aws ec2 create-tags --resources $INSTANCE_ID --tags Key=AppName,Value=Linux_Server
