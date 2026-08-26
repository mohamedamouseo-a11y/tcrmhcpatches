# TCRMHC UX/UI Phase 1 — Design System + Light/Dark Theme

Base target: `mohamedamouseo-a11y/TCRMHC` / `main` (prepared against the current GitHub main containing commit `74cb8e5e07314d52450a115c0949ff1d6cf480b2`).

## Scope

This patch establishes the UX/UI foundation only. It does not redesign individual screens yet.

It adds:

- Persistent Light/Dark theme engine (`tcrmhc.theme`).
- Theme initialization before React render to reduce theme flash.
- Theme toggle on both Login and authenticated Admin shell.
- Semantic design tokens for surfaces, typography colors, borders, shadows, accent, radius and motion.
- A compatibility layer that maps existing legacy variables to semantic tokens so existing screens can be migrated safely one-by-one.
- Foundation light-theme overrides for the application shell, cards, forms, tables, Help Center primitives and Developer Hub primitives.
- Improved focus-visible accessibility and reduced-motion handling.

## Files

New:
- `apps/web/src/lib/theme.ts`
- `apps/web/src/features/ThemeToggle.tsx`

Modified:
- `apps/web/src/main.tsx`
- `apps/web/src/features/admin/AdminLayout.tsx`
- `apps/web/src/features/auth/LoginPage.tsx`
- `apps/web/src/styles.css`

## Apply

From `/var/www/TCRMHC`:

```bash
python3 /path/to/APPLY-TCRMHC-UXUI-PHASE1.py
pnpm --filter @tcrmhc/web typecheck
pnpm --filter @tcrmhc/web build
```

Then verify Login + authenticated shell in Arabic/English, Light/Dark, desktop/mobile.

Do not touch TCRM Main or any other repository.
