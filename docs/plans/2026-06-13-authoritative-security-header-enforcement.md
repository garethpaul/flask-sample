---
title: Authoritative Security Header Enforcement
type: security
status: completed
date: 2026-06-13
---

# Authoritative Security Header Enforcement

## Summary

Make the shared Flask response hook authoritative so a route, error handler, or
extension cannot bypass the reviewed browser policy by pre-populating a weaker
value for one of the managed security headers.

## Priority

1. Enforce every reviewed header value at the final shared response boundary.
2. Prove deliberately weak preexisting values are replaced, not preserved.
3. Preserve the current route, error, trusted-host, startup, dependency, and
   browser-policy behavior.

## Requirements

- R1. The `after_request` hook must assign every `BASIC_SECURITY_HEADERS` value
  directly rather than using missing-only insertion.
- R2. A focused test must create a response with a weak value for every managed
  header and prove the hook replaces each value with the reviewed map.
- R3. Existing exact header assertions and 400, 404, and 405 coverage must
  remain unchanged.
- R4. The static gate must reject `setdefault`, missing direct assignment,
  missing weak-value setup, incomplete map iteration, or reduced assertions.
- R5. README, SECURITY, VISION, CHANGES, and AGENTS must describe the shared
  hook as authoritative for managed header names.
- R6. The completed plan must record actual focused, full-suite, mutation, and
  hosted verification evidence.

## Non-Goals

- Adding, removing, or changing the value of any security header.
- Changing route methods, templates, trusted hosts, debug settings, startup
  parsing, dependency constraints, or CI configuration.
- Preventing an upstream proxy from modifying headers after Flask returns the
  response.
- Claiming browser behavior beyond deterministic Flask response tests.

## Implementation Units

### 1. Authoritative Response Hook

Files: `app.py`

- Replace missing-only insertion with direct assignment for every managed
  header.

### 2. Policy Precedence Test

Files: `tests/test_app.py`

- Build a response with intentionally weak values for the complete managed map.
- Invoke the shared hook and assert every final value equals the reviewed map.

### 3. Static Contracts

Files: `scripts/check-baseline.sh`

- Require direct shared-map assignment and the complete override regression.
- Require completed mutation and hosted-verification evidence in this plan.

### 4. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record the authoritative managed-header boundary and its upstream-proxy
  limitation.

## Verification Plan

- Run the focused override test and `make check`, `make lint`, `make test`, and
  `make build` in the constrained environment.
- Restore `setdefault`, remove weak-value setup, remove map iteration, and
  reduce final assertions; the unit or static gates must reject each mutation.
- Run `pip check`, Python compilation, shell syntax, `git diff --check`, and
  intended-file secret scans.
- Take bounded exact-head pull-request, workflow, and code-scanning snapshots
  after push; do not start a watch loop.

## Work Completed

- Replaced missing-only security-header insertion with direct assignment from
  the complete reviewed map at the shared `after_request` boundary.
- Added a regression response containing an intentionally weak value for every
  managed header and asserted both response identity and every final value.
- Extended the static baseline to reject fallback insertion, incomplete weak
  setup, partial map iteration, reduced final assertions, documentation drift,
  and incomplete plan evidence.
- Updated contributor, security, maintenance, vision, and change guidance with
  the authoritative Flask boundary and upstream-proxy limitation.

## Verification Completed

- The focused authoritative-header regression passed in the constrained Flask
  3.1.3 environment.
- `make check`, `make lint`, `make test`, and `make build` passed with all 16
  tests in the constrained environment.
- `pip check` reported no broken requirements.
- The setdefault mutation failed the unit or static baseline.
- The weak-value setup mutation failed the static baseline.
- The map-iteration mutation failed the static baseline.
- The final-assertion mutation failed the unit or static baseline.
- Python compilation, shell syntax, `git diff --check`, and intended-file secret
  scans are included in final-tree verification.
- The hosted pull-request check is not available before the implementation
  push; bounded exact-head evidence will be recorded in the engineering tracker
  without a watch loop.
