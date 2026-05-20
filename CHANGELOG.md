# Changelog

All notable changes to this deploy stack are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Repository renamed to `letta-vision-deploy`; services `letta-vision`, `letta-vision-db`.
- UI build context `../letta-vision-client` (sibling repo, not nested).
- Compose service renamed from `letta-bridge` to `letta-vision-client`.

## [0.1.0] - 2026-05-20

### Added

- Docker Compose stack: PostgreSQL (pgvector), Letta server, vision client UI.
- `db-init` for database extensions.
- Shared volume mount for Letta file access.

[Unreleased]: https://github.com/damonreed/letta-vision-deploy/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/damonreed/letta-vision-deploy/releases/tag/v0.1.0
