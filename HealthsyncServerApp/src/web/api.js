const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { google } = require('googleapis');
const fs = require('fs');

const app = express();
app.use(express.json());
app.use(express.static(path.join(__dirname, 'static')));

const pool = new Pool({
  host: 'localhost',
  database: 'healthsync',
  user: 'healthsync_user',
  password: 'Bartal123!',
  port: 5432,
});

// --- Config ---
const JWT_SECRET = process.env.JWT_SECRET || 'healthsync-jwt-secret-2026';
const REDIRECT_URI = process.env.GOOGLE_REDIRECT_URI || 'http://192.168.122.138:5000/api/auth/google/callback';

const CREDS_PATH = process.env.GOOGLE_CREDENTIALS || path.join(__dirname, '../../credentials.json');
let googleCreds;
try {
  const raw = JSON.parse(fs.readFileSync(CREDS_PATH, 'utf8'));
  googleCreds = raw.installed || raw.web;
} catch (e) {
  console.warn('Warning: Could not load credentials.json:', e.message);
}

function getOAuthClient() {
  return new google.auth.OAuth2(googleCreds.client_id, googleCreds.client_secret, REDIRECT_URI);
}

// --- Auth Middleware ---
function auth(req, res, next) {
  const header = req.headers.authorization;
  if (!header) return res.status(401).json({ error: 'Kein Token' });
  try {
    req.user = jwt.verify(header.split(' ')[1], JWT_SECRET);
    next();
  } catch {
    res.status(401).json({ error: 'Ungültiger Token' });
  }
}

function optionalAuth(req, res, next) {
  const header = req.headers.authorization;
  if (header) {
    try { req.user = jwt.verify(header.split(' ')[1], JWT_SECRET); } catch {}
  }
  next();
}

// --- Auth Endpoints ---

app.post('/api/register', async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password)
    return res.status(400).json({ error: 'Name, E-Mail und Passwort erforderlich' });
  try {
    const hash = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO users (name, email, password_hash) VALUES ($1, $2, $3) RETURNING id, name, email',
      [name, email, hash]
    );
    const user = result.rows[0];
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET);
    res.json({ token, user: { ...user, has_drive: false } });
  } catch (err) {
    if (err.code === '23505') return res.status(400).json({ error: 'E-Mail bereits registriert' });
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).json({ error: 'E-Mail und Passwort erforderlich' });
  try {
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    const user = result.rows[0];
    if (!user || !await bcrypt.compare(password, user.password_hash))
      return res.status(401).json({ error: 'Ungültige Anmeldedaten' });
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET);
    res.json({ token, user: { id: user.id, name: user.name, email: user.email, has_drive: !!user.google_refresh_token } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/me', auth, async (req, res) => {
  const result = await pool.query(
    'SELECT id, name, email, google_refresh_token IS NOT NULL AS has_drive FROM users WHERE id = $1',
    [req.user.id]
  );
  res.json(result.rows[0]);
});

// --- Google OAuth ---

// Step 1: redirect to Google consent screen
// Token passed as query param since browser can't set Authorization header on a redirect
app.get('/api/auth/google', (req, res) => {
  const token = req.query.token;
  if (!token) return res.status(401).send('Token fehlt');
  let user;
  try { user = jwt.verify(token, JWT_SECRET); } catch { return res.status(401).send('Ungültiger Token'); }

  const url = getOAuthClient().generateAuthUrl({
    access_type: 'offline',
    scope: ['https://www.googleapis.com/auth/drive'],
    state: user.id.toString(),
    prompt: 'consent',
  });
  res.redirect(url);
});

// Step 2: Google redirects back here with code
app.get('/api/auth/google/callback', async (req, res) => {
  const { code, state: userId, error } = req.query;
  if (error) return res.send(`Google Fehler: ${error}`);
  if (!code || !userId) return res.status(400).send('Fehlende Parameter');

  try {
    const oauth2Client = getOAuthClient();
    const { tokens } = await oauth2Client.getToken(code);
    oauth2Client.setCredentials(tokens);

    // Auto-discover Health Sync folders in user's Drive
    const drive = google.drive({ version: 'v3', auth: oauth2Client });
    const folderNames = [
      'Health Sync Aktivitäten', 'Health Sync Puls',
      'Health Sync Sauerstoffsättigung', 'Health Sync Schlaf',
      'Health Sync Schritte', 'Health Sync Kalorien',
    ];

    const folderIds = {};
    for (const name of folderNames) {
      try {
        const r = await drive.files.list({
          q: `name = '${name}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false`,
          fields: 'files(id)',
          pageSize: 1,
        });
        if (r.data.files[0]) folderIds[name] = r.data.files[0].id;
      } catch {}
    }

    await pool.query(
      'UPDATE users SET google_refresh_token = $1, drive_folder_ids = $2 WHERE id = $3',
      [tokens.refresh_token, JSON.stringify(folderIds), userId]
    );

    res.redirect('/?connected=1');
  } catch (err) {
    res.status(500).send(`Fehler beim Verbinden: ${err.message}`);
  }
});

// --- Data Endpoints ---
// If logged in: show user's data + unassigned (user_id IS NULL) data
// If not logged in: show only unassigned data

app.get('/api/overview', optionalAuth, async (req, res) => {
  const uid = req.user?.id ?? null;
  try {
    const filter = uid ? '(user_id = $1 OR user_id IS NULL)' : 'user_id IS NULL';
    const params = uid ? [uid] : [];
    const tables = [
      ['heart_rate', 'heart_rate_records'],
      ['steps', 'step_records'],
      ['sleep', 'sleep_sessions'],
      ['oxygen', 'oxygen_saturation'],
      ['activities', 'activities'],
    ];
    const rows = await Promise.all(tables.map(async ([label, table]) => {
      const r = await pool.query(`SELECT COUNT(*) FROM ${table} WHERE ${filter}`, params);
      return { table: label, records: r.rows[0].count };
    }));
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/steps', optionalAuth, async (req, res) => {
  const uid = req.user?.id ?? null;
  const filter = uid ? '(user_id = $1 OR user_id IS NULL)' : 'user_id IS NULL';
  const params = uid ? [uid] : [];
  try {
    const result = await pool.query(`
      SELECT TO_CHAR(recorded_at, 'DD.MM.YYYY') AS day,
             SUM(steps) AS steps,
             ROUND(SUM(distance_meters)) AS distance_m,
             ROUND(SUM(calories)::numeric, 1) AS calories
      FROM step_records WHERE ${filter}
      GROUP BY day, DATE_TRUNC('day', recorded_at)
      ORDER BY DATE_TRUNC('day', recorded_at) DESC
    `, params);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/heartrate', optionalAuth, async (req, res) => {
  const uid = req.user?.id ?? null;
  const filter = uid ? '(user_id = $1 OR user_id IS NULL)' : 'user_id IS NULL';
  const params = uid ? [uid] : [];
  try {
    const result = await pool.query(`
      SELECT TO_CHAR(measured_at, 'DD.MM.YYYY') AS day,
             ROUND(AVG(bpm)) AS avg_bpm, MIN(bpm) AS min_bpm,
             MAX(bpm) AS max_bpm, COUNT(*) AS measurements
      FROM heart_rate_records WHERE ${filter}
      GROUP BY day ORDER BY day DESC
    `, params);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/sleep', optionalAuth, async (req, res) => {
  const uid = req.user?.id ?? null;
  const filter = uid ? '(user_id = $1 OR user_id IS NULL)' : 'user_id IS NULL';
  const params = uid ? [uid] : [];
  try {
    const result = await pool.query(`
      SELECT TO_CHAR(start_time, 'DD.MM.YYYY') AS night,
             ROUND(total_sleep_minutes / 60.0, 1) AS hours_slept,
             deep_minutes, light_minutes, rem_minutes, awake_minutes, sleep_quality_score
      FROM sleep_sessions WHERE ${filter}
      ORDER BY start_time DESC
    `, params);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/oxygen', optionalAuth, async (req, res) => {
  const uid = req.user?.id ?? null;
  const filter = uid ? '(user_id = $1 OR user_id IS NULL)' : 'user_id IS NULL';
  const params = uid ? [uid] : [];
  try {
    const result = await pool.query(`
      SELECT TO_CHAR(measured_at, 'DD.MM.YYYY') AS day,
             ROUND(AVG(spo2_percent), 1) AS avg_spo2,
             MIN(spo2_percent) AS min_spo2, MAX(spo2_percent) AS max_spo2
      FROM oxygen_saturation WHERE ${filter}
      GROUP BY day ORDER BY day DESC
    `, params);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/activities', optionalAuth, async (req, res) => {
  const uid = req.user?.id ?? null;
  const filter = uid ? '(user_id = $1 OR user_id IS NULL)' : 'user_id IS NULL';
  const params = uid ? [uid] : [];
  try {
    const result = await pool.query(`
      SELECT TO_CHAR(start_time, 'DD.MM.YYYY') AS day,
             activity_type, duration_minutes, steps,
             ROUND(distance_meters) AS distance_m,
             ROUND(calories::numeric, 1) AS calories,
             avg_heart_rate, max_heart_rate
      FROM activities WHERE ${filter}
      ORDER BY start_time DESC
    `, params);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/tips', optionalAuth, async (req, res) => {
  const uid = req.user?.id ?? null;
  const filter = uid ? '(user_id = $1 OR user_id IS NULL)' : 'user_id IS NULL';
  const params = uid ? [uid] : [];
  try {
    const [steps, heartrate, sleep, oxygen, activity] = await Promise.all([
      pool.query(`SELECT SUM(steps) AS value FROM step_records WHERE ${filter} AND DATE_TRUNC('day', recorded_at) = (SELECT DATE_TRUNC('day', MAX(recorded_at)) FROM step_records WHERE ${filter})`, [...params, ...params]),
      pool.query(`SELECT ROUND(AVG(bpm)) AS value FROM heart_rate_records WHERE ${filter} AND DATE_TRUNC('day', measured_at) = (SELECT DATE_TRUNC('day', MAX(measured_at)) FROM heart_rate_records WHERE ${filter})`, [...params, ...params]),
      pool.query(`SELECT total_sleep_minutes AS value FROM sleep_sessions WHERE ${filter} ORDER BY start_time DESC LIMIT 1`, params),
      pool.query(`SELECT ROUND(AVG(spo2_percent)) AS value FROM oxygen_saturation WHERE ${filter} AND DATE_TRUNC('day', measured_at) = (SELECT DATE_TRUNC('day', MAX(measured_at)) FROM oxygen_saturation WHERE ${filter})`, [...params, ...params]),
      pool.query(`SELECT COUNT(*) AS value FROM activities WHERE ${filter} AND start_time >= NOW() - INTERVAL '7 days'`, params),
    ]);

    const metrics = [
      { category: 'steps',      value: parseFloat(steps.rows[0]?.value) },
      { category: 'heart_rate', value: parseFloat(heartrate.rows[0]?.value) },
      { category: 'sleep',      value: parseFloat(sleep.rows[0]?.value) },
      { category: 'oxygen',     value: parseFloat(oxygen.rows[0]?.value) },
      { category: 'activity',   value: parseFloat(activity.rows[0]?.value) },
    ];

    const tips = [];
    for (const { category, value } of metrics) {
      if (isNaN(value)) continue;
      const result = await pool.query(`
        SELECT category, severity, tip FROM health_tips
        WHERE category = $1 AND (
          (condition_type = 'below' AND $2 < threshold_high) OR
          (condition_type = 'above' AND $2 >= threshold_low) OR
          (condition_type = 'range' AND $2 >= threshold_low AND $2 <= threshold_high)
        ) LIMIT 1
      `, [category, value]);
      if (result.rows[0]) tips.push({ ...result.rows[0], value });
    }

    const order = { critical: 0, warning: 1, info: 2 };
    tips.sort((a, b) => order[a.severity] - order[b.severity]);
    res.json(tips);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => console.log(`HealthSync API running on :${PORT}`));
