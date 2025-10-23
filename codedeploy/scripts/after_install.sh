#!/usr/bin/env bash
set -euo pipefail

cd /opt/eventlink

echo "=== AFTER INSTALL: Python deps ==="
python3 -m pip install --upgrade pip
python3 -m pip install -r app/requirements.txt

# Ensure package import works: we import app.wsgi (package 'app')
touch /opt/eventlink/app/__init__.py

# Gunicorn is usually in /usr/local/bin on Amazon Linux; systemd unit may use it
if [ -x /usr/local/bin/gunicorn ] && [ ! -x /usr/bin/gunicorn ]; then
  sudo ln -sf /usr/local/bin/gunicorn /usr/bin/gunicorn
fi

# Ensure runtime ownership for logs and code
sudo chown -R ec2-user:ec2-user /opt/eventlink /var/log/eventlink
