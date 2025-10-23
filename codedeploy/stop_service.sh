#!/usr/bin/env bash
set -euo pipefail
if systemctl is-active --quiet eventlink; then
  systemctl stop eventlink
fi
