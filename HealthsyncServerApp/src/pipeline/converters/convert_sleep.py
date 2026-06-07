#!/usr/bin/env python3
"""
Convert Samsung Health / Health Connect sleep CSV files to database-ready JSON.
Maps to the `sleep_sessions` table schema.

The CSV contains per-stage rows (each row = one sleep stage with duration).
This script aggregates them into sleep sessions with totals per stage.
"""

import pandas as pd
import json
import os
import sys
from datetime import datetime, timedelta


def parse_timestamp(datum_str):
    """Parse 'YYYY.MM.DD HH:MM:SS' to ISO 8601 string."""
    try:
        dt = datetime.strptime(datum_str.strip(), "%Y.%m.%d %H:%M:%S")
        return dt.strftime("%Y-%m-%dT%H:%M:%SZ")
    except (ValueError, AttributeError):
        return None


def parse_timestamp_dt(datum_str):
    """Parse 'YYYY.MM.DD HH:MM:SS' to datetime object."""
    try:
        return datetime.strptime(datum_str.strip(), "%Y.%m.%d %H:%M:%S")
    except (ValueError, AttributeError):
        return None


def safe_int(value):
    """Convert to int, return None if not possible."""
    try:
        if pd.isna(value):
            return None
        return int(float(value))
    except (ValueError, TypeError):
        return None


def compute_sleep_quality(deep_min, light_min, rem_min, awake_min, total_sleep_min):
    """
    Compute a sleep quality score (0-100) based on stage proportions.
    Ideal: ~20% deep, ~50% light, ~25% REM, <5% awake of total time.
    """
    if total_sleep_min <= 0:
        return 0
    
    total_time = deep_min + light_min + rem_min + awake_min
    if total_time <= 0:
        return 0
    
    score = 50  # base score
    
    # Duration bonus: 7-9 hours is ideal
    if 420 <= total_sleep_min <= 540:
        score += 20
    elif 360 <= total_sleep_min <= 600:
        score += 10
    elif total_sleep_min < 300:
        score -= 10
    
    # Deep sleep proportion (ideal ~20%)
    deep_ratio = deep_min / total_time
    if 0.15 <= deep_ratio <= 0.25:
        score += 10
    elif 0.10 <= deep_ratio <= 0.30:
        score += 5
    elif deep_ratio < 0.05:
        score -= 10
    
    # REM proportion (ideal ~25%)
    rem_ratio = rem_min / total_time
    if 0.20 <= rem_ratio <= 0.30:
        score += 10
    elif 0.15 <= rem_ratio <= 0.35:
        score += 5
    elif rem_ratio < 0.05:
        score -= 5
    
    # Awake penalty
    awake_ratio = awake_min / total_time
    if awake_ratio > 0.15:
        score -= 15
    elif awake_ratio > 0.10:
        score -= 10
    elif awake_ratio > 0.05:
        score -= 5
    
    return max(0, min(100, score))


def group_into_sessions(df):
    """
    Group sleep stage rows into sessions.
    A new session starts when there's a gap > 2 hours between entries.
    """
    if df.empty:
        return []
    
    # Parse and sort by timestamp
    entries = []
    for _, row in df.iterrows():
        datum_str = str(row.get('Datum', ''))
        dt = parse_timestamp_dt(datum_str)
        if dt is None:
            continue
        
        duration_sec = safe_int(row.get('Durée en secondes', 0))
        stage = str(row.get('Schlafstadium', '')).lower().strip()
        
        if duration_sec is None:
            duration_sec = 0
        
        entries.append({
            'dt': dt,
            'duration_sec': duration_sec,
            'stage': stage
        })
    
    if not entries:
        return []
    
    # Sort by timestamp
    entries.sort(key=lambda x: x['dt'])
    
    # Group into sessions (gap > 2 hours = new session)
    sessions = []
    current_session = [entries[0]]
    
    for i in range(1, len(entries)):
        prev_end = entries[i - 1]['dt'] + timedelta(seconds=entries[i - 1]['duration_sec'])
        curr_start = entries[i]['dt']
        gap = (curr_start - prev_end).total_seconds()
        
        if gap > 7200:  # > 2 hours gap = new session
            sessions.append(current_session)
            current_session = [entries[i]]
        else:
            current_session.append(entries[i])
    
    if current_session:
        sessions.append(current_session)
    
    return sessions


def convert_sleep(csv_path, output_dir, user_id=None):
    """
    Convert a sleep CSV to database-ready JSON files grouped by day.
    
    CSV columns: Datum, Zeit, Durée en secondes, Schlafstadium
    
    Returns: list of output file paths created.
    """
    print(f"[sleep] Processing: {csv_path}")
    
    df = pd.read_csv(csv_path, encoding='utf-8')
    
    if df.empty:
        print(f"  ⚠ Empty CSV, skipping.")
        return []
    
    sessions = group_into_sessions(df)
    
    if not sessions:
        print(f"  ⚠ No valid sessions found.")
        return []
    
    records = []
    now_str = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
    
    for session_entries in sessions:
        if len(session_entries) < 2:
            continue  # Skip very short sessions (1 entry)
        
        start_time = session_entries[0]['dt']
        # End time = last entry start + its duration
        last = session_entries[-1]
        end_time = last['dt'] + timedelta(seconds=last['duration_sec'])
        
        # Aggregate durations per stage
        stage_minutes = {'deep': 0, 'light': 0, 'rem': 0, 'awake': 0}
        for entry in session_entries:
            stage = entry['stage']
            minutes = entry['duration_sec'] / 60.0
            if stage in stage_minutes:
                stage_minutes[stage] += minutes
        
        deep_min = int(round(stage_minutes['deep']))
        light_min = int(round(stage_minutes['light']))
        rem_min = int(round(stage_minutes['rem']))
        awake_min = int(round(stage_minutes['awake']))
        total_sleep_min = deep_min + light_min + rem_min  # excluding awake
        
        # Skip sessions shorter than 30 min of actual sleep
        if total_sleep_min < 30:
            continue
        
        quality_score = compute_sleep_quality(
            deep_min, light_min, rem_min, awake_min, total_sleep_min
        )
        
        record = {
            "user_id": user_id,
            "start_time": start_time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "end_time": end_time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "total_sleep_minutes": total_sleep_min,
            "deep_minutes": deep_min,
            "light_minutes": light_min,
            "rem_minutes": rem_min,
            "awake_minutes": awake_min,
            "sleep_quality_score": quality_score,
            "created_at": now_str,
            "updated_at": now_str
        }
        records.append(record)
    
    if not records:
        print(f"  ⚠ No valid sleep sessions found.")
        return []
    
    # Group by the START date of the session
    output_files = []
    date_groups = {}
    for rec in records:
        date_str = rec['start_time'][:10]
        date_groups.setdefault(date_str, []).append(rec)
    
    for date_str, day_records in date_groups.items():
        day_dir = os.path.join(output_dir, date_str)
        os.makedirs(day_dir, exist_ok=True)
        
        filename = f"sleep_sessions_{date_str}.json"
        filepath = os.path.join(day_dir, filename)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(day_records, f, indent=2, ensure_ascii=False)
        
        output_files.append(filepath)
        print(f"  ✓ {filename} — {len(day_records)} sessions")
    
    print(f"  Total: {len(records)} sessions → {len(output_files)} files")
    return output_files


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python convert_sleep.py <csv_file> [output_dir]")
        sys.exit(1)
    
    csv_file = sys.argv[1]
    out_dir = sys.argv[2] if len(sys.argv) > 2 else "output"
    convert_sleep(csv_file, out_dir)
