#!/usr/bin/env bash
# Install the daily systemd timer that runs scripts/backup.sh.
# Requires sudo. Idempotent: copies units, reloads, enables the timer.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UNIT_DIR="$ROOT/systemd"

if [[ ! -f "$UNIT_DIR/letta-vision-backup.service" || ! -f "$UNIT_DIR/letta-vision-backup.timer" ]]; then
  echo "error: systemd units missing under $UNIT_DIR" >&2
  exit 1
fi

sudo install -m 644 "$UNIT_DIR/letta-vision-backup.service" /etc/systemd/system/letta-vision-backup.service
sudo install -m 644 "$UNIT_DIR/letta-vision-backup.timer" /etc/systemd/system/letta-vision-backup.timer
sudo systemctl daemon-reload
sudo systemctl enable --now letta-vision-backup.timer
sudo systemctl status letta-vision-backup.timer --no-pager
echo
echo "Next run:"
systemctl list-timers letta-vision-backup.timer --no-pager
