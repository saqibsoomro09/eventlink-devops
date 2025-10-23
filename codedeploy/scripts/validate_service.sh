#!/usr/bin/env bash
set -euo pipefail
echo "===== VALIDATE SERVICE ====="

# Retry check to give Gunicorn time to start
for i in {1..5}; do
  if curl -fsS http://127.0.0.1/health | grep -q '"status":"ok"'; then
    echo "Health check succeeded!"
    exit 0
  fi
  echo "Waiting for app to become healthy... (attempt $i)"
  sleep 3
done

echo "Health check failed — app not responding on port 80."
sudo systemctl status eventlink --no-pager || true
exit 1
