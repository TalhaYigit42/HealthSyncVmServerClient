#!/usr/bin/env python3
from flask import Flask, jsonify, send_from_directory
import psycopg2, psycopg2.extras, os

_THIS_DIR = os.path.dirname(os.path.abspath(__file__))
app = Flask(__name__, static_folder=os.path.join(_THIS_DIR, "static"))

DB = dict(dbname="healthsync", user="healthsync_user",
          password="Bartal123!", host="localhost", port=5432)

def query(sql):
    conn = psycopg2.connect(**DB)
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute(sql)
    rows = [dict(r) for r in cur.fetchall()]
    conn.close()
    return rows

# --- REST API ---

@app.route("/api/overview")
def api_overview():
    return jsonify(query("""
        SELECT 'heart_rate' AS "table", COUNT(*) AS records FROM heart_rate_records UNION ALL
        SELECT 'steps',                 COUNT(*)             FROM step_records       UNION ALL
        SELECT 'sleep',                 COUNT(*)             FROM sleep_sessions     UNION ALL
        SELECT 'oxygen',                COUNT(*)             FROM oxygen_saturation  UNION ALL
        SELECT 'activities',            COUNT(*)             FROM activities
    """))

@app.route("/api/steps")
def api_steps():
    return jsonify(query("""
        SELECT TO_CHAR(recorded_at, 'DD.MM.YYYY') AS day,
               SUM(steps) AS steps,
               ROUND(SUM(distance_meters)) AS distance_m,
               ROUND(SUM(calories)::numeric, 1) AS calories
        FROM step_records GROUP BY day ORDER BY day DESC
    """))

@app.route("/api/heartrate")
def api_heartrate():
    return jsonify(query("""
        SELECT TO_CHAR(measured_at, 'DD.MM.YYYY') AS day,
               ROUND(AVG(bpm)) AS avg_bpm,
               MIN(bpm) AS min_bpm,
               MAX(bpm) AS max_bpm,
               COUNT(*) AS measurements
        FROM heart_rate_records GROUP BY day ORDER BY day DESC
    """))

@app.route("/api/sleep")
def api_sleep():
    return jsonify(query("""
        SELECT TO_CHAR(start_time, 'DD.MM.YYYY') AS night,
               ROUND(total_sleep_minutes / 60.0, 1) AS hours_slept,
               deep_minutes, light_minutes, rem_minutes, awake_minutes,
               sleep_quality_score
        FROM sleep_sessions ORDER BY start_time DESC
    """))

@app.route("/api/oxygen")
def api_oxygen():
    return jsonify(query("""
        SELECT TO_CHAR(measured_at, 'DD.MM.YYYY') AS day,
               ROUND(AVG(spo2_percent), 1) AS avg_spo2,
               MIN(spo2_percent) AS min_spo2,
               MAX(spo2_percent) AS max_spo2
        FROM oxygen_saturation GROUP BY day ORDER BY day DESC
    """))

@app.route("/api/activities")
def api_activities():
    return jsonify(query("""
        SELECT TO_CHAR(start_time, 'DD.MM.YYYY') AS day,
               activity_type, duration_minutes, steps,
               ROUND(distance_meters) AS distance_m,
               ROUND(calories::numeric, 1) AS calories,
               avg_heart_rate, max_heart_rate
        FROM activities ORDER BY start_time DESC
    """))

# --- Serve frontend ---

@app.route("/")
def index():
    return send_from_directory("static", "index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
