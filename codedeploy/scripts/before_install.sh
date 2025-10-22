#!/usr/bin/env bash
set -euo pipefail

# Stop old service if present (ignore errors)
systemctl stop eventlink || true

# Ensure target dir exists and owned by runtime user
mkdir -p /opt/eventlink
chown -R ec2-user:ec2-user /opt/eventlink

# Keep OS current; Amazon Linux 2023 uses dnf
if command -v dnf >/dev/null 2>&1; then
  dnf -y update
  dnf -y install python3 python3-pip curl
else
  yum -y update
  yum -y install python3 python3-pip curl
fi

# Upgrade pip to avoid old resolver issues
python3 -m pip install --upgrade pip
