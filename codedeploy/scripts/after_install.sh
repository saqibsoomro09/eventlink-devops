#!/usr/bin/env bash
set -euo pipefail

cd /opt/eventlink

# Install Python deps (system site for simplicity)
python3 -m pip install --upgrade pip
python3 -m pip install -r app/requirements.txt

# Ensure runtime ownership
chown -R ec2-user:ec2-user /opt/eventlink

# Create log directory used by systemd/gunicorn and (optionally) CloudWatch
mkdir -p /var/log/eventlink
chown ec2-user:ec2-user /var/log/eventlink
