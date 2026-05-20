# Security Policy

## Scope

This repository defines a **local or private-network** Docker Compose stack. It wires together PostgreSQL, a Letta Vision server, and letta-vision-client. It is not hardened for anonymous internet exposure.

## Supported versions

Security fixes apply to the latest commit on the default branch.

## Reporting a vulnerability

Please **do not** open a public issue for security vulnerabilities.

Use [GitHub Security Advisories](https://github.com/damonreed/letta-vision-deploy/security/advisories/new) for this repository when available, or contact maintainers privately.

For issues in the UI application itself, report to [letta-vision-client/SECURITY.md](https://github.com/damonreed/letta-vision-client/blob/main/SECURITY.md).

## Operational requirements

- **Never commit `.env`** — it contains database and API credentials.
- Restrict host firewall access to ports **8283** (Letta) and **8284** (UI) on trusted networks only.
- Use strong values for `LETTA_POSTGRES_PASSWORD` and `LETTA_SERVER_PASSWORD`.
- The `shared/` directory is mounted into Letta; do not place secrets there.
- Rebuild images after dependency updates: `docker compose build --no-cache`.

## Third-party images

- `pgvector/pgvector:pg16` — track upstream image updates.
- `letta-vision-local:latest` — build from your audited Letta Vision server source.
