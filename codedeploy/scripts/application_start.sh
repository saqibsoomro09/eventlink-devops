#!/usr/bin/env bash
set -euo pipefail
echo "===== APPLICATION START ====="

# Write/refresh the systemd unit every deploy (idempotent)
sudo tee /etc/systemd/system/eventlink.service > /dev/null <<'UNIT'
[Unit]
Description=EventLink Flask via Gunicorn
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/eventlink
Environment=PYTHONPATH=/opt/eventlink
# Allow binding to :80 as non-root
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/gunicorn --workers 2 --bind 0.0.0.0:80 \
  --access-logfile /var/log/eventlink/gunicorn.log \
  --error-logfile  /var/log/eventlink/gunicorn.log \
  app.wsgi:app
Restart=always
RestartSec=2
TimeoutStartSec=90

[Install]
WantedBy=multi-user.target
UNIT

sudo systemctl daemon-reload
sudo systemctl enable eventlink
sudo systemctl restart eventlink

# Let gunicorn warm up a touch; ValidateService will do the real wait
sleep 2
echo "===== APPLICATION START COMPLETE ====="
