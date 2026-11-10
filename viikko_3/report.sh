#!/usr/bin/env bash

GENERATED_AT=$(date)

UPTIME_TEXT=$(uptime -p)

DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')

DISK_PERCENT=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')

MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')

disk_status() {
    if [ "$DISK_PERCENT" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DISK_STATUS=$(disk_status)

echo "Report generated: $GENERATED_AT"
echo "Uptime: $UPTIME_TEXT"
echo "Disk usage: $DISK_USAGE"
echo "Disk status: $DISK_STATUS"
echo "Total RAM: $MEM_TOTAL MiB"
echo "Available RAM: $MEM_AVAILABLE MiB"
