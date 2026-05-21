# Release notes — v0.4.0 (letta-vision-deploy)

**Theme:** Letta Vision stack v0.4.0 — cross-turn images, tool UI, MCP, SSE errors.

## Stack pairing

| Component | Source | Image tag |
|-----------|--------|-----------|
| Server | `letta-vision@v0.4.0` | `letta-vision:v0.4.0` or `letta-vision:latest` |
| Client | `letta-vision-client@v0.4.0` | `build: ../letta-vision-client` |

## Upgrade

```bash
cd letta-vision && git checkout v0.4.0 && docker build -t letta-vision:v0.4.0 -t letta-vision:latest .
cd ../letta-vision-client && git checkout v0.4.0
cd ../letta-vision-deploy && docker compose up -d --build
```

Set `LETTA_VERSION=0.4.0` in `.env` (default in compose).

## Operator notes

- Image-bearing conversations resend all historical inline images on every turn; expect super-linear token growth on long visual threads.
- Upstream LLM providers (e.g. OpenRouter) may still timeout or return 502; tune `LETTA_LLM_REQUEST_TIMEOUT_SECONDS` and retry env vars.
- MCP and tool-generated images require client v0.4.0 (not v0.3.0 alone).

## Release notes (components)

- [letta-vision RELEASE_NOTES_v0.4.0](../../letta-vision/docs/RELEASE_NOTES_v0.4.0.md)
- [letta-vision-client RELEASE_NOTES_v0.4.0](../../letta-vision-client/docs/RELEASE_NOTES_v0.4.0.md)
