# letta-vision-deploy

Docker Compose stack for a self-hosted **Letta Vision** server (PostgreSQL + pgvector) and the **[letta-vision-client](https://github.com/damonreed/letta-vision-client)** web UI.

This repository is orchestration only: compose services, database init, and shared volumes. The UI is a **sibling repository** checked out next to this directory (not inside it).

## Expected directory layout

```
letta-stack/
├── letta-vision/              # server source → build image letta-local:latest
├── letta-vision-client/       # web UI (this compose file builds ../letta-vision-client)
└── letta-vision-deploy/       # you are here
    ├── docker-compose.yml
    ├── db-init/
    └── shared/
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| `letta-vision-db` | 5432 (internal) | PostgreSQL 16 with pgvector |
| `letta-vision` | 8283 | Letta server (`letta-local:latest` image) |
| `letta-vision-client` | 8284 | Web UI for agents, chat, memory, files |

## Quick start

1. Clone [letta-vision-client](https://github.com/damonreed/letta-vision-client) as a sibling: `../letta-vision-client`.

2. Copy environment template and set secrets:

   ```bash
   cp .env.example .env
   # Edit .env — generate passwords with: openssl rand -hex 32
   ```

3. Build the Letta image from `letta-vision` and tag `letta-local:latest`.

4. Start the stack from this directory:

   ```bash
   docker compose up -d --build
   ```

5. Open http://localhost:8284 (UI) and http://localhost:8283 (API).

## Volumes

`deploy_letta-pgdata` is marked `external: true` so existing Postgres data from an earlier `deploy` compose project can be reused. To start fresh:

```bash
docker volume rm deploy_letta-pgdata   # destructive
docker volume create deploy_letta-pgdata
```

Or remove `external: true` from `docker-compose.yml` and let Compose create a new named volume.

## Documentation

- UI architecture: [letta-vision-client/docs/ARCHITECTURE.md](../letta-vision-client/docs/ARCHITECTURE.md)
- Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)
- Security: [SECURITY.md](SECURITY.md)

## License

Apache License 2.0 — see [LICENSE](LICENSE).
