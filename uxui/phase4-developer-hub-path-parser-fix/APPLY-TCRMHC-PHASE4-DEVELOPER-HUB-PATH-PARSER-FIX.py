#!/usr/bin/env python3
from pathlib import Path
import subprocess
from datetime import datetime, timezone
import shutil

ROOT = Path.cwd()
EXPECTED_HEAD = "5ceb57cd3e02a65a993559dd199174625a503017"
TARGET = ROOT / "apps/api/src/modules/admin/developer-hub-github.service.ts"
EXPECTED_DIRTY = {
    "apps/web/src/features/admin/TenantsPage.tsx",
    "apps/web/src/features/admin/TenantDetailPage.tsx",
    "apps/web/src/styles.css",
}

OLD_SIG = 'async function gitText(args: string[], options: { env?: NodeJS.ProcessEnv; timeout?: number } = {}): Promise<string> {'
NEW_SIG = 'async function gitText(args: string[], options: { env?: NodeJS.ProcessEnv; timeout?: number; preserveOutput?: boolean } = {}): Promise<string> {'

OLD_RETURN = '    return result.stdout.trim();'
NEW_RETURN = '    return options.preserveOutput ? result.stdout : result.stdout.trim();'

OLD_NULL = 'async function gitTextOrNull(args: string[]): Promise<string | null> {\n  try { return await gitText(args); } catch { return null; }\n}'
NEW_NULL = 'async function gitTextOrNull(args: string[], options: { env?: NodeJS.ProcessEnv; timeout?: number; preserveOutput?: boolean } = {}): Promise<string | null> {\n  try { return await gitText(args, options); } catch { return null; }\n}'

OLD_STATUS = '    gitTextOrNull(["status", "--porcelain=v1"])'
NEW_STATUS = '    gitTextOrNull(["status", "--porcelain=v1"], { preserveOutput: true })'

def fail(message: str):
    raise SystemExit(f"ERROR: {message}")

def git(*args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).rstrip("\r\n")

if not TARGET.exists():
    fail("run from /var/www/TCRMHC")

head = git("rev-parse", "HEAD")
if head != EXPECTED_HEAD:
    fail(f"unexpected TCRMHC HEAD {head}; preserve current work and stop")

dirty = set()
raw = subprocess.check_output(["git", "status", "--porcelain=v1", "-z"], cwd=ROOT)
records = [r for r in raw.split(b"\0") if r]
for record in records:
    if len(record) < 4:
        fail("unexpected porcelain record")
    dirty.add(record[3:].decode("utf-8"))

if dirty != EXPECTED_DIRTY:
    fail(f"expected exactly the three already-applied Phase 4 UI files before parser fix; found: {sorted(dirty)}")

text = TARGET.read_text(encoding="utf-8")
for anchor, label in [
    (OLD_SIG, "gitText signature"),
    (OLD_RETURN, "gitText return"),
    (OLD_NULL, "gitTextOrNull"),
    (OLD_STATUS, "status call"),
]:
    if anchor not in text:
        fail(f"anchor missing: {label}")

stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
backup = ROOT / ".patch-backups" / f"phase4-developer-hub-path-parser-{stamp}" / TARGET.relative_to(ROOT)
backup.parent.mkdir(parents=True, exist_ok=True)
shutil.copy2(TARGET, backup)

text = text.replace(OLD_SIG, NEW_SIG, 1)
text = text.replace(OLD_RETURN, NEW_RETURN, 1)
text = text.replace(OLD_NULL, NEW_NULL, 1)
text = text.replace(OLD_STATUS, NEW_STATUS, 1)
TARGET.write_text(text, encoding="utf-8")

print("Applied Developer Hub Git porcelain path parser fix.")
print("Modified: apps/api/src/modules/admin/developer-hub-github.service.ts")
print("Existing Phase 4 UI files were preserved.")
