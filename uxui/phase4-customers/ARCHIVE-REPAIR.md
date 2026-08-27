# Phase 4 archive repair

The previous Phase 4 archive on `main` was incomplete even though the manifest and README were rebased correctly.

The canonical archive has now been replaced with a complete archive prepared against:

`5ceb57cd3e02a65a993559dd199174625a503017`

The complete ZIP contains an installer with the embedded UI payload for:

- `apps/web/src/features/admin/TenantsPage.tsx`
- `apps/web/src/features/admin/TenantDetailPage.tsx`
- `apps/web/src/styles.css`

Expected complete archive SHA-256:

`0eb0956569a67b6290dc5b8cf5d1ad8140b22da3895c65c30adb3f45a297023b`

Expected installer size inside ZIP: approximately 44 KB, not the previous baseline-only helper.
