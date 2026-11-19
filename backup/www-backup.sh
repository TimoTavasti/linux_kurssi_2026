#!/bin/bash

TIMESTAMP=$(date +%F-%H%M)

DEST="/srv/backups/www/$TIMESTAMP"

mkdir -p "$DEST"

rsync -a \
-e "ssh -i /root/.ssh/sync_ed25519 -o BatchMode=yes" \
ubuntu@192.168.1.30:/var/www/html/ \
"$DEST"

echo "$(date): backup completed" >> /srv/backups/logs/www-backup.log

find /srv/backups/www -mindepth 1 -maxdepth 1 -type d | sort | head -n -2 | xargs -r rm -rf
