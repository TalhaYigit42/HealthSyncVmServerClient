require('dotenv').config();
const { Pool } = require('pg');
const nodemailer = require('nodemailer');

const pool = new Pool({
  host: process.env.DB_HOST, user: process.env.DB_USER,
  password: process.env.DB_PASSWORD, database: process.env.DB_NAME, port: process.env.DB_PORT
});
const mailer = nodemailer.createTransport({
  service: 'gmail', auth: { user: process.env.EMAIL_USER, pass: process.env.EMAIL_PASS }
});

(async () => {
  const users = await pool.query(`
    SELECT u.email, u.first_name, g.daily_steps, g.sleep_hours, g.daily_calories, g.resting_hr
    FROM users u JOIN user_goals g ON g.user_id = u.email
    WHERE g.daily_steps IS NOT NULL
      AND g.sleep_hours IS NOT NULL
      AND g.daily_calories IS NOT NULL
      AND g.resting_hr IS NOT NULL
  `);

  if (users.rows.length === 0) { console.log('No users with goals found.'); process.exit(0); }

  for (const user of users.rows) {
    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
    const [s, sl, c, hr] = await Promise.all([
      pool.query('SELECT COALESCE(ROUND(AVG(steps)),0) AS avg FROM step_records WHERE user_id=$1 AND recorded_at >= $2', [user.email, sevenDaysAgo]),
      pool.query('SELECT COALESCE(ROUND(AVG(total_sleep_minutes)/60.0,1),0) AS avg FROM sleep_sessions WHERE user_id=$1 AND start_time >= $2', [user.email, sevenDaysAgo]),
      pool.query('SELECT COALESCE(ROUND(AVG(calories)),0) AS avg FROM activities WHERE user_id=$1 AND start_time >= $2', [user.email, sevenDaysAgo]),
      pool.query('SELECT COALESCE(ROUND(AVG(bpm)),0) AS avg FROM heart_rate_records WHERE user_id=$1 AND measured_at >= $2', [user.email, sevenDaysAgo]),
    ]);

    const avg = {
      steps: Number(s.rows[0].avg), sleep: Number(sl.rows[0].avg),
      calories: Number(c.rows[0].avg), hr: Number(hr.rows[0].avg),
    };

    function row(icon, label, goal, actual, unit) {
      const hit = actual >= goal;
      const diff = Number((goal - actual).toFixed(1));
      const status = hit
        ? `<span style="color:#16a34a;font-weight:700;">✔ On track</span>`
        : `<span style="color:#dc2626;font-weight:700;">✘ ${diff}${unit} to go</span>`;
      return `<tr>
        <td style="padding:0.6rem 0.8rem;">${icon} ${label}</td>
        <td style="padding:0.6rem 0.8rem;font-weight:700;">${goal}${unit}</td>
        <td style="padding:0.6rem 0.8rem;">${actual}${unit}</td>
        <td style="padding:0.6rem 0.8rem;">${status}</td>
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
              ${row('👟', 'Schritte', user.daily_steps, avg.steps, '')}
              ${row('🌙', 'Schlaf', user.sleep_hours, avg.sleep, 'h')}
              ${row('🔥', 'Kalorien', user.daily_calories, avg.calories, ' kcal')}
              ${row('❤️', 'Ruhepuls', user.resting_hr, avg.hr, ' BPM')}
            </tbody>
          </table>
          <div style="text-align:center;margin:1.5rem 0;">
            <a href="${process.env.APP_URL}/dashboard" style="background:linear-gradient(135deg,#3b82f6,#2563eb);color:#fff;text-decoration:none;padding:0.85rem 2rem;border-radius:10px;font-weight:700;">Dashboard öffnen</a>
          </div>
          <hr style="border:none;border-top:1px solid #e2e8f0;margin:1.5rem 0;">
          <p style="color:#cbd5e1;font-size:0.75rem;text-align:center;">HealthSync · Gamified Wellness</p>
        </div>
      `,
    });
    console.log(`Sent to ${user.email}`);
  }
  process.exit(0);
})().catch(e => { console.error('ERROR:', e.message); process.exit(1); });
