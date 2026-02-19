#!/bin/bash

# Configuration
VPC_ID="vpc-xxxxxxxxx"  # Replace with your VPC ID
SUBNET1="subnet-xxxxxx"  # Replace with subnet in AZ1
SUBNET2="subnet-yyyyyy"  # Replace with subnet in AZ2
AMI_ID="ami-xxxxxxxxx"  # Replace with Amazon Linux 2 AMI
INSTANCE_TYPE="t2.micro"
ALB_NAME="my-app-lb"

echo "========================================="
echo "Starting ALB Lab Setup"
echo "========================================="

echo "Step 1: Creating ALB Security Group..."
ALB_SG_ID=$(bash create-alb-sg.sh $VPC_ID | tail -1)
echo "ALB Security Group ID: $ALB_SG_ID"

echo "Step 2: Creating Instance Security Group..."
INSTANCE_SG_ID=$(bash create-instance-sg.sh $VPC_ID $ALB_SG_ID | tail -1)
echo "Instance Security Group ID: $INSTANCE_SG_ID"

echo "Step 3: Creating EC2 Instances..."
INSTANCES=$(bash create-alb-instances.sh $AMI_ID $INSTANCE_TYPE $SUBNET1 $INSTANCE_SG_ID | tail -1)
DEFAULT_INSTANCE=$(echo $INSTANCES | awk '{print $1}')
DATA_INSTANCE=$(echo $INSTANCES | awk '{print $2}')
IMAGES_INSTANCE=$(echo $INSTANCES | awk '{print $3}')

echo "Waiting 60 seconds for instances to initialize..."
sleep 60

echo "Step 4: Creating ALB and Target Groups..."
ALB_DNS=$(bash create-alb.sh $ALB_NAME "$SUBNET1 $SUBNET2" $ALB_SG_ID $VPC_ID $DEFAULT_INSTANCE $DATA_INSTANCE $IMAGES_INSTANCE | tail -1)

echo "========================================="
echo "Lab Setup Complete!"
echo "========================================="
echo "ALB DNS: $ALB_DNS"
echo "Test URLs:"
echo "  Default: http://$ALB_DNS"
echo "  Data:    http://$ALB_DNS/data"
echo "  Images:  http://$ALB_DNS/images"
echo "========================================="
