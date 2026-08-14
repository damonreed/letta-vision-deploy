#!/usr/bin/env bash
# Restore Postgres + MinIO from a backup archive created by scripts/backup.sh.
#
# Usage:
#   ./scripts/restore.sh /path/to/letta-vision-backup-YYYYMMDD-HHMMSS.tar.gz
#   ./scripts/restore.sh --yes /path/to/archive.tar.gz   # skip confirmation
#
# WARNING: replaces MinIO data and recreates the Postgres Docker volume.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

YES=0
ARCHIVE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes|-y) YES=1; shift ;;
    -h|--help)
      sed -n '2,12p' "$0"
      exit 0
      ;;
    *)
      ARCHIVE="$1"
      shift
      ;;
  esac
done

if [[ -z "$ARCHIVE" || ! -f "$ARCHIVE" ]]; then
  echo "usage: $0 [--yes] /path/to/letta-vision-backup-....tar.gz" >&2
  exit 1
fi
ARCHIVE="$(cd "$(dirname "$ARCHIVE")" && pwd)/$(basename "$ARCHIVE")"

if [[ ! -f docker-compose.yml ]]; then
  echo "error: docker-compose.yml not found in $ROOT" >&2
  exit 1
fi

MINIO_PATH="${MINIO_DATA_PATH:-}"
if [[ -z "$MINIO_PATH" && -f .env ]]; then
  MINIO_PATH="$(grep -E '^MINIO_DATA_PATH=' .env | cut -d= -f2- || true)"
fi
MINIO_PATH="${MINIO_PATH:-./data/minio}"
# Resolve relative MinIO path against repo root
if [[ "$MINIO_PATH" != /* ]]; then
  MINIO_PATH="$ROOT/$MINIO_PATH"
fi

PROJECT_NAME="${COMPOSE_PROJECT_NAME:-$(basename "$ROOT")}"
PG_VOLUME="${PROJECT_NAME}_letta-vision-pgdata"

STAMP="$(date -u +%Y%m%d-%H%M%S)"
WORK="$(dirname "$MINIO_PATH")/restore-work-$STAMP"

echo "=== restore ==="
echo "archive=$ARCHIVE"
echo "minio_dest=$MINIO_PATH"
echo "pg_volume=$PG_VOLUME"
echo "work=$WORK"

if [[ "$YES" -ne 1 ]]; then
  echo
  echo "This will:"
  echo "  1. Stop all letta-vision compose services"
  echo "  2. Move current MinIO data aside and replace it from the archive"
  echo "  3. Delete Docker volume $PG_VOLUME and recreate Postgres from the dump"
  echo
  read -r -p "Type 'restore' to continue: " confirm
  if [[ "$confirm" != "restore" ]]; then
    echo "aborted"
    exit 1
  fi
fi

mkdir -p "$WORK" 2>/dev/null || sudo mkdir -p "$WORK"
if [[ ! -w "$WORK" ]]; then
  sudo chown -R "$(whoami):$(whoami)" "$WORK"
fi

echo "=== extracting archive ==="
tar -xzf "$ARCHIVE" -C "$WORK"

if [[ ! -f "$WORK/postgres/letta.dump" ]]; then
  echo "error: archive missing postgres/letta.dump" >&2
  exit 1
fi
if [[ ! -d "$WORK/minio" ]]; then
  echo "error: archive missing minio/" >&2
  exit 1
fi
if [[ -f "$WORK/MANIFEST.txt" ]]; then
  echo "--- MANIFEST ---"
  cat "$WORK/MANIFEST.txt"
  echo "----------------"
fi

echo "=== stopping stack ==="
docker compose stop

echo "=== replacing MinIO data ==="
PARENT="$(dirname "$MINIO_PATH")"
mkdir -p "$PARENT" 2>/dev/null || sudo mkdir -p "$PARENT"
if [[ -e "$MINIO_PATH" ]]; then
  BAK="${MINIO_PATH}.bak.$STAMP"
  echo "moving existing MinIO -> $BAK"
  if [[ -w "$PARENT" ]]; then
    mv "$MINIO_PATH" "$BAK"
  else
    sudo mv "$MINIO_PATH" "$BAK"
  fi
fi
if [[ -w "$PARENT" ]]; then
  mkdir -p "$MINIO_PATH"
  rsync -a "$WORK/minio/" "$MINIO_PATH/"
else
  sudo mkdir -p "$MINIO_PATH"
  sudo rsync -a "$WORK/minio/" "$MINIO_PATH/"
fi

echo "=== recreating Postgres volume ==="
docker compose rm -f letta-vision-db 2>/dev/null || true
# Volume may still be in use until container is removed
if docker volume inspect "$PG_VOLUME" >/dev/null 2>&1; then
  docker volume rm "$PG_VOLUME"
fi

echo "=== starting DB (fresh volume + db-init) ==="
docker compose up -d letta-vision-db
echo "waiting for healthy DB..."
for i in $(seq 1 60); do
  if docker compose exec -T letta-vision-db pg_isready -U letta >/dev/null 2>&1; then
    break
  fi
  sleep 1
done
docker compose exec -T letta-vision-db pg_isready -U letta

echo "=== pg_restore ==="
# Fresh DB already has empty schema from init? Actually empty volume gets POSTGRES_DB=letta
# created empty; db-init only enables extensions. App migrations create schema — but dump
# includes full schema+data. Use --clean --if-exists for safety if objects exist.
docker compose exec -T letta-vision-db \
  pg_restore -U letta -d letta --clean --if-exists --no-owner --no-acl \
  < "$WORK/postgres/letta.dump" \
  || true
# pg_restore returns non-zero on some benign warnings; verify with a simple query
docker compose exec -T letta-vision-db \
  psql -U letta -d letta -c "SELECT count(*) AS agents FROM agents;" 

echo "=== starting full stack ==="
docker compose up -d

echo "=== cleanup work dir ==="
rm -rf "$WORK" 2>/dev/null || sudo rm -rf "$WORK"

echo
echo "Restore complete from $ARCHIVE"
echo "Smoke-check: UI http://localhost:8284 — agents, images, chat history."
echo "Previous MinIO (if any) left at ${MINIO_PATH}.bak.$STAMP — remove when satisfied."
