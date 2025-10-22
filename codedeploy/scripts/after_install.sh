#!/usr/bin/env bash
set -euo pipefail

cd /opt/eventlink

# Install Python deps (build in system site — simple service)
python3 -m pip install -r requirements.txt

# Ensure runtime ownership
chown -R ec2-user:ec2-user /opt/eventlink
