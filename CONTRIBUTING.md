# Contributing to letta-stack deploy

This repository holds Compose configuration and database bootstrap scripts for a self-hosted Letta stack.

## Related repositories

- **[letta-vision-client](https://github.com/damonreed/letta-vision-client)** — web UI (clone as sibling `../letta-vision-client` before building).
- **Letta / letta-vision server** — build the `letta-local:latest` image from your server source.

## Changes in this repo

Appropriate contributions here include:

- Compose service definitions, health checks, and networking
- `db-init` SQL for PostgreSQL extensions
- Documentation for environment variables and volumes
- Example `.env.example` updates (never real secrets)

UI features, API routes, and frontend work belong in **letta-vision-client**.

## Pull requests

1. Fork and branch from `main`.
2. Document new environment variables in `.env.example` and [README.md](README.md).
3. Update [CHANGELOG.md](CHANGELOG.md) under **Unreleased** for operator-visible changes.
4. Describe how you tested: `docker compose config` and `docker compose up` on a clean machine.

## License

Contributions are licensed under the Apache License 2.0 — see [LICENSE](LICENSE).
