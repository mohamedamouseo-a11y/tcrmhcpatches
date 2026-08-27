# TCRMHC UX/UI Phase 2.1 — Tamy Polish

Target: `mohamedamouseo-a11y/TCRMHC` / `main`  
Prepared against current Phase 2 commit: `aa8b9770898d38dd54152eae9cb25392aed17ed5`

## Why this follow-up exists

Visual review of the Phase 2 screenshots found two real UX issues:

1. In **Light Mode**, Tamy's conversation area rendered as a large gray block with very low-contrast empty-state/chat text.
2. In **Arabic RTL**, Tamy's unsaved default launcher position was calculated from the right edge, putting it over the right-side navigation.

## Scope

Modified only:

- `apps/web/src/features/TamyFloatingAgent.tsx`
- `apps/web/src/styles.css`

No backend, database, AI provider, auth, Developer Hub logic, or individual page redesign.

## Expected behavior

- Light Tamy chat area becomes a clean readable light surface.
- Dark Tamy remains regression-safe.
- Arabic RTL with no saved Tamy position defaults to the left side.
- English LTR with no saved Tamy position defaults to the right side.
- An already saved `tcrmhc.tamy.position` remains respected.
- Dragging and persistence continue to work.
- Dock left/right remains unchanged.

## QA screenshots

Capture at least:

- `01-phase2.1-tamy-ar-default-no-overlap.webp`
- `02-phase2.1-tamy-light-readable.webp`
- `03-phase2.1-tamy-dark-regression.webp`
- `04-phase2.1-tamy-moved.webp`
- `05-phase2.1-tamy-position-after-refresh.webp`
- `06-phase2.1-tamy-chat-response.webp`
- `07-phase2.1-developer-hub-review.webp`
- `08-phase2.1-developer-hub-final-synced.webp`

The chat-response screenshot must contain a real harmless Help Center question and a real answer from the existing TCRMHC private AI support backend.
