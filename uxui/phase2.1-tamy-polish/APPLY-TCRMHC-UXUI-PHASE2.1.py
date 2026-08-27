#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime, timezone
import shutil
import subprocess

ROOT = Path.cwd()
BASE_COMMIT = "aa8b9770898d38dd54152eae9cb25392aed17ed5"
MARKER = "/* TCRMHC UX/UI Phase 2.1 — Tamy polish */"

TAMY = ROOT / "apps/web/src/features/TamyFloatingAgent.tsx"
STYLES = ROOT / "apps/web/src/styles.css"

def fail(message: str):
    raise SystemExit(f"ERROR: {message}")

def git(*args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()

if not TAMY.exists() or not STYLES.exists():
    fail("run from /var/www/TCRMHC")

head = git("rev-parse", "HEAD")
if head != BASE_COMMIT:
    fail(f"unexpected TCRMHC HEAD {head}; Phase 2.1 was prepared against {BASE_COMMIT}")

status = git("status", "--porcelain")
if status:
    fail("worktree is not clean. Preserve current changes and stop.")

styles = STYLES.read_text(encoding="utf-8")
if MARKER in styles:
    print("Phase 2.1 already applied; no changes made.")
    raise SystemExit(0)

tamy = TAMY.read_text(encoding="utf-8")

old_default = """function defaultPoint(): Point {
  if (typeof window === "undefined") return { x: EDGE_GAP, y: 160 };
  return clampPoint({
    x: window.innerWidth - FAB_SIZE - 24,
    y: Math.max(120, Math.round(window.innerHeight * 0.62))
  });
}

function readPosition(): Point {
  if (typeof window === "undefined") return defaultPoint();
  try {
    const value = JSON.parse(window.localStorage.getItem(POSITION_KEY) || "null") as Point | null;
    if (value && Number.isFinite(value.x) && Number.isFinite(value.y)) return clampPoint(value);
  } catch {
    // Ignore malformed legacy preference.
  }
  return defaultPoint();
}"""

new_default = """function defaultPoint(lang: Language): Point {
  if (typeof window === "undefined") return { x: EDGE_GAP, y: 160 };
  const x = lang === "ar"
    ? 24
    : window.innerWidth - FAB_SIZE - 24;
  return clampPoint({
    x,
    y: Math.max(120, Math.round(window.innerHeight * 0.62))
  });
}

function readPosition(lang: Language): Point {
  if (typeof window === "undefined") return defaultPoint(lang);
  try {
    const value = JSON.parse(window.localStorage.getItem(POSITION_KEY) || "null") as Point | null;
    if (value && Number.isFinite(value.x) && Number.isFinite(value.y)) return clampPoint(value);
  } catch {
    // Ignore malformed legacy preference.
  }
  return defaultPoint(lang);
}"""

if old_default not in tamy:
    fail("Tamy default-position anchor not found; stop instead of guessing")
tamy = tamy.replace(old_default, new_default, 1)

old_state = '  const [position, setPosition] = useState<Point>(() => readPosition());'
new_state = '  const [position, setPosition] = useState<Point>(() => readPosition(lang));'
if old_state not in tamy:
    fail("Tamy position-state anchor not found")
tamy = tamy.replace(old_state, new_state, 1)

resize_anchor = """  useEffect(() => {
    const onResize = () => {
      setPosition((current) => {
        const next = clampPoint(current);
        window.localStorage.setItem(POSITION_KEY, JSON.stringify(next));
        return next;
      });
    };
    window.addEventListener("resize", onResize);
    return () => window.removeEventListener("resize", onResize);
  }, []);
"""

lang_effect = """  useEffect(() => {
    const onResize = () => {
      setPosition((current) => {
        const next = clampPoint(current);
        window.localStorage.setItem(POSITION_KEY, JSON.stringify(next));
        return next;
      });
    };
    window.addEventListener("resize", onResize);
    return () => window.removeEventListener("resize", onResize);
  }, []);

  useEffect(() => {
    if (!window.localStorage.getItem(POSITION_KEY)) {
      setPosition(defaultPoint(lang));
    }
  }, [lang]);
"""
if resize_anchor not in tamy:
    fail("Tamy resize-effect anchor not found")
tamy = tamy.replace(resize_anchor, lang_effect, 1)

CSS = '/* TCRMHC UX/UI Phase 2.1 — Tamy polish */\n\n/* Keep Tamy\'s conversation surface aligned with the semantic theme. */\n.tamy-panel .ai-chat-log {\n  border: 1px solid var(--ui-border);\n  border-radius: 14px;\n  background: color-mix(in srgb, var(--ui-bg-subtle) 74%, var(--ui-surface));\n  color: var(--ui-text);\n  box-shadow: inset 0 1px 0 color-mix(in srgb, white 4%, transparent);\n}\n\n.tamy-panel .ai-chat-log .empty-state {\n  color: var(--ui-text-secondary);\n}\n\n.tamy-panel .ai-message {\n  color: var(--ui-text);\n  border: 1px solid var(--ui-border);\n  background: var(--ui-surface-solid);\n}\n\n.tamy-panel .ai-message p,\n.tamy-panel .ai-message strong {\n  color: inherit;\n}\n\n.tamy-panel .ai-citations {\n  border-color: var(--ui-border);\n  color: var(--ui-text-secondary);\n}\n\n.tamy-panel .ai-citations a {\n  color: var(--ui-accent-text);\n}\n\n.tamy-panel .ai-chat-form textarea {\n  color: var(--ui-text);\n  border-color: var(--ui-border-strong);\n  background: var(--ui-input);\n}\n\n.tamy-panel .ai-chat-form textarea::placeholder {\n  color: var(--ui-text-tertiary);\n  opacity: 1;\n}\n\nhtml[data-theme="light"] .tamy-panel .ai-chat-log {\n  background: #f4f7fb;\n}\n\nhtml[data-theme="light"] .tamy-panel .ai-chat-log .empty-state {\n  color: #5f6c7f;\n}\n\nhtml[data-theme="light"] .tamy-panel .ai-message {\n  color: #152033;\n  background: #ffffff;\n  border-color: rgba(24, 40, 64, 0.12);\n}\n\nhtml[data-theme="light"] .tamy-panel .ai-chat-form textarea {\n  color: #152033;\n  background: #ffffff;\n  border-color: rgba(24, 40, 64, 0.20);\n}\n\nhtml[data-theme="light"] .tamy-panel .ai-chat-form textarea::placeholder {\n  color: #667085;\n}\n'

stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
backup_root = ROOT / ".patch-backups" / f"uxui-phase2.1-{stamp}"
for path in (TAMY, STYLES):
    target = backup_root / path.relative_to(ROOT)
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, target)

TAMY.write_text(tamy, encoding="utf-8")
STYLES.write_text(styles.rstrip() + "\n\n" + CSS.strip() + "\n", encoding="utf-8")

print("Applied TCRMHC UX/UI Phase 2.1 — Tamy polish.")
print(f"Backup: {backup_root}")
print("Changed:")
print("- apps/web/src/features/TamyFloatingAgent.tsx")
print("- apps/web/src/styles.css")
