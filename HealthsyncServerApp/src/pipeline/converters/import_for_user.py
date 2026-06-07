#!/usr/bin/env python3
"""
Called by the HealthSyncWeb Express server to import CSV files for a specific user.
Usage: python3 import_for_user.py <input_dir> <output_dir> <user_email>
"""
import sys
import os

# Make sure the converters dir is in path
_DIR = os.path.dirname(os.path.abspath(__file__))
if _DIR not in sys.path:
    sys.path.insert(0, _DIR)

import run_all

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print('Usage: import_for_user.py <input_dir> <output_dir> <user_email>', file=sys.stderr)
        sys.exit(1)

    input_dir  = sys.argv[1]
    output_dir = sys.argv[2]
    user_id    = sys.argv[3]

    os.makedirs(output_dir, exist_ok=True)
    run_all.run_all(input_dir, output_dir, user_id=user_id)
