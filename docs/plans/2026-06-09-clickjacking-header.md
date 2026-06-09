---
title: Clickjacking Header
date: 2026-06-09
status: completed
execution: code
---

## Context

The sample sets basic response headers for content sniffing and referrer policy.
If the app is exposed beyond localhost, the root page should also avoid being
embedded in another site without an explicit product reason.

## Goals

- Add a simple clickjacking protection header to every response.
- Cover the header with the existing Flask route tests.
- Extend the static baseline so response header regressions are caught.
- Keep the sample small and dependency-free.

## Implementation

- Added `X-Frame-Options: DENY` to `BASIC_SECURITY_HEADERS`.
- Extended `test_root_get_sets_basic_security_headers`.
- Updated README, VISION, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
