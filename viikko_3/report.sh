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

<section>
<h2>Commands Used</h2>

<ul>
<li><strong>date</strong> - Displays the current date, time and time zone.</li>

<li><strong>uptime -p</strong> - Displays how long the server has been running.</li>

<li><strong>df -P / | awk 'NR==2 {print $5}'</strong> - Uses a pipe to extract the root filesystem usage percentage.</li>

<li><strong>free -m</strong> - Displays memory information in MiB.</li>
</ul>

</section>

<section>
<h2>How the Script Works</h2>

<p>
The Bash script collects information about the server using Linux commands.
The values are stored in variables using command substitution \$().
</p>

<p>
A Bash function called disk_status() uses an if statement to determine
whether the disk usage status should be displayed as OK or WARNING.
</p>

<p>
The script generates an HTML file and saves it as index.html.
Nginx serves the generated report through the website.
</p>

</section>

<section>
<h2>Scheduling</h2>

<p>
The report is updated automatically once per minute using cron.
</p>

<p>
Cron executes the following command:
</p>

<code>
* * * * * sudo /home/ubuntu/linux_kurssi_2026/viikko_3/report.sh
</code>

</section>

<section>
<h2>Test Results</h2>

<table>

<tr>
<th>Test Input</th>
<th>Expected Result</th>
<th>Actual Result</th>
</tr>

<tr>
<td>50%</td>
<td>OK</td>
<td>OK</td>
</tr>

<tr>
<td>80%</td>
<td>WARNING</td>
<td>WARNING</td>
</tr>

<tr>
<td>90%</td>
<td>WARNING</td>
<td>WARNING</td>
</tr>

</table>

<p>
Automatic update test:
The report generation time changed automatically from
20:29:01 to 20:31:01 after reloading the page.
</p>

</section>

<section>
<h2>Lesson Learned</h2>

<p>
One challenge was reorganizing the Git repository structure.
Originally the repository root was inside the Week 2 directory.
The solution was to move the .git directory to the linux_kurssi_2026 root folder,
allowing all weekly assignments to use the same repository structure.
</p>

</section>

<section>
<h2>GitHub Repository</h2>

<p>
<a href="https://github.com/TimoTavasti/linux_kurssi_2026/tree/main/viikko_3">
View the source code on GitHub
</a>
</p>

</section>

</body>
</html>
EOF
