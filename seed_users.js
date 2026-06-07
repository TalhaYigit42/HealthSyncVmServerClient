require('dotenv').config();
const { Pool } = require('pg');
const bcrypt = require('bcrypt');

const pool = new Pool({
  host: process.env.DB_HOST, user: process.env.DB_USER,
  password: process.env.DB_PASSWORD, database: process.env.DB_NAME, port: process.env.DB_PORT
});

(async () => {
  const hash = await bcrypt.hash('Password123!', 12);

  // ── User 1: talhakere@gmail.com ──────────────────────────────────────────
  await pool.query(
    `INSERT INTO users (first_name, last_name, email, password_hash)
     VALUES ('Talha', 'Kere', 'talhakere@gmail.com', $1)
     ON CONFLICT (email) DO NOTHING`, [hash]
  );

  // Goals
  await pool.query(
    `INSERT INTO user_goals (user_id, daily_steps, sleep_hours, daily_calories, resting_hr, email_reminders)
     VALUES ('talhakere@gmail.com', 8500, 7.5, 450, 68, TRUE)
     ON CONFLICT (user_id) DO NOTHING`
  );

  // Step records — last 14 days
  for (let i = 0; i < 14; i++) {
    const d = new Date(Date.now() - i * 24 * 60 * 60 * 1000);
    const steps = 6000 + Math.floor(Math.random() * 5000);
    await pool.query(
      `INSERT INTO step_records (user_id, recorded_at, steps, distance_meters, calories)
       VALUES ('talhakere@gmail.com', $1, $2, $3, $4)
       ON CONFLICT (user_id, recorded_at) DO NOTHING`,
      [d, steps, Math.round(steps * 0.75), Math.round(steps * 0.04)]
    );
  }

  // Sleep sessions — last 14 days
  for (let i = 0; i < 14; i++) {
    const start = new Date(Date.now() - i * 24 * 60 * 60 * 1000 - 8 * 60 * 60 * 1000);
    const totalMins = 360 + Math.floor(Math.random() * 120);
    const end = new Date(start.getTime() + totalMins * 60 * 1000);
    await pool.query(
      `INSERT INTO sleep_sessions (user_id, start_time, end_time, total_sleep_minutes, deep_minutes, light_minutes, rem_minutes, awake_minutes, sleep_quality_score)
       VALUES ('talhakere@gmail.com', $1, $2, $3, $4, $5, $6, $7, $8)
       ON CONFLICT (user_id, start_time) DO NOTHING`,
      [start, end, totalMins,
        Math.floor(totalMins * 0.2), Math.floor(totalMins * 0.5),
        Math.floor(totalMins * 0.2), Math.floor(totalMins * 0.1),
        60 + Math.floor(Math.random() * 30)]
    );
  }

  // Heart rate — last 14 days
  for (let i = 0; i < 14; i++) {
    const d = new Date(Date.now() - i * 24 * 60 * 60 * 1000);
    await pool.query(
      `INSERT INTO heart_rate_records (user_id, measured_at, bpm, resting)
       VALUES ('talhakere@gmail.com', $1, $2, $3)
       ON CONFLICT (user_id, measured_at) DO NOTHING`,
      [d, 62 + Math.floor(Math.random() * 20), Math.random() > 0.5]
    );
  }

  // Activities — last 7 days
  const types = ['WALKING', 'RUNNING', 'CYCLING'];
  for (let i = 0; i < 7; i++) {
    const start = new Date(Date.now() - i * 24 * 60 * 60 * 1000 - 2 * 60 * 60 * 1000);
    const dur = 20 + Math.floor(Math.random() * 40);
    const end = new Date(start.getTime() + dur * 60 * 1000);
    await pool.query(
      `INSERT INTO activities (user_id, activity_type, start_time, end_time, duration_minutes, steps, distance_meters, calories, avg_heart_rate, max_heart_rate, intensity_level)
       VALUES ('talhakere@gmail.com', $1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       ON CONFLICT (user_id, start_time) DO NOTHING`,
      [types[i % 3], start, end, dur,
        Math.floor(dur * 100), Math.floor(dur * 80),
        Math.floor(dur * 8), 110 + Math.floor(Math.random() * 30),
        150 + Math.floor(Math.random() * 30), ['LOW','MODERATE','HIGH'][Math.floor(Math.random()*3)]]
    );
  }

  console.log('✓ talhakere@gmail.com created with data and goals');

  // ── User 2: talhayigit142@gmail.com (no goals) ───────────────────────────
  await pool.query(
    `INSERT INTO users (first_name, last_name, email, password_hash)
     VALUES ('Talha', 'Yigit', 'talhayigit142@gmail.com', $1)
     ON CONFLICT (email) DO NOTHING`, [hash]
  );

  console.log('✓ talhayigit142@gmail.com created (no goals)');
  console.log('  Password for both: Password123!');

  process.exit(0);
})().catch(e => { console.error('ERROR:', e.message); process.exit(1); });
