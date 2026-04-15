#!/usr/bin/env python3
"""
backup_verify.py - Verificacao de integridade dos backups automatizados
Verifica se os backups foram criados nas ultimas 24h e se o tamanho esta dentro do esperado.
"""

import os
import sys
from datetime import datetime, timedelta
from pathlib import Path


BACKUP_DIR = "/home/horaamiga/backups"
MAX_AGE_HOURS = 25  # Backup deve ter menos de 25h
MIN_SIZE_MB = 5     # Backup minimo esperado em MB
RETENTION_DAYS = 7  # Manter backups dos ultimos 7 dias


def get_backup_files(backup_dir):
    """Lista arquivos de backup ordenados por data de modificacao."""
    path = Path(backup_dir)
    if not path.exists():
        return []

    backups = []
    for f in path.glob("*.tar.gz"):
        stat = f.stat()
        backups.append({
            "name": f.name,
            "path": str(f),
            "size_mb": round(stat.st_size / (1024 * 1024), 2),
            "modified": datetime.fromtimestamp(stat.st_mtime),
            "age_hours": (datetime.now() - datetime.fromtimestamp(stat.st_mtime)).total_seconds() / 3600,
        })

    return sorted(backups, key=lambda x: x["modified"], reverse=True)


def verify_latest_backup(backups):
    """Verifica se o backup mais recente e valido."""
    if not backups:
        print("[FAIL] Nenhum backup encontrado!")
        return False

    latest = backups[0]
    print(f"  Ultimo backup: {latest['name']}")
    print(f"  Tamanho: {latest['size_mb']} MB")
    print(f"  Idade: {latest['age_hours']:.1f} horas")

    issues = []

    if latest["age_hours"] > MAX_AGE_HOURS:
        issues.append(f"Backup muito antigo ({latest['age_hours']:.1f}h > {MAX_AGE_HOURS}h)")

    if latest["size_mb"] < MIN_SIZE_MB:
        issues.append(f"Backup muito pequeno ({latest['size_mb']}MB < {MIN_SIZE_MB}MB)")

    if issues:
        for issue in issues:
            print(f"  [WARN] {issue}")
        return False

    print("  [OK] Backup valido")
    return True


def check_retention(backups):
    """Verifica politica de retencao de backups."""
    cutoff = datetime.now() - timedelta(days=RETENTION_DAYS)
    old_backups = [b for b in backups if b["modified"] < cutoff]

    if old_backups:
        print(f"\n  [INFO] {len(old_backups)} backup(s) alem da retencao de {RETENTION_DAYS} dias")
        for b in old_backups:
            print(f"    - {b['name']} ({b['size_mb']}MB)")

    return len(old_backups)


def run_verification(backup_dir):
    """Executa verificacao completa dos backups."""
    print(f"\n[{datetime.now().isoformat()}] Backup Verification")
    print(f"  Directory: {backup_dir}")
    print("-" * 60)

    backups = get_backup_files(backup_dir)
    print(f"  Total backups encontrados: {len(backups)}")

    is_valid = verify_latest_backup(backups)
    check_retention(backups)

    print("-" * 60)
    print(f"  Result: {'BACKUP OK' if is_valid else 'BACKUP ISSUES'}")

    return is_valid


if __name__ == "__main__":
    backup_dir = sys.argv[1] if len(sys.argv) > 1 else BACKUP_DIR
    valid = run_verification(backup_dir)
    sys.exit(0 if valid else 1)
