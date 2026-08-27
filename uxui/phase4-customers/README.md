# TCRMHC UX/UI Phase 4 — Customers / Tenants

Target: `mohamedamouseo-a11y/TCRMHC` / `main`  
Prepared against current remote HEAD: `5ceb57cd3e02a65a993559dd199174625a503017`

## Baseline reviewed

The current Customers screen is intentionally basic: a page header, toggleable inline create form, unfiltered 25-row table and pagination. The Customer Detail screen exposes status/membership count and positions, but has no edit experience. The existing API already supports:

- customer pagination
- server-side `search`
- server-side `status` filtering
- create customer
- read customer detail
- update customer name / slug / code / status

Phase 4 uses only those existing capabilities. No new backend data or fake analytics are introduced.

## Phase 4 output

- Premium Customers hero and current result count.
- Search and status filters backed by the existing API.
- Responsive desktop table.
- Professional mobile customer cards using the same semantic table data.
- Accessible create-customer modal.
- Customer detail redesign with identity, memberships and positions.
- Edit customer workflow using the existing `updateTenant` endpoint.
- Full Light/Dark and Arabic RTL/English LTR parity.
- Tamy and Phase 2/3 shell remain untouched.

## Intended application files

Modified only:

- `apps/web/src/features/admin/TenantsPage.tsx`
- `apps/web/src/features/admin/TenantDetailPage.tsx`
- `apps/web/src/styles.css`

## Validation

At minimum:

```bash
pnpm --filter @tcrmhc/web typecheck
pnpm --filter @tcrmhc/web build
```

Live QA must include list/search/filter, create modal without committing fake data, one real existing customer detail, edit UX validation without changing production data unless an authorized harmless reversible test is available, Light/Dark, RTL/LTR and mobile.

## Rebased baseline note

Phase 4 was originally prepared against `6f1ad3d83ee42220e7a2016166e01570dd00a973`. TCRMHC subsequently advanced by one commit to `5ceb57cd3e02a65a993559dd199174625a503017`, which adds only `apps/api/src/db/migrations/0011_kb_phase1_getting_started.sql`. The Phase 4 target files were not changed by that intervening commit, so this patch has been safely rebased by updating the baseline gate only.
