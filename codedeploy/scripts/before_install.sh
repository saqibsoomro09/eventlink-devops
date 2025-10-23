#!/usr/bin/env bash
set -euo pipefail
echo "===== BEFORE INSTALL STARTED ====="

# Stop the app if it's running (ignore errors)
sudo systemctl stop eventlink 2>/dev/null || true

# Minimal OS prep (avoid wide updates during deploys)
sudo dnf install -y python3 python3-pip

# Make sure target dirs exist
sudo mkdir -p /opt/eventlink
sudo mkdir -p /var/log/eventlink
sudo chown -R ec2-user:ec2-user /opt/eventlink /var/log/eventlink

echo "===== BEFORE INSTALL COMPLETED ====="
