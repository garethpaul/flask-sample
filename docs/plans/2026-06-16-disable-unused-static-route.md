---
title: Disable the unused Flask static route
type: security
date: 2026-06-16
status: in_progress
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

## Verification

- Run focused unit and live HTTP tests.
- Run repository-root `make check`, `make lint`, `make test`, and `make build`.
- Run absolute-Makefile `make check` from an external directory.
- Audit Python/shell syntax, mutations, generated artifacts, changed-line
  credential patterns, executable modes, and `git diff --check`.

