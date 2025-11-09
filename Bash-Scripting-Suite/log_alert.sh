#!/usr/bin/env bash
# log_alert.sh - scan logs for keywords and report the count
set -euo pipefail
IFS=$'\n\t'

LOG_FILE="/var/log/syslog"   # change to /var/log/messages on RHEL systems
PATTERNS=("error" "failed" "unauthorized")
OUTPUT="/var/log/bash_suite/log_alert.log"
mkdir -p "$(dirname "${OUTPUT}")"

TS=$(date +'%Y%m%d-%H%M%S')
echo "[${TS}] Scanning ${LOG_FILE} for patterns" >> "${OUTPUT}"

for p in "${PATTERNS[@]}"; do
  COUNT=$(sudo grep -i "${p}" "${LOG_FILE}" | wc -l || true)
  echo "[${TS}] Pattern: ${p} Count: ${COUNT}" >> "${OUTPUT}"
done
