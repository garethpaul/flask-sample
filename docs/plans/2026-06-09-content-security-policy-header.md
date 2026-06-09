---
title: Content Security Policy Header
date: 2026-06-09
status: completed
execution: code
---

## Context

The Flask sample already sets basic response security headers for sniffing,
referrer policy, and frame embedding. The rendered template is static and does
not require external assets, so a minimal CSP can document and enforce that
boundary.

## Goals

- Add a deterministic Content-Security-Policy response header.
- Keep same-origin assets allowed for the sample template.
- Keep frame embedding disabled through CSP as well as `X-Frame-Options`.
- Add unit and static baseline coverage.
- Expose `make lint`, `make test`, and `make build` gates.

## Implementation

- Added `Content-Security-Policy: default-src 'self'; frame-ancestors 'none'`.
- Added a root-route unit test for the CSP header.
- Extended the static baseline, README, VISION, SECURITY, and CHANGES.
- Added Makefile aliases for lint and build gates.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
