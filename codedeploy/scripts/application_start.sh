#!/usr/bin/env bash
set -euo pipefail
echo "===== APPLICATION START ====="

# Create / update systemd unit
sudo tee /etc/systemd/system/eventlink.service > /dev/null <<'UNIT'
[Unit]
Description=EventLink Flask via Gunicorn
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/eventlink
# Allow non-root to bind to port 80
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/gunicorn --workers 2 --bind 0.0.0.0:80 \
  --access-logfile /var/log/eventlink/gunicorn.log \
  --error-logfile  /var/log/eventlink/gunicorn.log \
  wsgi:app
Restart=always
RestartSec=2
TimeoutStartSec=30

[Install]
WantedBy=multi-user.target
UNIT

# Reload and restart
sudo systemctl daemon-reload
sudo systemctl enable eventlink
sudo systemctl restart eventlink

# Short pause to allow Gunicorn to start fully
sleep 3

echo "===== APPLICATION START COMPLETE ====="
