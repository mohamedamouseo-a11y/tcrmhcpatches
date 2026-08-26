#!/usr/bin/env python3
from __future__ import annotations

import shutil
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
MARKER = "/* TCRMHC UX/UI Phase 1 — Semantic Design System + Light/Dark Theme */"

TARGETS = {
    "main": ROOT / "apps/web/src/main.tsx",
    "admin_layout": ROOT / "apps/web/src/features/admin/AdminLayout.tsx",
    "login": ROOT / "apps/web/src/features/auth/LoginPage.tsx",
    "styles": ROOT / "apps/web/src/styles.css",
    "theme": ROOT / "apps/web/src/lib/theme.ts",
    "toggle": ROOT / "apps/web/src/features/ThemeToggle.tsx",
}

THEME_TS = r'''export type ThemeMode = "light" | "dark";

const THEME_STORAGE_KEY = "tcrmhc.theme";

function systemTheme(): ThemeMode {
  if (typeof window === "undefined" || typeof window.matchMedia !== "function") return "dark";
  return window.matchMedia("(prefers-color-scheme: light)").matches ? "light" : "dark";
}

export function readThemeMode(): ThemeMode {
  if (typeof window === "undefined") return "dark";
  const stored = window.localStorage.getItem(THEME_STORAGE_KEY);
  return stored === "light" || stored === "dark" ? stored : systemTheme();
}

export function applyTheme(mode: ThemeMode): void {
  if (typeof document === "undefined") return;
  document.documentElement.dataset.theme = mode;
  document.documentElement.style.colorScheme = mode;
}

export function setThemeMode(mode: ThemeMode): void {
  if (typeof window !== "undefined") window.localStorage.setItem(THEME_STORAGE_KEY, mode);
  applyTheme(mode);
  if (typeof window !== "undefined") {
    window.dispatchEvent(new CustomEvent("tcrmhc:theme-change", { detail: { mode } }));
  }
}

export function initializeTheme(): ThemeMode {
  const mode = readThemeMode();
  applyTheme(mode);
  return mode;
}
'''

TOGGLE_TSX = r'''import { useEffect, useState } from "react";
import type { Language } from "../i18n/translations";
import { readThemeMode, setThemeMode, type ThemeMode } from "../lib/theme";

function SunIcon() {
  return <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" aria-hidden="true"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/></svg>;
}

function MoonIcon() {
  return <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" aria-hidden="true"><path d="M20.5 14.5A8.5 8.5 0 0 1 9.5 3.5 8.7 8.7 0 1 0 20.5 14.5z"/></svg>;
}

export function ThemeToggle({ lang, compact = false }: { lang: Language; compact?: boolean }) {
  const [theme, setTheme] = useState<ThemeMode>(() => readThemeMode());

  useEffect(() => {
    const sync = (event: Event) => {
      const next = (event as CustomEvent<{ mode?: ThemeMode }>).detail?.mode;
      setTheme(next === "light" || next === "dark" ? next : readThemeMode());
    };
    window.addEventListener("tcrmhc:theme-change", sync);
    return () => window.removeEventListener("tcrmhc:theme-change", sync);
  }, []);

  const target: ThemeMode = theme === "dark" ? "light" : "dark";
  const label = target === "light"
    ? (lang === "ar" ? "الوضع الفاتح" : "Light mode")
    : (lang === "ar" ? "الوضع الداكن" : "Dark mode");

  return <button
    className={`toolbar-btn theme-toggle${compact ? " square" : ""}`}
    type="button"
    onClick={() => { setThemeMode(target); setTheme(target); }}
    aria-label={label}
    title={label}
    data-theme-target={target}
  >
    {target === "light" ? <SunIcon /> : <MoonIcon />}
    {!compact && <span>{label}</span>}
  </button>;
}
'''

CSS = r'''
/* TCRMHC UX/UI Phase 1 — Semantic Design System + Light/Dark Theme */
:root,
html[data-theme="dark"] {
  --ui-bg: #07111f;
  --ui-bg-subtle: #0a1728;
  --ui-surface: rgba(10, 27, 49, 0.88);
  --ui-surface-solid: #0c1b30;
  --ui-surface-raised: rgba(15, 35, 60, 0.96);
  --ui-sidebar: rgba(5, 17, 34, 0.985);
  --ui-topbar: rgba(7, 18, 33, 0.86);
  --ui-input: #0a1b31;
  --ui-text: #f5f7fb;
  --ui-text-secondary: #b6c0cf;
  --ui-text-tertiary: #8d99ab;
  --ui-border: rgba(255, 255, 255, 0.11);
  --ui-border-strong: rgba(255, 255, 255, 0.18);
  --ui-accent: #d6a122;
  --ui-accent-hover: #e8b83e;
  --ui-accent-soft: rgba(214, 161, 34, 0.11);
  --ui-accent-border: rgba(214, 161, 34, 0.42);
  --ui-accent-text: #ffe39a;
  --ui-success: #80d8a4;
  --ui-danger: #ffaaaa;
  --ui-shadow-sm: 0 8px 24px rgba(0, 0, 0, 0.18);
  --ui-shadow-md: 0 20px 54px rgba(0, 0, 0, 0.24);
  --ui-radius-sm: 10px;
  --ui-radius-md: 14px;
  --ui-radius-lg: 18px;
  --ui-transition: 160ms cubic-bezier(.2,.8,.2,1);
  --ui-page-background:
    radial-gradient(circle at 10% 8%, rgba(26, 77, 132, 0.18), transparent 31%),
    radial-gradient(circle at 88% 14%, rgba(214, 161, 34, 0.07), transparent 28%),
    linear-gradient(145deg, #06101e 0%, #09182a 48%, #050d18 100%);

  --text: var(--ui-text);
  --muted: var(--ui-text-secondary);
  --line: var(--ui-border);
  --line-gold: var(--ui-accent-border);
  --card: var(--ui-surface);
  --shadow: var(--ui-shadow-md);
}

html[data-theme="light"] {
  --ui-bg: #f4f7fb;
  --ui-bg-subtle: #edf2f7;
  --ui-surface: rgba(255, 255, 255, 0.92);
  --ui-surface-solid: #ffffff;
  --ui-surface-raised: #ffffff;
  --ui-sidebar: rgba(255, 255, 255, 0.97);
  --ui-topbar: rgba(255, 255, 255, 0.86);
  --ui-input: #ffffff;
  --ui-text: #152033;
  --ui-text-secondary: #5f6c7f;
  --ui-text-tertiary: #7c8898;
  --ui-border: rgba(24, 40, 64, 0.12);
  --ui-border-strong: rgba(24, 40, 64, 0.2);
  --ui-accent: #b98208;
  --ui-accent-hover: #9f7004;
  --ui-accent-soft: rgba(185, 130, 8, 0.09);
  --ui-accent-border: rgba(185, 130, 8, 0.34);
  --ui-accent-text: #815900;
  --ui-success: #18794e;
  --ui-danger: #b42318;
  --ui-shadow-sm: 0 8px 24px rgba(31, 48, 73, 0.08);
  --ui-shadow-md: 0 22px 56px rgba(31, 48, 73, 0.11);
  --ui-page-background:
    radial-gradient(circle at 10% 8%, rgba(46, 99, 159, 0.07), transparent 32%),
    radial-gradient(circle at 88% 14%, rgba(214, 161, 34, 0.08), transparent 29%),
    linear-gradient(145deg, #f8fafc 0%, #f3f6fa 48%, #eef3f8 100%);

  --text: var(--ui-text);
  --muted: var(--ui-text-secondary);
  --line: var(--ui-border);
  --line-gold: var(--ui-accent-border);
  --card: var(--ui-surface);
  --shadow: var(--ui-shadow-md);
}

html { background: var(--ui-bg); }
body {
  color: var(--ui-text);
  background: var(--ui-page-background);
  transition: background-color var(--ui-transition), color var(--ui-transition);
}

::selection { background: var(--ui-accent); color: #071225; }

:where(button, a, input, select, textarea):focus-visible {
  outline: 3px solid color-mix(in srgb, var(--ui-accent) 42%, transparent);
  outline-offset: 2px;
}

button:disabled { cursor: not-allowed; }

.toolbar-btn {
  color: var(--ui-text);
  border-color: var(--ui-border);
  background: color-mix(in srgb, var(--ui-surface-solid) 78%, transparent);
  box-shadow: none;
  transition: border-color var(--ui-transition), background var(--ui-transition), transform var(--ui-transition), color var(--ui-transition);
}
.toolbar-btn:hover:not(:disabled) {
  border-color: var(--ui-accent-border);
  background: var(--ui-accent-soft);
}
.theme-toggle svg { width: 18px; height: 18px; flex: 0 0 auto; }

.admin-shell { background: color-mix(in srgb, var(--ui-bg) 82%, transparent); }
.admin-sidebar {
  border-color: var(--ui-border);
  background: var(--ui-sidebar);
  box-shadow: 10px 0 38px rgba(0,0,0,.04);
}
[dir="rtl"] .admin-sidebar { box-shadow: -10px 0 38px rgba(0,0,0,.04); }
.admin-sidebar nav a { color: var(--ui-text-secondary); }
.admin-sidebar nav a:hover,
.admin-sidebar nav a.active {
  color: var(--ui-text);
  border-color: var(--ui-accent-border);
  background: var(--ui-accent-soft);
}
.admin-sidebar-footer { border-color: var(--ui-border); }
.admin-sidebar-footer span { color: var(--ui-accent-text); }
.admin-topbar {
  border-color: var(--ui-border);
  background: var(--ui-topbar);
  box-shadow: 0 1px 0 var(--ui-border), 0 10px 30px rgba(0,0,0,.035);
}
.admin-content { color: var(--ui-text); }

.stat-card,
.admin-panel,
.admin-card,
.help-module,
.dev-github-module .admin-card,
.dev-hub-page .admin-card {
  color: var(--ui-text);
  border-color: var(--ui-border);
  background: var(--ui-surface);
  box-shadow: var(--ui-shadow-sm);
}
.stat-card strong,
.help-module h3,
.help-module h4 { color: var(--ui-accent-text); }

.admin-form input,
.admin-form select,
.kb-toolbar select,
.kb-field input,
.kb-field textarea,
.kb-field select,
.dev-user-toolbar input,
.dev-user-toolbar select,
.dev-github-field input,
.dev-github-field select,
.ai-chat-form textarea,
input,
select,
textarea {
  color: var(--ui-text);
  border-color: var(--ui-border);
  background: var(--ui-input);
}
input::placeholder,
textarea::placeholder { color: var(--ui-text-tertiary); }

.table-wrap th,
.table-wrap td,
.compact-list > div { border-color: var(--ui-border); }
.table-wrap th { color: var(--ui-accent-text); }
.table-link,
.footer a,
.article-breadcrumb { color: var(--ui-accent-text); }

.kb-subnav,
.help-subcategories span,
.article-meta span,
.tenant-pill {
  border-color: var(--ui-accent-border);
  background: var(--ui-accent-soft);
}
.kb-subnav a { color: var(--ui-text-secondary); }
.kb-subnav a:hover { color: var(--ui-accent-text); }

.auth-card,
.login-card {
  color: var(--ui-text);
  border-color: var(--ui-border);
  background: var(--ui-surface-raised);
  box-shadow: var(--ui-shadow-md);
}
.brand-panel {
  border-color: var(--ui-border);
  background:
    linear-gradient(150deg, color-mix(in srgb, var(--ui-accent) 6%, transparent), transparent),
    color-mix(in srgb, var(--ui-surface) 88%, transparent);
}
.login-panel {
  background: color-mix(in srgb, var(--ui-bg) 72%, transparent);
}
.welcome p,
.footer,
.feature span { color: var(--ui-text-secondary); }

html[data-theme="light"] body::before,
html[data-theme="light"] body::after { opacity: .24; }
html[data-theme="light"] .primary-btn,
html[data-theme="light"] .primary-small { color: #211704; }
html[data-theme="light"] .status-active,
html[data-theme="light"] .status-success { color: #0f6d43; }
html[data-theme="light"] .status-suspended,
html[data-theme="light"] .status-locked,
html[data-theme="light"] .status-failure,
html[data-theme="light"] .status-blocked { color: #a61b14; }

@media (prefers-reduced-motion: reduce) {
  body { transition: none; }
}
'''


def fail(message: str) -> None:
    raise SystemExit(f"ERROR: {message}")


def read(path: Path) -> str:
    if not path.exists():
        fail(f"missing required file: {path}")
    return path.read_text(encoding="utf-8")


def backup(paths: list[Path]) -> Path:
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    out = ROOT / ".patch-backups" / f"uxui-phase1-{stamp}"
    out.mkdir(parents=True, exist_ok=True)
    for path in paths:
        if path.exists():
            rel = path.relative_to(ROOT)
            dest = out / rel
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, dest)
    return out


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        fail(f"anchor for {label} expected once, found {count}")
    return text.replace(old, new, 1)


def main() -> None:
    if not (ROOT / "package.json").exists() or not (ROOT / "apps/web").exists():
        fail("run this script from the TCRMHC repository root")

    styles = read(TARGETS["styles"])
    if MARKER in styles:
        print("TCRMHC UX/UI Phase 1 already appears applied; no changes made.")
        return

    main_tsx = read(TARGETS["main"])
    admin = read(TARGETS["admin_layout"])
    login = read(TARGETS["login"])

    backup_dir = backup([TARGETS["main"], TARGETS["admin_layout"], TARGETS["login"], TARGETS["styles"], TARGETS["theme"], TARGETS["toggle"]])

    main_tsx = replace_once(
        main_tsx,
        'import { App } from "./App";\nimport "./styles.css";',
        'import { App } from "./App";\nimport { initializeTheme } from "./lib/theme";\nimport "./styles.css";\n\ninitializeTheme();',
        "main theme bootstrap",
    )

    admin = replace_once(
        admin,
        'import type { Language } from "../../i18n/translations";\n',
        'import type { Language } from "../../i18n/translations";\nimport { ThemeToggle } from "../ThemeToggle";\n',
        "AdminLayout ThemeToggle import",
    )
    admin = replace_once(
        admin,
        '<header className="admin-topbar"><button className="toolbar-btn"',
        '<header className="admin-topbar"><ThemeToggle lang={lang}/><button className="toolbar-btn"',
        "AdminLayout topbar ThemeToggle",
    )

    login = replace_once(
        login,
        'import { translations, type Language } from "../../i18n/translations";\n',
        'import { translations, type Language } from "../../i18n/translations";\nimport { ThemeToggle } from "../ThemeToggle";\n',
        "LoginPage ThemeToggle import",
    )
    login = replace_once(
        login,
        '        <div className="toolbar">\n          <button className="toolbar-btn"',
        '        <div className="toolbar">\n          <ThemeToggle lang={lang} compact />\n          <button className="toolbar-btn"',
        "LoginPage toolbar ThemeToggle",
    )

    TARGETS["theme"].parent.mkdir(parents=True, exist_ok=True)
    TARGETS["theme"].write_text(THEME_TS, encoding="utf-8")
    TARGETS["toggle"].write_text(TOGGLE_TSX, encoding="utf-8")
    TARGETS["main"].write_text(main_tsx, encoding="utf-8")
    TARGETS["admin_layout"].write_text(admin, encoding="utf-8")
    TARGETS["login"].write_text(login, encoding="utf-8")
    TARGETS["styles"].write_text(styles.rstrip() + "\n\n" + CSS.strip() + "\n", encoding="utf-8")

    print("Applied TCRMHC UX/UI Phase 1 successfully.")
    print(f"Backups: {backup_dir}")
    print("Changed:")
    for key in ("main", "admin_layout", "login", "styles", "theme", "toggle"):
        print(f"- {TARGETS[key].relative_to(ROOT)}")


if __name__ == "__main__":
    main()
