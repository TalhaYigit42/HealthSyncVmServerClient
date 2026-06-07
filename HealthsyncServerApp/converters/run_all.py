#!/usr/bin/env python3
"""
Master runner for the Health CSV → JSON conversion pipeline.

Scans the input directory for all CSV files, detects which converter to use
based on folder name or filename, runs it, then inserts into the DB.

Usage:
    python run_all.py [input_directory] [output_directory]
"""

import os
import sys
import glob
from datetime import datetime

from convert_activities import convert_activities
from convert_heart_rate import convert_heart_rate
from convert_sleep import convert_sleep
from convert_steps import convert_steps
from convert_oxygen import convert_oxygen
import addToDB


def clear_processed_output(output_dir):
    if not os.path.isdir(output_dir):
        return

    print("=" * 70)
    print("  CLEARING ALREADY-PROCESSED OUTPUT FILES")
    print("=" * 70)

    try:
        conn = addToDB.get_db_connection()
        addToDB.create_tables(conn)
    except Exception as e:
        print(f"  WARNING: Could not connect to DB for cleanup: {e}")
        print("  Skipping cleanup step.\n")
        return

    json_files = glob.glob(os.path.join(output_dir, "**", "*.json"), recursive=True)
    removed = 0

    for fpath in sorted(json_files):
        try:
            if addToDB.check_file_in_db(conn, fpath):
                os.remove(fpath)
                print(f"  Removed (already in DB): {os.path.relpath(fpath, output_dir)}")
                removed += 1
        except Exception as e:
            print(f"  WARNING: Error checking {os.path.basename(fpath)}: {e}")

    for entry in sorted(os.listdir(output_dir)):
        day_dir = os.path.join(output_dir, entry)
        if os.path.isdir(day_dir) and not os.listdir(day_dir):
            os.rmdir(day_dir)

    conn.close()
    print(f"\n  Cleared {removed} file(s) already in the database.\n")


def detect_csv_type(csv_path):
    path_lower = csv_path.lower().replace('\\', '/')
    filename_lower = os.path.basename(csv_path).lower()

    if 'aktivit' in path_lower:
        return 'activities'
    elif 'puls' in path_lower:
        return 'heart_rate'
    elif 'schlaf' in path_lower:
        return 'sleep'
    elif 'schritt' in path_lower:
        return 'steps'
    elif 'sauerstoff' in path_lower:
        return 'oxygen'

    if 'walking' in filename_lower or 'training' in filename_lower or 'running' in filename_lower:
        return 'activities'
    elif 'puls' in filename_lower or 'heart' in filename_lower:
        return 'heart_rate'
    elif 'schlaf' in filename_lower or 'sleep' in filename_lower:
        return 'sleep'
    elif 'schritt' in filename_lower or 'step' in filename_lower:
        return 'steps'
    elif 'sauerstoff' in filename_lower or 'oxygen' in filename_lower:
        return 'oxygen'

    return None


def find_all_csvs(input_dir):
    csv_files = []
    for root, dirs, files in os.walk(input_dir):
        dirname = os.path.basename(root).lower()
        if dirname in ('converters', 'output', '.git'):
            continue
        for filename in files:
            if filename.lower().endswith('.csv'):
                csv_files.append(os.path.join(root, filename))
    return sorted(csv_files)


def run_all(input_dir, output_dir, user_id=None):
    clear_processed_output(output_dir)

    print("=" * 70)
    print("  Health CSV → Database-Ready JSON Conversion Pipeline")
    print("=" * 70)
    print(f"  Input directory:  {os.path.abspath(input_dir)}")
    print(f"  Output directory: {os.path.abspath(output_dir)}")
    if user_id:
        print(f"  User ID:          {user_id}")
    print(f"  Started at:       {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 70)
    print()

    csv_files = find_all_csvs(input_dir)

    if not csv_files:
        print("No CSV files found in the input directory.")
        return

    print(f"Found {len(csv_files)} CSV file(s)\n")

    converters = {
        'activities': convert_activities,
        'heart_rate': convert_heart_rate,
        'sleep':      convert_sleep,
        'steps':      convert_steps,
        'oxygen':     convert_oxygen,
    }

    results = {'success': 0, 'failed': 0, 'skipped': 0, 'total_files_created': 0}
    type_counts = {}

    for csv_path in csv_files:
        csv_type = detect_csv_type(csv_path)

        if csv_type is None:
            print(f"SKIPPED (unknown type): {csv_path}")
            results['skipped'] += 1
            continue

        type_counts[csv_type] = type_counts.get(csv_type, 0) + 1
        converter = converters[csv_type]

        try:
            output_files = converter(csv_path, output_dir, user_id=user_id)
            results['success'] += 1
            results['total_files_created'] += len(output_files)
            print()
        except Exception as e:
            print(f"FAILED: {csv_path}")
            print(f"   Error: {str(e)}")
            results['failed'] += 1
            print()

    print("=" * 70)
    print("  CONVERSION SUMMARY")
    print("=" * 70)
    print(f"  CSV files found:        {len(csv_files)}")
    print(f"  Successfully converted: {results['success']}")
    print(f"  Failed:                 {results['failed']}")
    print(f"  Skipped (unknown):      {results['skipped']}")
    print(f"  JSON files created:     {results['total_files_created']}")
    print()
    print("  By type:")
    for csv_type, count in sorted(type_counts.items()):
        print(f"    {csv_type:15s} — {count} CSV file(s)")
    print()
    print(f"  Output: {os.path.abspath(output_dir)}")
    print(f"  Finished at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 70)
    print()

    print("=" * 70)
    print("  DATABASE INTEGRATION")
    print("=" * 70)
    try:
        addToDB.main(output_dir)
    except Exception as e:
        print(f"Database insertion failed: {e}")
    print("=" * 70)


if __name__ == "__main__":
    input_directory = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), '..')
    output_directory = sys.argv[2] if len(sys.argv) > 2 else os.path.join(os.path.dirname(__file__), 'output')
    uid = sys.argv[3] if len(sys.argv) > 3 else None
    run_all(input_directory, output_directory, user_id=uid)
