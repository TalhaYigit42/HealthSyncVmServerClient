#!/bin/bash

echo "Starting HealthSync..."

# Start PostgreSQL if not running
if ! systemctl is-active --quiet postgresql; then
  echo "Starting PostgreSQL..."
  sudo systemctl start postgresql
fi

# Kill any existing node processes
pkill -f "node server.js" 2>/dev/null
pkill -f "node api.js" 2>/dev/null
sleep 1

# Start the backend (Vue frontend + API on port 3000)
cd ~/HealthSyncWeb
nohup node server.js >> ~/web.log 2>&1 &
sleep 2

if curl -s http://localhost:3000 > /dev/null; then
  echo "Backend running at http://192.168.122.138:3000"
else
  echo "ERROR: Backend failed to start. Check ~/web.log"
  exit 1
fi

# Run pipeline to fetch latest data from Google Drive
echo "Fetching latest data from Google Drive..."
cd ~/HealthsyncServerApp
timeout 120 python3 src/pipeline/pipeline.py 2>&1 | grep -E "Pipeline|ERROR|Done|No new|complete|gestartet"

echo "Done. Open http://192.168.122.138:3000"
