---
title: Location-Independent Flask Verification
type: reliability
date: 2026-06-13
status: completed
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

- Derived the repository root from the loaded Makefile and invoked the checker
  through that absolute path.
- Run unittest discovery from the repository root so both the tests directory
  and application imports remain deterministic outside the checkout.
- Extended the baseline with rooted-path, completed-plan, external-run, and
  synchronized-guidance contracts.
- Preserved Flask routes, responses, security headers, templates, dependencies,
  workflow, and tests unchanged.

## Verification Completed

- `make check`, `make lint`, `make test`, and `make build` passed in the
  constrained Flask 3.1.3 environment at repository root and from /tmp through
  the absolute Makefile path.
- Six isolated hostile root-derivation, checker-path, test-path, documentation,
  plan-status, and verification-evidence mutations were rejected.
- Dependency consistency, Python compilation, shell syntax, `git diff --check`,
  exact-path review, added-line secret scanning, and generated-artifact
  inspection passed.
- No route, response, header, template, dependency, workflow, or test behavior
  changed; browser and production proxy behavior were not claimed.
