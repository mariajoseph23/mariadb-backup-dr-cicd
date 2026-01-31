#!/usr/bin/env bash
set -euo pipefail

: "${DB_HOST:?required}"
: "${DB_PORT:?required}"
: "${DB_USER:?required}"
: "${DB_PASS:?required}"
: "${DB_NAME:?required}"

echo "Running validation checks on ${DB_NAME}"

Q_USERS_COUNT="SELECT COUNT(*) AS c FROM ${DB_NAME}.users;"
Q_ORDERS_COUNT="SELECT COUNT(*) AS c FROM ${DB_NAME}.orders;"

USERS_COUNT=$(mariadb --silent --skip-column-names \
  --host="$DB_HOST" --port="$DB_PORT" --user="$DB_USER" --password="$DB_PASS" \
  -e "$Q_USERS_COUNT")

ORDERS_COUNT=$(mariadb --silent --skip-column-names \
  --host="$DB_HOST" --port="$DB_PORT" --user="$DB_USER" --password="$DB_PASS" \
  -e "$Q_ORDERS_COUNT")

echo "users count: ${USERS_COUNT}"
echo "orders count: ${ORDERS_COUNT}"

if [ "$USERS_COUNT" -ne 3 ]; then
  echo "ERROR: Expected 3 users, got ${USERS_COUNT}"
  exit 1
fi

if [ "$ORDERS_COUNT" -ne 4 ]; then
  echo "ERROR: Expected 4 orders, got ${ORDERS_COUNT}"
  exit 1
fi

# Deterministic checksum across important columns (order independent)
Q_USERS_HASH="
SELECT MD5(GROUP_CONCAT(rowhash ORDER BY rowhash SEPARATOR ''))
FROM (
  SELECT MD5(CONCAT_WS('#', id, email, full_name)) AS rowhash
  FROM ${DB_NAME}.users
) t;
"

Q_ORDERS_HASH="
SELECT MD5(GROUP_CONCAT(rowhash ORDER BY rowhash SEPARATOR ''))
FROM (
  SELECT MD5(CONCAT_WS('#', id, user_id, amount_cents, status)) AS rowhash
  FROM ${DB_NAME}.orders
) t;
"

USERS_HASH=$(mariadb --silent --skip-column-names \
  --host="$DB_HOST" --port="$DB_PORT" --user="$DB_USER" --password="$DB_PASS" \
  -e "$Q_USERS_HASH")

ORDERS_HASH=$(mariadb --silent --skip-column-names \
  --host="$DB_HOST" --port="$DB_PORT" --user="$DB_USER" --password="$DB_PASS" \
  -e "$Q_ORDERS_HASH")

echo "users hash:  ${USERS_HASH}"
echo "orders hash: ${ORDERS_HASH}"

echo "Validation passed"

