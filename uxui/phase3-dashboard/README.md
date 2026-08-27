# TCRMHC UX/UI Phase 3 — Professional Dashboard

Target: `mohamedamouseo-a11y/TCRMHC` / `main`  
Prepared against current remote HEAD: `c16898fcd4317076fbb943ae038db4a7c32bc564`

## Current dashboard baseline

The current Dashboard is functionally minimal: one page header, six plain stat cards and a compact recent-security-event list. It already receives exactly these values from the existing `Overview` API:

- total customers
- active customers
- total users
- active users
- active sessions
- security events in the last 24 hours
- recent security events

Phase 3 redesigns the UX/UI **without inventing additional backend metrics**.

## Phase 3 output

- Premium operational hero.
- Activity snapshot using real current counts.
- Six professional KPI cards.
- Active-customer and active-user percentages computed strictly from existing counts.
- Recent Security Events panel with timestamps/outcome badges.
- Quick-access panel to existing admin sections.
- Responsive layout for desktop/tablet/mobile.
- Full semantic Light/Dark support.
- Arabic RTL and English LTR.
- No charts based on fake historical/trend data.

## Intended application files

Modified only:

- `apps/web/src/features/admin/DashboardPage.tsx`
- `apps/web/src/styles.css`

## Validation

At minimum:

```bash
pnpm --filter @tcrmhc/web typecheck
pnpm --filter @tcrmhc/web build
```

Then live visual QA in Arabic/English, Light/Dark, desktop/mobile and verify all Dashboard links/data.
