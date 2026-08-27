#!/usr/bin/env python3
from pathlib import Path
import subprocess

ROOT = Path.cwd()
EXPECTED_HEAD = "5ceb57cd3e02a65a993559dd199174625a503017"
TARGET = ROOT / "apps/web/src/features/admin/TenantsPage.tsx"
EXPECTED_PHASE4 = {
    "apps/web/src/features/admin/TenantsPage.tsx",
    "apps/web/src/features/admin/TenantDetailPage.tsx",
    "apps/web/src/styles.css",
}

OLD = '      adminApi.tenants({ page, pageSize: 25, search: search.trim() || undefined, status: status || undefined })'
NEW = '      const query: { page?: number; pageSize?: number; search?: string; status?: string } = { page, pageSize: 25 };\n      const normalizedSearch = search.trim();\n      if (normalizedSearch) query.search = normalizedSearch;\n      if (status) query.status = status;\n      adminApi.tenants(query)'

def fail(message: str):
    raise SystemExit(f"ERROR: {message}")

def git(*args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()

if not TARGET.exists():
    fail("run from /var/www/TCRMHC")

head = git("rev-parse", "HEAD")
if head != EXPECTED_HEAD:
    fail(f"unexpected HEAD {head}; preserve all work and stop")

changed = set()
for line in git("status", "--porcelain").splitlines():
    if not line:
        continue
    path = line[3:]
    if " -> " in path:
        path = path.split(" -> ", 1)[1]
    changed.add(path)

if changed != EXPECTED_PHASE4:
    fail(f"expected exactly the three already-applied Phase 4 UI files; found: {sorted(changed)}")

text = TARGET.read_text(encoding="utf-8")
if NEW in text:
    print("Phase 4 typecheck fix already applied; no changes needed.")
    raise SystemExit(0)
if OLD not in text:
    fail("official Phase 4 request anchor not found; do not guess or rewrite")

TARGET.write_text(text.replace(OLD, NEW, 1), encoding="utf-8")
print("Applied official Phase 4 exactOptionalPropertyTypes fix.")
print("Changed only: apps/web/src/features/admin/TenantsPage.tsx")
