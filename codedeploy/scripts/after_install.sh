#!/usr/bin/env bash
set -euo pipefail
echo "=== AFTER INSTALL: start ==="

cd /opt/eventlink

# 1) Python deps (don't upgrade pip here)
# On AL2023, pip may require --break-system-packages; use it if supported.
if python3 -m pip --version | grep -Eq 'pip 2[3-9]\.'; then
  python3 -m pip install -r app/requirements.txt --no-cache-dir --break-system-packages
else
  python3 -m pip install -r app/requirements.txt --no-cache-dir
fi

# 2) Make sure 'app' is a package (so `app.wsgi:app` imports cleanly)
touch /opt/eventlink/app/__init__.py || true

# 3) Ensure gunicorn is where systemd ExecStart expects it
# (When installed via pip it is often in /usr/local/bin on AL2023.)
if [ -x /usr/local/bin/gunicorn ] && [ ! -x /usr/bin/gunicorn ]; then
  ln -sf /usr/local/bin/gunicorn /usr/bin/gunicorn
fi

# 4) Prepare log directory & file for gunicorn/systemd
mkdir -p /var/log/eventlink
touch /var/log/eventlink/gunicorn.log
chown -R ec2-user:ec2-user /var/log/eventlink /opt/eventlink
chmod 755 /var/log/eventlink || true

echo "=== AFTER INSTALL: done ==="
