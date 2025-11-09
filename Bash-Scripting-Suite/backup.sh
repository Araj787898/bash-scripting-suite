#!/usr/bin/env bash
# backup.sh - simple backup with rotation
set -euo pipefail
IFS=$'\n\t'

# CONFIG
SRC_DIRS=(/home /etc)
BACKUP_ROOT="/var/backups/bash_suite"
RETENTION_DAYS=7
TIMESTAMP=$(date +'%Y%m%d-%H%M%S')
HOSTNAME=$(hostname -s)
ARCHIVE_NAME="${HOSTNAME}-backup-${TIMESTAMP}.tar.gz"
LOGFILE="/var/log/bash_suite/backup.log"

# Ensure log dir
mkdir -p "${BACKUP_ROOT}" "$(dirname "${LOGFILE}")"

echo "[${TIMESTAMP}] Starting backup: ${ARCHIVE_NAME}" >> "${LOGFILE}"

# Create the archive
tar -czf "${BACKUP_ROOT}/${ARCHIVE_NAME}" "${SRC_DIRS[@]}" --warning=no-file-changed 2>> "${LOGFILE}" || {
    echo "[${TIMESTAMP}] ERROR: Backup tar failed" >> "${LOGFILE}"
    exit 1
}

echo "[${TIMESTAMP}] Backup completed: ${BACKUP_ROOT}/${ARCHIVE_NAME}" >> "${LOGFILE}"

# Rotate old backups
find "${BACKUP_ROOT}" -type f -name "*.tar.gz" -mtime +${RETENTION_DAYS} -print -exec rm -f {} \; >> "${LOGFILE}" 2>&1 || true

echo "[${TIMESTAMP}] Rotation complete. Keeping last ${RETENTION_DAYS} days." >> "${LOGFILE}"
