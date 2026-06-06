#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=/home/pi/backups
FILE=${BACKUP_DIR}/rpi_${DATE}.sql.gz

mysqldump --all-databases | gzip > "$FILE"

if [ $? -eq 0 ]; then
    echo "$(date) - Backup OK : $FILE"
    /home/pi/scripts/sync_kdrive.sh
else
    echo "$(date) - ERREUR mysqldump"
fi
