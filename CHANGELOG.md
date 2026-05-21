# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/damonreed/letta-vision-deploy/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.4.0
[0.3.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.3.0
[0.2.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.2.0
[0.1.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.1.0
