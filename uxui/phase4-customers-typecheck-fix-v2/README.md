# TCRMHC Phase 4 — Typecheck Fix V2

This supersedes the previous Phase 4 typecheck hotfix.

The first hotfix diagnosed the TypeScript issue correctly, but its safeguard parsed `git status --porcelain` after applying `.strip()`. A valid porcelain line can begin with a space (` M path`), so stripping the whole output corrupts the first record before fixed-column slicing.

V2 uses `git status --porcelain=v1 -z` as raw bytes and never strips porcelain output.

The source fix keeps `adminApi.tenants()` unchanged and builds the request object incrementally, adding `search` and `status` only when they contain real values. This is compatible with `exactOptionalPropertyTypes`.

Expected HEAD:
`5ceb57cd3e02a65a993559dd199174625a503017`

Expected dirty files exactly:
- `apps/web/src/features/admin/TenantsPage.tsx`
- `apps/web/src/features/admin/TenantDetailPage.tsx`
- `apps/web/src/styles.css`
