# Release notes — v0.6.0 (letta-vision-deploy)

**Theme:** Letta Vision stack v0.6.0 — unified embedding, multimodal image memory, hybrid recall, historic uplift GA.

## Stack pairing

| Component | Source | Image tag |
|-----------|--------|-----------|
| Server | `letta-vision@v0.6.0` | `letta-vision:v0.6.0` or `letta-vision:latest` |
| Client | `letta-vision-client@v0.6.0` | `build: ../letta-vision-client` |

## Upgrade

```bash
cd letta-vision && git checkout v0.6.0 && docker build -t letta-vision:v0.6.0 -t letta-vision:latest .
cd ../letta-vision-client && git checkout v0.6.0
cd ../letta-vision-deploy && git checkout v0.6.0
# Update .env: LETTA_VERSION=0.6.0
docker compose up -d --build
```

Run migrations explicitly if the server container was not recreated:

```bash
docker compose run --rm letta-vision alembic upgrade head
```

Expected head: `v063_provider_models_vision` (after `v060`–`v062`).

Set `LETTA_VERSION=0.6.0` in `.env` (default in compose after this release).

### Historic corpus uplift (existing deployments)

If upgrading from pre-v0.6 data with inline base64 images or NULL 768 embeddings, run the uplift CLI after migration — see [letta-vision RELEASE_NOTES_v0.6.0](../../letta-vision/docs/RELEASE_NOTES_v0.6.0.md) and [Historic Uplift FR](../../letta-vision/docs/FR_letta-vision_Historic-Embedding-Uplift_v0.6.0-GA.md) §10.1.

### Post-upgrade checks

```bash
curl -sf http://localhost:8283/v1/health/
# Vision flags (Bearer $LETTA_SERVER_PASSWORD):
curl -sf -H "Authorization: Bearer $LETTA_SERVER_PASSWORD" http://localhost:8283/v1/models/ \
  | jq '.[] | select(.handle | test("deepseek-v4-pro|kimi-k2.6")) | {handle, supports_vision}'
```

## Operator notes

- **MinIO** — object store for image bytes (`letta-vision-minio` + `minio-init` bucket). Set `MINIO_DATA_PATH` for production persistence (see `.env.example` sliver comment).
- **Deployment embedding** — `LETTA_DEFAULT_EMBEDDING_HANDLE=openrouter/google/gemini-embedding-2` (compose default); applies to all agents and folder ingest.
- **Image captions** — `LETTA_IMAGE_CAPTION_MODEL_HANDLE` (default `openrouter/minimax/minimax-m3`).
- **Model overrides** — `MODEL_OVERRIDES_PATH=/data/shared/model_overrides.json`; **client** mount is read-write (Providers vision toggle); **server** mount is read-only.
- **OpenRouter vision** — `openrouter/*` models use OpenRouter `input_modalities` at sync time; remove manual overrides that forced vision on text-only listings.
- **Migrations** — `v062` drops `embedding_legacy_4096`; must ship with matching server ORM (v0.6.0 image).

## Release notes (components)

- [letta-vision RELEASE_NOTES_v0.6.0](../../letta-vision/docs/RELEASE_NOTES_v0.6.0.md)
- [letta-vision-client RELEASE_NOTES_v0.6.0](../../letta-vision-client/docs/RELEASE_NOTES_v0.6.0.md)
