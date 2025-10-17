#!/usr/bin/env bash
set -euo pipefail
cd /opt/eventlink/app
# Ensure Python + pip
if ! command -v pip3 >/dev/null 2>&1; then
  sudo yum -y install python3-pip || sudo dnf -y install python3-pip
fi
sudo pip3 install -r requirements.txt
