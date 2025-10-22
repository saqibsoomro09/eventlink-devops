#!/usr/bin/env bash
set -euo pipefail

# Create / update systemd unit (non-root bind to :80 with caps)
cat >/etc/systemd/system/eventlink.service <<'UNIT'
[Unit]
Description=EventLink Flask via Gunicorn
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/eventlink
# Allow non-root to bind privileged port 80
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/gunicorn --workers 2 --bind 0.0.0.0:80 wsgi:app
Restart=always
RestartSec=2
TimeoutStartSec=30

[Install]
WantedBy=multi-user.target
UNIT

# Reload systemd and (re)start the service
systemctl daemon-reload
systemctl enable eventlink
systemctl restart eventlink
