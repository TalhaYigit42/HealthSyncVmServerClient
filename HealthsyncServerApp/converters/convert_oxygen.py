#!/usr/bin/env python3
"""
Convert Samsung Health / Health Connect oxygen saturation CSV files to JSON.

NOTE: There is no matching table in the current database schema.
This converter outputs the data as-is for future use.
Values of 0.0 are filtered out (sensor initialization artifacts).
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


def safe_float(value):
    """Convert to float, return None if not possible."""
    try:
        if pd.isna(value):
            return None
        return float(value)
    except (ValueError, TypeError):
        return None


def convert_oxygen(csv_path, output_dir, user_id=None):
    """
    Convert an oxygen saturation CSV to JSON files grouped by day.
    
    CSV columns: Datum, Zeit, Saturation d'oxygène
    
    Returns: list of output file paths created.
    """
    print(f"[oxygen] Processing: {csv_path}")
    
    df = pd.read_csv(csv_path, encoding='utf-8')
    
    if df.empty:
        print(f"  ⚠ Empty CSV, skipping.")
        return []
    
    # The oxygen saturation column name (French in the export)
    oxy_col = None
    for col in df.columns:
        if 'saturation' in col.lower() or 'oxygène' in col.lower() or 'oxygen' in col.lower():
            oxy_col = col
            break
    
    if oxy_col is None:
        print(f"  ⚠ Could not find oxygen saturation column.")
        return []
    
    now_str = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
    records = []
    
    for _, row in df.iterrows():
        datum_str = str(row.get('Datum', ''))
        if not datum_str or datum_str == 'nan':
            continue
        
        measured_at = parse_timestamp(datum_str)
        if measured_at is None:
            continue
        
        spo2 = safe_float(row.get(oxy_col, None))
        
        # Filter out 0.0 values (sensor errors / initialization)
        if spo2 is None or spo2 == 0.0:
            continue
        
        record = {
            "user_id": user_id,
            "measured_at": measured_at,
            "spo2_percent": int(round(spo2)),
            "created_at": now_str
        }
        records.append(record)
    
    if not records:
        print(f"  ⚠ No valid records found (all 0.0 or empty).")
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
        
        filename = f"oxygen_saturation_{date_str}.json"
        filepath = os.path.join(day_dir, filename)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(day_records, f, indent=2, ensure_ascii=False)
        
        output_files.append(filepath)
        print(f"  ✓ {filename} — {len(day_records)} records")
    
    print(f"  Total: {len(records)} rows → {len(output_files)} files")
    return output_files


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python convert_oxygen.py <csv_file> [output_dir]")
        sys.exit(1)
    
    csv_file = sys.argv[1]
    out_dir = sys.argv[2] if len(sys.argv) > 2 else "output"
    convert_oxygen(csv_file, out_dir)
