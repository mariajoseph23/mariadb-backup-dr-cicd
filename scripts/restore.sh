#!/usr/bin/env bash
set -euo pipefail

: "${DB_HOST:?required}"
: "${DB_PORT:?required}"
: "${DB_USER:?required}"
: "${DB_PASS:?required}"

BACKUP_FILE="${BACKUP_FILE:-./artifacts/backup.sql}"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "ERROR: Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "Restoring from ${BACKUP_FILE}"

mariadb \
  --host="$DB_HOST" \
  --port="$DB_PORT" \
  --user="$DB_USER" \
  --password="$DB_PASS" \
  < "$BACKUP_FILE"

echo "Restore complete"

