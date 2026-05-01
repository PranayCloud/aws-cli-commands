#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI not found. Please install AWS CLI first."
    exit 1
fi

# Take user input
read -p "Enter VPC ID: " VPC_ID
read -p "Enter Security Group Name: " SG_NAME
read -p "Enter Source Security Group ID (Allowed for Port 80): " SOURCE_SG_ID

# Create Security Group
echo "Creating Security Group..."

SG_ID=$(aws ec2 create-security-group \
    --group-name "$SG_NAME" \
    --description "Security group created via shell script" \
    --vpc-id "$VPC_ID" \
    --query 'GroupId' \
    --output text)

# Check if created successfully
if [ -z "$SG_ID" ]; then
    echo "Failed to create Security Group."
    exit 1
fi

echo "Security Group Created Successfully!"
echo "Security Group ID: $SG_ID"





# Add inbound rule for HTTP
echo "Adding HTTP rule (Port 80)..."
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 80 \
    --source-group "$SOURCE_SG_ID"

echo "Inbound rules added successfully!"

echo "Done 🚀"