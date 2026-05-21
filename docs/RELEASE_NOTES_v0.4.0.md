# Release notes — v0.4.0 (letta-vision-deploy)

**Theme:** Cross-turn image context persistence in the LLM request path.

## Stack pairing

| Component | Source | Image tag |
|-----------|--------|-----------|
| Server | `letta-vision@v0.4.0` | `letta-vision:v0.4.0` or `letta-vision:latest` |
| Client | `letta-vision-client@v0.3.0+` (no client changes required) | `build: ../letta-vision-client` |

## Upgrade

```bash
cd letta-vision && git checkout v0.4.0 && docker build -t letta-vision:v0.4.0 -t letta-vision:latest .
cd ../letta-vision-deploy && docker compose up -d --build
```

Set `LETTA_VERSION=0.4.0` in `.env` (default in compose).

## Operator notes

- Image-bearing conversations resend all historical inline images on every turn; expect super-linear token growth on long visual threads.
- No proxy or UI changes required for this release.
