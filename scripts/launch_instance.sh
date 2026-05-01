# Use following command to launch an instance with this script:
# ./scripts/launch_instance.sh WebServer1 <SubnetId> ./userdata/default-server.txt

#!/bin/bash

AMI_ID="ami-0157bd2f091f051ea"
INSTANCE_TYPE="t3.micro"
KEY_NAME="feb-key-2026"
SECURITY_GROUP_ID="sg-0101da3fd62783adb"

INSTANCE_NAME="$1"
SUBNET_ID="$2"
USERDATA_PATH="$3"

if [ -z "$INSTANCE_NAME" ] || [ -z "$SUBNET_ID" ] || [ -z "$USERDATA_PATH" ]; then
  echo "Usage: $0 <InstanceName> <SubnetId> <UserDataFilePath>"
  exit 1
fi

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --subnet-id "$SUBNET_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME},{Key=Purpose,Value=Training}]" \
    --user-data file://"$USERDATA_PATH" \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Instance created with ID: $INSTANCE_ID"
