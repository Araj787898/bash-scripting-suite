#!/usr/bin/env bash
# update_cleanup.sh - update packages and clean package cache
set -euo pipefail
IFS=$'\n\t'

LOGFILE="/var/log/bash_suite/update_cleanup.log"
mkdir -p "$(dirname "${LOGFILE}")"

echo "[$(date +'%Y%m%d-%H%M%S')] Starting update/cleanup" >> "${LOGFILE}"

# Detect package manager
if command -v apt >/dev/null 2>&1; then
  sudo apt update >> "${LOGFILE}" 2>&1
  sudo DEBIAN_FRONTEND=noninteractive apt -y upgrade >> "${LOGFILE}" 2>&1
  sudo apt -y autoremove >> "${LOGFILE}" 2>&1
  sudo apt -y autoclean >> "${LOGFILE}" 2>&1
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf -y upgrade >> "${LOGFILE}" 2>&1
  sudo dnf -y autoremove >> "${LOGFILE}" 2>&1
elif command -v yum >/dev/null 2>&1; then
  sudo yum -y update >> "${LOGFILE}" 2>&1
else
  echo "No known package manager found" >> "${LOGFILE}"
  exit 1
fi

echo "[$(date +'%Y%m%d-%H%M%S')] Update/cleanup finished" >> "${LOGFILE}"
