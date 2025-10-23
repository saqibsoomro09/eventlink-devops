#!/usr/bin/env bash
set -euo pipefail
echo "===== VALIDATE SERVICE ====="

ATTEMPTS=30
SLEEP=2

for i in $(seq 1 "$ATTEMPTS"); do
  if curl -fsS http://127.0.0.1/health | grep -q '"status":"ok"'; then
    echo "Health check succeeded!"
    exit 0
  fi
  echo "Waiting for app to become healthy... (attempt $i/$ATTEMPTS)"
  sleep "$SLEEP"
done

echo "Health check failed — app not responding on :80"
sudo systemctl --no-pager --full status eventlink || true
echo "----- last gunicorn log lines -----"
sudo tail -n 200 /var/log/eventlink/gunicorn.log || true
exit 1
