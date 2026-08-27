# TCRMHC UX/UI Phase 5 — Users Management

Target application: `mohamedamouseo-a11y/TCRMHC` / `main`  
Original prepared baseline: `3174572106238da0ef356087132bec364b67c943`  
Approved continuation baseline: `39195817b8e45850568401d77065d4b7132c0902`

## Approved baseline continuation

Production advanced by exactly one commit after the original Phase 5 baseline. GitHub compare confirms the only intervening application change is:

`apps/api/src/db/migrations/0012_kb_phase2_sales_leads.sql`

That commit does **not** modify any Phase 5 target file:

- `apps/web/src/features/admin/UsersPage.tsx`
- `apps/web/src/features/admin/UserDetailPage.tsx`
- `apps/web/src/styles.css`

Therefore the Phase 5 UI payload remains valid on the newer production HEAD. Do not roll production back.

## Canonical patch payload

The ZIP is stored as five Base64 parts. Run inside this patch directory:

```bash
bash RECONSTRUCT.sh
```

Expected reconstructed archive:

`TCRMHC-UXUI-PHASE5-USERS.zip`

Expected original archive SHA-256:

`af9260e31201680080afee3d5ed8a94575171dbee8455a2a59e80f5fc86b246a`

After checksum verification, extract the archive outside `/var/www/TCRMHC`.

### Mandatory continuation adjustment

Because the canonical archive was built before the Sales & Leads content commit, edit **only the temporary extracted installer copy** before running it:

`TCRMHC-UXUI-PHASE5-USERS/APPLY-TCRMHC-UXUI-PHASE5.py`

Change exactly:

`BASE_COMMIT = "3174572106238da0ef356087132bec364b67c943"`

to:

`BASE_COMMIT = "39195817b8e45850568401d77065d4b7132c0902"`

Do not alter the embedded Users UI payload or any other installer logic.

Then run the adjusted installer from the TCRMHC repository root.

## Expected application changes

Only:

- `apps/web/src/features/admin/UsersPage.tsx`
- `apps/web/src/features/admin/UserDetailPage.tsx`
- `apps/web/src/styles.css`

## Scope

Phase 5 redesigns Users Management using existing TCRMHC capabilities: server-backed username/email search; status filtering; customer membership filtering; create-user UX; global roles; account status management; password reset UX; customer memberships; derived Help Audiences; Light/Dark; RTL/LTR; responsive mobile.

No backend/database change is introduced by Phase 5. The existing `0012_kb_phase2_sales_leads.sql` migration must remain untouched.

Production QA must not create fake users, reset real passwords, disable/lock real users, alter real roles, or add fake memberships only to obtain screenshots.
