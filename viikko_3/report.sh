#!/usr/bin/env bash

GENERATED_AT=$(date)

UPTIME_TEXT=$(uptime -p)

DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')

DISK_PERCENT=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')

MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')

OUTPUT_FILE="/var/www/html/viikko_3/index.html"

disk_status() {
    if [ "$DISK_PERCENT" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DISK_STATUS=$(disk_status)

cat > "$OUTPUT_FILE" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Week 3 Server Status Report</title>

<style>
body {
    font-family: Arial, sans-serif;
    max-width: 1000px;
    margin: 40px auto;
    background: #f5f7fa;
    padding: 20px;
}

section {
    background: white;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 20px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th, td {
    border: 1px solid #ccc;
    padding: 10px;
}

th {
    background: #e8f0fe;
}
</style>

</head>

<body>

<section>

<h1>Server Status Report</h1>

<table>

<tr>
<th>Information</th>
<th>Value</th>
</tr>

<tr>
<td>Report generated</td>
<td>$GENERATED_AT</td>
</tr>

<tr>
<td>Server uptime</td>
<td>$UPTIME_TEXT</td>
</tr>

<tr>
<td>Root filesystem disk usage</td>
<td>$DISK_USAGE</td>
</tr>

<tr>
<td>Disk space status</td>
<td>$DISK_STATUS</td>
</tr>

<tr>
<td>Total RAM</td>
<td>$MEM_TOTAL MiB</td>
</tr>

<tr>
<td>Available RAM</td>
<td>$MEM_AVAILABLE MiB</td>
</tr>

</table>

</section>

</body>
</html>
EOF
