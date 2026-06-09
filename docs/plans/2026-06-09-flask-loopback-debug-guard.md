---
title: Flask Loopback Debug Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

`FLASK_DEBUG` was already opt-in, but startup still allowed a developer to pair
that flag with an explicit public host binding such as `0.0.0.0`. That could
expose the Werkzeug debugger outside the local loopback interface during sample
experimentation.

## Goals

- Keep `FLASK_DEBUG` opt-in for local development.
- Enable debug mode only when the resolved bind host is loopback.
- Preserve existing host and port validation behavior.
- Add unit and static baseline coverage for the debug/host boundary.

## Implementation

- Added `debug_allowed_for_host()` to combine the debug flag with loopback host
  validation.
- Set imported app debug state and `app.run(..., debug=...)` through the new
  helper.
- Added unit coverage for IPv4, IPv6, localhost, public wildcard, and hostname
  cases.
- Updated README, SECURITY, VISION, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `sh -n scripts/check-baseline.sh`
- `python3 -m unittest discover -s tests -p "test*.py"`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
