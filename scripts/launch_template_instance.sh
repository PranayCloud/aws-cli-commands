# ▶️ Usage:
# ./scripts/launch_template_instance.sh <LaunchTemplateId> <InstanceCount>

# 📥 Parameters:
# LaunchTemplateId  → Existing Launch Template ID from AWS
# InstanceCount     → Number of EC2 instances to launch

#!/bin/bash
LAUNCH_TEMPLATE_ID="$1"
COUNT="$2"

aws ec2 run-instances --launch-template LaunchTemplateId=$LAUNCH_TEMPLATE_ID --count $COUNT --output text --query 'Instances[*].InstanceId' | while read INSTANCE_ID; do
    echo "Instance created with ID: $INSTANCE_ID"
done