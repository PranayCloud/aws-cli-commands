# =============================================================
# 🛑 Script Name: terminate-instance.sh
#
# 🎯 Purpose:
# This script terminates a specific EC2 instance using the
# Instance ID provided by the user.
#
# =============================================================

#!/bin/bash
aws ec2 terminate-instances --instance-ids $1