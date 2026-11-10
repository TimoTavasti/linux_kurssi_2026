#!/usr/bin/env bash

GENERATED_AT=$(date)

UPTIME_TEXT=$(uptime -p)

DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')

MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')

echo "Aika: $GENERATED_AT"
echo "Käynnissä: $UPTIME_TEXT"
echo "Levytila: $DISK_USAGE"
echo "RAM yhteensä: $MEM_TOTAL MiB"
echo "RAM vapaana: $MEM_AVAILABLE MiB"
