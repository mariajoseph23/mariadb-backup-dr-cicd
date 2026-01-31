# MariaDB Backup, Restore, and DR Validation (CI/CD)

This repository demonstrates disaster recovery readiness for MariaDB by
automating backup, restore, and validation in a CI pipeline.

## What this project demonstrates

- Logical backups using `mysqldump`
- Restore into a clean MariaDB instance
- Post-restore data validation
- Ephemeral MariaDB in CI using GitHub Actions
- Confidence in recovery, not just backups

## Disaster recovery flow

1. Provision ephemeral MariaDB in CI
2. Apply schema and seed test data
3. Take logical backup
4. Drop database
5. Restore from backup
6. Validate data integrity

## Repo layout

- `migrations/` . Database schema
- `scripts/backup.sh` . Create logical backup
- `scripts/restore.sh` . Restore from backup
- `scripts/validate.sh` . Validate restored data
- `.github/workflows/dr-ci.yml` . DR validation pipeline

