#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${BUCKET:-}" ]]; then
  echo "Set BUCKET env var to your S3 bucket (e.g., eventlink-artifacts)"; exit 1
fi

TS=$(date +"%Y-%m-%d_%H-%M-%S")
ART="releases/${TS}_build-01.zip"
mkdir -p releases

zip -r "$ART" app/ codedeploy/ -x "__pycache__/*" "*.pyc"
aws s3 cp "$ART" "s3://${BUCKET}/${ART}" --only-show-errors

echo "Artifact uploaded: s3://${BUCKET}/${ART}"
echo "Use this exact key in CodeDeploy for Test, then promote the SAME key to Prod."
