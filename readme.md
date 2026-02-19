📌 Prerequisites

Before running this scripts, make sure the following are already configured in your AWS account:

1️⃣ Install AWS CLI

Check if AWS CLI is installed:

aws --version


If not installed, install it:

sudo apt update
sudo apt install awscli -y

2️⃣ Configure AWS Credentials

Run:

aws configure


Provide:

AWS Access Key ID:
AWS Secret Access Key:
Default region name: ap-south-1
Default output format: json


👉 Use ap-south-1 (Mumbai) since your AMI belongs to this region.

Verify:

aws sts get-caller-identity
