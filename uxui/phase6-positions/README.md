# TCRMHC UX/UI Phase 6 — Positions Management

Target: `mohamedamouseo-a11y/TCRMHC` / `main`  
Prepared against current remote HEAD: `b2239e3e829526d37e02aa523bd038bee45a2a49`

## Baseline reviewed

The current Positions screen is a minimal inline create form plus a basic four-column table.

Existing APIs already support:
- paginated positions;
- server-side search;
- status filtering;
- customer filtering;
- position creation;
- editing bilingual names, code, description, status and sort order;
- global Help Audience listing;
- position-to-Help-Audience mapping.

The Help Center access model already derives effective audiences through active user memberships -> active positions -> `kb_position_audiences`. Phase 6 exposes that existing mapping professionally; it does not invent a new authorization model.

## Phase 6 output

- Premium Positions hero.
- Search + customer + status filters.
- Professional responsive table/mobile cards.
- Create Position modal.
- Manage Position panel with safe editing.
- Help Audience mapping panel.
- Inactive positions clearly show that mappings are not effective and mapping updates are disabled until active.
- Full Light/Dark and RTL/LTR coverage.
- No backend/database changes.

## Intended application files

Modified only:
- `apps/web/src/features/admin/PositionsPage.tsx`
- `apps/web/src/styles.css`

## Production QA safety

Do not create fake positions, rename production positions, deactivate real positions, or change real Help Audience mappings only for screenshots. Visual/wiring validation is sufficient unless a legitimate authorized production change exists.
