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

def git_text(*args: str) -> str:
    result = subprocess.run(["git", *args], cwd=ROOT, text=True, capture_output=True, check=True)
    return result.stdout.rstrip("\r\n")

def dirty_paths() -> set[str]:
    result = subprocess.run(
        ["git", "status", "--porcelain=v1", "-z"],
        cwd=ROOT,
        capture_output=True,
        check=True,
    )
    records = [record for record in result.stdout.split(b"\0") if record]
    paths: set[str] = set()
    index = 0
    while index < len(records):
        record = records[index]
        if len(record) < 4 or record[2:3] != b" ":
            fail(f"unexpected porcelain record format at index {index}")
        xy = record[:2]
        path = record[3:].decode("utf-8", errors="strict")
        if xy[:1] in {b"R", b"C"} or xy[1:2] in {b"R", b"C"}:
            index += 1
            if index >= len(records):
                fail("incomplete rename/copy porcelain record")
            path = records[index].decode("utf-8", errors="strict")
        paths.add(path)
        index += 1
    return paths

if not (ROOT / "package.json").exists() or not TARGET.exists():
    fail("run from /var/www/TCRMHC")

head = git_text("rev-parse", "HEAD")
if head != EXPECTED_HEAD:
    fail(f"unexpected HEAD {head}; preserve all work and stop")

changed = dirty_paths()
if changed != EXPECTED_PHASE4:
    fail(f"expected exactly the three already-applied Phase 4 UI files; found: {sorted(changed)}")

text = TARGET.read_text(encoding="utf-8")
if NEW in text:
    print("Phase 4 exactOptionalPropertyTypes fix already applied; no source change needed.")
else:
    if OLD not in text:
        fail("official Phase 4 request anchor not found; do not guess or rewrite")
    TARGET.write_text(text.replace(OLD, NEW, 1), encoding="utf-8")
    print("Applied Phase 4 exactOptionalPropertyTypes fix.")

changed_after = dirty_paths()
if changed_after != EXPECTED_PHASE4:
    fail(f"unexpected worktree after hotfix: {sorted(changed_after)}")

print("Safeguard passed with exact three Phase 4 UI files.")
print("Changed source only within apps/web/src/features/admin/TenantsPage.tsx.")
