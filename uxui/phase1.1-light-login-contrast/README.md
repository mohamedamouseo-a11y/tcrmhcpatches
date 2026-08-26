# TCRMHC UX/UI Phase 1.1 — Light Login Contrast Fix

Target repository: `mohamedamouseo-a11y/TCRMHC`  
Target branch: `main`  
Prepared against current GitHub HEAD: `669f967daf65783a09f4340ed93a0b2e9034e26e`

## Reason

Visual QA of Phase 1 found a light-mode login contrast blocker: legacy login selectors still used hard-coded dark-theme text colors. In Light Mode this left field labels, placeholder text, icons, password toggle, and "Remember me" with insufficient contrast.

The current code still contains legacy hard-coded login colors such as:

- `.field label { color: #f7f9fc; }`
- `.input-wrap input { color: #f7f9fc; ... }`
- `.input-wrap input::placeholder { color: #77869a; }`
- `.remember { color: #dfe5ee; }`

Phase 1.1 adds narrowly scoped `html[data-theme="light"] .login-card ...` overrides only.

## Scope

Modified only:

- `apps/web/src/styles.css`

No React logic, backend, database, auth behavior, routing, GitHub operations, or other screens are changed.

## Visual acceptance

Verify on live TCRMHC:

1. Login Arabic RTL — Light Mode.
2. Login English LTR — Light Mode.
3. Email/username and Password labels are clearly readable.
4. Placeholder text is clearly readable.
5. Input text, leading icons, password toggle and Remember me are readable.
6. Focus ring remains visible.
7. Dark Mode remains unchanged/regression-free.

Capture and attach actual screenshots to the same session.