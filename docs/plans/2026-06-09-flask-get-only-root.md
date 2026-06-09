---
title: Flask Sample GET-only root route
date: 2026-06-09
status: completed
execution: code
---

## Context

The sample root route only renders `templates/hello.html`, but it currently
accepts both GET and POST. Because the route does not process submitted data,
POST support adds unnecessary request surface for a minimal Flask learning app.

## Goals

- Keep the root route rendering behavior unchanged for GET requests.
- Reject unsupported POST requests with Flask's default method handling.
- Extend route tests and the static baseline so the root route remains GET-only.
- Keep the app simple and avoid production deployment scaffolding.

## Verification

- `make check`
- `python3 -m unittest discover -s tests -p "test*.py"`
- `git diff --check`
