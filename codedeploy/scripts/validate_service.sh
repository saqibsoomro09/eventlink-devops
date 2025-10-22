#!/usr/bin/env bash
set -euo pipefail

# Prefer localhost so SG rules don't interfere
curl -fsS http://127.0.0.1/health | grep -q '"status":"ok"'

# Tiny smoke test
resp="$(curl -fsS -X POST http://127.0.0.1/add -H 'Content-Type: application/json' -d '{"a":2,"b":3}')"
echo "Add response: $resp"
echo "$resp" | grep -q '"result":5'
