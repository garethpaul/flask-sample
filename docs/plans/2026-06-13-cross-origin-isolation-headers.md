---
title: Cross-Origin Isolation Headers
type: security
status: completed
date: 2026-06-13
---

# Cross-Origin Isolation Headers

## Summary

Keep the minimal Flask document and its error responses in a same-origin
browser context by adding opener and resource policy headers to the shared
response boundary.

## Priority

1. Add deterministic same-origin opener and resource policies.
2. Prove the complete security-header map applies to successful and error
   responses.
3. Preserve the current CSP, trusted-host, GET-only, and local-debug behavior.

## Requirements

- R1. Every Flask response must include
  `Cross-Origin-Opener-Policy: same-origin`.
- R2. Every Flask response must include
  `Cross-Origin-Resource-Policy: same-origin`.
- R3. The root response test must assert both exact values.
- R4. Tests must assert the complete `BASIC_SECURITY_HEADERS` map on trusted
  404 and 405 responses and an untrusted-host 400 response.
- R5. Static contracts must reject missing headers, weakened values, missing
  error-path coverage, or direct route-only header assignment.
- R6. README, SECURITY, VISION, and CHANGES must describe the same-origin
  browser boundary and its error-response coverage.

## Non-Goals

- Adding cross-origin assets, popups, OAuth, APIs, CORS, or browser capabilities.
- Replacing the existing CSP, frame, referrer, permissions, or MIME policies.
- Changing route methods, trusted hosts, debug settings, dependencies, or CI.
- Claiming browser compatibility beyond deterministic response-header tests.

## Implementation Units

### 1. Shared Response Policies

Files: `app.py`

- Add exact COOP and CORP values to `BASIC_SECURITY_HEADERS` so the existing
  `after_request` boundary covers all responses.

### 2. Route and Error Coverage

Files: `tests/test_app.py`

- Extend root response assertions.
- Verify the full header map on 400, 404, and 405 responses.

### 3. Static Contracts and Guidance

Files: `scripts/check-baseline.sh`, `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`

- Require the exact shared-map entries and error-response test matrix.
- Record completed local, mutation, review, and hosted-check evidence.

## Verification Plan

- Run focused unit tests and `make check`, `make lint`, `make test`, and
  `make build` in the constrained virtual environment.
- Remove one header, weaken one value, and remove one error status from the
  matrix; the static or unit gates must reject each mutation.
- Run Python compilation, shell syntax, `git diff --check`, and intended-file
  secret scans.
- Take one bounded exact-head pull-request and CodeQL snapshot after push; do
  not poll.

## Work Completed

- Added exact same-origin opener and resource policies to the shared
  `BASIC_SECURITY_HEADERS` map.
- Extended the successful root-response assertions for both headers.
- Added full-map regression coverage for untrusted-host 400, missing-route 404,
  and unsupported-method 405 responses.
- Extended the static baseline and repository guidance with the shared-map,
  error-matrix, and completed-plan contracts.

## Verification Completed

- Focused Flask 3.1.3 tests passed in a clean constrained virtual environment.
- `make check`, `make lint`, `make test`, and `make build` passed with the clean
  constrained Flask 3.1.3 virtual environment; all 15 tests passed.
- `pip check`, Python compilation, `sh -n scripts/check-baseline.sh`,
  `git diff --check`, and the intended-file secret scan passed.
- The missing header mutation failed the 15-test unit suite.
- The weakened value mutation failed the 15-test unit suite.
- The error matrix mutation failed with `Route tests must preserve full
  security-header coverage for 400, 404, and 405 responses.`
- The hosted pull-request check is not available before push; one bounded
  exact-head snapshot will be recorded in the engineering tracker without
  polling.
