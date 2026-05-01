#!/bin/bash

AMI_ID="$1"
INSTANCE_TYPE="$2"
SUBNET_ID="$3"
SG_ID="$4"

if [ -z "$AMI_ID" ] || [ -z "$INSTANCE_TYPE" ] || [ -z "$SUBNET_ID" ] || [ -z "$SG_ID" ]; then
  echo "Usage: ./create-alb-instances.sh <AMI_ID> <INSTANCE_TYPE> <SUBNET_ID> <SG_ID>"
  exit 1
fi

echo "Creating Default Server..."
DEFAULT_INSTANCE=$(aws ec2 run-instances \
--image-id $AMI_ID \
--instance-type $INSTANCE_TYPE \
--subnet-id $SUBNET_ID \
--security-group-ids $SG_ID \
--user-data file://alb-instances-userdata/default-server.txt \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Default-Server}]' \
--query 'Instances[0].InstanceId' \
--output text)

echo "Default Server Instance ID: $DEFAULT_INSTANCE"

echo "Creating Data Server..."
DATA_INSTANCE=$(aws ec2 run-instances \
--image-id $AMI_ID \
--instance-type $INSTANCE_TYPE \
--subnet-id $SUBNET_ID \
--security-group-ids $SG_ID \
--user-data file://alb-instances-userdata/data-servers.txt \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Data-Server}]' \
--query 'Instances[0].InstanceId' \
--output text)

echo "Data Server Instance ID: $DATA_INSTANCE"

echo "Creating Images Server..."
IMAGES_INSTANCE=$(aws ec2 run-instances \
--image-id $AMI_ID \
--instance-type $INSTANCE_TYPE \
--subnet-id $SUBNET_ID \
--security-group-ids $SG_ID \
--user-data file://alb-instances-userdata/images-server.txt \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Images-Server}]' \
--query 'Instances[0].InstanceId' \
--output text)

echo "Images Server Instance ID: $IMAGES_INSTANCE"

echo "$DEFAULT_INSTANCE $DATA_INSTANCE $IMAGES_INSTANCE"
