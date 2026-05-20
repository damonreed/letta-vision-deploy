# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-05-20

### Added

- Docker Compose stack: `letta-vision-db`, `letta-vision`, `letta-vision-client`.
- PostgreSQL init scripts (`db-init`) for pgvector.
- `shared/` bind mount for Letta file access.
- `.env.example` for required secrets and optional provider keys.

[Unreleased]: https://github.com/damonreed/letta-vision-deploy/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.1.0
