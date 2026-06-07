#!/usr/bin/env python3
"""
Download CSV files from Google Drive using a Service Account.

Setup:
    1. Create a service account in Google Cloud Console
    2. Enable the Google Drive API
    3. Save the key as service_account.json in the project root
    4. Each user shares their HealthSync Drive folders with the service account email

The service account auto-discovers all shared HealthSync folders and identifies
the owner by their Google email address, which becomes their user_id.
"""

import os
import io
import sys

import psycopg2
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload

SCOPES = ["https://www.googleapis.com/auth/drive.readonly"]

FOLDER_TYPE_KEYWORDS = {
    "aktivitaeten": "aktivit",
    "puls":         "puls",
    "sauerstoff":   "sauerstoff",
    "schlaf":       "schlaf",
    "schritte":     "schritt",
    "kalorien":     "kalorien",
}


def _get_credentials(service_account_path: str):
    if not os.path.exists(service_account_path):
        raise FileNotFoundError(
            f"Service account key not found: {service_account_path}\n"
            "Download it from Google Cloud Console → APIs & Services → Credentials → "
            "Service Accounts → Keys and save it as service_account.json."
        )
    return service_account.Credentials.from_service_account_file(
        service_account_path, scopes=SCOPES
    )


def _default_sa_path():
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    return os.environ.get(
        "GDRIVE_SERVICE_ACCOUNT_PATH",
        os.path.join(project_root, "service_account.json")
    )


def discover_user_folders(service_account_path: str = None) -> dict:
    """
    Scan all folders shared with the service account and group them by owner.

    Returns:
        {
          "user@gmail.com": {
            "aktivitaeten": "<folder_id>",
            "puls":         "<folder_id>",
            ...
          },
          ...
        }
    """
    if service_account_path is None:
        service_account_path = _default_sa_path()

    creds = _get_credentials(service_account_path)
    service = build("drive", "v3", credentials=creds)

    results = service.files().list(
        q="sharedWithMe=true and mimeType='application/vnd.google-apps.folder' and trashed=false",
        fields="files(id, name, owners)",
        pageSize=1000,
    ).execute()

    folders = results.get("files", [])
    user_folders = {}

    for folder in folders:
        name_lower = folder["name"].lower()
        owners = folder.get("owners", [])
        if not owners:
            continue
        owner_email = owners[0]["emailAddress"]

        folder_type = None
        for ftype, keyword in FOLDER_TYPE_KEYWORDS.items():
            if keyword in name_lower:
                folder_type = ftype
                break

        if folder_type is None:
            continue

        if owner_email not in user_folders:
            user_folders[owner_email] = {}
        user_folders[owner_email][folder_type] = folder["id"]

    return user_folders


def _get_db_conn():
    import os
    return psycopg2.connect(
        dbname=os.environ.get("DB_NAME", "healthsync"),
        user=os.environ.get("DB_USER", "healthsync_user"),
        password=os.environ.get("DB_PASSWORD", "Bartal123!"),
        host=os.environ.get("DB_HOST", "localhost"),
        port=os.environ.get("DB_PORT", "5432"),
    )


def _is_processed(conn, drive_file_id: str) -> bool:
    with conn.cursor() as cur:
        cur.execute("SELECT 1 FROM processed_drive_files WHERE drive_file_id = %s", (drive_file_id,))
        return cur.fetchone() is not None


def mark_processed(conn, drive_file_id: str, user_id: str, file_name: str):
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO processed_drive_files (drive_file_id, user_id, file_name) "
            "VALUES (%s, %s, %s) ON CONFLICT DO NOTHING",
            (drive_file_id, user_id, file_name)
        )
    conn.commit()


def download_csv_files(folder_id: str, dest_dir: str,
                       service_account_path: str = None,
                       user_id: str = None) -> list:
    """
    Download every CSV file in `folder_id` into `dest_dir`.
    Skips files whose Drive ID is already in processed_drive_files.

    Returns: [{"local_path": str, "drive_id": str, "file_name": str}, ...]
    """
    if service_account_path is None:
        service_account_path = _default_sa_path()

    os.makedirs(dest_dir, exist_ok=True)

    creds = _get_credentials(service_account_path)
    service = build("drive", "v3", credentials=creds)

    query = (
        f"'{folder_id}' in parents "
        "and name contains '.csv' "
        "and trashed=false"
    )
    results = service.files().list(
        q=query,
        fields="files(id, name, modifiedTime)",
        pageSize=1000,
    ).execute()
    remote_files = results.get("files", [])

    if not remote_files:
        print("  [drive] No CSV files found in folder.")
        return []

    print(f"  [drive] Found {len(remote_files)} CSV file(s).")
    downloaded = []

    try:
        conn = _get_db_conn()
    except Exception as e:
        print(f"  [drive] WARNING: DB unavailable for dedup check: {e}")
        conn = None

    for file_info in remote_files:
        file_id = file_info["id"]
        file_name = file_info["name"]

        if conn and _is_processed(conn, file_id):
            print(f"  [drive] Skipping (already processed): {file_name}")
            continue

        print(f"  [drive] Downloading: {file_name} ...", end=" ", flush=True)
        request = service.files().get_media(fileId=file_id)
        buf = io.BytesIO()
        downloader = MediaIoBaseDownload(buf, request)
        done = False
        while not done:
            _, done = downloader.next_chunk()

        buf.seek(0)
        local_path = os.path.join(dest_dir, file_name)
        with open(local_path, "wb") as fh:
            fh.write(buf.read())

        print("done")
        downloaded.append({"local_path": local_path, "drive_id": file_id, "file_name": file_name})

    if conn:
        conn.close()

    print(f"  [drive] Downloaded {len(downloaded)} new file(s).")
    return downloaded


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python download_gdrive.py <folder_id> <destination_dir>")
        sys.exit(1)
    files = download_csv_files(sys.argv[1], sys.argv[2])
    for f in files:
        print(f"  Downloaded: {f}")
