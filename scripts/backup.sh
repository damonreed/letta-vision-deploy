#!/usr/bin/env bash
# Backup Postgres (pg_dump -Fc) + MinIO image store into one tar.gz.
# Run from letta-vision-deploy (or any cwd; script cds to repo root).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ ! -f docker-compose.yml ]]; then
  echo "error: docker-compose.yml not found in $ROOT" >&2
  exit 1
fi

# Load MINIO_DATA_PATH from .env if present (without sourcing secrets into the shell broadly)
MINIO_PATH="${MINIO_DATA_PATH:-}"
if [[ -z "$MINIO_PATH" && -f .env ]]; then
  MINIO_PATH="$(grep -E '^MINIO_DATA_PATH=' .env | cut -d= -f2- || true)"
fi
MINIO_PATH="${MINIO_PATH:-./data/minio}"

# Prefer a sibling backups dir next to MinIO data when on a large disk; else ./data/backups
if [[ "$MINIO_PATH" == /* ]]; then
  DEFAULT_BACKUP_DIR="$(dirname "$MINIO_PATH")/backups"
else
  DEFAULT_BACKUP_DIR="$ROOT/data/backups"
fi
BACKUP_DIR="${BACKUP_DIR:-$DEFAULT_BACKUP_DIR}"

STAMP="$(date -u +%Y%m%d-%H%M%S)"
WORK="$BACKUP_DIR/work-$STAMP"
ARCHIVE="$BACKUP_DIR/letta-vision-backup-$STAMP.tar.gz"

echo "=== backup $STAMP ==="
echo "minio_source=$MINIO_PATH"
echo "backup_dir=$BACKUP_DIR"
echo "archive=$ARCHIVE"

if mkdir -p "$BACKUP_DIR" 2>/dev/null && [[ -w "$BACKUP_DIR" ]]; then
  mkdir -p "$WORK/postgres" "$WORK/minio"
else
  sudo mkdir -p "$WORK/postgres" "$WORK/minio" "$BACKUP_DIR"
  sudo chown -R "$(whoami):$(whoami)" "$BACKUP_DIR"
fi

echo "=== stopping app + minio (postgres stays up) ==="
docker compose stop letta-vision-client letta-vision minio

cleanup_start() {
  echo "=== restarting services ==="
  docker compose up -d
}
trap cleanup_start EXIT

echo "=== pg_dump -Fc ==="
docker compose exec -T letta-vision-db \
  pg_dump -U letta -Fc -d letta > "$WORK/postgres/letta.dump"

echo "=== rsync MinIO ==="
if [[ -r "$MINIO_PATH" ]]; then
  rsync -a "$MINIO_PATH/" "$WORK/minio/"
else
  sudo rsync -a "$MINIO_PATH/" "$WORK/minio/"
  sudo chown -R "$(whoami):$(whoami)" "$WORK/minio"
fi

{
  echo "hostname: $(hostname)"
  echo "timestamp_utc: $STAMP"
  echo "minio_source: $MINIO_PATH"
  echo "pg_dump: postgres/letta.dump ($(du -h "$WORK/postgres/letta.dump" | cut -f1))"
  echo "minio_tree: $(du -sh "$WORK/minio" | cut -f1)"
  echo "minio_objects_approx: $(find "$WORK/minio" -type f | wc -l | tr -d ' ')"
  for repo in ../letta-vision ../letta-vision-client .; do
    name="$(basename "$(cd "$repo" 2>/dev/null && pwd || echo "$repo")")"
    if [[ -d "$repo/.git" ]]; then
      echo "${name}_git: $(git -C "$repo" rev-parse --short HEAD 2>/dev/null || echo n/a)"
    fi
  done
} > "$WORK/MANIFEST.txt"
cat "$WORK/MANIFEST.txt"

echo "=== creating archive ==="
tar -C "$WORK" -czf "$ARCHIVE" .
rm -rf "$WORK"

trap - EXIT
cleanup_start

echo
echo "Backup complete: $ARCHIVE"
ls -lh "$ARCHIVE"
