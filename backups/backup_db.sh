#!/bin/bash

# HealthSync PostgreSQL Backup Script
BACKUP_DIR="$HOME/backups"
LOG_FILE="$BACKUP_DIR/backup.log"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/healthsync_$TIMESTAMP.sql.gz"

DB_NAME="healthsync"
DB_USER="healthsync_user"
export PGPASSWORD="Bartal123!"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "===== Backup gestartet ====="
log "Ziel: $BACKUP_FILE"

pg_dump -U "$DB_USER" -h localhost "$DB_NAME" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ] && [ -s "$BACKUP_FILE" ]; then
    SIZE=$(du -sh "$BACKUP_FILE" | cut -f1)
    log "Backup erfolgreich erstellt ($SIZE)"
else
    log "FEHLER: Backup fehlgeschlagen oder Datei leer!"
    exit 1
fi

# Backups älter als 7 Tage löschen
DELETED=$(find "$BACKUP_DIR" -name "healthsync_*.sql.gz" -mtime +7 -print -delete | wc -l)
if [ "$DELETED" -gt 0 ]; then
    log "Alte Backups gelöscht: $DELETED Datei(en)"
fi

log "===== Backup abgeschlossen ====="
