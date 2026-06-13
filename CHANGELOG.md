# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0] - 2026-06-13

### Changed

- Default `LETTA_VERSION=0.6.0` in compose and `.env.example`.
- `docs/RELEASE_NOTES_v0.6.0.md` — stack pairing for unified embedding + multimodal recall GA.
- README build instructions reference `v0.6.0` tag.

### Added

- MinIO object store services (`minio`, `minio-init`) for image bytes.
- `LETTA_OBJECT_STORE_URI`, `LETTA_DEFAULT_EMBEDDING_HANDLE`, `LETTA_EMBED_ALL_MESSAGES`, `LETTA_IMAGE_CAPTION_MODEL_HANDLE` in compose.
- `LETTA_TELEMETRY_PROVIDER_TRACE_PG_METADATA_ONLY` env passthrough.
- Parameterized `MINIO_DATA_PATH`, `MODEL_OVERRIDES_DIR` host paths in `.env.example`.

### Fixed

- Client `shared/` mount read-write for Providers vision overrides; server stays read-only.
- Correct `LETTA_*` embedding env var names in compose (replacing deprecated `LETTA_EMBEDDING` usage in docs).

## [0.5.0] - 2026-06-01

### Changed

- Default `LETTA_VERSION=0.5.0` in compose and `.env.example`.
- `docs/RELEASE_NOTES_v0.5.0.md` — stack pairing for three-tier memory release.

### Added

- `MODEL_OVERRIDES_PATH` shared volume mount for server and client.
- `LETTA_ENCRYPTION_KEY`, `LETTA_TRACK_PROVIDER_TRACE`, `GLOBAL_MAX_CONTEXT_WINDOW_LIMIT` env passthrough.
- OpenRouter attribution env vars (`OPENROUTER_TITLE`, `OPENROUTER_REFERER`).

## [0.4.0] - 2026-05-21

### Changed

- Default `LETTA_VERSION=0.4.0` in compose and `.env.example`.
- `docs/RELEASE_NOTES_v0.4.0.md` — stack pairing for server + client v0.4.0.

## [0.3.0] - 2026-05-20

### Changed

- Document v0.3.0 vision stack pairing; recommend `LETTA_LLM_REQUEST_TIMEOUT_SECONDS=300` in `.env.example`.
- `docs/RELEASE_NOTES_v0.3.0.md` with upgrade steps for server + client tags.

## [0.2.0] - 2026-05-20

Pre-vision baseline compose stack; LLM timeout env passthrough.

## [0.1.0] - 2026-05-20

### Added

- Docker Compose stack: `letta-vision-db`, `letta-vision`, `letta-vision-client`.
- PostgreSQL init scripts (`db-init`) for pgvector.
- `shared/` bind mount for Letta file access.
- `.env.example` for required secrets and optional provider keys.

[Unreleased]: https://github.com/damonreed/letta-vision-deploy/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.6.0
[0.5.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.5.0
[0.4.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.4.0
[0.3.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.3.0
[0.2.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.2.0
[0.1.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.1.0
