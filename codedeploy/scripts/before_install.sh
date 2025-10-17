#!/usr/bin/env bash
set -euo pipefail
sudo mkdir -p /opt/eventlink/app
# Stop previous service if present (idempotent)
if systemctl list-units --type=service | grep -q eventlink.service; then
  sudo systemctl stop eventlink || true
fi
