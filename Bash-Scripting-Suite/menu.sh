#!/usr/bin/env bash
# menu.sh - simple interactive menu to run suite tools
set -euo pipefail
IFS=$'\n\t'

show_menu(){
  cat <<'EOF'
Bash Scripting Suite - Menu
1) Run backup
2) Run update & cleanup
3) Run monitor once
4) Scan logs for alerts
5) Run all (recommended)
6) Exit
EOF
}

while true; do
  show_menu
  read -rp "Choose an option [1-6]: " choice
  case "$choice" in
    1) sudo bash "$(dirname "$0")/backup.sh" ;;
    2) sudo bash "$(dirname "$0")/update_cleanup.sh" ;;
    3) bash "$(dirname "$0")/monitor.sh" ;;
    4) sudo bash "$(dirname "$0")/log_alert.sh" ;;
    5)
       sudo bash "$(dirname "$0")/update_cleanup.sh"
       sudo bash "$(dirname "$0")/backup.sh"
       bash "$(dirname "$0")/monitor.sh"
       sudo bash "$(dirname "$0")/log_alert.sh"
       ;;
    6) echo "Goodbye"; exit 0 ;;
    *) echo "Invalid option";;
  esac
done
