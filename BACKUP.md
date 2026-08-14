# Backup and restore (Postgres + images)

Logical Postgres dump (`pg_dump -Fc`) plus a filesystem copy of the MinIO data directory, packed into one timestamped archive. Portable across hosts and Docker volume IDs.

## What is backed up

| Data | Source | Notes |
|------|--------|-------|
| Database `letta` | `letta-vision-db` via `pg_dump -Fc` | Agents, messages, image metadata/embeddings |
| Image bytes | `MINIO_DATA_PATH` (default `./data/minio`; production often `/data/letta-vision/minio`) | Bucket `letta-vision`, prefix `images/` |

**Not included:** `letta-vision-memfs`, `./shared` model overrides, or `.env` secrets. Keep `.env` (especially `LETTA_ENCRYPTION_KEY`, Postgres/MinIO passwords) separately — a new host needs matching secrets to decrypt DB fields.

## Backup

From this repo on the host running Compose:

```bash
./scripts/backup.sh
```

Optional:

```bash
BACKUP_DIR=/data/letta-vision/backups ./scripts/backup.sh
```

Default `BACKUP_DIR` is a `backups/` sibling of `MINIO_DATA_PATH` when that path is absolute (e.g. `/data/letta-vision/backups`), otherwise `./data/backups`.

The script:

1. Stops `letta-vision-client`, `letta-vision`, and `minio` (Postgres stays up).
2. Runs `pg_dump -U letta -Fc -d letta`.
3. `rsync`s MinIO data into a work tree.
4. Writes `MANIFEST.txt` and creates `letta-vision-backup-YYYYMMDD-HHMMSS.tar.gz`.
5. Restarts the stack with `docker compose up -d`.

### Archive layout

```text
MANIFEST.txt
postgres/letta.dump
minio/                  # contents of MINIO_DATA_PATH
```

### Verify an archive

```bash
ARCHIVE=/path/to/letta-vision-backup-....tar.gz
tar -xOzf "$ARCHIVE" ./MANIFEST.txt
mkdir -p /tmp/lv-verify && tar -xzf "$ARCHIVE" -C /tmp/lv-verify ./postgres/letta.dump
docker run --rm -v /tmp/lv-verify/postgres:/dump:ro pgvector/pgvector:pg16 \
  pg_restore -l /dump/letta.dump | head
rm -rf /tmp/lv-verify
```

## Restore

**Destructive.** Replaces MinIO data and deletes/recreates the Postgres Docker volume.

```bash
./scripts/restore.sh /path/to/letta-vision-backup-YYYYMMDD-HHMMSS.tar.gz
# or non-interactive:
./scripts/restore.sh --yes /path/to/letta-vision-backup-....tar.gz
```

### Same host (disaster recovery)

1. Confirm the archive with `pg_restore -l` / `MANIFEST.txt`.
2. Run `./scripts/restore.sh …` from `letta-vision-deploy` with the same `.env` and `MINIO_DATA_PATH`.
3. Smoke-check UI (agents, image URLs, chat history).
4. Remove `${MINIO_DATA_PATH}.bak.*` only after you are satisfied.

### New host (migration)

1. Clone sibling repos (`letta-vision`, `letta-vision-client`, `letta-vision-deploy`).
2. Copy `.env` (or recreate secrets — **`LETTA_ENCRYPTION_KEY` must match** if you need existing encrypted fields).
3. Set `MINIO_DATA_PATH` to a large disk path.
4. `docker compose up -d` once is optional; `./scripts/restore.sh` stops the stack, writes MinIO, recreates the DB volume, `pg_restore`s, then brings everything up.
5. Confirm `LETTA_OBJECT_STORE_URI` still points at `s3://letta-vision/images?endpoint=http://minio:9000` (Compose default).

### Pitfalls

- Do not mix an old live MinIO tree with a restored dump (or vice versa).
- Volume name is project-prefixed: typically `letta-vision-deploy_letta-vision-pgdata` (`docker volume ls`).
- `db-init/` runs only on an empty Postgres data dir (fresh volume) — the restore path relies on that.
- Changing `LETTA_ENCRYPTION_KEY` breaks decryption even when dump + images are perfect.
- Prefer writing archives under `/data` (or another large volume) on production hosts; avoid filling `/`.

## Example (sliver)

```bash
ssh sliver 'cd ~/src/letta-stack/letta-vision-deploy && ./scripts/backup.sh'
# archive lands under /data/letta-vision/backups/ when MINIO_DATA_PATH=/data/letta-vision/minio
```
