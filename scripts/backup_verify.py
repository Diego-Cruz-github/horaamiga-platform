#!/usr/bin/env python3
"""
backup_verify.py - Integrity check for automated backups.
Verifies that backups were created in the last 24h and that their size is
within the expected range. Exits non-zero on problems, so it can run under
cron and feed alerting.
"""

import sys
from datetime import datetime, timedelta
from pathlib import Path

BACKUP_DIR = "/home/horaamiga/backups"
MAX_AGE_HOURS = 25  # the newest backup must be younger than 25h
MIN_SIZE_MB = 5     # minimum expected backup size in MB
RETENTION_DAYS = 7  # keep backups for the last 7 days


def get_backup_files(backup_dir):
    """Lists backup files sorted by modification time (newest first)."""
    path = Path(backup_dir)
    if not path.exists():
        return []

    backups = []
    for f in path.glob("*.tar.gz"):
        stat = f.stat()
        modified = datetime.fromtimestamp(stat.st_mtime)
        backups.append({
            "name": f.name,
            "path": str(f),
            "size_mb": round(stat.st_size / (1024 * 1024), 2),
            "modified": modified,
            "age_hours": (datetime.now() - modified).total_seconds() / 3600,
        })

    return sorted(backups, key=lambda x: x["modified"], reverse=True)


def verify_latest_backup(backups):
    """Validates the newest backup (age and size)."""
    if not backups:
        print("[FAIL] No backups found!")
        return False

    latest = backups[0]
    print(f"  Latest backup: {latest['name']}")
    print(f"  Size: {latest['size_mb']} MB")
    print(f"  Age: {latest['age_hours']:.1f} hours")

    issues = []

    if latest["age_hours"] > MAX_AGE_HOURS:
        issues.append(f"Backup too old ({latest['age_hours']:.1f}h > {MAX_AGE_HOURS}h)")

    if latest["size_mb"] < MIN_SIZE_MB:
        issues.append(f"Backup too small ({latest['size_mb']}MB < {MIN_SIZE_MB}MB)")

    if issues:
        for issue in issues:
            print(f"  [WARN] {issue}")
        return False

    print("  [OK] Backup is valid")
    return True


def check_retention(backups):
    """Reports backups beyond the retention window."""
    cutoff = datetime.now() - timedelta(days=RETENTION_DAYS)
    old_backups = [b for b in backups if b["modified"] < cutoff]

    if old_backups:
        print(f"\n  [INFO] {len(old_backups)} backup(s) beyond the {RETENTION_DAYS}-day retention")
        for b in old_backups:
            print(f"    - {b['name']} ({b['size_mb']}MB)")

    return len(old_backups)


def run_verification(backup_dir):
    """Runs the full backup verification."""
    print(f"\n[{datetime.now().isoformat()}] Backup Verification")
    print(f"  Directory: {backup_dir}")
    print("-" * 60)

    backups = get_backup_files(backup_dir)
    print(f"  Backups found: {len(backups)}")

    is_valid = verify_latest_backup(backups)
    check_retention(backups)

    print("-" * 60)
    print(f"  Result: {'BACKUP OK' if is_valid else 'BACKUP ISSUES'}")

    return is_valid


if __name__ == "__main__":
    backup_dir = sys.argv[1] if len(sys.argv) > 1 else BACKUP_DIR
    valid = run_verification(backup_dir)
    sys.exit(0 if valid else 1)
