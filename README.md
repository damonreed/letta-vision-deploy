# letta-vision-deploy

Docker Compose stack for a self-hosted **Letta Vision** server (PostgreSQL + pgvector) and the **[letta-vision-client](https://github.com/damonreed/letta-vision-client)** web UI.

This repository contains only orchestration: `docker-compose.yml`, database bootstrap SQL, and environment templates. Clone **letta-vision-client** as a sibling directory so Compose can build the UI (`../letta-vision-client`).

## Prerequisites

- Docker with Compose v2
- Letta Vision server image tagged **`letta-local:latest`** (build from your [letta-vision](https://github.com/letta-ai/letta) server source)
- Sibling checkout of [letta-vision-client](https://github.com/damonreed/letta-vision-client)

## Directory layout

Use any parent folder; sibling paths matter, not the parent name:

```
your-workspace/
├── letta-vision/           # server → docker build -t letta-local:latest .
├── letta-vision-client/    # git clone …/letta-vision-client
└── letta-vision-deploy/    # git clone …/letta-vision-deploy (this repo)
    ├── docker-compose.yml
    ├── db-init/
    ├── .env.example
    └── shared/             # created on first run (Letta file mount)
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| `letta-vision-db` | internal | PostgreSQL 16 with pgvector |
| `letta-vision` | 8283 | Letta Vision API (`letta-local:latest`) |
| `letta-vision-client` | 8284 | Web UI |

## Quick start

```bash
# 1. Clone (sibling layout)
git clone https://github.com/damonreed/letta-vision-deploy.git
git clone https://github.com/damonreed/letta-vision-client.git

# 2. Build the server image (from your letta-vision tree)
cd ../letta-vision   # or wherever you keep server source
docker build -t letta-local:latest .

# 3. Configure and start
cd ../letta-vision-deploy
cp .env.example .env
# Edit .env — set LETTA_POSTGRES_PASSWORD and LETTA_SERVER_PASSWORD (openssl rand -hex 32)
mkdir -p shared
docker compose up -d --build
```

- UI: http://localhost:8284  
- API: http://localhost:8283  

On first start, Compose creates Docker volumes for Postgres data and Letta memfs. The `db-init` scripts run only when the database volume is new.

## Environment variables

See [.env.example](.env.example). Required:

| Variable | Description |
|----------|-------------|
| `LETTA_POSTGRES_PASSWORD` | PostgreSQL password |
| `LETTA_SERVER_PASSWORD` | Letta API password (used by the UI container) |

Optional keys configure model providers (OpenRouter, E2B, Ollama, etc.) per your Letta Vision server setup.

## Documentation

- UI design and API: [letta-vision-client/docs/ARCHITECTURE.md](https://github.com/damonreed/letta-vision-client/blob/main/docs/ARCHITECTURE.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SECURITY.md](SECURITY.md)

## License

Apache License 2.0 — see [LICENSE](LICENSE).
