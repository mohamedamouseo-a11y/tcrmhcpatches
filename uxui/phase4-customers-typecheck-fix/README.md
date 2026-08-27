# TCRMHC Phase 4 — Typecheck Fix

Official continuation patch for the already-applied, uncommitted Phase 4 UI.

The web typecheck failed because `exactOptionalPropertyTypes` rejects explicitly present optional `search` and `status` properties whose value is `undefined`.

This patch validates the approved HEAD and exact three dirty Phase 4 files, then changes only `TenantsPage.tsx` so optional query keys are omitted when blank.

After applying, rerun web typecheck/build and continue the original Phase 4 QA + Developer Hub Review/Execute flow.
