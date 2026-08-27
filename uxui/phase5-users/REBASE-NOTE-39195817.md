# Phase 5 Users — Approved rebase note

Approved TCRMHC continuation HEAD:

`39195817b8e45850568401d77065d4b7132c0902`

Original Phase 5 baseline:

`3174572106238da0ef356087132bec364b67c943`

GitHub comparison shows exactly one intervening commit, and it adds only:

`apps/api/src/db/migrations/0012_kb_phase2_sales_leads.sql`

It does not modify:

- `apps/web/src/features/admin/UsersPage.tsx`
- `apps/web/src/features/admin/UserDetailPage.tsx`
- `apps/web/src/styles.css`

Phase 5 may therefore continue on the newer HEAD without resetting or rolling back production. After reconstructing and checksum-verifying the canonical ZIP, change only the temporary extracted installer's `BASE_COMMIT` constant from the old SHA to the approved continuation SHA. Do not alter the embedded UI payload.
