# EventLink DevOps Pipeline – Three Environments (Dev → Test → Prod)

This repo implements the pipeline described in our Project Brief:
build once → upload versioned bundle to S3 → deploy with CodeDeploy to **Test** → manual promotion to **Prod**.
Health is proved with `/health` and a smoke test on `/add`. Later evolution adds `/subtract` to show an automated redeploy path. :contentReference[oaicite:6]{index=6}

## Endpoints
- `GET /health` → `{"status":"ok"}`
- `POST /add`      body: `{"a":2,"b":3}`
- `POST /subtract` body: `{"a":7,"b":4}` (Level 4 evolution)  :contentReference[oaicite:7]{index=7}

## Build & Artifact
```bash
export BUCKET=eventlink-artifacts
bash build.sh
# Result: s3://eventlink-artifacts/releases/YYYY-MM-DD_HH-MM-SS_build-01.zip
