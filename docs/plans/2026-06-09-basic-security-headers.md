# Basic Security Headers

date: 2026-06-09
status: completed

## Context

The sample app only serves a simple route, but every response should still keep
basic browser-facing headers that reduce content-sniffing ambiguity and avoid
leaking referrer details. The baseline already covers local debug, host, port,
and route method behavior, so response headers should be guarded alongside
those Flask defaults.

## Completed Scope

- Added an `after_request` hook that sets `X-Content-Type-Options: nosniff`.
- Added `Referrer-Policy: no-referrer` for route responses.
- Added route coverage for the root response headers.
- Extended `scripts/check-baseline.sh` so the hook, header names, test, and
  completed plan remain present.
- Updated README, VISION, and CHANGES with the response header guardrail.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
