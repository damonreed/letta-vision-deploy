# letta-vision-deploy

Docker Compose orchestration for a self-hosted **Letta Vision** stack: PostgreSQL (pgvector), the Letta Vision API server, and the **[letta-vision-client](https://github.com/damonreed/letta-vision-client)** web UI.

## Full letta-stack install

End-to-end setup on a new machine. All three repositories live as **siblings** under one parent directory.

### 1. Create the workspace

```bash
mkdir -p ~/src/letta-stack
cd ~/src/letta-stack
```

### 2. Clone the three repositories

```bash
git clone https://github.com/damonreed/letta-vision-deploy.git
git clone https://github.com/damonreed/letta-vision-client.git
git clone https://github.com/damonreed/letta-vision.git
```

Resulting layout:

```
letta-stack/
├── letta-vision/           # Letta Vision server (API)
├── letta-vision-client/    # Web UI
└── letta-vision-deploy/    # This repo — Compose stack
```

### 3. Build the Letta Vision server image

From the server repository:

```bash
cd letta-vision
docker build -t letta-vision-local:latest .
```

Compose expects that image tag (`letta-vision-local:latest`) for the `letta-vision` service.

### 4. Build and start the Compose stack

```bash
cd ../letta-vision-deploy
cp .env.example .env
```

Edit `.env` and set at least:

- `LETTA_POSTGRES_PASSWORD` — `openssl rand -hex 32`
- `LETTA_SERVER_PASSWORD` — `openssl rand -hex 32`

Optional keys (OpenRouter, E2B, Ollama, etc.) depend on your server configuration; see [.env.example](.env.example).

```bash
docker compose up -d --build
```

The first run builds **letta-vision-client** from `../letta-vision-client` and starts all services.

| Endpoint | URL |
|----------|-----|
| Web UI | http://localhost:8284 |
| Letta API | http://localhost:8283 |

On first start, Compose creates Docker volumes for Postgres and memfs. `db-init/` runs only when the database volume is new.

---

## Services

| Service | Port | Description |
|---------|------|-------------|
| `letta-vision-db` | internal | PostgreSQL 16 with pgvector |
| `letta-vision` | 8283 | Letta Vision API (`letta-vision-local:latest`) |
| `letta-vision-client` | 8284 | Web UI |

## Prerequisites

- Docker with Compose v2
- Git
- Enough disk for images, volumes, and `shared/` file uploads

## Environment variables

| Variable | Description |
|----------|-------------|
| `LETTA_POSTGRES_PASSWORD` | PostgreSQL password (required) |
| `LETTA_SERVER_PASSWORD` | Letta API password; used by the UI container (required) |

See [.env.example](.env.example) for optional provider keys.

## Documentation

- UI architecture: [letta-vision-client/docs/ARCHITECTURE.md](https://github.com/damonreed/letta-vision-client/blob/main/docs/ARCHITECTURE.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SECURITY.md](SECURITY.md)

## License

Apache License 2.0 — see [LICENSE](LICENSE).
