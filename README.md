# HealthSync — Setup & Developer Guide

A health tracking web app. Vue 3 frontend, Node.js/Express backend, PostgreSQL database.
Pulls health data (steps, sleep, heart rate, oxygen, activities) from Samsung Health exports via Google Drive.

---

## How it works

```
Samsung Health app
      ↓  exports CSVs
Google Drive folders
      ↓
Python pipeline (HealthsyncServerApp/)
  • runs every 15 min
  • downloads new CSVs from Drive
  • converts them and inserts into DB
      ↓
PostgreSQL database
      ↓
Node.js backend (server.js)
  • REST API with JWT auth
  • serves the built Vue frontend
      ↓
Browser → http://localhost:3000
```

---

## Requirements

- [Node.js](https://nodejs.org/) v18+
- [Python](https://www.python.org/) 3.10+  *(only needed for the pipeline)*
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

```bash
sudo -u postgres psql
```

Inside psql:

```sql
CREATE USER healthsync_user WITH PASSWORD 'Bartal123!';
CREATE DATABASE healthsync OWNER healthsync_user;
GRANT ALL PRIVILEGES ON DATABASE healthsync TO healthsync_user;
\q
```

Import the database (schema + all existing data):

```bash
PGPASSWORD=Bartal123! psql -U healthsync_user -h localhost -d healthsync -f healthsync_dump.sql
```

---

## Step 3 — Create the .env file

Create a file called `.env` in the **root of the repo** (same folder as `server.js`):

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

**What each line does:**

| Variable | What it does |
|---|---|
| `PORT` | Port the app runs on. `3000` means `http://localhost:3000` |
| `JWT_SECRET` | Used to sign login tokens. Can be any long random string — just don't change it while users are logged in or they'll get logged out |
| `DB_HOST` | Where PostgreSQL is. `localhost` if it's on your own machine |
| `DB_USER` | The PostgreSQL user you created above |
| `DB_PASSWORD` | Password for that user |
| `DB_NAME` | The database name |
| `DB_PORT` | PostgreSQL port — almost always `5432` |
| `EMAIL_USER` | Gmail address to send password reset emails from (optional) |
| `EMAIL_PASS` | Gmail **app password** (not your normal password). Get one at: Google Account → Security → 2-Step Verification → App passwords |
| `APP_URL` | Used in password reset links. Change to your IP/domain if running on a server |

> **EMAIL is optional.** If you leave it blank, the app still works — password reset emails just won't send.

---

## Step 4 — Install dependencies and build the frontend

```bash
# Backend
npm install

# Frontend
cd frontend
npm install
npm run build
cd ..
```

`npm run build` compiles the Vue app into `frontend/dist/`. The backend serves it automatically.

---

## Step 5 — Run the app

```bash
node server.js
```

Open **http://localhost:3000** — you'll see the login page.

**Test accounts** (already in the DB dump, password is the same for all):

| Email | Password | Notes |
|---|---|---|
| `talhakere@gmail.com` | `Password123!` | Has 14 days of seeded health data |
| `talhayigit142@gmail.com` | `Password123!` | Empty account |
| `alex.k.kaczmarczyk@gmail.com` | `Password123!` | Empty account |

Or just register a new account — registration is open.

---

## Development workflow (making changes)

When you're actively working on the code, don't run `npm run build` every time you change something.
Instead, run the backend and frontend separately so you get **hot reload** (the browser updates automatically when you save a file).

**Terminal 1 — Backend:**
```bash
node server.js
```

**Terminal 2 — Frontend dev server:**
```bash
cd frontend
npm run dev
```

Then open **http://localhost:5173** (not 3000) — that's the Vite dev server with hot reload.
API calls from the frontend automatically proxy to the backend on port 3000, so both work together.

When you're done and want to deploy/test the final version:
```bash
cd frontend && npm run build && cd ..
node server.js
# → open http://localhost:3000
```

---

## Code structure — where to find everything

```
HealthSyncVmServerClient/
│
├── server.js                         # The entire backend in one file
│   ├── PostgreSQL connection pool
│   ├── JWT auth middleware
│   └── All API routes (/api/login, /api/register, /api/health/*, etc.)
│
├── .env                              # Your config (you create this — never commit it)
├── healthsync_dump.sql               # Full DB export — reimport if DB gets messed up
├── seed_users.js                     # Creates test users with fake data: node seed_users.js
├── send_reminder.js                  # Sends daily health reminder emails: node send_reminder.js
│
├── frontend/src/
│   ├── views/                        # One file per page
│   │   ├── LoginView.vue             # /login
│   │   ├── RegisterView.vue          # /register
│   │   ├── DashboardView.vue         # /dashboard — main overview
│   │   ├── HealthView.vue            # /health — heart rate & oxygen
│   │   ├── SleepView.vue             # /sleep
│   │   ├── ActivityView.vue          # /activity
│   │   ├── AchievementsView.vue      # /achievements
│   │   ├── SettingsView.vue          # /settings — goals, email prefs
│   │   ├── ImportView.vue            # /import — upload CSVs manually
│   │   ├── ForgotPasswordView.vue    # /forgot-password
│   │   └── ResetPasswordView.vue     # /reset-password
│   │
│   ├── components/                   # Reusable pieces used across pages
│   │   ├── Sidebar.vue               # Navigation sidebar
│   │   ├── StatCard.vue              # The metric cards (steps, bpm, etc.)
│   │   ├── WeeklyOverview.vue        # Bar chart component
│   │   ├── SummaryWidget.vue
│   │   ├── StreakWidget.vue
│   │   ├── AchievementsWidget.vue
│   │   ├── DailyQuests.vue
│   │   └── TipsWidget.vue
│   │
│   ├── router.js                     # URL → page mapping + auth guards
│   ├── App.vue                       # Root component (wraps everything)
│   └── main.js                       # App entry point
│
└── HealthsyncServerApp/              # Python data pipeline (Sprint 1)
    ├── src/pipeline/
    │   ├── pipeline.py               # Main loop — polls every 15 min
    │   ├── download_gdrive.py        # Downloads CSVs from Google Drive
    │   └── converters/               # One script per data type
    │       ├── convert_steps.py
    │       ├── convert_sleep.py
    │       ├── convert_heart_rate.py
    │       ├── convert_oxygen.py
    │       ├── convert_activities.py
    │       └── run_all.py            # Runs all converters in sequence
    └── service_account.json          # Google credentials (you add this — not in git)
```

### Adding a new page

1. Create `frontend/src/views/MyNewView.vue`
2. Add it to `frontend/src/router.js`:
   ```js
   import MyNewView from './views/MyNewView.vue'
   // then in the routes array:
   { path: '/my-page', name: 'MyPage', component: MyNewView, meta: { requiresAuth: true } }
   ```
3. Add a link in `frontend/src/components/Sidebar.vue`

### Adding a new API endpoint

Add it to `server.js`. Protected routes use the `authenticateToken` middleware:

```js
app.get('/api/my-endpoint', authenticateToken, async (req, res) => {
  const userEmail = req.user.email  // logged-in user's email
  // do DB stuff
  res.json({ data: 'something' })
})
```

### How auth works

- On login, the backend creates a **JWT token** (signed with `JWT_SECRET`) and sends it to the browser
- The browser stores it in `localStorage` as `hs_token`
- Every API request sends it in the `Authorization: Bearer <token>` header
- The `authenticateToken` middleware in `server.js` checks it
- `router.js` has a navigation guard: if there's no token in localStorage, it redirects to `/login`

---

## Google Drive pipeline setup (optional)

Only needed if you want live data auto-imported from Samsung Health.

### Get a service account

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project → enable **Google Drive API**
3. Go to **Credentials → Create Credentials → Service Account**
4. On the service account → **Keys → Add Key → JSON**
5. Save the downloaded file as `service_account.json` inside `HealthsyncServerApp/`

### Share Drive folders with it

1. Open `service_account.json` and copy the `client_email` value (looks like `name@project.iam.gserviceaccount.com`)
2. In Google Drive, share each health folder with that email (Editor access)

Folder names must match these patterns (from Samsung Health exports):
- `Health Sync Aktivitäten`
- `Health Sync Puls`
- `Health Sync Schlaf`
- `Health Sync Schritte`
- `Health Sync Sauerstoffsättigung`

### Run the pipeline

```bash
cd HealthsyncServerApp
pip install google-api-python-client google-auth psycopg2-binary schedule
python src/pipeline/pipeline.py
```

Runs once immediately, then every 15 minutes. Press Ctrl+C to stop.

---

## Common errors

**`password authentication failed for user "healthsync_user"`**
→ PostgreSQL isn't running or wrong password. Run `sudo systemctl start postgresql` and check `.env`.

**`relation "users" does not exist`**
→ DB import didn't work. Re-run the `psql ... -f healthsync_dump.sql` command from Step 2.

**Blank white page at localhost:3000**
→ You didn't build the frontend. Run `cd frontend && npm run build`.

**`EADDRINUSE: address already in use :::3000`**
→ Something else is on port 3000. Change `PORT=3000` in `.env` to `3001` and open `http://localhost:3001`.

**`Cannot find module 'dotenv'`**
→ Run `npm install` in the root folder.
