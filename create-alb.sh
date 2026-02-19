#!/bin/bash

# Variables
ALB_NAME="my-application-lb"
SUBNETS="subnet-xxxxxx subnet-yyyyyy"  # Replace with your subnet IDs (minimum 2 in different AZs)
SECURITY_GROUP="sg-xxxxxxxxx"  # Replace with your security group ID
VPC_ID="vpc-xxxxxxxxx"  # Replace with your VPC ID
TARGET_GROUP_NAME="my-target-group"
REGION="ap-south-1"

echo "Creating Target Group..."
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
    --name $TARGET_GROUP_NAME \
    --protocol HTTP \
    --port 80 \
    --vpc-id $VPC_ID \
    --region $REGION \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)

echo "Target Group ARN: $TARGET_GROUP_ARN"

echo "Creating Application Load Balancer..."
ALB_ARN=$(aws elbv2 create-load-balancer \
    --name $ALB_NAME \
    --subnets $SUBNETS \
    --security-groups $SECURITY_GROUP \
    --scheme internet-facing \
    --type application \
    --ip-address-type ipv4 \
    --region $REGION \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)

echo "ALB ARN: $ALB_ARN"

echo "Creating Listener..."
aws elbv2 create-listener \
    --load-balancer-arn $ALB_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN \
    --region $REGION

echo "ALB created successfully!"
echo "DNS Name:"
aws elbv2 describe-load-balancers \
    --load-balancer-arns $ALB_ARN \
    --region $REGION \
    --query 'LoadBalancers[0].DNSName' \
    --output text
