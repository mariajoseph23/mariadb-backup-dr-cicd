#!/usr/bin/env bash
set -euo pipefail

: "${DB_HOST:?required}"
: "${DB_PORT:?required}"
: "${DB_USER:?required}"
: "${DB_PASS:?required}"
: "${DB_NAME:?required}"

BACKUP_DIR="${BACKUP_DIR:-./artifacts}"
BACKUP_FILE="${BACKUP_FILE:-${BACKUP_DIR}/backup.sql}"

mkdir -p "$BACKUP_DIR"

echo "Creating logical backup for ${DB_NAME} -> ${BACKUP_FILE}"

mysqldump \
  --host="$DB_HOST" \
  --port="$DB_PORT" \
  --user="$DB_USER" \
  --password="$DB_PASS" \
  --databases "$DB_NAME" \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  > "$BACKUP_FILE"

echo "Backup complete: $(wc -c < "$BACKUP_FILE") bytes"

