#!/bin/bash
BACKUP_DIR=/home/pi/backups
REMOTE_DIR=/home/jo/kdrive-jo/technique/backups-pi

for f in ${BACKUP_DIR}/rpi_*.sql.gz; do
    [ -f "$f" ] || continue
    if rsync -az --timeout=10 "$f" jo@192.168.1.103:"${REMOTE_DIR}/" 2>/dev/null; then
        echo "$(date) - Sync OK : $(basename $f)"
        rm "$f"
    fi
done
