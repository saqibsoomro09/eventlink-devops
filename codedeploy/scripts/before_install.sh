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
  # Avoid curl conflicts on AL2023: allow resolver to replace/skip if needed
  dnf -y install python3 python3-pip || true
  dnf -y install --setopt=install_weak_deps=False --allowerasing --skip-broken curl || true
else
  yum -y update
  # Same idea for older distros
  yum -y install python3 python3-pip || true
  yum -y install --skip-broken curl || true
fi

# Upgrade pip to avoid old resolver issues
python3 -m pip install --upgrade pip
