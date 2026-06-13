---
title: Location-Independent Flask Verification
type: reliability
date: 2026-06-13
status: planned
execution: code
---

# Location-Independent Flask Verification

## Summary

Resolve the maintained checker and unittest discovery path from the loaded
Makefile so every documented gate works outside the checkout.

## Requirements

- R1. Derive the repository root from `MAKEFILE_LIST`.
- R2. Invoke `scripts/check-baseline.sh` through its repository-rooted path.
- R3. Discover tests from the repository-rooted `tests` directory.
- R4. Add static contracts that reject caller-directory-relative checker and
  test paths.
- R5. Preserve Flask behavior, dependencies, security headers, request
  boundaries, templates, workflow, and exact test coverage.
- R6. Record actual root and external-directory verification before completion.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` at repository
  root with the constrained dependency environment.
- Run all four gates from `/tmp` through the absolute Makefile path.
- Reject isolated hostile root-derivation, checker-path, test-path,
  documentation, plan-status, and verification-evidence mutations.
- Run constrained tests, dependency audit, Python compilation, shell syntax,
  `git diff --check`, exact-path review, secret scanning, and artifact inspection.

## Non-Goals

- Changing Flask routes, responses, headers, templates, dependencies, or
  deployment behavior.
- Claiming browser or production proxy behavior beyond existing tests.

## Work Completed

Pending implementation.

## Verification Completed

Pending implementation and verification.
