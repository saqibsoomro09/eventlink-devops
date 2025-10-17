#!/usr/bin/env bash
set -euo pipefail

# Systemd unit for gunicorn
sudo tee /etc/systemd/system/eventlink.service >/dev/null <<'UNIT'
[Unit]
Description=EventLink Flask app
After=network.target

[Service]
# Simpler for the lab to bind to :80; in production you'd avoid running as root
User=root
WorkingDirectory=/opt/eventlink/app
ExecStart=/usr/bin/gunicorn -w 2 -b 0.0.0.0:80 wsgi:application
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
UNIT

sudo systemctl daemon-reload
sudo systemctl enable eventlink
sudo systemctl start eventlink
sleep 2
sudo systemctl status eventlink --no-pager || true
