#!/usr/bin/env python3
"""
Convert Samsung Health / Health Connect step CSV files to database-ready JSON.
Maps to the `step_records` table schema.

Handles two formats:
- Health Connect daily summary: one row per day with total steps
- Samsung Health per-minute: many rows per day, needs aggregation to daily total
"""

import pandas as pd
import json
import os
import sys
from datetime import datetime


def parse_timestamp(datum_str):
    """Parse 'YYYY.MM.DD HH:MM:SS' to ISO 8601 string."""
    try:
        dt = datetime.strptime(datum_str.strip(), "%Y.%m.%d %H:%M:%S")
        return dt.strftime("%Y-%m-%dT%H:%M:%SZ")
    except (ValueError, AttributeError):
        return None


def extract_date(datum_str):
    """Extract date string (YYYY-MM-DD) from 'YYYY.MM.DD HH:MM:SS'."""
    try:
        dt = datetime.strptime(datum_str.strip(), "%Y.%m.%d %H:%M:%S")
        return dt.strftime("%Y-%m-%d")
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


def is_per_minute_format(df):
    """
    Detect if the CSV is per-minute (Samsung Health) or daily summary (Health Connect).
    Per-minute files have many rows with small step counts per day.
    """
    if len(df) <= 1:
        return False
    
    # Check if there are multiple rows for the same date
    dates = set()
    for _, row in df.iterrows():
        datum_str = str(row.get('Datum', ''))
        date = extract_date(datum_str)
        if date and date in dates:
            return True
        if date:
            dates.add(date)
    
    return False


def convert_steps(csv_path, output_dir, user_id=None):
    """
    Convert a steps CSV to database-ready JSON files grouped by day.
    
    CSV columns: Datum, Zeit, Schritte, [Datenquelle]
    
    Returns: list of output file paths created.
    """
    print(f"[steps] Processing: {csv_path}")
    
    df = pd.read_csv(csv_path, encoding='utf-8')
    
    if df.empty:
        print(f"  ⚠ Empty CSV, skipping.")
        return []
    
    per_minute = is_per_minute_format(df)
    now_str = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
    
    if per_minute:
        # Aggregate per-minute rows into daily totals
        daily_totals = {}
        for _, row in df.iterrows():
            datum_str = str(row.get('Datum', ''))
            date = extract_date(datum_str)
            steps = safe_int(row.get('Schritte', 0))
            
            if date is None or steps is None:
                continue
            
            if date not in daily_totals:
                daily_totals[date] = 0
            daily_totals[date] += steps
        
        records = []
        for date, total_steps in daily_totals.items():
            record = {
                "user_id": user_id,
                "recorded_at": f"{date}T00:00:00Z",
                "steps": total_steps,
                "distance_meters": None,
                "calories": None,
                "walking_speed": None,
                "created_at": now_str
            }
            records.append(record)
    else:
        # Daily summary format — one row per day
        records = []
        for _, row in df.iterrows():
            datum_str = str(row.get('Datum', ''))
            if not datum_str or datum_str == 'nan':
                continue
            
            recorded_at = parse_timestamp(datum_str)
            steps = safe_int(row.get('Schritte', None))
            
            if recorded_at is None:
                continue
            
            record = {
                "user_id": user_id,
                "recorded_at": recorded_at,
                "steps": steps,
                "distance_meters": None,
                "calories": None,
                "walking_speed": None,
                "created_at": now_str
            }
            records.append(record)
    
    if not records:
        print(f"  ⚠ No valid records found.")
        return []
    
    # Group by date
    output_files = []
    date_groups = {}
    for rec in records:
        date_str = rec['recorded_at'][:10]
        date_groups.setdefault(date_str, []).append(rec)
    
    for date_str, day_records in date_groups.items():
        day_dir = os.path.join(output_dir, date_str)
        os.makedirs(day_dir, exist_ok=True)
        
        filename = f"step_records_{date_str}.json"
        filepath = os.path.join(day_dir, filename)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(day_records, f, indent=2, ensure_ascii=False)
        
        output_files.append(filepath)
        print(f"  ✓ {filename} — {len(day_records)} records")
    
    print(f"  Total: {len(records)} rows → {len(output_files)} files")
    return output_files


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python convert_steps.py <csv_file> [output_dir]")
        sys.exit(1)
    
    csv_file = sys.argv[1]
    out_dir = sys.argv[2] if len(sys.argv) > 2 else "output"
    convert_steps(csv_file, out_dir)
