#!/usr/bin/env bash
# monitor.sh - log CPU and memory usage and alert when above thresholds
set -euo pipefail
IFS=$'\n\t'

LOGFILE="/var/log/bash_suite/monitor.log"
mkdir -p "$(dirname "${LOGFILE}")"

# CONFIG
CPU_THRESHOLD=85   # percent
MEM_THRESHOLD=85   # percent
EMAIL_NOTIFY=""    # optionally set to user@example.com
TIMESTAMP=$(date +'%Y%m%d-%H%M%S')

# Gather metrics
CPU_LOAD=$(top -bn1 | awk '/Cpu\(s\):/ {print 100 - $8}') || CPU_LOAD=0
MEM_USED_PCT=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')

echo "[${TIMESTAMP}] CPU:${CPU_LOAD}% MEM:${MEM_USED_PCT}% " >> "${LOGFILE}"

ALERT=0
if (( ${CPU_LOAD%.*} >= CPU_THRESHOLD )); then
  echo "[${TIMESTAMP}] ALERT: CPU above ${CPU_THRESHOLD}% (${CPU_LOAD}%)" >> "${LOGFILE}"
  ALERT=1
fi
if (( ${MEM_USED_PCT} >= MEM_THRESHOLD )); then
  echo "[${TIMESTAMP}] ALERT: MEM above ${MEM_THRESHOLD}% (${MEM_USED_PCT}%)" >> "${LOGFILE}"
  ALERT=1
fi

if [ "${ALERT}" -eq 1 ] && [ -n "${EMAIL_NOTIFY}" ]; then
  printf "Subject:System Alert on ${HOSTNAME}\n\nSee ${LOGFILE}\n" | sendmail "${EMAIL_NOTIFY}"
fi
