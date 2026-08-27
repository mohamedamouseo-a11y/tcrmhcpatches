# TCRMHC UX/UI Phase 2 — Application Shell + Tamy

Target: `mohamedamouseo-a11y/TCRMHC` / `main`  
Prepared against current remote HEAD: `1910167e64182cfd0df7f2fcb2afe725cc4134ac`

## What this phase does

Phase 2 upgrades the shared application shell rather than redesigning individual content pages.

It adds:

- A professional responsive shell for desktop/tablet/mobile.
- A true mobile navigation drawer with scrim and close control, replacing the current mobile behavior where the full sidebar consumes the top of the page.
- A polished sticky topbar with page context, theme, language, and logout controls.
- Light/Dark semantic shell styling based on the Phase 1 design system.
- **Tamy**, a global floating AI launcher available throughout the authenticated system.
- Tamy can be dragged smoothly inside the browser viewport and its last position is saved.
- Tamy opens the existing private AI support agent in a dedicated panel.
- The Tamy panel can dock on the left or right and remembers that side.
- Mobile Tamy becomes a near-full-screen contained assistant panel.
- Escape-to-close, ARIA labels, keyboard activation, focus styling, and reduced-motion compatibility.

## Intended application files

New:
- `apps/web/src/features/TamyFloatingAgent.tsx`

Modified:
- `apps/web/src/features/admin/AdminLayout.tsx`
- `apps/web/src/styles.css`

## Important scope boundary

This is **shell + Tamy foundation** only. Dashboard, tables, users, Developer Hub internals, Knowledge Base internals, etc. will be redesigned screen-by-screen in later phases.

Tamy currently uses the already-existing `AiSupportAgent` and its private KB AI backend. AI Staff switching/routing is a later Tamy phase.

## Validation

At minimum:

```bash
pnpm --filter @tcrmhc/web typecheck
pnpm --filter @tcrmhc/web build
```

Then live QA in Arabic/English, Light/Dark, desktop/mobile, plus Tamy drag, persistence, left/right docking, chat, and refresh behavior.
