# Release notes — v0.5.0 (letta-vision-deploy)

**Theme:** Letta Vision stack v0.5.0 — three-tier file memory, chat recovery, provider UI.

## Stack pairing

| Component | Source | Image tag |
|-----------|--------|-----------|
| Server | `letta-vision@v0.5.0` | `letta-vision:v0.5.0` or `letta-vision:latest` |
| Client | `letta-vision-client@v0.5.0` | `build: ../letta-vision-client` |

## Upgrade

```bash
cd letta-vision && git checkout v0.5.0 && docker build -t letta-vision:v0.5.0 -t letta-vision:latest .
cd ../letta-vision-client && git checkout v0.5.0
cd ../letta-vision-deploy && git checkout v0.5.0
# Update .env: LETTA_VERSION=0.5.0
docker compose up -d --build
```

After first boot with v0.5.0 server:

```bash
docker exec letta-vision python scripts/refresh_letta_v1_system_prompts.py
# Optional headline backfill:
docker exec letta-vision python scripts/backfill_file_core_blocks.py
```

Set `LETTA_VERSION=0.5.0` in `.env` (default in compose).

## Operator notes

- Migration `f1a2b3c4d5e6` runs on server start — requires PostgreSQL with pgvector (existing stack).
- `MODEL_OVERRIDES_PATH=/data/shared/model_overrides.json` — place custom model overrides in `./shared/`.
- File headlines appear in every agent's system prompt for attached folders; token use scales with file count.
- Chat stream recovery requires client v0.5.0 (not v0.4.0 alone).

## Release notes (components)

- [letta-vision RELEASE_NOTES_v0.5.0](../../letta-vision/docs/RELEASE_NOTES_v0.5.0.md)
- [letta-vision-client RELEASE_NOTES_v0.5.0](../../letta-vision-client/docs/RELEASE_NOTES_v0.5.0.md)
