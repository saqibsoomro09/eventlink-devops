#!/usr/bin/env bash
set -euo pipefail

cd /opt/eventlink

# System-wide install is fine for this small app (keeps scripts simple)
python3 -m pip install -r requirements.txt

# Make sure ec2-user can read/write app dir (logs, etc.)
chown -R ec2-user:ec2-user /opt/eventlink
