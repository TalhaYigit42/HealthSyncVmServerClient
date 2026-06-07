#!/usr/bin/env python3
"""
Download all CSV files from a Google Drive folder into a local directory.

Authentication:
    Place a `credentials.json` (OAuth2 Desktop App) in the project root
    (one level above the converters/ folder), or set GDRIVE_CREDENTIALS_PATH
    in the environment to point elsewhere.

    On first run the script opens a browser for consent and saves a
    token.json next to credentials.json.  Subsequent runs are automatic.

Usage (standalone):
    python download_gdrive.py <folder_id> <destination_dir>

Folder ID:
    The ID is the last path component in the Drive folder URL:
    https://drive.google.com/drive/folders/<FOLDER_ID>
"""

import os
import io
import sys

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload

# Read + delete access to the user's Drive files
SCOPES = ["https://www.googleapis.com/auth/drive"]


def _get_credentials(credentials_path: str, token_path: str) -> Credentials:
    """Load existing token or run the OAuth2 flow to create one."""
    creds = None

    if os.path.exists(token_path):
        creds = Credentials.from_authorized_user_file(token_path, SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            if not os.path.exists(credentials_path):
                raise FileNotFoundError(
                    f"Google OAuth credentials file not found: {credentials_path}\n"
                    "Download it from https://console.cloud.google.com/ "
                    "(APIs & Services → Credentials → OAuth 2.0 Client IDs) "
                    "and save it as credentials.json in the project root."
                )
            flow = InstalledAppFlow.from_client_secrets_file(credentials_path, SCOPES)
            creds = flow.run_local_server(port=0)

        with open(token_path, "w") as fh:
            fh.write(creds.to_json())

    return creds


def download_csv_files(folder_id: str, dest_dir: str,
                       credentials_path: str = None,
                       token_path: str = None) -> list[str]:
    """
    Download every CSV file found in `folder_id` (non-recursive, top level
    only) into `dest_dir`.  Skips files that have already been downloaded
    (same name + same Drive modifiedTime stored in a sidecar .meta file).

    Returns a list of local file paths that were freshly downloaded.
    """
    # Resolve credential paths
    project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    if credentials_path is None:
        credentials_path = os.environ.get(
            "GDRIVE_CREDENTIALS_PATH",
            os.path.join(project_root, "credentials.json")
        )
    if token_path is None:
        token_path = os.path.join(os.path.dirname(credentials_path), "token.json")

    os.makedirs(dest_dir, exist_ok=True)

    creds = _get_credentials(credentials_path, token_path)
    service = build("drive", "v3", credentials=creds)

    # List all CSV files in the folder (filter by extension, not MIME type,
    # because some exporters use text/troff or other non-standard types)
    query = (
        f"'{folder_id}' in parents "
        "and name contains '.csv' "
        "and trashed=false"
    )
    results = (
        service.files()
        .list(
            q=query,
            fields="files(id, name, modifiedTime)",
            pageSize=1000,
        )
        .execute()
    )
    remote_files = results.get("files", [])

    if not remote_files:
        print("  [drive] No CSV files found in the Drive folder.")
        return []

    print(f"  [drive] Found {len(remote_files)} CSV file(s) in Drive folder.")
    downloaded = []  # list of {"local_path": str, "drive_id": str}

    for file_info in remote_files:
        file_id = file_info["id"]
        file_name = file_info["name"]
        modified_time = file_info.get("modifiedTime", "")

        local_path = os.path.join(dest_dir, file_name)
        meta_path = local_path + ".meta"

        # Skip if already downloaded with the same modification timestamp
        if os.path.exists(local_path) and os.path.exists(meta_path):
            with open(meta_path) as mf:
                cached_time = mf.read().strip()
            if cached_time == modified_time:
                print(f"  [drive] Skipping (up-to-date): {file_name}")
                continue

        print(f"  [drive] Downloading: {file_name} ...", end=" ", flush=True)
        request = service.files().get_media(fileId=file_id)
        buf = io.BytesIO()
        downloader = MediaIoBaseDownload(buf, request)
        done = False
        while not done:
            _, done = downloader.next_chunk()

        buf.seek(0)
        with open(local_path, "wb") as fh:
            fh.write(buf.read())

        # Write sidecar meta file with the modification timestamp
        with open(meta_path, "w") as mf:
            mf.write(modified_time)

        print("done")
        downloaded.append({"local_path": local_path, "drive_id": file_id})

    print(f"  [drive] Downloaded {len(downloaded)} new/updated file(s).")
    return downloaded


def download_csv_files_with_creds(folder_id: str, dest_dir: str, creds) -> list[dict]:
    """
    Same as download_csv_files but accepts a Credentials object directly.
    Used by the multi-user pipeline.
    """
    os.makedirs(dest_dir, exist_ok=True)
    service = build("drive", "v3", credentials=creds)

    query = f"'{folder_id}' in parents and name contains '.csv' and trashed=false"
    results = service.files().list(
        q=query, fields="files(id, name, modifiedTime)", pageSize=1000
    ).execute()
    remote_files = results.get("files", [])

    if not remote_files:
        return []

    downloaded = []
    for file_info in remote_files:
        file_id = file_info["id"]
        file_name = file_info["name"]
        modified_time = file_info.get("modifiedTime", "")
        local_path = os.path.join(dest_dir, file_name)
        meta_path = local_path + ".meta"

        if os.path.exists(local_path) and os.path.exists(meta_path):
            with open(meta_path) as mf:
                if mf.read().strip() == modified_time:
                    continue

        request = service.files().get_media(fileId=file_id)
        buf = io.BytesIO()
        downloader = MediaIoBaseDownload(buf, request)
        done = False
        while not done:
            _, done = downloader.next_chunk()
        buf.seek(0)
        with open(local_path, "wb") as fh:
            fh.write(buf.read())
        with open(meta_path, "w") as mf:
            mf.write(modified_time)
        downloaded.append({"local_path": local_path, "drive_id": file_id})

    return downloaded


def delete_drive_files_with_creds(file_ids: list[str], creds):
    """Delete Drive files using a Credentials object directly."""
    if not file_ids:
        return
    service = build("drive", "v3", credentials=creds)
    for file_id in file_ids:
        try:
            service.files().delete(fileId=file_id).execute()
        except Exception as e:
            print(f"  [drive] WARNING: could not delete {file_id}: {e}")


def delete_drive_files(file_ids: list[str],
                       credentials_path: str = None,
                       token_path: str = None):
    """Permanently delete files from Google Drive by their file IDs."""
    if not file_ids:
        return

    project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    if credentials_path is None:
        credentials_path = os.environ.get(
            "GDRIVE_CREDENTIALS_PATH",
            os.path.join(project_root, "credentials.json")
        )
    if token_path is None:
        token_path = os.path.join(os.path.dirname(credentials_path), "token.json")

    creds = _get_credentials(credentials_path, token_path)
    service = build("drive", "v3", credentials=creds)

    deleted = 0
    for file_id in file_ids:
        try:
            service.files().delete(fileId=file_id).execute()
            deleted += 1
        except Exception as e:
            print(f"  [drive] WARNING: could not delete file {file_id}: {e}")

    print(f"  [drive] Deleted {deleted}/{len(file_ids)} file(s) from Drive.")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python download_gdrive.py <folder_id> <destination_dir>")
        sys.exit(1)

    folder = sys.argv[1]
    dest = sys.argv[2]
    files = download_csv_files(folder, dest)
    for f in files:
        print(f"  Downloaded: {f}")
