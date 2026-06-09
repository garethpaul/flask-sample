---
title: Permissions Policy Header
date: 2026-06-09
status: completed
execution: code
---

## Context

The sample app renders a static template and does not use camera, microphone,
or geolocation browser capabilities. Existing response headers already cover
sniffing, referrer behavior, frame embedding, and a minimal CSP.

## Goals

- Add a deterministic Permissions-Policy response header.
- Disable unused camera, microphone, and geolocation capabilities.
- Cover the header with the existing Flask route tests.
- Extend static verification and docs so the browser capability boundary stays
  visible.

## Implementation

- Added `Permissions-Policy: geolocation=(), microphone=(), camera=()` to the
  shared response header map.
- Extended the root-route security header test.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
