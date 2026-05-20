# Contributing to letta-vision-deploy

This repository provides Docker Compose configuration for a self-hosted Letta Vision stack.

## Related repositories

- **[letta-vision-client](https://github.com/damonreed/letta-vision-client)** — web UI (must be cloned as `../letta-vision-client`).
- **Letta Vision server** — build and tag `letta-vision:latest` from your server source before `docker compose up`.

## Changes in this repo

Appropriate contributions:

- Compose services, health checks, networking
- `db-init` SQL for PostgreSQL extensions
- `.env.example` and README operator documentation (never real secrets)

Application code belongs in **letta-vision-client** or your Letta Vision server repository.

## Pull requests

1. Fork and branch from `main`.
2. Document new environment variables in `.env.example` and [README.md](README.md).
3. Update [CHANGELOG.md](CHANGELOG.md) under **Unreleased** for operator-visible changes.
4. Test on a clean machine: `docker compose config` and `docker compose up -d --build` with a fresh `.env`.

## License

Contributions are licensed under the Apache License 2.0 — see [LICENSE](LICENSE).
