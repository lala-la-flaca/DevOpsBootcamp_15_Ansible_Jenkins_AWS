#!/usr/bin/env bash
echo 'running script'
apt update
apt install ansible -y
apt install python3-boto3 