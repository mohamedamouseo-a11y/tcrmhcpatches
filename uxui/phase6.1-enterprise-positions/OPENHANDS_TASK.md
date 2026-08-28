# OpenHands Task — TCRMHC Phase 6.1

Target server path: `/var/www/TCRMHC`

Expected TCRMHC `main` HEAD before apply:
`e9e25c3379d48ff356ced9bf2e8e86045fc157d3`

Patch directory:
`uxui/phase6.1-enterprise-positions`

Expected reconstructed ZIP SHA-256:
`7b6ad0b5950d85b053108f573ca30e4aaa17736aec4370c73252973615c78850`

## Do only this

1. On the real server, verify `/var/www/TCRMHC` exists, branch is `main`, HEAD matches the SHA above, and worktree is clean.
2. Fresh-fetch `mohamedamouseo-a11y/tcrmhcpatches`, enter `uxui/phase6.1-enterprise-positions`, run `bash RECONSTRUCT.sh`, and verify the ZIP checksum.
3. Extract the ZIP outside `/var/www/TCRMHC`.
4. From `/var/www/TCRMHC`, run `APPLY-TCRMHC-UXUI-PHASE6.1.py`.
5. Run only `git status --short` after apply.
6. Do **not** run tests, builds, deploy, Developer Hub, or push TCRMHC.
7. Write a short report to `reports/phase6.1-enterprise-positions/OPENHANDS_REPORT.md` in the `tcrmhcpatches` repo and push only that report to `tcrmhcpatches/main` if repo authentication is already available.

## Expected changed application files

- `apps/web/src/features/admin/PositionsPage.tsx`
- `apps/web/src/styles.css`

If anything else changes, stop and report the blocker.

## Report fields

- Starting TCRMHC HEAD
- Patch repo HEAD used
- Reconstructed ZIP SHA-256
- Installer result
- Changed application files
- Final `git status --short`
- `READY_FOR_MANUAL_PUSH` or blocker reason

Never include credentials, tokens, cookies, passwords, or secrets.
