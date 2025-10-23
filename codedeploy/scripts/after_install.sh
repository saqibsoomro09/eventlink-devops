#!/usr/bin/env bash
set -euo pipefail
echo "=== AFTER INSTALL: Python deps ==="

cd /opt/eventlink

# DO NOT upgrade pip here (that caused the failure).
# Install only your dependencies. On AL2023, --break-system-packages is needed.
# If your pip is older and doesn't know the flag, the second command will still work.
if python3 -m pip --version | grep -q "pip 2[3-9]"; then
  python3 -m pip install -r app/requirements.txt --no-cache-dir --break-system-packages
else
  python3 -m pip install -r app/requirements.txt --no-cache-dir
fi

# Ensure runtime ownership + logs (optional, harmless if they already exist)
chown -R ec2-user:ec2-user /opt/eventlink
mkdir -p /var/log/eventlink
chown ec2-user:ec2-user /var/log/eventlink

echo "=== AFTER INSTALL: done ==="
