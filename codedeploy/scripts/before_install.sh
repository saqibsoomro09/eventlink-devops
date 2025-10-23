#!/bin/bash
set -e
echo "===== BEFORE INSTALL STARTED ====="

# Clean cache
sudo dnf clean all -y

# Update safely without touching curl
sudo dnf update -y --exclude=curl* --exclude=curl-minimal*

# Install only what's needed for Python
sudo dnf install -y python3 python3-pip

# Ensure app directory exists
sudo mkdir -p /home/ec2-user/eventlink
sudo chown -R ec2-user:ec2-user /home/ec2-user/eventlink

echo "===== BEFORE INSTALL COMPLETED SUCCESSFULLY ====="
