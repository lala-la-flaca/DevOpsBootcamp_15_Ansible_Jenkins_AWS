#!/usr/bin/env bash
set -euo pipefail
echo 'running script'

# Packages
apt-get update -y
apt-get install -y ansible python3-boto3 python3-botocore unzip curl jq

# SSH key perms (assumes Jenkins copied it to /root)
chmod 400 /root/ssh-key.pem || true

ansible --version

# Install AWS CLI if missing
if ! command -v aws &>/dev/null; then
    echo "Installing AWS CLI v2..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip -o /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install --update
fi

#Creating credentials file
mkdir -p ~/.aws
chmod 700 ~/.aws

# ensure AWS keys are provided
if [[ -z "${AWS_ACCESS_KEY_ID:-}" || -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
  echo "ERROR: AWS credentials are not set"
  exit 1
fi

# create credentials file
cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOF
chmod 600 ~/.aws/credentials

# create aws comfig file
cat > ~/.aws/config <<EOF
[default]
region = us-east-2
output = json
EOF
chmod 600 ~/.aws/config

echo "✅ AWS credentials configured"

#Checking AWS CLI
echo "Checking AWS CLI"
aws --version
aws sts get-caller-identity

echo "✅ AWS credentials configured"