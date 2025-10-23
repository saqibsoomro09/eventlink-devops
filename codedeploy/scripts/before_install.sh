#!/usr/bin/env bash
set -euo pipefail

# Stop service if it exists; don't fail if not installed yet
systemctl stop eventlink.service || true

# Refresh metadata & update
(yum -y makecache || dnf -y makecache) || true
(yum -y update || dnf -y update) || true

# Ensure core tools
(yum -y install python3 python3-pip python3-virtualenv unzip curl || \
 dnf -y install  python3 python3-pip python3-virtualenv unzip curl)

# Ensure app dir exists (matches appspec destination)
mkdir -p /opt/eventlink

# Make scripts executable if needed after copy
chmod +x /opt/eventlink/codedeploy/scripts/*.sh || true
