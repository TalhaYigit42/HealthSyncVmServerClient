require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

// ─── PostgreSQL Pool ──────────────────────────────────────────────────────────
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 5432,
});

// ─── Auth Middleware ──────────────────────────────────────────────────────────
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.status(401).json({ error: 'Token erforderlich.' });

  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch {
    return res.status(403).json({ error: 'Ungültiger Token.' });
  }
}

// ─── POST /api/register ──────────────────────────────────────────────────────
app.post('/api/register', async (req, res) => {
  const { first_name, last_name, email, password } = req.body;

  if (!first_name || !last_name || !email || !password) {
    return res.status(400).json({ error: 'Alle Felder sind erforderlich.' });
  }

  try {
    const existing = await pool.query('SELECT uid FROM users WHERE email = $1', [email]);
    if (existing.rows.length > 0) {
      return res.status(409).json({ error: 'E-Mail ist bereits registriert.' });
    }

    const password_hash = await bcrypt.hash(password, 12);

    await pool.query(
      'INSERT INTO users (first_name, last_name, email, password_hash) VALUES ($1, $2, $3, $4)',
      [first_name, last_name, email, password_hash]
    );

    res.status(201).json({ message: 'Registrierung erfolgreich!' });
  } catch (err) {
    console.error('Register error:', err);
    res.status(500).json({ error: 'Serverfehler bei der Registrierung.' });
  }
});

// ─── POST /api/login ─────────────────────────────────────────────────────────
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'E-Mail und Passwort sind erforderlich.' });
  }

  try {
    const result = await pool.query(
      'SELECT uid, first_name, last_name, email, password_hash FROM users WHERE email = $1',
      [email]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Ungültige E-Mail oder Passwort.' });
    }

    const user = result.rows[0];
    const passwordMatch = await bcrypt.compare(password, user.password_hash);

    if (!passwordMatch) {
      return res.status(401).json({ error: 'Ungültige E-Mail oder Passwort.' });
    }

    const token = jwt.sign(
      { uid: user.uid, email: user.email, first_name: user.first_name, last_name: user.last_name },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      message: 'Login erfolgreich!',
      token,
      user: { uid: user.uid, first_name: user.first_name, last_name: user.last_name, email: user.email },
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Serverfehler beim Login.' });
  }
});

// ─── GET /api/user ───────────────────────────────────────────────────────────
app.get('/api/user', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT uid, first_name, last_name, email FROM users WHERE uid = $1',
      [req.user.uid]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User nicht gefunden.' });
    }

    res.json({ user: result.rows[0] });
  } catch (err) {
    console.error('User fetch error:', err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── GET /api/health/summary ─────────────────────────────────────────────────
app.get('/api/health/summary', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const [steps, hr, sleep] = await Promise.all([
      pool.query(
        `SELECT COALESCE(SUM(steps), 0) AS total FROM step_records
         WHERE user_id = $1 AND recorded_at::date = (
           SELECT MAX(recorded_at::date) FROM step_records WHERE user_id = $1
         )`,
        [uid]
      ),
      pool.query(
        `SELECT ROUND(AVG(bpm)) AS avg_bpm, MIN(bpm) AS resting, MAX(bpm) AS max_bpm
         FROM heart_rate_records WHERE user_id = $1 AND measured_at::date = (
           SELECT MAX(measured_at::date) FROM heart_rate_records WHERE user_id = $1
         )`,
        [uid]
      ),
      pool.query(
        `SELECT start_time, total_sleep_minutes, sleep_quality_score
         FROM sleep_sessions WHERE user_id = $1
         ORDER BY start_time DESC LIMIT 4`,
        [uid]
      ),
    ]);
    // Group sleep sessions by night (noon-to-noon boundary)
    function getNightKey(ts) {
      const d = new Date(ts);
      if (d.getUTCHours() < 12) d.setUTCDate(d.getUTCDate() - 1);
      return d.toISOString().slice(0, 10);
    }
    const sleepRows = sleep.rows;
    const latestNight = sleepRows.length ? getNightKey(sleepRows[0].start_time) : null;
    const nightSessions = latestNight ? sleepRows.filter(r => getNightKey(r.start_time) === latestNight) : [];
    const sleepResult = nightSessions.length ? {
      total_sleep_minutes: nightSessions.reduce((s, r) => s + (parseInt(r.total_sleep_minutes) || 0), 0),
      sleep_quality_score: Math.round(nightSessions.reduce((s, r) => s + (parseInt(r.sleep_quality_score) || 0), 0) / nightSessions.length),
    } : null;
    res.json({
      steps: parseInt(steps.rows[0].total) || 0,
      heart_rate: {
        avg: parseInt(hr.rows[0].avg_bpm) || null,
        resting: parseInt(hr.rows[0].resting) || null,
        max: parseInt(hr.rows[0].max_bpm) || null,
      },
      sleep: sleepResult,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── GET /api/health/heartrate ───────────────────────────────────────────────
app.get('/api/health/heartrate', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const [todayHR, weeklyHR] = await Promise.all([
      pool.query(
        `SELECT date_trunc('hour', measured_at) AS hour, ROUND(AVG(bpm)) AS avg_bpm
         FROM heart_rate_records WHERE user_id = $1
           AND measured_at::date = (SELECT MAX(measured_at::date) FROM heart_rate_records WHERE user_id = $1)
         GROUP BY hour ORDER BY hour`,
        [uid]
      ),
      pool.query(
        `SELECT TO_CHAR(measured_at::date, 'YYYY-MM-DD') AS day, MIN(bpm) AS resting, ROUND(AVG(bpm)) AS avg_bpm
         FROM heart_rate_records WHERE user_id = $1
           AND measured_at >= NOW() - INTERVAL '7 days'
         GROUP BY day ORDER BY day`,
        [uid]
      ),
    ]);
    res.json({ today: todayHR.rows, weekly: weeklyHR.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── GET /api/health/steps ───────────────────────────────────────────────────
app.get('/api/health/steps', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const result = await pool.query(
      `SELECT TO_CHAR(recorded_at::date, 'YYYY-MM-DD') AS day, SUM(steps) AS steps
       FROM step_records WHERE user_id = $1
         AND recorded_at >= NOW() - INTERVAL '7 days'
       GROUP BY day ORDER BY day`,
      [uid]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── GET /api/health/sleep ───────────────────────────────────────────────────
app.get('/api/health/sleep', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const result = await pool.query(
      `SELECT start_time, end_time, total_sleep_minutes, deep_minutes,
              light_minutes, rem_minutes, awake_minutes, sleep_quality_score
       FROM sleep_sessions WHERE user_id = $1
       ORDER BY start_time DESC LIMIT 14`,
      [uid]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── GET /api/health/activities ──────────────────────────────────────────────
app.get('/api/health/activities', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const result = await pool.query(
      `SELECT activity_type, start_time, duration_minutes, steps,
              distance_meters, calories, avg_heart_rate, intensity_level
       FROM activities WHERE user_id = $1
       ORDER BY start_time DESC LIMIT 20`,
      [uid]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});


// ─── GET /api/health/tips ─────────────────────────────────────────────────────
app.get('/api/health/tips', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const [stepsRes, hrRes, sleepRes] = await Promise.all([
      pool.query(
        `SELECT COALESCE(SUM(steps), 0) AS total FROM step_records
         WHERE user_id = $1 AND recorded_at::date = (
           SELECT MAX(recorded_at::date) FROM step_records WHERE user_id = $1
         )`,
        [uid]
      ),
      pool.query(
        `SELECT ROUND(AVG(bpm)) AS avg_bpm FROM heart_rate_records
         WHERE user_id = $1 AND measured_at::date = (
           SELECT MAX(measured_at::date) FROM heart_rate_records WHERE user_id = $1
         )`,
        [uid]
      ),
      pool.query(
        `SELECT total_sleep_minutes FROM sleep_sessions
         WHERE user_id = $1 ORDER BY start_time DESC LIMIT 1`,
        [uid]
      ),
    ]);

    const stepsVal = parseInt(stepsRes.rows[0].total) || null;
    const hrVal    = parseInt(hrRes.rows[0].avg_bpm) || null;
    const sleepVal = sleepRes.rows[0] ? parseInt(sleepRes.rows[0].total_sleep_minutes) : null;

    const metrics = { steps: stepsVal, heart_rate: hrVal, sleep: sleepVal };

    // Build matching WHERE clauses per category
    const activeCategories = Object.entries(metrics).filter(([,v]) => v !== null).map(([k]) => k);
    const matchedTips = [];

    if (activeCategories.length) {
      const tipsRes = await pool.query(
        `SELECT id, category, condition_type, threshold_low, threshold_high, severity, tip
         FROM health_tips WHERE category = ANY($1)`,
        [activeCategories]
      );
      for (const tip of tipsRes.rows) {
        const val = metrics[tip.category];
        if (val === null) continue;
        let matches = false;
        if (tip.condition_type === 'below' && val < tip.threshold_high && val >= (tip.threshold_low ?? 0)) matches = true;
        if (tip.condition_type === 'range' && val >= tip.threshold_low && val <= tip.threshold_high) matches = true;
        if (tip.condition_type === 'above' && val >= tip.threshold_low) matches = true;
        if (matches) matchedTips.push(tip);
      }
    }

    // Sort: critical > warning > info, then slice to 4
    const order = { critical: 0, warning: 1, info: 2 };
    matchedTips.sort((a, b) => (order[a.severity] ?? 3) - (order[b.severity] ?? 3));
    res.json(matchedTips.slice(0, 4));
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── GET /api/health/streak ───────────────────────────────────────────────────
app.get('/api/health/streak', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const [daysRes, totalRes] = await Promise.all([
      pool.query(
        `SELECT DISTINCT recorded_at::date AS day
         FROM step_records WHERE user_id = $1 AND steps > 0
         ORDER BY day DESC`,
        [uid]
      ),
      pool.query(
        `SELECT COUNT(DISTINCT recorded_at::date) AS total
         FROM step_records WHERE user_id = $1 AND steps > 0`,
        [uid]
      ),
    ]);

    const toDateStr = d => {
      if (d instanceof Date) {
        // Use local date parts to avoid UTC shift
        const y = d.getUTCFullYear(); const m = String(d.getUTCMonth()+1).padStart(2,'0'); const day = String(d.getUTCDate()).padStart(2,'0');
        return y+'-'+m+'-'+day;
      }
      return String(d).slice(0,10);
    };
    const days = daysRes.rows.map(r => toDateStr(r.day));
    let streak = 0;
    const today = new Date();
    const todayStr = today.toISOString().slice(0, 10);
    const yesterdayStr = new Date(today.getTime() - 86400000).toISOString().slice(0, 10);
    // Allow streak starting from today OR yesterday (so streak doesn't break before first log of the day)
    const startOffset = (days[0] === todayStr || days[0] === yesterdayStr) ? 0 : -1;
    if (startOffset === 0) {
      for (let i = 0; i < days.length; i++) {
        const expected = new Date(today);
        expected.setDate(today.getDate() - (days[0] === yesterdayStr ? 1 : 0) - i);
        const expectedStr = expected.toISOString().slice(0, 10);
        if (days[i] === expectedStr) {
          streak++;
        } else {
          break;
        }
      }
    }

    // Build last 7 days active map
    const last7 = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date(today);
      d.setUTCDate(d.getUTCDate() - i);
      const ds = d.toISOString().slice(0, 10);
      last7.push({ date: ds, active: days.includes(ds) });
    }

    res.json({
      streak,
      total_active_days: parseInt(totalRes.rows[0].total) || 0,
      last7,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── GET /api/health/weekly ───────────────────────────────────────────────────
app.get('/api/health/weekly', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const [stepsRes, hrRes] = await Promise.all([
      pool.query(
        `SELECT TO_CHAR(recorded_at::date, 'YYYY-MM-DD') AS day, SUM(steps) AS steps
         FROM step_records WHERE user_id = $1
           AND recorded_at >= NOW() - INTERVAL '7 days'
         GROUP BY day`,
        [uid]
      ),
      pool.query(
        `SELECT measured_at::date AS day,
                ROUND(AVG(bpm)) AS avg_bpm,
                MIN(bpm) AS resting_bpm
         FROM heart_rate_records WHERE user_id = $1
           AND measured_at >= NOW() - INTERVAL '7 days'
         GROUP BY day`,
        [uid]
      ),
    ]);

    // Build last 7 days
    const result = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      const dayStr = d.toISOString().slice(0, 10);
      const toDateStr = d => { if(d instanceof Date){const y=d.getUTCFullYear();const m=String(d.getUTCMonth()+1).padStart(2,"0");const dy=String(d.getUTCDate()).padStart(2,"0");return y+"-"+m+"-"+dy;} return String(d).slice(0,10); };
      const stepRow = stepsRes.rows.find(r => toDateStr(r.day) === dayStr);
      const hrRow   = hrRes.rows.find(r => toDateStr(r.day) === dayStr);
      result.push({
        day: dayStr,
        steps: stepRow ? parseInt(stepRow.steps) : null,
        avg_bpm: hrRow ? parseInt(hrRow.avg_bpm) : null,
        resting_bpm: hrRow ? parseInt(hrRow.resting_bpm) : null,
      });
    }
    res.json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});



// ─── User Settings Endpoints ─────────────────────────────────────────────────

app.post('/api/user/password', authenticateToken, async (req, res) => {
  const { currentPassword, newPassword } = req.body;
  if (!currentPassword || !newPassword)
    return res.status(400).json({ error: 'Alle Felder sind erforderlich.' });
  if (newPassword.length < 6)
    return res.status(400).json({ error: 'Neues Passwort muss mindestens 6 Zeichen haben.' });
  try {
    const result = await pool.query('SELECT password_hash FROM users WHERE uid = $1', [req.user.uid]);
    if (!result.rows.length) return res.status(404).json({ error: 'User nicht gefunden.' });
    const match = await bcrypt.compare(currentPassword, result.rows[0].password_hash);
    if (!match) return res.status(401).json({ error: 'Aktuelles Passwort ist falsch.' });
    const hash = await bcrypt.hash(newPassword, 12);
    await pool.query('UPDATE users SET password_hash = $1 WHERE uid = $2', [hash, req.user.uid]);
    res.json({ message: 'Passwort erfolgreich geändert.' });
  } catch (err) {
    console.error('Password change error:', err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

app.get('/api/user/export', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const [steps, hr, sleep, oxygen, acts] = await Promise.all([
      pool.query('SELECT recorded_at, steps, distance_meters, calories FROM step_records WHERE user_id = $1 ORDER BY recorded_at DESC', [uid]),
      pool.query('SELECT measured_at, bpm FROM heart_rate_records WHERE user_id = $1 ORDER BY measured_at DESC', [uid]),
      pool.query('SELECT start_time, end_time, total_sleep_minutes, deep_minutes, light_minutes, rem_minutes, sleep_quality_score FROM sleep_sessions WHERE user_id = $1 ORDER BY start_time DESC', [uid]),
      pool.query('SELECT measured_at, spo2_percent FROM oxygen_saturation WHERE user_id = $1 ORDER BY measured_at DESC', [uid]),
      pool.query('SELECT activity_type, start_time, duration_minutes, steps, distance_meters, calories, avg_heart_rate FROM activities WHERE user_id = $1 ORDER BY start_time DESC', [uid]),
    ]);
    const payload = {
      exported_at: new Date().toISOString(),
      steps: steps.rows,
      heart_rate: hr.rows,
      sleep: sleep.rows,
      oxygen: oxygen.rows,
      activities: acts.rows,
    };
    res.setHeader('Content-Disposition', 'attachment; filename="healthsync-export.json"');
    res.setHeader('Content-Type', 'application/json');
    res.send(JSON.stringify(payload, null, 2));
  } catch (err) {
    console.error('Export error:', err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

app.delete('/api/user', authenticateToken, async (req, res) => {
  const uid = req.user.uid;
  const email = req.user.email;
  try {
    await pool.query('DELETE FROM step_records WHERE user_id = $1', [email]);
    await pool.query('DELETE FROM heart_rate_records WHERE user_id = $1', [email]);
    await pool.query('DELETE FROM sleep_sessions WHERE user_id = $1', [email]);
    await pool.query('DELETE FROM oxygen_saturation WHERE user_id = $1', [email]);
    await pool.query('DELETE FROM activities WHERE user_id = $1', [email]);
    await pool.query('DELETE FROM users WHERE uid = $1', [uid]);
    res.json({ message: 'Account erfolgreich gelöscht.' });
  } catch (err) {
    console.error('Delete account error:', err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── Serve Vue Frontend ───────────────────────────────────────────────────────
const frontendDist = path.join(__dirname, 'frontend', 'dist');
app.use(express.static(frontendDist));

app.get(/^(?!\/api).*/, (req, res) => {
  res.setHeader("Cache-Control", "no-store");
  res.sendFile(path.join(frontendDist, 'index.html'));
});

// ─── Start Server ─────────────────────────────────────────────────────────────
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`HealthSync Server läuft auf http://localhost:${PORT}`);
});

// ─── POST /api/import/csv ────────────────────────────────────────────────────
const multer = require('multer');
const { execFile } = require('child_process');
const os = require('os');
const fs = require('fs');

const upload = multer({ dest: os.tmpdir() });

function detectCategory(filename) {
  const f = filename.toLowerCase();
  if (f.includes('aktivit') || f.includes('walking') || f.includes('training') || f.includes('running')) return 'Health Sync Aktivitäten';
  if (f.includes('puls') || f.includes('heart')) return 'Health Sync Puls';
  if (f.includes('schlaf') || f.includes('sleep')) return 'Health Sync Schlaf';
  if (f.includes('schritt') || f.includes('step')) return 'Health Sync Schritte';
  if (f.includes('sauerstoff') || f.includes('oxygen') || f.includes('spo2')) return 'Health Sync Sauerstoffsättigung';
  return null;
}

app.post('/api/import/csv', authenticateToken, upload.array('files', 30), async (req, res) => {
  const uid = req.user.email;
  const files = req.files || [];

  if (files.length === 0) {
    return res.status(400).json({ error: 'Keine Dateien hochgeladen.' });
  }

  const stagingDir = path.join(os.tmpdir(), `hs_import_${Date.now()}`);
  const outputDir  = path.join(os.tmpdir(), `hs_output_${Date.now()}`);
  fs.mkdirSync(outputDir, { recursive: true });

  const imported = [];
  const skipped  = [];

  for (const file of files) {
    const cat = detectCategory(file.originalname);
    if (!cat) {
      skipped.push(file.originalname);
      try { fs.unlinkSync(file.path); } catch {}
      continue;
    }
    const catDir = path.join(stagingDir, cat);
    fs.mkdirSync(catDir, { recursive: true });
    const dest = path.join(catDir, file.originalname);
    fs.renameSync(file.path, dest);
    imported.push({ name: file.originalname, category: cat });
  }

  if (imported.length === 0) {
    try { fs.rmSync(stagingDir, { recursive: true, force: true }); } catch {}
    try { fs.rmSync(outputDir,  { recursive: true, force: true }); } catch {}
    return res.status(400).json({ error: 'Keine erkennbaren CSV-Dateien. Dateinamen müssen z.B. Puls, Schritte, Schlaf, Sauerstoff oder Aktivitäten enthalten.', skipped });
  }

  const helperScript = path.join(process.env.HOME, 'HealthsyncServerApp/src/pipeline/converters/import_for_user.py');

  execFile('python3', [helperScript, stagingDir, outputDir, uid], { timeout: 120000 }, (err, stdout, stderr) => {
    try { fs.rmSync(stagingDir, { recursive: true, force: true }); } catch {}
    try { fs.rmSync(outputDir,  { recursive: true, force: true }); } catch {}

    if (err && err.code !== 0 && !stdout) {
      console.error('Import pipeline error:', stderr);
      return res.status(500).json({ error: 'Pipeline-Fehler beim Import.', details: stderr.slice(-500) });
    }

    const lines = stdout.split('\n');
    const successLine = lines.find(l => l.includes('Successfully converted'));
    const recordsLine = lines.find(l => l.includes('inserted') || l.includes('records'));

    res.json({
      success: true,
      imported,
      skipped,
      message: successLine ? successLine.trim() : `${imported.length} Datei(en) verarbeitet.`,
    });
  });
});

// ─── GET /api/import/stats ────────────────────────────────────────────────────
app.get('/api/import/stats', authenticateToken, async (req, res) => {
  const uid = req.user.email;
  try {
    const [hr, steps, sleep, acts, oxy] = await Promise.all([
      pool.query('SELECT COUNT(*) as cnt, MAX(measured_at)::date as latest FROM heart_rate_records WHERE user_id = $1', [uid]),
      pool.query('SELECT COUNT(*) as cnt, MAX(recorded_at)::date as latest FROM step_records WHERE user_id = $1', [uid]),
      pool.query('SELECT COUNT(*) as cnt, MAX(start_time)::date as latest FROM sleep_sessions WHERE user_id = $1', [uid]),
      pool.query('SELECT COUNT(*) as cnt, MAX(start_time)::date as latest FROM activities WHERE user_id = $1', [uid]),
      pool.query('SELECT COUNT(*) as cnt, MAX(measured_at)::date as latest FROM oxygen_saturation WHERE user_id = $1', [uid]),
    ]);
    res.json([
      { label: 'Herzrate-Messungen', icon: '❤️',  count: parseInt(hr.rows[0].cnt),    latest: hr.rows[0].latest    ? String(hr.rows[0].latest).slice(0,10)    : null },
      { label: 'Schritte',           icon: '👟',  count: parseInt(steps.rows[0].cnt), latest: steps.rows[0].latest ? String(steps.rows[0].latest).slice(0,10) : null },
      { label: 'Schlaf-Sessions',    icon: '🌙',  count: parseInt(sleep.rows[0].cnt), latest: sleep.rows[0].latest ? String(sleep.rows[0].latest).slice(0,10) : null },
      { label: 'Aktivitäten',        icon: '🏃',  count: parseInt(acts.rows[0].cnt),  latest: acts.rows[0].latest  ? String(acts.rows[0].latest).slice(0,10)  : null },
      { label: 'Sauerstoff',         icon: '🫁',  count: parseInt(oxy.rows[0].cnt),   latest: oxy.rows[0].latest   ? String(oxy.rows[0].latest).slice(0,10)   : null },
    ]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── Password Reset ───────────────────────────────────────────────────────────
const nodemailer = require('nodemailer');
const crypto = require('crypto');

const mailer = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// POST /api/auth/forgot-password
app.post('/api/auth/forgot-password', async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ error: 'E-Mail erforderlich.' });

  try {
    const result = await pool.query('SELECT uid, first_name FROM users WHERE email = $1', [email]);
    // Always respond OK so we don't leak whether email exists
    if (result.rows.length === 0) {
      return res.json({ message: 'Falls diese E-Mail registriert ist, wurde ein Reset-Link gesendet.' });
    }

    const user = result.rows[0];
    const token = crypto.randomBytes(48).toString('hex');
    const expiresAt = new Date(Date.now() + 60 * 60 * 1000); // 1 hour

    // Invalidate old tokens for this user
    await pool.query('UPDATE password_reset_tokens SET used = TRUE WHERE user_id = $1 AND used = FALSE', [user.uid]);

    await pool.query(
      'INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES ($1, $2, $3)',
      [user.uid, token, expiresAt]
    );

    const resetUrl = `${process.env.APP_URL}/reset-password?token=${token}`;

    await mailer.sendMail({
      from: `"HealthSync" <${process.env.EMAIL_USER}>`,
      to: email,
      subject: 'Passwort zurücksetzen – HealthSync',
      html: `
        <div style="font-family:sans-serif;max-width:480px;margin:0 auto;padding:2rem;background:#f8fafc;border-radius:16px;">
          <div style="text-align:center;margin-bottom:1.5rem;">
            <div style="background:linear-gradient(135deg,#3b82f6,#2563eb);width:48px;height:48px;border-radius:14px;display:inline-flex;align-items:center;justify-content:center;">
              <span style="color:#fff;font-size:1.5rem;">💙</span>
            </div>
            <h2 style="color:#0f172a;margin-top:0.8rem;">HealthSync</h2>
          </div>
          <h3 style="color:#0f172a;">Hey ${user.first_name}, Passwort zurücksetzen</h3>
          <p style="color:#64748b;line-height:1.6;">Du hast eine Anfrage zum Zurücksetzen deines Passworts gestellt. Klicke auf den Button unten um ein neues Passwort zu setzen.</p>
          <div style="text-align:center;margin:2rem 0;">
            <a href="${resetUrl}" style="background:linear-gradient(135deg,#3b82f6,#2563eb);color:#fff;text-decoration:none;padding:0.85rem 2rem;border-radius:10px;font-weight:700;font-size:0.97rem;">Passwort zurücksetzen</a>
          </div>
          <p style="color:#94a3b8;font-size:0.8rem;text-align:center;">Dieser Link ist 1 Stunde gültig. Falls du diese Anfrage nicht gestellt hast, ignoriere diese E-Mail.</p>
          <hr style="border:none;border-top:1px solid #e2e8f0;margin:1.5rem 0;">
          <p style="color:#cbd5e1;font-size:0.75rem;text-align:center;">HealthSync · Gamified Wellness</p>
        </div>
      `,
    });

    res.json({ message: 'Falls diese E-Mail registriert ist, wurde ein Reset-Link gesendet.' });
  } catch (err) {
    console.error('Forgot password error:', err);
    res.status(500).json({ error: 'Serverfehler. Bitte erneut versuchen.' });
  }
});

// POST /api/auth/reset-password
app.post('/api/auth/reset-password', async (req, res) => {
  const { token, password } = req.body;
  if (!token || !password) return res.status(400).json({ error: 'Token und Passwort erforderlich.' });
  if (password.length < 6) return res.status(400).json({ error: 'Passwort muss mindestens 6 Zeichen haben.' });

  try {
    const result = await pool.query(
      'SELECT id, user_id, expires_at, used FROM password_reset_tokens WHERE token = $1',
      [token]
    );

    if (result.rows.length === 0) return res.status(400).json({ error: 'Ungültiger oder abgelaufener Link.' });

    const row = result.rows[0];
    if (row.used) return res.status(400).json({ error: 'Dieser Link wurde bereits verwendet.' });
    if (new Date() > new Date(row.expires_at)) return res.status(400).json({ error: 'Dieser Link ist abgelaufen.' });

    const hash = await bcrypt.hash(password, 12);
    await pool.query('UPDATE users SET password_hash = $1 WHERE uid = $2', [hash, row.user_id]);
    await pool.query('UPDATE password_reset_tokens SET used = TRUE WHERE id = $1', [row.id]);

    res.json({ message: 'Passwort erfolgreich zurückgesetzt. Du kannst dich jetzt anmelden.' });
  } catch (err) {
    console.error('Reset password error:', err);
    res.status(500).json({ error: 'Serverfehler. Bitte erneut versuchen.' });
  }
});

// ─── Goals ────────────────────────────────────────────────────────────────────
// GET /api/goals
app.get('/api/goals', authenticateToken, async (req, res) => {
  const email = req.user.email;
  try {
    const result = await pool.query('SELECT * FROM user_goals WHERE user_id = $1', [email]);
    if (result.rows.length === 0) {
      return res.json({ daily_steps: 10000, sleep_hours: 8.0, daily_calories: 500, resting_hr: 60, email_reminders: false });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error('GET goals error:', err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// PUT /api/goals
app.put('/api/goals', authenticateToken, async (req, res) => {
  const email = req.user.email;
  const { daily_steps, sleep_hours, daily_calories, resting_hr, email_reminders } = req.body;
  try {
    await pool.query(
      `INSERT INTO user_goals (user_id, daily_steps, sleep_hours, daily_calories, resting_hr, email_reminders, updated_at)
       VALUES ($1,$2,$3,$4,$5,$6,NOW())
       ON CONFLICT (user_id) DO UPDATE SET
         daily_steps=$2, sleep_hours=$3, daily_calories=$4, resting_hr=$5, email_reminders=$6, updated_at=NOW()`,
      [email, daily_steps, sleep_hours, daily_calories, resting_hr, email_reminders]
    );
    res.json({ message: 'Ziele gespeichert.' });
  } catch (err) {
    console.error('PUT goals error:', err);
    res.status(500).json({ error: 'Serverfehler.' });
  }
});

// ─── Daily Goal Reminder Cron ─────────────────────────────────────────────────
const cron = require('node-cron');

cron.schedule('0 8 * * *', async () => {
  console.log('[cron] Sending daily goal reminders...');
  try {
    const users = await pool.query(
      `SELECT u.email, u.first_name, g.daily_steps, g.sleep_hours, g.daily_calories, g.resting_hr
       FROM users u JOIN user_goals g ON g.user_id = u.email
       WHERE g.email_reminders = TRUE`
    );
    for (const user of users.rows) {
      const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();

      const [stepsRes, sleepRes, calRes, hrRes] = await Promise.all([
        pool.query(`SELECT COALESCE(ROUND(AVG(steps)),0) AS avg FROM step_records WHERE user_id=$1 AND recorded_at >= $2`, [user.email, sevenDaysAgo]),
        pool.query(`SELECT COALESCE(ROUND(AVG(total_sleep_minutes)/60.0,1),0) AS avg FROM sleep_sessions WHERE user_id=$1 AND start_time >= $2`, [user.email, sevenDaysAgo]),
        pool.query(`SELECT COALESCE(ROUND(AVG(calories)),0) AS avg FROM activities WHERE user_id=$1 AND start_time >= $2`, [user.email, sevenDaysAgo]),
        pool.query(`SELECT COALESCE(ROUND(AVG(bpm)),0) AS avg FROM heart_rate_records WHERE user_id=$1 AND measured_at >= $2`, [user.email, sevenDaysAgo]),
      ]);

      const avg = {
        steps:    Number(stepsRes.rows[0].avg),
        sleep:    Number(sleepRes.rows[0].avg),
        calories: Number(calRes.rows[0].avg),
        hr:       Number(hrRes.rows[0].avg),
      };

      function row(icon, label, goal, actual, unit) {
        const hit = actual >= goal;
        const bar = hit
          ? `<span style="color:#16a34a;font-weight:700;">✔ On track</span>`
          : `<span style="color:#dc2626;font-weight:700;">✘ ${Number((goal - actual).toFixed(1))}${unit} to go</span>`;
        return `
          <tr>
            <td style="padding:0.6rem 0.8rem;">${icon} ${label}</td>
            <td style="padding:0.6rem 0.8rem;font-weight:700;">${goal}${unit}</td>
            <td style="padding:0.6rem 0.8rem;">${actual}${unit}</td>
            <td style="padding:0.6rem 0.8rem;">${bar}</td>
          </tr>`;
      }

      const allOnTrack = avg.steps >= user.daily_steps && avg.sleep >= user.sleep_hours && avg.calories >= user.daily_calories;

      await mailer.sendMail({
        from: `"HealthSync" <${process.env.EMAIL_USER}>`,
        to: user.email,
        subject: `Hey ${user.first_name}, hier sind deine täglichen Ziele 💙`,
        html: `
          <div style="font-family:sans-serif;max-width:520px;margin:0 auto;padding:2rem;background:#f8fafc;border-radius:16px;">
            <div style="text-align:center;margin-bottom:1.5rem;">
              <div style="background:linear-gradient(135deg,#3b82f6,#2563eb);width:48px;height:48px;border-radius:14px;display:inline-flex;align-items:center;justify-content:center;">
                <span style="color:#fff;font-size:1.5rem;">💙</span>
              </div>
              <h2 style="color:#0f172a;margin-top:0.8rem;">HealthSync</h2>
            </div>
            <h3 style="color:#0f172a;">Hey ${user.first_name}! ${allOnTrack ? '🎉 Du erreichst alle deine Ziele!' : 'Deine Ziele für diese Woche:'}</h3>
            <p style="color:#64748b;line-height:1.6;">Hier ist dein 7-Tage-Durchschnitt verglichen mit deinen Zielen:</p>
            <table style="width:100%;border-collapse:collapse;background:#fff;border-radius:12px;overflow:hidden;margin:1rem 0;">
              <thead>
                <tr style="background:#eff6ff;">
                  <th style="padding:0.6rem 0.8rem;text-align:left;font-size:0.8rem;color:#64748b;">Ziel</th>
                  <th style="padding:0.6rem 0.8rem;text-align:left;font-size:0.8rem;color:#64748b;">Zielwert</th>
                  <th style="padding:0.6rem 0.8rem;text-align:left;font-size:0.8rem;color:#64748b;">Ø 7 Tage</th>
                  <th style="padding:0.6rem 0.8rem;text-align:left;font-size:0.8rem;color:#64748b;">Status</th>
                </tr>
              </thead>
              <tbody>
                ${row('👟','Schritte',       user.daily_steps,    avg.steps,    '')}
                ${row('🌙','Schlaf',          user.sleep_hours,    avg.sleep,    'h')}
                ${row('🔥','Kalorien',        user.daily_calories, avg.calories, ' kcal')}
                ${row('❤️','Ruhepuls (max)', user.resting_hr,     avg.hr,       ' BPM')}
              </tbody>
            </table>
            <div style="text-align:center;margin:1.5rem 0;">
              <a href="${process.env.APP_URL}/dashboard" style="background:linear-gradient(135deg,#3b82f6,#2563eb);color:#fff;text-decoration:none;padding:0.85rem 2rem;border-radius:10px;font-weight:700;font-size:0.97rem;">Dashboard öffnen</a>
            </div>
            <hr style="border:none;border-top:1px solid #e2e8f0;margin:1.5rem 0;">
            <p style="color:#cbd5e1;font-size:0.75rem;text-align:center;">Du erhältst diese E-Mail weil du Erinnerungen in HealthSync aktiviert hast. <a href="${process.env.APP_URL}/settings" style="color:#94a3b8;">Einstellungen ändern</a></p>
          </div>
        `,
      });
      console.log(`[cron] Reminder sent to ${user.email}`);
    }
  } catch (err) {
    console.error('[cron] Reminder error:', err);
  }
});

// ─── CSV Export (ZIP) ─────────────────────────────────────────────────────────
const archiver = require('archiver');

app.get('/api/user/export/csv', authenticateToken, async (req, res) => {
  const email = req.user.email;
  try {
    const tables = [
      {
        file: 'steps.csv',
        query: 'SELECT recorded_at, steps, distance_meters, calories, walking_speed FROM step_records WHERE user_id=$1 ORDER BY recorded_at',
      },
      {
        file: 'heart_rate.csv',
        query: 'SELECT measured_at, bpm, resting FROM heart_rate_records WHERE user_id=$1 ORDER BY measured_at',
      },
      {
        file: 'sleep.csv',
        query: 'SELECT start_time, end_time, total_sleep_minutes, deep_minutes, light_minutes, rem_minutes, awake_minutes, sleep_quality_score FROM sleep_sessions WHERE user_id=$1 ORDER BY start_time',
      },
      {
        file: 'oxygen_saturation.csv',
        query: 'SELECT measured_at, spo2_percent FROM oxygen_saturation WHERE user_id=$1 ORDER BY measured_at',
      },
      {
        file: 'activities.csv',
        query: 'SELECT activity_type, start_time, end_time, duration_minutes, steps, distance_meters, calories, avg_heart_rate, max_heart_rate, intensity_level FROM activities WHERE user_id=$1 ORDER BY start_time',
      },
    ];

    function toCSV(rows) {
      if (rows.length === 0) return '';
      const cols = Object.keys(rows[0]);
      const escape = val => {
        if (val === null || val === undefined) return '';
        const s = String(val);
        return s.includes(',') || s.includes('"') || s.includes('\n') ? `"${s.replace(/"/g, '""')}"` : s;
      };
      return [cols.join(','), ...rows.map(r => cols.map(c => escape(r[c])).join(','))].join('\n');
    }

    res.setHeader('Content-Type', 'application/zip');
    res.setHeader('Content-Disposition', 'attachment; filename="healthsync-export.zip"');

    const archive = archiver('zip', { zlib: { level: 6 } });
    archive.pipe(res);

    for (const t of tables) {
      const result = await pool.query(t.query, [email]);
      const csv = toCSV(result.rows);
      if (csv) archive.append(csv, { name: t.file });
    }

    await archive.finalize();
  } catch (err) {
    console.error('CSV export error:', err);
    if (!res.headersSent) res.status(500).json({ error: 'Export fehlgeschlagen.' });
  }
});
