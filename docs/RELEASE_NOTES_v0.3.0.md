# Release notes — v0.3.0 (letta-vision-deploy)

**Theme:** Compose stack pairing for vision v0.3.0.

## Stack versions

| Component | Tag | Notes |
|-----------|-----|-------|
| Server image | Build from `letta-vision@v0.3.0` | Tag `letta-vision:latest` or `letta-vision:v0.3.0` |
| Client | Build from `letta-vision-client@v0.3.0` | `build: ../letta-vision-client` |
| Database | unchanged | pgvector/pg16 |

## Recommended `.env` for vision

```env
LETTA_LLM_REQUEST_TIMEOUT_SECONDS=300
LETTA_LLM_STREAM_TIMEOUT_SECONDS=600
```

## Full upgrade

```bash
cd letta-vision && git checkout v0.3.0 && docker build -t letta-vision:v0.3.0 -t letta-vision:latest .
cd ../letta-vision-client && git checkout v0.3.0
cd ../letta-vision-deploy && git checkout v0.3.0
docker compose up -d --build --force-recreate
```

## Endpoints

| Service | URL |
|---------|-----|
| Web UI | http://localhost:8284 |
| Letta API | http://localhost:8283 |

See [letta-vision implementation report](../../letta-vision/docs/IMPLEMENTATION_REPORT_v0.3.0_vision-support.md) for verification checklist.
