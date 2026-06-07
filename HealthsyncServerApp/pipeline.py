#!/usr/bin/env python3
"""
HealthSync Pipeline — runs every 15 minutes.

Automatically discovers all users by scanning Google Drive folders shared
with the service account. The folder owner's email is used as user_id.

To add a new user: they just share their HealthSync Drive folders with
the service account email. No config changes needed.

Steps each cycle (per discovered user):
  1. Discover all shared HealthSync folders and group by owner email
  2. Download new CSV files per user
  3. Convert CSVs → JSON → insert into DB (tagged with user_id)
  4. Clean up local staging files

Environment variables:
  GDRIVE_SERVICE_ACCOUNT_PATH — path to service_account.json (default: ./service_account.json)
  PIPELINE_INTERVAL_MIN       — scheduler interval in minutes (default: 15)
  PIPELINE_CSV_STAGING        — local staging dir for downloads (default: ./csv_staging)
"""

import os
import sys
import glob
import shutil
import schedule
import time
import traceback
from datetime import datetime

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
CONVERTERS_DIR = os.path.join(PROJECT_ROOT, "converters")
OUTPUT_DIR = os.path.join(CONVERTERS_DIR, "output")

if CONVERTERS_DIR not in sys.path:
    sys.path.insert(0, CONVERTERS_DIR)

GDRIVE_SERVICE_ACCOUNT_PATH = os.environ.get(
    "GDRIVE_SERVICE_ACCOUNT_PATH",
    os.path.join(PROJECT_ROOT, "service_account.json")
)
PIPELINE_INTERVAL_MIN = int(os.environ.get("PIPELINE_INTERVAL_MIN", "15"))
CSV_STAGING_DIR = os.environ.get(
    "PIPELINE_CSV_STAGING",
    os.path.join(PROJECT_ROOT, "csv_staging")
)

FOLDER_KEY_TO_NAME = {
    "aktivitaeten": "Health Sync Aktivitäten",
    "puls":         "Health Sync Puls",
    "sauerstoff":   "Health Sync Sauerstoffsättigung",
    "schlaf":       "Health Sync Schlaf",
    "schritte":     "Health Sync Schritte",
    "kalorien":     "Health Sync Kalorien",
}


def _log(msg: str):
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{ts}] {msg}", flush=True)


def clear_output_dir():
    if not os.path.isdir(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        return
    removed_files = removed_dirs = 0
    for entry in os.listdir(OUTPUT_DIR):
        full_path = os.path.join(OUTPUT_DIR, entry)
        if os.path.isdir(full_path):
            shutil.rmtree(full_path)
            removed_dirs += 1
        else:
            os.remove(full_path)
            removed_files += 1
    _log(f"Cleared output dir: {removed_files} file(s), {removed_dirs} dir(s) removed.")


def delete_json_output():
    if not os.path.isdir(OUTPUT_DIR):
        return
    removed = 0
    for fpath in glob.glob(os.path.join(OUTPUT_DIR, "**", "*.json"), recursive=True):
        os.remove(fpath)
        removed += 1
    for entry in os.listdir(OUTPUT_DIR):
        day_dir = os.path.join(OUTPUT_DIR, entry)
        if os.path.isdir(day_dir) and not os.listdir(day_dir):
            os.rmdir(day_dir)
    _log(f"Deleted {removed} JSON file(s) from output dir.")


def run_pipeline():
    _log("=" * 60)
    _log("Pipeline cycle starting.")
    _log("=" * 60)

    from download_gdrive import discover_user_folders, download_csv_files
    import run_all

    # Step 1 — Auto-discover users from shared Drive folders
    _log("Step 1 — Discovering users from shared Google Drive folders ...")
    try:
        user_folders = discover_user_folders(GDRIVE_SERVICE_ACCOUNT_PATH)
    except Exception:
        _log("ERROR during folder discovery:")
        traceback.print_exc()
        return

    if not user_folders:
        _log("No shared HealthSync folders found. Make sure users have shared their folders.")
        return

    _log(f"Found {len(user_folders)} user(s): {', '.join(user_folders.keys())}")

    any_downloaded = False

    for user_id, folders in user_folders.items():
        _log(f"--- Processing user: {user_id} ---")

        user_staging = os.path.join(CSV_STAGING_DIR, user_id.replace("@", "_").replace(".", "_"))
        if os.path.isdir(user_staging):
            shutil.rmtree(user_staging)
        os.makedirs(user_staging, exist_ok=True)

        user_downloaded = []

        for folder_key, folder_id in folders.items():
            category_name = FOLDER_KEY_TO_NAME.get(folder_key, folder_key)
            dest_subdir = os.path.join(user_staging, category_name)
            os.makedirs(dest_subdir, exist_ok=True)
            try:
                batch = download_csv_files(
                    folder_id=folder_id,
                    dest_dir=dest_subdir,
                    service_account_path=GDRIVE_SERVICE_ACCOUNT_PATH,
                    user_id=user_id,
                )
                user_downloaded.extend(batch)
            except Exception:
                _log(f"ERROR downloading '{category_name}' for {user_id}:")
                traceback.print_exc()

        if not user_downloaded:
            _log(f"No new files for {user_id}. Skipping.")
            shutil.rmtree(user_staging, ignore_errors=True)
            continue

        any_downloaded = True
        _log(f"Downloaded {len(user_downloaded)} file(s) for {user_id}. Running converters ...")

        clear_output_dir()

        try:
            run_all.run_all(user_staging, OUTPUT_DIR, user_id=user_id)
            # Mark all downloaded files as processed so they're skipped next cycle
            from download_gdrive import mark_processed, _get_db_conn
            try:
                conn = _get_db_conn()
                for f in user_downloaded:
                    mark_processed(conn, f["drive_id"], user_id, f["file_name"])
                conn.close()
                _log(f"Marked {len(user_downloaded)} file(s) as processed.")
            except Exception:
                _log("WARNING: Could not mark files as processed:")
                traceback.print_exc()
        except Exception:
            _log(f"ERROR during conversion/DB insertion for {user_id}:")
            traceback.print_exc()

        shutil.rmtree(user_staging, ignore_errors=True)
        delete_json_output()

    if not any_downloaded:
        _log("No new CSV files for any user. Cycle complete.")
        return

    _log("Pipeline cycle complete.")
    _log("=" * 60)


if __name__ == "__main__":
    _log(f"HealthSync Pipeline started (interval: {PIPELINE_INTERVAL_MIN} min).")
    _log(f"  Service account : {GDRIVE_SERVICE_ACCOUNT_PATH}")
    _log(f"  CSV staging dir : {CSV_STAGING_DIR}")
    _log(f"  Output dir      : {OUTPUT_DIR}")
    print()

    run_pipeline()

    schedule.every(PIPELINE_INTERVAL_MIN).minutes.do(run_pipeline)
    _log(f"Scheduler running. Next run in {PIPELINE_INTERVAL_MIN} minute(s). Press Ctrl+C to stop.")

    while True:
        schedule.run_pending()
        time.sleep(30)
