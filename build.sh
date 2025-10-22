#!/usr/bin/env bash
set -euo pipefail

: "${BUCKET:?Set BUCKET to your S3 bucket name (e.g., eventlink-artifacts)}"

TS="$(date +'%Y-%m-%d_%H-%M-%S')"
BUILD_NUM="${BUILD_NUM:-01}"
OUTDIR="releases"
ZIP="${OUTDIR}/${TS}_build-${BUILD_NUM}.zip"

mkdir -p "${OUTDIR}"

# Clean bytecode
find app -name '__pycache__' -type d -prune -exec rm -rf {} + || true

# Create the bundle (app + codedeploy/* only)
zip -rq "${ZIP}" app/ codedeploy/

# Upload to S3 (requires AWS CLI configured on Build EC2)
aws s3 cp "${ZIP}" "s3://${BUCKET}/releases/$(basename "${ZIP}")"

echo "Artifact uploaded: s3://${BUCKET}/releases/$(basename "${ZIP}")"
