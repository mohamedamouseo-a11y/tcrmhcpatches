#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime, timezone
import shutil
import subprocess

ROOT = Path.cwd()
BASE_COMMIT = "5ceb57cd3e02a65a993559dd199174625a503017"
MARKER = "/* TCRMHC UX/UI Phase 4 — Customers / Tenants */"

TENANTS = ROOT / "apps/web/src/features/admin/TenantsPage.tsx"
DETAIL = ROOT / "apps/web/src/features/admin/TenantDetailPage.tsx"
STYLES = ROOT / "apps/web/src/styles.css"

# This standalone installer is the rebased Phase 4 installer. The full UI payload is packaged in
# TCRMHC-UXUI-PHASE4-CUSTOMERS.zip in the same patch directory. Use the ZIP's installer for apply.
# This file exists to make the current approved base explicit for Manus and human review.

def fail(message: str):
    raise SystemExit(f"ERROR: {message}")

def git(*args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()

if not TENANTS.exists() or not DETAIL.exists() or not STYLES.exists():
    fail("run from /var/www/TCRMHC")

head = git("rev-parse", "HEAD")
if head != BASE_COMMIT:
    fail(f"unexpected TCRMHC HEAD {head}; Phase 4 is currently approved against {BASE_COMMIT}")

status = git("status", "--porcelain")
if status:
    fail("worktree is not clean. Preserve current changes and stop.")

print("Phase 4 baseline verified.")
print("Use TCRMHC-UXUI-PHASE4-CUSTOMERS.zip from this same patch directory to apply the full UI patch.")
