#!/usr/bin/env python3
"""
Convert Samsung Health / Health Connect heart rate CSV files to database-ready JSON.
Maps to the `heart_rate_records` table schema.
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


def is_resting(datum_str, bpm):
    """
    Heuristic: consider a measurement 'resting' if:
    - Time is between 00:00 and 06:00 (nighttime) AND bpm < 80
    - OR bpm < 65 at any time
    """
    try:
        dt = datetime.strptime(datum_str.strip(), "%Y.%m.%d %H:%M:%S")
        nighttime = 0 <= dt.hour < 6
        if nighttime and bpm < 80:
            return True
        if bpm < 65:
            return True
        return False
    except (ValueError, AttributeError):
        return False


def safe_int(value):
    """Convert to int, return None if not possible."""
    try:
        if pd.isna(value):
            return None
        return int(float(value))
    except (ValueError, TypeError):
        return None


def convert_heart_rate(csv_path, output_dir, user_id=None):
    """
    Convert a heart rate CSV to database-ready JSON files grouped by day.
    
    CSV columns: Datum, Zeit, Puls, Datenquelle
    
    Returns: list of output file paths created.
    """
    print(f"[heart_rate] Processing: {csv_path}")
    
    df = pd.read_csv(csv_path, encoding='utf-8')
    
    if df.empty:
        print(f"  ⚠ Empty CSV, skipping.")
        return []
    
    records = []
    for _, row in df.iterrows():
        datum_str = str(row.get('Datum', ''))
        if not datum_str or datum_str == 'nan':
            continue
        
        bpm = safe_int(row.get('Puls', None))
        if bpm is None:
            continue
        
        measured_at = parse_timestamp(datum_str)
        if measured_at is None:
            continue
        
        record = {
            "user_id": user_id,
            "measured_at": measured_at,
            "bpm": bpm,
            "resting": is_resting(datum_str, bpm),
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
        date_str = rec['measured_at'][:10]
        date_groups.setdefault(date_str, []).append(rec)
    
    for date_str, day_records in date_groups.items():
        day_dir = os.path.join(output_dir, date_str)
        os.makedirs(day_dir, exist_ok=True)
        
        filename = f"heart_rate_records_{date_str}.json"
        filepath = os.path.join(day_dir, filename)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(day_records, f, indent=2, ensure_ascii=False)
        
        output_files.append(filepath)
        print(f"  ✓ {filename} — {len(day_records)} records")
    
    print(f"  Total: {len(records)} rows → {len(output_files)} files")
    return output_files


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python convert_heart_rate.py <csv_file> [output_dir]")
        sys.exit(1)
    
    csv_file = sys.argv[1]
    out_dir = sys.argv[2] if len(sys.argv) > 2 else "output"
    convert_heart_rate(csv_file, out_dir)
