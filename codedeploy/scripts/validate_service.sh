#!/usr/bin/env bash
set -euo pipefail
echo "Validating /health..."
curl -fsS http://localhost/health | grep -q '"ok"'
echo "Health OK"
echo "Validating /add..."
curl -fsS -X POST http://localhost/add -H "Content-Type: application/json" -d '{"a":2,"b":3}' | grep -q '"result":5'
echo "Functional check OK"
