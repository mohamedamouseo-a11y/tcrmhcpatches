# TCRMHC UX/UI Phase 6.1 — Enterprise Positions Polish

Target: `mohamedamouseo-a11y/TCRMHC` / `main`  
Prepared against current remote Phase 6 HEAD: `e9e25c3379d48ff356ced9bf2e8e86045fc157d3`

## Why Phase 6.1 exists

Phase 6 is functionally successful, but the supplied production screenshots do not meet the new Enterprise Premium quality bar.

Observed directly from `TCRMHC-UXUI-PHASE6-SCREENSHOTS.zip`:

- The list screen is clean but still resembles a conventional admin panel.
- The data area occupies a small portion of a large empty canvas.
- Typography and table hierarchy are too light/small for an enterprise governance console.
- The Create Position modal is conventional rather than workflow-oriented.
- Manage Position is a generic centered modal rather than a dedicated governance workspace.
- Help Audience mapping needs stronger policy context.
- `02-phase6-positions-dark-en.webp` is visually Light Mode.
- `08-phase6-create-position-light.webp` and `09-phase6-create-position-dark.webp` are byte-identical.
- `10-phase6-manage-position-light.webp` and `12-phase6-help-audience-mapping.webp` are byte-identical.
- Required mobile Positions/Manage screenshots are absent from the uploaded archive.

Phase 6.1 is therefore a visual/interaction elevation, not a feature rewrite.

## Enterprise target

- Strong information architecture, not decorative card stacking.
- A command-header feel with real current-scope context.
- High-quality data-grid density and hierarchy.
- Structured creation flow with clear governance sections.
- Full-height Position Governance workspace instead of generic edit modal.
- Help Audience mapping presented explicitly as content-access policy.
- Distinct Light and Dark compositions.
- Native RTL/LTR and responsive behavior.
- No fake analytics and no new backend data.

## Files

Modified only:

- `apps/web/src/features/admin/PositionsPage.tsx`
- `apps/web/src/styles.css`

No backend, DB, API, auth or Help Audience logic changes.
