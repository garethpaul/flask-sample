---
title: Flask Sample debug baseline
date: 2026-06-08
status: completed
execution: code
---

## Context

This repository is a tiny Flask sample that renders `templates/hello.html` at
the root route. The app previously hardcoded debug mode and bound to all
interfaces by default, while dependency and test commands were undocumented.

## Goals

- Keep the root route behavior minimal and explicit.
- Make debug mode opt-in through local environment configuration.
- Default local execution to localhost instead of public binding.
- Add a Flask dependency file and a small route test suite.
- Add a static verification command for future maintenance.

## Scope Boundaries

- Do not add production deployment scaffolding.
- Do not introduce a database, auth, or extra routes.
- Do not change the rendered template content beyond test coverage.

## Implementation

- Added `debug_enabled()` and `FLASK_DEBUG` handling.
- Changed the default host to `127.0.0.1` with optional `FLASK_RUN_HOST`.
- Added `requirements.txt`, `tests/test_app.py`, `scripts/check-baseline.sh`,
  `Makefile`, and docs updates.

## Verification

- `make check`
- `python3 -m unittest discover -s tests -p "test*.py"`
- `git diff --check`
