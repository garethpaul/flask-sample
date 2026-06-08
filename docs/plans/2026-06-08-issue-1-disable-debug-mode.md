---
title: Issue 1 Disable Debug Mode
type: fix
status: active
date: 2026-06-08
origin: https://github.com/garethpaul/flask-sample/issues/1
execution: code
---

# Issue 1 Disable Debug Mode

## Summary

Disable Flask debug mode by default and require an explicit local-development environment flag to enable it.

## Problem Frame

Issue #1 was filed from the public repository review because `app.py` sets `app.debug = True` during application startup. In deployed Flask apps, debug mode can expose stack traces, configuration details, and development-only behavior.

## Requirements

- R1. `app.py` must not set `app.debug = True` unconditionally.
- R2. Debug mode must default to false.
- R3. Debug mode may be enabled only by an explicit local-development environment variable.
- R4. The PR must reference `https://github.com/garethpaul/flask-sample/issues/1`.

## Implementation Unit

### U1. Environment-Gated Debug Mode

- **Goal:** Add a small `debug_enabled` helper, use it for `app.debug`, document the local development flag, and test default/explicit behavior with a fake Flask module.
- **Files:** `app.py`, `app_tests.py`, `README.md`
- **Test Scenarios:** Default debug false, truthy env enables debug, falsey env remains false, and source no longer contains unconditional `debug=True`.
- **Verification:** `python3 app_tests.py`, `python3 -m py_compile app.py app_tests.py`, `git diff --check`, and `rg -n "debug=True|FLASK_SAMPLE_DEBUG|debug_enabled" app.py app_tests.py README.md`.

## Risks

- Existing local workflows that relied on debug mode being always enabled must now opt in with `FLASK_SAMPLE_DEBUG=1`.
