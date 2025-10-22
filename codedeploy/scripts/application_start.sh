#!/usr/bin/env bash
set -euo pipefail

# Create a hardened systemd unit binding to :80 (non-root allowed via CAP_NET_BIND_SERVICE)
cat >/etc/systemd/system/eventlink.service <<'UNIT'
[Unit]
Description=EventLink Flask via Gunicorn
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/eventlink
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
Environment=PYTHONUNBUFFERED=1
# NOTE: gunicorn is typically at /usr/local/bin when installed via pip
ExecStart=/usr/local/bin/gunicorn --workers 2 --bind 0.0.0.0:80 wsgi:app
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable eventlink
systemctl restart eventlink
