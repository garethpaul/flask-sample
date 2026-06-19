---
title: Disable the unused Flask static route
type: security
date: 2026-06-16
status: completed
execution: code
---

# Disable the unused Flask static route

## Goal

Remove the unused default Flask static endpoint and the ineffective,
caller-directory-dependent `app.static_dir` assignment so the application
exposes only its intentional root route and framework error handling.

## Requirements

- Construct the Flask application with static serving disabled explicitly.
- Remove the non-Flask `static_dir` attribute and avoid deriving application
  paths from the caller's current working directory.
- Prove the URL map contains no `static` endpoint or `/static/<path>` rule.
- Prove `/static/...` returns `404` through both the Flask test client and a
  live HTTP server while retaining every authoritative security header.
- Preserve the root GET behavior, method restrictions, trusted-host boundary,
  debug controls, dependency lock, and existing security-header values.

## Scope Boundaries

- Do not add static assets or a replacement asset endpoint.
- Do not change CSP, cross-origin isolation, host validation, debug policy, or
  dependency versions.
- Do not claim reverse-proxy, TLS, browser, or production deployment coverage.

## Implementation Units

### U1: Disable default static serving

Files: `app.py`

Create the Flask app with `static_folder=None` and remove the ineffective
attribute assignment.

### U2: Add executable route-boundary coverage

Files: `tests/test_app.py`, `scripts/check-live-http-security.py`

Add route-map, test-client, and live-server regressions for the absent static
endpoint and its hardened `404` response.

### U3: Preserve the maintenance contract

Files: `scripts/check-baseline.sh`, `AGENTS.md`, `CHANGES.md`, `README.md`,
`SECURITY.md`, `VISION.md`

Add mutation-sensitive static contracts and document the intentionally reduced
HTTP surface and its verification boundary.

## Test Scenarios

- The URL map exposes `hello` but no `static` endpoint.
- A representative `/static/app.js` request returns `404` with the complete
  authoritative header map through the test client.
- The same request returns `404` with the same headers over a bound live HTTP
  server.
- Mutations that restore default static serving, reintroduce CWD-derived static
  state, remove either regression, or reopen plan evidence are rejected.

## Work Completed

- Constructed the Flask app with `static_folder=None` and removed the
  ineffective CWD-derived `static_dir` attribute.
- Added URL-map and test-client regressions for the disabled static endpoint.
- Added a controlled live HTTP static-path 404 regression with complete
  authoritative security-header assertions and bounded cleanup.
- Extended the baseline and live checker to preserve the implementation,
  regression coverage, documentation, and completed evidence.

## Verification Completed

- The focused static-route tests passed.
- The live HTTP static-route test passed with every managed security header.
- all four Make gates passed from the repository root.
- The absolute Makefile path passed from an external directory.
- six hostile mutations were rejected across static registration, CWD-derived
  state, route-map coverage, test-client coverage, live HTTP coverage, and plan
  completion evidence.
- Python and shell syntax, generated-artifact cleanup, executable modes,
  changed-line credential scans, and `git diff --check` passed.
- Push run `27646069938` and pull-request run `27646082902` passed at
  implementation commit `bb862303b6f519f59ee389d96596c216e228923b`.
- No reverse-proxy, TLS, browser, or production deployment result is claimed.
