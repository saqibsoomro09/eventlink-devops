#!/usr/bin/env bash
set -euo pipefail

# Retry helper (waits for service warm-up)
retry() {
  local n=0 max=10 delay=2
  until [ $n -ge $max ]; do
    "$@" && return 0
    n=$((n+1))
    sleep $delay
  done
  return 1
}

echo "Probing /health ..."
retry curl -fsS http://127.0.0.1/health | grep -q '"status":"ok"'
echo "Health OK"

echo "Smoke test /add ..."
resp="$(curl -fsS -X POST http://127.0.0.1/add -H 'Content-Type: application/json' -d '{"a":2,"b":3}')"
echo "Add response: $resp"
echo "$resp" | grep -q '"result":5'
echo "Validation passed"
