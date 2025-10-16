#!/usr/bin/env bash
set -euo pipefail
echo 'running script'

# Packages
apt-get update -y
apt-get install -y ansible python3-boto3 python3-botocore unzip curl jq

# SSH key perms (assumes Jenkins copied it to /root)
chmod 400 /root/ssh-key.pem || true

ansible --version

