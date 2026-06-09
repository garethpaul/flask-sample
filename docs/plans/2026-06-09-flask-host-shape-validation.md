---
title: Flask Host Shape Validation
date: 2026-06-09
status: completed
execution: code
---

## Context

`FLASK_RUN_HOST` already trimmed blank values and fell back to `127.0.0.1`, but
any non-empty value was accepted. URL-shaped values, path-like values, or
host-plus-port strings could then reach Flask's host binding even though `PORT`
is parsed separately.

## Goals

- Accept IP literals and simple DNS-style hostnames.
- Reject URL-shaped, path-like, trailing-dot, oversized, and host-plus-port
  values by falling back to localhost.
- Keep `PORT` as the only local port configuration path.
- Add unit and static baseline coverage.

## Implementation

- Added standard-library `ipaddress` and DNS-label validation to `host_name`.
- Added tests for URL-shaped, host-plus-port, path-like, localhost, and IPv6
  loopback host values.
- Updated README, VISION, SECURITY, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
