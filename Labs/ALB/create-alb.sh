#!/bin/bash

ALB_NAME="$1"
SUBNETS="$2"
ALB_SG_ID="$3"
VPC_ID="$4"
DEFAULT_INSTANCE="$5"
DATA_INSTANCE="$6"
IMAGES_INSTANCE="$7"

if [ -z "$ALB_NAME" ] || [ -z "$SUBNETS" ] || [ -z "$ALB_SG_ID" ] || [ -z "$VPC_ID" ] || [ -z "$DEFAULT_INSTANCE" ] || [ -z "$DATA_INSTANCE" ] || [ -z "$IMAGES_INSTANCE" ]; then
  echo "Usage: ./create-alb.sh <ALB_NAME> <SUBNETS> <ALB_SG_ID> <VPC_ID> <DEFAULT_INSTANCE> <DATA_INSTANCE> <IMAGES_INSTANCE>"
  exit 1
fi

echo "Creating Default Target Group..."
DEFAULT_TG_ARN=$(aws elbv2 create-target-group \
--name default-tg \
--protocol HTTP \
--port 80 \
--vpc-id $VPC_ID \
--query 'TargetGroups[0].TargetGroupArn' \
--output text)

echo "Creating Data Target Group..."
DATA_TG_ARN=$(aws elbv2 create-target-group \
--name data-tg \
--protocol HTTP \
--port 80 \
--vpc-id $VPC_ID \
--query 'TargetGroups[0].TargetGroupArn' \
--output text)

echo "Creating Images Target Group..."
IMAGES_TG_ARN=$(aws elbv2 create-target-group \
--name images-tg \
--protocol HTTP \
--port 80 \
--vpc-id $VPC_ID \
--query 'TargetGroups[0].TargetGroupArn' \
--output text)

echo "Registering instances to target groups..."
aws elbv2 register-targets --target-group-arn $DEFAULT_TG_ARN --targets Id=$DEFAULT_INSTANCE
aws elbv2 register-targets --target-group-arn $DATA_TG_ARN --targets Id=$DATA_INSTANCE
aws elbv2 register-targets --target-group-arn $IMAGES_TG_ARN --targets Id=$IMAGES_INSTANCE

echo "Creating Application Load Balancer..."
ALB_ARN=$(aws elbv2 create-load-balancer \
--name $ALB_NAME \
--subnets $SUBNETS \
--security-groups $ALB_SG_ID \
--scheme internet-facing \
--type application \
--query 'LoadBalancers[0].LoadBalancerArn' \
--output text)

echo "ALB ARN: $ALB_ARN"

echo "Creating Listener with default action..."
LISTENER_ARN=$(aws elbv2 create-listener \
--load-balancer-arn $ALB_ARN \
--protocol HTTP \
--port 80 \
--default-actions Type=forward,TargetGroupArn=$DEFAULT_TG_ARN \
--query 'Listeners[0].ListenerArn' \
--output text)

echo "Adding /data path rule..."
aws elbv2 create-rule \
--listener-arn $LISTENER_ARN \
--priority 1 \
--conditions Field=path-pattern,Values='/data*' \
--actions Type=forward,TargetGroupArn=$DATA_TG_ARN

echo "Adding /images path rule..."
aws elbv2 create-rule \
--listener-arn $LISTENER_ARN \
--priority 2 \
--conditions Field=path-pattern,Values='/images*' \
--actions Type=forward,TargetGroupArn=$IMAGES_TG_ARN

echo "ALB Setup Complete!"
aws elbv2 describe-load-balancers --load-balancer-arns $ALB_ARN --query 'LoadBalancers[0].DNSName' --output text
