#!/usr/bin/env bash
set -euo pipefail
echo 'running script'

# Packages
apt-get update -y
apt-get install -y ansible python3-boto3 python3-botocore unzip curl jq

echo "Ansible version: "
ansible --version

# Create AWS credentials directory
mkdir -p /root/.aws
chmod 700 /root/.aws