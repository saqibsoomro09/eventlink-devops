#!/usr/bin/env bash
set -euo pipefail
sudo yum -y update || sudo dnf -y update
sudo yum -y install ruby wget || sudo dnf -y install ruby wget
cd /tmp
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
wget https://aws-codedeploy-${REGION}.s3.${REGION}.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent
sudo systemctl status codedeploy-agent --no-pager || true
