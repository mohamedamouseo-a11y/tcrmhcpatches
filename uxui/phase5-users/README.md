# TCRMHC UX/UI Phase 5 — Users Management

Target application: `mohamedamouseo-a11y/TCRMHC` / `main`  
Prepared against: `3174572106238da0ef356087132bec364b67c943`

## Canonical patch payload

The ZIP is stored as five Base64 parts because this patch repository is being written through a text-safe connector.

Run inside this patch directory:

```bash
bash RECONSTRUCT.sh
```

Expected reconstructed archive:

`TCRMHC-UXUI-PHASE5-USERS.zip`

Expected SHA-256:

`af9260e31201680080afee3d5ed8a94575171dbee8455a2a59e80f5fc86b246a`

After checksum verification, extract the archive outside `/var/www/TCRMHC`, then run its installer from the TCRMHC repository root:

`TCRMHC-UXUI-PHASE5-USERS/APPLY-TCRMHC-UXUI-PHASE5.py`

## Expected application changes

Only:

- `apps/web/src/features/admin/UsersPage.tsx`
- `apps/web/src/features/admin/UserDetailPage.tsx`
- `apps/web/src/styles.css`

## Scope

Phase 5 redesigns Users Management using capabilities already present in TCRMHC:

- server-backed username/email search;
- status filtering;
- customer membership filtering;
- create-user UX;
- global roles;
- account status management;
- password reset UX;
- customer memberships;
- derived Help Audiences;
- Light/Dark, RTL/LTR and responsive mobile behavior.

The current API does not support editing username/email, so Phase 5 does not invent that workflow. It also introduces no backend or database changes.

Production QA must not create fake users, reset real passwords, disable/lock real users, alter real roles, or add fake memberships only to obtain screenshots.
