---
title: Flask Sample host validation
date: 2026-06-09
status: completed
execution: code
---

## Context

Local startup read `FLASK_RUN_HOST` directly. A missing value used the localhost
default, but a blank environment value could bypass that default and send an
empty host string into Flask's development server.

## Goals

- Keep the default local host at `127.0.0.1`.
- Treat blank or whitespace-only `FLASK_RUN_HOST` values as unset.
- Preserve explicit developer host overrides.
- Cover the parser with unit tests and static baseline assertions.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `make check`
- `git diff --check`
