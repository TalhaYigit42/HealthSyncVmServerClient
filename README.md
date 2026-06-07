# HealthSync — Full Setup Guide

A health tracking web app with a **Vue 3** frontend and **Node.js + Express + PostgreSQL** backend.
The app shows dashboards for steps, sleep, heart rate, oxygen, and activities.
Health data is imported automatically from Google Drive CSVs via a Python pipeline.

---

## How it works (big picture)

```
Samsung Health app
      ↓ exports CSVs
Google Drive folders  ←──────────────────────────────────────┐
      ↓                                                       │
Python pipeline (HealthsyncServerApp/)                        │
  - Runs every 15 minutes                                     │
  - Downloads new CSVs from Drive                             │
  - Converts them → inserts into PostgreSQL DB                │
      ↓                                                       │
PostgreSQL database (healthsync)                              │
      ↓                                                       │
Node.js backend (server.js)                                   │
  - REST API with JWT auth                                    │
  - Serves the Vue frontend                                   │
      ↓                                                       │
Browser → http://localhost:3000  ─────────────────────────────┘
```

---

## What you need installed

- [Node.js](https://nodejs.org/) v18+
- [Python](https://www.python.org/) 3.10+
- [PostgreSQL](https://www.postgresql.org/download/) v14+
- Git

---

## Step 1 — Clone the repo

```bash
git clone https://github.com/TalhaYigit42/HealthSyncVmServerClient.git
cd HealthSyncVmServerClient
```

---

## Step 2 — Set up PostgreSQL

Open a terminal and run:

```bash
sudo -u postgres psql
```

Inside psql, paste this:

```sql
CREATE USER healthsync_user WITH PASSWORD 'Bartal123!';
CREATE DATABASE healthsync OWNER healthsync_user;
GRANT ALL PRIVILEGES ON DATABASE healthsync TO healthsync_user;
\q
```

Then import the full database (schema + existing data):

```bash
PGPASSWORD=Bartal123! psql -U healthsync_user -h localhost -d healthsync -f healthsync_dump.sql
```

---

## Step 3 — Configure the backend (.env)

Create a `.env` file in the **root folder** of the repo:

```
PORT=3000
JWT_SECRET=HealthSync_S3cur3_JWT_S3cr3t_K3y_2025!

DB_HOST=localhost
DB_USER=healthsync_user
DB_PASSWORD=Bartal123!
DB_NAME=healthsync
DB_PORT=5432

EMAIL_USER=
EMAIL_PASS=
APP_URL=http://localhost:3000
```

**What each variable does:**

| Variable | What it's for |
|---|---|
| `PORT` | Which port the app runs on |
| `JWT_SECRET` | Secret key used to sign login tokens — can be any long random string |
| `DB_HOST` | Where PostgreSQL is running (`localhost` for your own machine) |
| `DB_USER` / `DB_PASSWORD` | The DB user you created in Step 2 |
| `DB_NAME` | The database name |
| `EMAIL_USER` / `EMAIL_PASS` | Gmail address + app password for sending password reset emails (optional) |
| `APP_URL` | Your server's address — used in reset email links |

> **EMAIL_USER / EMAIL_PASS** — only needed if you want password reset emails to work.
> To get an app password: Google Account → Security → 2-Step Verification → App passwords.
> Leave blank if you don't need it.

---

## Step 4 — Install and build

```bash
# Backend
npm install

# Frontend
cd frontend
npm install
npm run build
cd ..
```

The `npm run build` compiles the Vue app into `frontend/dist/` — the backend automatically serves it.

---

## Step 5 — Start the app

```bash
node server.js
```

Open your browser: **http://localhost:3000**

You'll see the login page. You can register a new account or use a test account:

| Email | Password |
|---|---|
| `talhakere@gmail.com` | `Password123!` |
| `talhayigit142@gmail.com` | `Password123!` |
| `alex.k.kaczmarczyk@gmail.com` | `Password123!` |

---

## Step 6 (optional) — Set up the Google Drive pipeline

This is only needed if you want to automatically import health data from Google Drive.
If you just want to use the app with the existing data, skip this.

### How it works

The pipeline (`HealthsyncServerApp/`) uses a **Google service account** to access Drive:

1. You export health data from Samsung Health as CSVs
2. Upload them to specific Google Drive folders
3. Share those folders with the service account email
4. The pipeline checks every 15 minutes for new files, downloads them, converts them, and inserts them into the DB
5. After processing, files are deleted from Drive automatically

### Setting up Google credentials

**You need a `service_account.json` file.** Here's how to get one:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or use an existing one)
3. Go to **APIs & Services → Library** and enable **Google Drive API**
4. Go to **APIs & Services → Credentials → Create Credentials → Service Account**
5. Give it a name, click Create
6. On the service account page, go to **Keys → Add Key → JSON**
7. Download the JSON file and save it as `service_account.json` in the `HealthsyncServerApp/` folder

### Share your Drive folders with the service account

1. Open the `service_account.json` file and find the `client_email` field (looks like `something@project.iam.gserviceaccount.com`)
2. In Google Drive, right-click each of your health data folders → Share → paste that email → give it **Editor** access

The pipeline expects folders named with these German keywords (from Samsung Health exports):
- `Health Sync Aktivitäten` (activities)
- `Health Sync Puls` (heart rate)
- `Health Sync Schlaf` (sleep)
- `Health Sync Schritte` (steps)
- `Health Sync Sauerstoffsättigung` (oxygen)

### Run the pipeline

```bash
cd HealthsyncServerApp
pip install -r requirements.txt  # if you have one, otherwise:
pip install google-api-python-client google-auth google-auth-oauthlib psycopg2-binary schedule

python src/pipeline/pipeline.py
```

It will run once immediately, then repeat every 15 minutes.

---

## Project structure

```
HealthSyncVmServerClient/
│
├── server.js              # Main backend — Express API + serves frontend
├── package.json           # Backend Node dependencies
├── .env                   # Your config (you create this — not in git)
├── healthsync_dump.sql    # Full DB dump — import this in Step 2
├── seed_users.js          # Adds test users with fake data (optional)
├── send_reminder.js       # Script that sends daily email reminders
├── testlocal.sh           # Linux/Mac startup script
│
├── frontend/              # Vue 3 frontend
│   ├── src/
│   │   ├── views/         # Full pages: Dashboard, Health, Sleep, Activity, etc.
│   │   ├── components/    # Reusable bits: Sidebar, charts, widgets
│   │   ├── router.js      # Which URL goes to which page
│   │   └── main.js        # App entry point
│   └── dist/              # Built output (generated by npm run build)
│
├── HealthsyncServerApp/   # Python data pipeline (Sprint 1)
│   ├── src/pipeline/
│   │   ├── pipeline.py          # Main loop — runs every 15 min
│   │   ├── download_gdrive.py   # Downloads CSVs from Google Drive
│   │   └── converters/          # One converter per data type (steps, sleep, etc.)
│   ├── service_account.json     # Google credentials (you add this — not in git)
│   └── csv_staging/             # Temp folder for downloaded CSVs (auto-cleaned)
│
└── backups/
    ├── backup_db.sh       # Script to dump the DB to a .sql.gz file
    └── restore_test.sh    # Script to restore from a backup
```

---

## Troubleshooting

**"password authentication failed"**
Make sure PostgreSQL is running (`sudo systemctl start postgresql`) and the password in `.env` matches Step 2.

**Blank page / frontend not loading**
Run `npm run build` inside the `frontend/` folder.

**Pipeline says "No new CSV files"**
Either the Drive folders have no new files, or the service account doesn't have access — check that you shared the folders with the service account email.

**Port 3000 already in use**
Change `PORT=3000` in `.env` to something else like `3001`.
