# TCRMHC Phase 4 — Developer Hub Git Path Parser Fix

Target repository: `mohamedamouseo-a11y/TCRMHC`  
Branch: `main`  
Approved application HEAD before Phase 4 publication: `5ceb57cd3e02a65a993559dd199174625a503017`

## Root cause proven from current GitHub source

`developer-hub-github.service.ts` currently has a generic helper that returns:

`result.stdout.trim()`

The Review Push status path comes from:

`git status --porcelain=v1`

A valid modified-file line begins with a leading status space, for example:

` M apps/web/src/...`

Calling `.trim()` on the whole stdout removes that leading space before `parseStatus()` slices fixed columns. The first pathname therefore becomes:

`pps/web/src/...`

instead of:

`apps/web/src/...`

This is exactly the malformed third path seen in the live Phase 4 Review Push evidence.

## Fix

- Add `preserveOutput?: boolean` to `gitText`.
- Keep existing trimmed behavior for normal Git commands.
- Allow `gitTextOrNull` to forward options.
- Call `git status --porcelain=v1` with `preserveOutput: true`.
- Leave `parseStatus()` and all other Git behavior unchanged.

## Current server precondition

Phase 4 UI is already applied and uncommitted. Before this parser fix, the only dirty files must be:

- `apps/web/src/features/admin/TenantsPage.tsx`
- `apps/web/src/features/admin/TenantDetailPage.tsx`
- `apps/web/src/styles.css`

After applying this fix, exactly one additional file is expected:

- `apps/api/src/modules/admin/developer-hub-github.service.ts`

## Validation

Run API/web typechecks and builds, restart only the TCRMHC API as required, then run a fresh Developer Hub Review Push.

The Review must show correct `apps/...` paths for all files and must not show any `pps/...` path.

Then publish all four reviewed files through TCRMHC Developer Hub using a normal commit/push.
