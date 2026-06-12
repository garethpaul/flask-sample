---
title: Python Dependency Constraints
date: 2026-06-12
status: completed
execution: code
---

## Context

`requirements.txt` intentionally declares the supported Flask 3.1 range, but
GitHub Actions resolves that range and every transitive dependency afresh on
each run. Resolver simulations for Python 3.10, 3.12, and 3.14 currently select
the same seven-package graph, so CI can freeze those reviewed versions without
narrowing the sample's public compatibility declaration.

## Goals

- Preserve `Flask>=3.1.3,<3.2` as the runtime compatibility contract.
- Add one reviewed constraints file covering Flask and its complete transitive
  graph on Python 3.10, 3.12, and 3.14.
- Install through the constraints file in GitHub Actions and invalidate the pip
  cache when either dependency file changes.
- Make the dependency-free checker reject missing, extra, duplicated, or
  changed constraints and unconstrained hosted installs.
- Document that version constraints freeze resolution but do not authenticate
  package artifacts with hashes.

## Scope Boundaries

- Do not change Flask behavior, routes, templates, headers, or startup rules.
- Do not narrow the supported Flask 3.1 range in `requirements.txt`.
- Do not claim hash-locked or offline-reproducible installation.
- Do not merge or close the existing trusted-hosts PR without authorization.

## Verification Plan

- Resolve `requirements.txt` for Python 3.10, 3.12, and 3.14 and confirm the
  same exact graph is selected.
- Verify every constrained release through official PyPI metadata.
- Install with `python -m pip install -r requirements.txt -c constraints.txt`,
  run `python -m pip check`, and execute all Make gates.
- Reject focused constraints, workflow, cache-path, documentation, and plan
  evidence mutations.
- Run shell syntax, Python compilation, `git diff --check`, and changed-file
  credential screening.
- Require exact-head push, pull-request, and CodeQL checks before final tracker
  reconciliation.

## Work Completed

- Added an exact seven-package constraints file selected consistently for
  Python 3.10, 3.12, and 3.14 while preserving the Flask 3.1 range in
  `requirements.txt`.
- Applied the constraints to hosted installation and included both dependency
  files in setup-python's pip cache key.
- Extended the dependency-free checker to require the complete constraints
  graph, the exact workflow install and cache block, synchronized docs, and
  completed plan evidence.
- Updated contributor, setup, security, change, and reproducibility guidance
  without changing application behavior.

## Verification Completed

- Official PyPI metadata verified Flask 3.1.3, Werkzeug 3.1.8, Jinja2 3.1.6,
  MarkupSafe 3.0.3, itsdangerous 2.2.0, click 8.4.1, and blinker 1.9.0 with
  non-yanked release artifacts.
- Pip resolver simulations for Python 3.10, 3.12, and 3.14 selected the same
  exact seven-package graph through `requirements.txt` and `constraints.txt`.
- An isolated Python 3.12 environment installed the constrained graph,
  `python -m pip check` reported no broken requirements, and all 14 tests
  passed.
- The dependency-free checker, all Make gates, shell syntax, Python
  compilation, and `git diff --check` are the canonical local verification.
- Focused hostile constraints mutations cover graph drift, unconstrained
  installation, cache-key drift, documentation drift, and stale plan evidence.
- Hosted run identifiers will be appended after the implementation head is
  pushed; delivery is not final until both canonical events and CodeQL pass.
