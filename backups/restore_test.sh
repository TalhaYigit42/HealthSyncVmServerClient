#!/bin/bash

# HealthSync Restore-Test Script
BACKUP_DIR="$HOME/backups"
LOG_FILE="$BACKUP_DIR/backup.log"
TEST_DB="healthsync_restore_test"

DB_USER="healthsync_user"
export PGPASSWORD="Bartal123!"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Neuestes Backup finden
LATEST=$(ls -t "$BACKUP_DIR"/healthsync_*.sql.gz 2>/dev/null | head -1)

if [ -z "$LATEST" ]; then
    log "FEHLER: Kein Backup gefunden in $BACKUP_DIR"
    exit 1
fi

log "===== Restore-Test gestartet ====="
log "Teste Backup: $LATEST"

# Test-DB anlegen
psql -U "$DB_USER" -h localhost -d postgres -c "DROP DATABASE IF EXISTS $TEST_DB;" > /dev/null 2>&1
psql -U "$DB_USER" -h localhost -d postgres -c "CREATE DATABASE $TEST_DB;" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    log "FEHLER: Test-Datenbank konnte nicht erstellt werden"
    exit 1
fi

# Backup einspielen
gunzip -c "$LATEST" | psql -U "$DB_USER" -h localhost "$TEST_DB" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    log "FEHLER: Restore in Test-DB fehlgeschlagen"
    psql -U "$DB_USER" -h localhost -d postgres -c "DROP DATABASE IF EXISTS $TEST_DB;" > /dev/null 2>&1
    exit 1
fi

# Tabellen prüfen
TABLES=$(psql -U "$DB_USER" -h localhost "$TEST_DB" -t -c \
    "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null | tr -d ' ')

log "Tabellen in wiederhergestellter DB: $TABLES"

# Test-DB aufräumen
psql -U "$DB_USER" -h localhost -d postgres -c "DROP DATABASE IF EXISTS $TEST_DB;" > /dev/null 2>&1

if [ "$TABLES" -gt 0 ]; then
    log "Restore-Test ERFOLGREICH"
else
    log "WARNUNG: Restore-Test — keine Tabellen gefunden"
fi

log "===== Restore-Test abgeschlossen ====="
