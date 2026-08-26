#!/usr/bin/env python3
from pathlib import Path
import shutil
from datetime import datetime, timezone

ROOT = Path.cwd()
STYLES = ROOT / "apps/web/src/styles.css"
MARKER = '/* TCRMHC UX/UI Phase 1.1 — Light Login Contrast Fix */'
PHASE1_MARKER = "/* TCRMHC UX/UI Phase 1 — Semantic Design System + Light/Dark Theme */"

CSS = r"""/* TCRMHC UX/UI Phase 1.1 — Light Login Contrast Fix */
html[data-theme="light"] .login-card .field label {
  color: var(--ui-text);
}

html[data-theme="light"] .login-card .input-wrap input {
  color: var(--ui-text);
  background: var(--ui-surface-solid);
  border-color: var(--ui-border-strong);
}

html[data-theme="light"] .login-card .input-wrap input::placeholder {
  color: #667085;
  opacity: 1;
}

html[data-theme="light"] .login-card .input-wrap > svg,
html[data-theme="light"] .login-card .password-toggle {
  color: var(--ui-text-secondary);
}

html[data-theme="light"] .login-card .remember {
  color: var(--ui-text-secondary);
}

html[data-theme="light"] .login-card .input-wrap input:focus {
  border-color: var(--ui-accent);
  box-shadow: 0 0 0 3px color-mix(in srgb, var(--ui-accent) 16%, transparent);
}"""

def fail(msg: str):
    raise SystemExit(f"ERROR: {msg}")

if not STYLES.exists():
    fail(f"missing {STYLES}; run from /var/www/TCRMHC")

text = STYLES.read_text(encoding="utf-8")
if MARKER in text:
    print("Phase 1.1 already applied; no changes made.")
    raise SystemExit(0)
if PHASE1_MARKER not in text:
    fail("Phase 1 design-system marker not found; do not apply Phase 1.1 to an unknown baseline")

stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
backup = ROOT / ".patch-backups" / f"uxui-phase1.1-{stamp}" / "apps/web/src/styles.css"
backup.parent.mkdir(parents=True, exist_ok=True)
shutil.copy2(STYLES, backup)

STYLES.write_text(text.rstrip() + "\n\n" + CSS + "\n", encoding="utf-8")

print("Applied TCRMHC UX/UI Phase 1.1 light-login contrast fix.")
print(f"Backup: {backup}")
print("Changed: apps/web/src/styles.css")
