---
title: Flask Debug Value Normalization
date: 2026-06-09
status: completed
execution: code
---

## Context

Debug mode is already opt-in and restricted to loopback hosts, but the flag
parser read raw values directly before calling `.lower()`. Local environment
values with extra whitespace or non-string test inputs should normalize before
the opt-in check so the allowlist remains predictable.

## Goals

- Preserve the existing opt-in debug allowlist: `1`, `true`, `yes`, and `on`.
- Trim whitespace and normalize case before checking the allowlist.
- Keep loopback-only debug gating unchanged.
- Add unit and static baseline coverage for normalization.

## Implementation

- Changed `debug_enabled` to use `str(raw_value).strip().lower()`.
- Added unit coverage for whitespace and uppercase debug flag values.
- Updated README, SECURITY, VISION, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
