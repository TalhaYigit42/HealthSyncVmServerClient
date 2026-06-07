#!/usr/bin/env python3
import os
import glob
import json
import psycopg2
from psycopg2.extras import execute_batch

DB_USER = os.environ.get("DB_USER", "healthsync_user")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "Bartal123!")
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_NAME = os.environ.get("DB_NAME", "healthsync")
DB_PORT = os.environ.get("DB_PORT", "5432")

def get_db_connection():
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT
    )

def create_tables(conn):
    with conn.cursor() as cur:
        # Users
        cur.execute("""
            CREATE TABLE IF NOT EXISTS users (
                uid SERIAL PRIMARY KEY,
                email VARCHAR UNIQUE NOT NULL,
                first_name VARCHAR NOT NULL,
                last_name VARCHAR NOT NULL,
                password_hash VARCHAR NOT NULL,
                created_at TIMESTAMP DEFAULT NOW()
            )
        """)
        # Heart rate
        cur.execute("""
            CREATE TABLE IF NOT EXISTS heart_rate_records (
                id SERIAL PRIMARY KEY,
                user_id VARCHAR,
                measured_at TIMESTAMP,
                bpm INT,
                resting BOOLEAN,
                created_at TIMESTAMP,
                UNIQUE (user_id, measured_at)
            )
        """)
        # Oxygen saturation
        cur.execute("""
            CREATE TABLE IF NOT EXISTS oxygen_saturation (
                id SERIAL PRIMARY KEY,
                user_id VARCHAR,
                measured_at TIMESTAMP,
                spo2_percent INT,
                created_at TIMESTAMP,
                UNIQUE (user_id, measured_at)
            )
        """)
        # Sleep sessions
        cur.execute("""
            CREATE TABLE IF NOT EXISTS sleep_sessions (
                id SERIAL PRIMARY KEY,
                user_id VARCHAR,
                start_time TIMESTAMP,
                end_time TIMESTAMP,
                total_sleep_minutes INT,
                deep_minutes INT,
                light_minutes INT,
                rem_minutes INT,
                awake_minutes INT,
                sleep_quality_score INT,
                created_at TIMESTAMP,
                updated_at TIMESTAMP,
                UNIQUE (user_id, start_time)
            )
        """)
        # Step records
        cur.execute("""
            CREATE TABLE IF NOT EXISTS step_records (
                id SERIAL PRIMARY KEY,
                user_id VARCHAR,
                recorded_at TIMESTAMP,
                steps INT,
                distance_meters FLOAT,
                calories FLOAT,
                walking_speed FLOAT,
                created_at TIMESTAMP,
                UNIQUE (user_id, recorded_at)
            )
        """)
        # Activities
        cur.execute("""
            CREATE TABLE IF NOT EXISTS activities (
                id SERIAL PRIMARY KEY,
                user_id VARCHAR,
                activity_type VARCHAR,
                start_time TIMESTAMP,
                end_time TIMESTAMP,
                duration_minutes INT,
                steps INT,
                distance_meters FLOAT,
                calories FLOAT,
                avg_heart_rate INT,
                max_heart_rate INT,
                intensity_level VARCHAR,
                created_at TIMESTAMP,
                UNIQUE (user_id, start_time)
            )
        """)
    conn.commit()

def process_file(conn, file_path):
    filename = os.path.basename(file_path).lower()
    
    with open(file_path, "r", encoding="utf-8") as f:
        data = json.load(f)
        
    if not isinstance(data, list) or not data:
        return 0
        
    inserted = 0
    with conn.cursor() as cur:
        if filename.startswith("heart_rate_records"):
            query = """
                INSERT INTO heart_rate_records 
                (user_id, measured_at, bpm, resting, created_at)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (user_id, measured_at) DO NOTHING
            """
            values = [(d.get('user_id'), d.get('measured_at'), d.get('bpm'), d.get('resting'), d.get('created_at')) for d in data]
            execute_batch(cur, query, values)
            inserted = cur.rowcount
            
        elif filename.startswith("oxygen_saturation"):
            query = """
                INSERT INTO oxygen_saturation 
                (user_id, measured_at, spo2_percent, created_at)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (user_id, measured_at) DO NOTHING
            """
            values = [(d.get('user_id'), d.get('measured_at'), d.get('spo2_percent'), d.get('created_at')) for d in data]
            execute_batch(cur, query, values)
            inserted = cur.rowcount
            
        elif filename.startswith("sleep_sessions"):
            query = """
                INSERT INTO sleep_sessions 
                (user_id, start_time, end_time, total_sleep_minutes, deep_minutes, 
                 light_minutes, rem_minutes, awake_minutes, sleep_quality_score, created_at, updated_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (user_id, start_time) DO NOTHING
            """
            values = [(d.get('user_id'), d.get('start_time'), d.get('end_time'), d.get('total_sleep_minutes'), 
                       d.get('deep_minutes'), d.get('light_minutes'), d.get('rem_minutes'), d.get('awake_minutes'),
                       d.get('sleep_quality_score'), d.get('created_at'), d.get('updated_at')) for d in data]
            execute_batch(cur, query, values)
            inserted = cur.rowcount
            
        elif filename.startswith("step_records"):
            query = """
                INSERT INTO step_records 
                (user_id, recorded_at, steps, distance_meters, calories, walking_speed, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (user_id, recorded_at) DO NOTHING
            """
            values = [(d.get('user_id'), d.get('recorded_at'), d.get('steps'), d.get('distance_meters'), 
                       d.get('calories'), d.get('walking_speed'), d.get('created_at')) for d in data]
            execute_batch(cur, query, values)
            inserted = cur.rowcount
            
        elif filename.startswith("activities"):
            query = """
                INSERT INTO activities 
                (user_id, activity_type, start_time, end_time, duration_minutes, 
                 steps, distance_meters, calories, avg_heart_rate, max_heart_rate,
                 intensity_level, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (user_id, start_time) DO NOTHING
            """
            values = [(d.get('user_id'), d.get('activity_type'), d.get('start_time'), d.get('end_time'),
                       d.get('duration_minutes'), d.get('steps'), d.get('distance_meters'), d.get('calories'),
                       d.get('avg_heart_rate'), d.get('max_heart_rate'), d.get('intensity_level'), d.get('created_at')) for d in data]
            execute_batch(cur, query, values)
            inserted = cur.rowcount
            
    conn.commit()
    # execute_batch rowcount doesn't always reflect total inserted ON CONFLICT DO NOTHING precisely
    # It returns len(values) if successful, but let's just use it as an indicator of completion
    if inserted == 0:
        pass # Not returning inserted because execute_batch behavior with DO NOTHING can be tricky

    return len(data)


def check_file_in_db(conn, file_path):
    """
    Check if the records from a JSON file already exist in the database.
    Samples the first record and checks the relevant table by unique key.
    Returns True if the data is already in the DB.
    """
    filename = os.path.basename(file_path).lower()

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except (json.JSONDecodeError, FileNotFoundError):
        return False

    if not isinstance(data, list) or not data:
        return False

    sample = data[0]

    try:
        with conn.cursor() as cur:
            if filename.startswith("heart_rate_records"):
                cur.execute(
                    "SELECT 1 FROM heart_rate_records WHERE user_id IS NOT DISTINCT FROM %s AND measured_at = %s LIMIT 1",
                    (sample.get('user_id'), sample.get('measured_at'))
                )
            elif filename.startswith("oxygen_saturation"):
                cur.execute(
                    "SELECT 1 FROM oxygen_saturation WHERE user_id IS NOT DISTINCT FROM %s AND measured_at = %s LIMIT 1",
                    (sample.get('user_id'), sample.get('measured_at'))
                )
            elif filename.startswith("sleep_sessions"):
                cur.execute(
                    "SELECT 1 FROM sleep_sessions WHERE user_id IS NOT DISTINCT FROM %s AND start_time = %s LIMIT 1",
                    (sample.get('user_id'), sample.get('start_time'))
                )
            elif filename.startswith("step_records"):
                cur.execute(
                    "SELECT 1 FROM step_records WHERE user_id IS NOT DISTINCT FROM %s AND recorded_at = %s LIMIT 1",
                    (sample.get('user_id'), sample.get('recorded_at'))
                )
            elif filename.startswith("activities"):
                cur.execute(
                    "SELECT 1 FROM activities WHERE user_id IS NOT DISTINCT FROM %s AND start_time = %s LIMIT 1",
                    (sample.get('user_id'), sample.get('start_time'))
                )
            else:
                return False

            return cur.fetchone() is not None
    except Exception:
        return False


def main(output_dir):
    print(f"Connecting to database '{DB_NAME}' at {DB_HOST}...")
    try:
        conn = get_db_connection()
    except Exception as e:
        print(f"❌ Failed to connect to database: {e}")
        return

    print("Ensuring tables exist...")
    create_tables(conn)
    
    # Find all JSON files recursively in output_dir
    json_files = glob.glob(os.path.join(output_dir, "**", "*.json"), recursive=True)
    if not json_files:
        print("No JSON files found in output directory.")
        conn.close()
        return
        
    print(f"Found {len(json_files)} JSON file(s). Starting database insertion...")
    total_records = 0
    files_processed = 0
    
    for filepath in sorted(json_files):
        try:
            records_count = process_file(conn, filepath)
            total_records += records_count
            files_processed += 1
        except Exception as e:
            print(f"  ❌ Error processing {os.path.basename(filepath)}: {e}")
            conn.rollback()

    conn.close()
    print(f"Database insertion complete. Processed {files_processed} files with {total_records} records.")

if __name__ == "__main__":
    import sys
    out_dir = sys.argv[1] if len(sys.argv) > 1 else "output"
    main(out_dir)
