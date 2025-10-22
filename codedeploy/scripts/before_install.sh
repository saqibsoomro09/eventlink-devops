#!/usr/bin/env bash
set -euo pipefail

# Stop service if it exists; don't fail if it's not installed yet
systemctl stop eventlink.service || true

# Refresh metadata (fast if fresh)
dnf -y makecache

# If you truly need full curl, swap it in; otherwise skip this whole block.
if rpm -q curl-minimal >/dev/null 2>&1; then
  dnf -y swap curl-minimal curl || dnf -y install --allowerasing curl
fi

# Core tools you probably need; remove curl here if you swapped above
dnf -y install python3 python3-pip python3-virtualenv unzip

# Ensure app dir exists (matches your appspec destination)
mkdir -p /opt/eventlink

# Make sure lifecycle scripts are executable (in case the bundle perms changed)
chmod +x /opt/eventlink/codedeploy/scripts/*.sh || true
