# Bash Scripting Suite for System Maintenance

## Overview
A small suite of bash scripts to automate common system maintenance tasks:
- `backup.sh` — backup important directories with rotation.
- `update_cleanup.sh` — update packages and clean caches.
- `monitor.sh` — simple resource monitor that logs and alerts on thresholds.
- `log_alert.sh` — scan logs for patterns and notify.
- `menu.sh` — interactive menu to run the tools.
- `examples/` — example cron entry and config.

## How to use
1. Extract the zip and make scripts executable:
   ```bash
   chmod +x *.sh
   ```
2. Run the menu:
   ```bash
   ./menu.sh
   ```
3. For automation, add to crontab (`crontab -e`):
   ```bash
   # daily update at 3am
   0 3 * * * /path/to/update_cleanup.sh >> /var/log/bash_suite/update.log 2>&1
   # daily backup at 4am
   0 4 * * * /path/to/backup.sh >> /var/log/bash_suite/backup.log 2>&1
   ```

## Notes
- Scripts are POSIX-compatible bash; tested on Ubuntu.
- Edit the `CONFIG` section at top of each script to change paths, thresholds, or email addresses.
- These scripts require sudo for system updates and some operations.
