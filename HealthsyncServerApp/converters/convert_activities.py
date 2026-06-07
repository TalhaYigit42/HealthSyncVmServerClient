#!/usr/bin/env python3
"""
Convert Samsung Health activity CSV files to database-ready JSON.
Maps to the `activities` table schema.
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


def safe_float(value):
    """Convert to float, return None if not possible."""
    try:
        if pd.isna(value):
            return None
        return float(value)
    except (ValueError, TypeError):
        return None


def convert_activities(csv_path, output_dir, user_id=None):
    """
    Convert an activity CSV to database-ready JSON files grouped by day.
    
    CSV columns: Quell-App, Aktivitätstyp, Aktivitätsname, Datum, Zeit,
                 Verstrichene Zeit, Aktive Zeit, Entfernung (km)
    
    Returns: list of output file paths created.
    """
    print(f"[activities] Processing: {csv_path}")
    
    df = pd.read_csv(csv_path, encoding='utf-8')
    
    if df.empty:
        print(f"  ⚠ Empty CSV, skipping.")
        return []
    
    records = []
    for _, row in df.iterrows():
        datum_str = str(row.get('Datum', ''))
        if not datum_str or datum_str == 'nan':
            continue
        
        start_dt = parse_timestamp_dt(datum_str)
        if start_dt is None:
            continue
        
        # Elapsed time in seconds
        elapsed_seconds = safe_int(row.get('Verstrichene Zeit', None))
        
        # Compute end_time
        end_time = None
        if start_dt and elapsed_seconds is not None:
            end_dt = start_dt + timedelta(seconds=elapsed_seconds)
            end_time = end_dt.strftime("%Y-%m-%dT%H:%M:%SZ")
        
        # Duration in minutes
        duration_minutes = None
        if elapsed_seconds is not None:
            duration_minutes = elapsed_seconds // 60
        
        # Distance: km → meters
        distance_km = safe_float(row.get('Entfernung (km)', None))
        distance_meters = None
        if distance_km is not None:
            distance_meters = int(round(distance_km * 1000))
        
        # Activity type (lowercased)
        activity_type = str(row.get('Aktivitätstyp', '')).lower()
        if activity_type == 'nan' or activity_type == '':
            activity_type = None
        
        record = {
            "user_id": user_id,
            "activity_type": activity_type,
            "start_time": parse_timestamp(datum_str),
            "end_time": end_time,
            "duration_minutes": duration_minutes,
            "steps": None,
            "distance_meters": distance_meters,
            "calories": None,
            "avg_heart_rate": None,
            "max_heart_rate": None,
            "intensity_level": None,
            "created_at": datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
        }
        records.append(record)
    
    if not records:
        print(f"  ⚠ No valid records found.")
        return []
    
    # Group by date
    output_files = []
    date_groups = {}
    for rec in records:
        if rec['start_time']:
            date_str = rec['start_time'][:10]
            date_groups.setdefault(date_str, []).append(rec)
    
    for date_str, day_records in date_groups.items():
        day_dir = os.path.join(output_dir, date_str)
        os.makedirs(day_dir, exist_ok=True)
        
        filename = f"activities_{date_str}.json"
        filepath = os.path.join(day_dir, filename)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(day_records, f, indent=2, ensure_ascii=False)
        
        output_files.append(filepath)
        print(f"  ✓ {filename} — {len(day_records)} records")
    
    print(f"  Total: {len(records)} rows → {len(output_files)} files")
    return output_files


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python convert_activities.py <csv_file> [output_dir]")
        sys.exit(1)
    
    csv_file = sys.argv[1]
    out_dir = sys.argv[2] if len(sys.argv) > 2 else "output"
    convert_activities(csv_file, out_dir)
