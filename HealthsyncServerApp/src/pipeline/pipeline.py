#!/usr/bin/env python3
"""
HealthSync Pipeline — runs every 15 minutes.

Steps each cycle:
  1. Download new CSV files from Google Drive into a staging folder
  2. Clear converters/output/ to avoid stale/duplicate JSON
  3. Run converters/run_all.py  (converts CSVs → JSON, then inserts into DB)
  4. Delete the downloaded CSV files and all JSON output files

Configuration via environment variables (or edit the DEFAULTS below):
  GDRIVE_FOLDER_ID        — Google Drive folder ID (REQUIRED)
  GDRIVE_CREDENTIALS_PATH — path to credentials.json  (default: ./credentials.json)
  PIPELINE_INTERVAL_MIN   — scheduler interval in minutes (default: 15)
  PIPELINE_CSV_STAGING    — where to put downloaded CSVs (default: ./csv_staging)
"""

import os
import sys
import glob
import json
import shutil
import schedule
import time
import traceback
from datetime import datetime

import psycopg2
from google.oauth2.credentials import Credentials
from google.auth.transport.requests import Request

# ---------------------------------------------------------------------------
# Paths  (all relative to this file's directory)
# ---------------------------------------------------------------------------
_THIS_DIR      = os.path.dirname(os.path.abspath(__file__))         # src/pipeline/
PROJECT_ROOT   = os.path.dirname(os.path.dirname(_THIS_DIR))        # project root
CONVERTERS_DIR = os.path.join(_THIS_DIR, "converters")              # src/pipeline/converters/
OUTPUT_DIR     = os.path.join(CONVERTERS_DIR, "output")

# src/pipeline/ → download_gdrive; src/pipeline/converters/ → run_all + converters
for _p in (_THIS_DIR, CONVERTERS_DIR):
    if _p not in sys.path:
        sys.path.insert(0, _p)

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

# Maps each Google Drive folder ID → local subfolder name.
# Subfolder names must contain the German keywords that run_all.py uses
# for type detection (aktivit, puls, schlaf, schritt, sauerstoff).
FOLDER_MAP = {
    "1Fgjms4WYhTg0HkDelEjd_w3zgHkUBCi1": "Health Sync Aktivitäten",
    "1g4nFO0DCfsXfXBWUe9za-uILAYJx3-9q": "Health Sync Puls",
    "14qmdpRz1Tvl7InPjlIdce2T-FRrAf9vq": "Health Sync Sauerstoffsättigung",
    "1Ue2v7QYGt_HKBtVuC6LfOfcOasWY2b2B": "Health Sync Schlaf",
    "1J78K8Ilt5FwLchrQCWcA5xUU4SntitIl": "Health Sync Schritte",
    "1KE42aJ07PTan4rO8QdLnuszrkRxRjPmD": "Health Sync Kalorien",  # no converter, skipped
}

GDRIVE_CREDENTIALS_PATH = os.environ.get(
    "GDRIVE_CREDENTIALS_PATH",
    os.path.join(PROJECT_ROOT, "credentials.json")
)
PIPELINE_INTERVAL_MIN = int(os.environ.get("PIPELINE_INTERVAL_MIN", "15"))
CSV_STAGING_DIR = os.environ.get(
    "PIPELINE_CSV_STAGING",
    os.path.join(PROJECT_ROOT, "csv_staging")
)

# DB connection for reading users
_DB = dict(
    dbname=os.environ.get("DB_NAME", "healthsync"),
    user=os.environ.get("DB_USER", "healthsync_user"),
    password=os.environ.get("DB_PASSWORD", "Bartal123!"),
    host=os.environ.get("DB_HOST", "localhost"),
    port=os.environ.get("DB_PORT", "5432"),
)

# Load client credentials for token refresh
def _load_client_creds():
    try:
        with open(GDRIVE_CREDENTIALS_PATH) as f:
            raw = json.load(f)
        return raw.get("installed") or raw.get("web")
    except Exception:
        return None

def _get_users_with_tokens():
    """Return list of (user_id, folder_ids_dict, credentials) for all users with Drive connected."""
    client = _load_client_creds()
    if not client:
        _log("WARNING: credentials.json not found — cannot build user credentials.")
        return []
    try:
        conn = psycopg2.connect(**_DB)
        cur = conn.cursor()
        cur.execute("SELECT id, google_refresh_token, drive_folder_ids FROM users WHERE google_refresh_token IS NOT NULL")
        rows = cur.fetchall()
        conn.close()
    except Exception as e:
        _log(f"WARNING: Could not query users table: {e}")
        return []

    result = []
    for user_id, refresh_token, drive_folder_ids in rows:
        creds = Credentials(
            token=None,
            refresh_token=refresh_token,
            token_uri="https://oauth2.googleapis.com/token",
            client_id=client["client_id"],
            client_secret=client["client_secret"],
        )
        try:
            creds.refresh(Request())
        except Exception as e:
            _log(f"WARNING: Could not refresh token for user {user_id}: {e}")
            continue
        folder_ids = drive_folder_ids if isinstance(drive_folder_ids, dict) else {}
        result.append((user_id, folder_ids, creds))
    return result


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _log(msg: str):
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{ts}] {msg}", flush=True)


def clear_output_dir():
    """Remove all files and subdirectories inside converters/output/."""
    if not os.path.isdir(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        _log(f"Created empty output dir: {OUTPUT_DIR}")
        return

    removed_files = 0
    removed_dirs = 0

    for entry in os.listdir(OUTPUT_DIR):
        full_path = os.path.join(OUTPUT_DIR, entry)
        if os.path.isdir(full_path):
            shutil.rmtree(full_path)
            removed_dirs += 1
        else:
            os.remove(full_path)
            removed_files += 1

    _log(f"Cleared output dir: {removed_files} file(s), {removed_dirs} dir(s) removed.")


def delete_csv_staging():
    """Delete all CSV (and .meta sidecar) files from the staging directory."""
    if not os.path.isdir(CSV_STAGING_DIR):
        return
    patterns = [
        os.path.join(CSV_STAGING_DIR, "*.csv"),
        os.path.join(CSV_STAGING_DIR, "*.meta"),
    ]
    removed = 0
    for pattern in patterns:
        for fpath in glob.glob(pattern):
            os.remove(fpath)
            removed += 1
    _log(f"Deleted {removed} file(s) from CSV staging dir.")


def delete_json_output():
    """Remove all JSON output files (and empty date dirs) from converters/output/."""
    if not os.path.isdir(OUTPUT_DIR):
        return

    removed = 0
    json_files = glob.glob(os.path.join(OUTPUT_DIR, "**", "*.json"), recursive=True)
    for fpath in json_files:
        os.remove(fpath)
        removed += 1

    # Remove now-empty date subdirectories
    for entry in os.listdir(OUTPUT_DIR):
        day_dir = os.path.join(OUTPUT_DIR, entry)
        if os.path.isdir(day_dir) and not os.listdir(day_dir):
            os.rmdir(day_dir)

    _log(f"Deleted {removed} JSON file(s) from output dir.")


# ---------------------------------------------------------------------------
# Core pipeline
# ---------------------------------------------------------------------------

def _run_pipeline_for_user(user_id, folder_ids, creds):
    """Run one full pipeline cycle for a single user."""
    from download_gdrive import download_csv_files_with_creds, delete_drive_files_with_creds

    # Build folder map: {folder_id: category_name}
    user_folder_map = {fid: name for name, fid in folder_ids.items()}
    if not user_folder_map:
        _log(f"  [user {user_id}] No Drive folders configured — skipping.")
        return

    organised_base = os.path.join(CSV_STAGING_DIR, f"organised_user_{user_id}")
    if os.path.isdir(organised_base):
        shutil.rmtree(organised_base)
    os.makedirs(organised_base, exist_ok=True)

    all_downloaded = []
    for folder_id, category_name in user_folder_map.items():
        dest_subdir = os.path.join(organised_base, category_name)
        os.makedirs(dest_subdir, exist_ok=True)
        try:
            batch = download_csv_files_with_creds(folder_id, dest_subdir, creds)
            all_downloaded.extend(batch)
        except Exception:
            _log(f"  [user {user_id}] ERROR downloading '{category_name}':")
            traceback.print_exc()

    if not all_downloaded:
        _log(f"  [user {user_id}] No new files.")
        shutil.rmtree(organised_base, ignore_errors=True)
        return

    drive_ids = [f["drive_id"] for f in all_downloaded]
    user_output_dir = os.path.join(OUTPUT_DIR, f"user_{user_id}")
    os.makedirs(user_output_dir, exist_ok=True)

    try:
        import run_all
        run_all.run_all(organised_base, user_output_dir, user_id=user_id)
    except Exception:
        _log(f"  [user {user_id}] ERROR during conversion/DB insertion:")
        traceback.print_exc()

    try:
        delete_drive_files_with_creds(drive_ids, creds)
    except Exception:
        _log(f"  [user {user_id}] WARNING: Drive deletion error:")
        traceback.print_exc()

    shutil.rmtree(organised_base, ignore_errors=True)
    shutil.rmtree(user_output_dir, ignore_errors=True)
    _log(f"  [user {user_id}] Done.")


SERVICE_ACCOUNT_PATH = os.path.join(PROJECT_ROOT, "service_account.json")
SERVICE_ACCOUNT_USER_ID = "alex.k.kaczmarczyk@gmail.com"


def _run_service_account_pipeline():
    """Pipeline using service account credentials — no per-user OAuth needed."""
    from google.oauth2 import service_account as sa
    from download_gdrive import download_csv_files_with_creds, delete_drive_files_with_creds

    creds = sa.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_PATH,
        scopes=["https://www.googleapis.com/auth/drive"],
    )

    organised_base = os.path.join(CSV_STAGING_DIR, "organised_service_account")
    if os.path.isdir(organised_base):
        shutil.rmtree(organised_base)
    os.makedirs(organised_base, exist_ok=True)

    all_downloaded = []
    for folder_id, category_name in FOLDER_MAP.items():
        dest_subdir = os.path.join(organised_base, category_name)
        os.makedirs(dest_subdir, exist_ok=True)
        try:
            batch = download_csv_files_with_creds(folder_id, dest_subdir, creds)
            all_downloaded.extend(batch)
        except Exception:
            _log(f"ERROR downloading '{category_name}' via service account:")
            traceback.print_exc()

    if not all_downloaded:
        _log("No new files via service account. Cycle complete.")
        shutil.rmtree(organised_base, ignore_errors=True)
        return

    drive_ids = [f["drive_id"] for f in all_downloaded]
    user_output_dir = os.path.join(OUTPUT_DIR, "service_account")
    os.makedirs(user_output_dir, exist_ok=True)

    try:
        import run_all
        run_all.run_all(organised_base, user_output_dir, user_id=SERVICE_ACCOUNT_USER_ID)
    except Exception:
        _log("ERROR during conversion/DB insertion (service account):")
        traceback.print_exc()

    try:
        delete_drive_files_with_creds(drive_ids, creds)
    except Exception:
        _log("WARNING: Drive deletion error (service account):")
        traceback.print_exc()

    shutil.rmtree(organised_base, ignore_errors=True)
    shutil.rmtree(user_output_dir, ignore_errors=True)
    _log("Service account pipeline cycle complete.")
    _log("=" * 60)


def run_pipeline():
    _log("=" * 60)
    _log("Pipeline cycle starting.")
    _log("=" * 60)

    if os.path.exists(SERVICE_ACCOUNT_PATH):
        _run_service_account_pipeline()
        return

    users = _get_users_with_tokens()

    if not users:
        # Fallback: run legacy single-user pipeline (token.json based)
        _log("No users with Drive connected. Running legacy pipeline ...")
        _run_legacy_pipeline()
        return

    _log(f"Running pipeline for {len(users)} user(s).")
    for user_id, folder_ids, creds in users:
        _log(f"Processing user {user_id} ...")
        try:
            _run_pipeline_for_user(user_id, folder_ids, creds)
        except Exception:
            _log(f"ERROR for user {user_id}:")
            traceback.print_exc()

    _log("Pipeline cycle complete.")
    _log("=" * 60)


def _run_legacy_pipeline():
    """Original single-user pipeline using token.json (backward compat)."""
    from download_gdrive import download_csv_files

    organised_base = os.path.join(CSV_STAGING_DIR, "organised")
    if os.path.isdir(organised_base):
        shutil.rmtree(organised_base)
    os.makedirs(organised_base, exist_ok=True)

    all_downloaded = []
    for folder_id, category_name in FOLDER_MAP.items():
        dest_subdir = os.path.join(organised_base, category_name)
        os.makedirs(dest_subdir, exist_ok=True)
        try:
            batch = download_csv_files(
                folder_id=folder_id,
                dest_dir=dest_subdir,
                credentials_path=GDRIVE_CREDENTIALS_PATH,
            )
            all_downloaded.extend(batch)
        except Exception:
            _log(f"ERROR downloading from folder '{category_name}':")
            traceback.print_exc()

    if not all_downloaded:
        _log("No new CSV files to process. Cycle complete.")
        return

    drive_ids = [f["drive_id"] for f in all_downloaded]
    clear_output_dir()

    try:
        import run_all
        run_all.run_all(organised_base, OUTPUT_DIR)
    except Exception:
        _log("ERROR during conversion / DB insertion:")
        traceback.print_exc()

    try:
        from download_gdrive import delete_drive_files
        delete_drive_files(drive_ids, credentials_path=GDRIVE_CREDENTIALS_PATH)
    except Exception:
        _log("WARNING: Drive deletion error:")
        traceback.print_exc()

    if os.path.isdir(organised_base):
        shutil.rmtree(organised_base)
    delete_csv_staging()
    delete_json_output()
    _log("Legacy pipeline cycle complete.")
    _log("=" * 60)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    _log(f"HealthSync Pipeline started (interval: {PIPELINE_INTERVAL_MIN} min).")
    _log(f"  Drive folders   : {len(FOLDER_MAP)} configured")
    _log(f"  CSV staging dir : {CSV_STAGING_DIR}")
    _log(f"  Output dir      : {OUTPUT_DIR}")
    _log(f"  Credentials     : {GDRIVE_CREDENTIALS_PATH}")
    print()

    # Run once immediately on startup, then on schedule
    run_pipeline()

    schedule.every(PIPELINE_INTERVAL_MIN).minutes.do(run_pipeline)

    _log(f"Scheduler running. Next run in {PIPELINE_INTERVAL_MIN} minute(s). "
         "Press Ctrl+C to stop.")

    while True:
        schedule.run_pending()
        time.sleep(30)
