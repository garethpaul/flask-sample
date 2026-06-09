---
title: Flask Sample PORT validation
date: 2026-06-09
status: completed
execution: code
---

## Context

Local startup parsed `PORT` with a direct `int(...)` call. Invalid, empty, or
out-of-range environment values raised an exception before Flask could start,
which made a small sample app brittle during local experimentation.

## Goals

- Keep the default local port at 5000.
- Accept valid TCP port numbers from `PORT`.
- Fall back to 5000 for invalid, empty, or out-of-range `PORT` values.
- Cover the parser with unit tests and static baseline assertions.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `make check`
- `git diff --check`
