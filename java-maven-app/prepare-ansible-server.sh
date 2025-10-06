#!/usr/bin/env bash
set -euo pipefail
echo 'running script'

# Packages
apt-get update -y
apt-get install -y ansible python3-boto3 python3-botocore unzip curl jq


# Install AWS CLI v2 if missing
if ! command -v aws >/dev/null 2>&1; then
  curl -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
  unzip -q awscliv2.zip
  ./aws/install || sudo ./aws/install
  rm -rf aws awscliv2.zip
fi

# Ansible collection for dynamic inventory
ansible-galaxy collection install amazon.aws


# SSH key perms (assumes Jenkins copied it to /root)
chmod 400 /root/ssh-key.pem || true

ansible --version

#Checking AWS CLI
echo "Checking AWS CLI"
aws --version
aws sts get-caller-identity