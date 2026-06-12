---
title: Pip Bootstrap Pin
date: 2026-06-12
status: completed
execution: code
---

# Pip Bootstrap Pin

## Summary

Replace the workflow's floating `pip install --upgrade pip` bootstrap with an
exact installer version that supports every Python runtime in the existing
3.10, 3.12, and 3.14 matrix. Preserve the constrained Flask dependency graph,
application behavior, and all current verification coverage.

## Priority

The workflow resolves the newest available installer on every run before it
installs an otherwise exact dependency graph. Pinning that bootstrap removes a
moving supply-chain input and makes hosted dependency installation repeatable.

## Requirements

- Pin the hosted bootstrap to `pip==26.1.2`.
- Keep Python 3.10, 3.12, and 3.14 support; official PyPI metadata declares
  `pip 26.1.2` compatible with Python `>=3.10`.
- Preserve the exact `requirements.txt` plus `constraints.txt` install, pip
  cache inputs, `pip check`, and full `make check` gate.
- Extend the SDK-free checker to require exactly one pinned bootstrap and reject
  floating upgrades, alternate pip versions, duplicate bootstraps, and plan or
  documentation drift.
- Do not change Flask source, tests, requirements, constraints, or runtime
  behavior.

## Supply-Chain Evidence

Official PyPI JSON metadata reported `pip 26.1.2` as the current non-yanked
release on 2026-06-12. Its universal wheel SHA-256 is
`382ff9f685ee3bc25864f820aa50505825f10f5458ffff07e30a6d96e5715cab` and
its source archive SHA-256 is
`f49cd134c61cf2fd75e0ce2676db03e4054504a5a4986d00f8299ae632dc4605`.
The workflow uses the exact version pin; artifact hash authentication remains a
separate future hardening boundary.

## Work Completed

- Replaced the floating pip upgrade with an exact `pip==26.1.2` bootstrap.
- Added exact workflow, plan, and repository-guidance contracts without
  changing the application or constrained dependency graph.

## Verification Completed

- Local Make gates passed with all 14 tests, Python compilation, source
  contracts, and the constrained dependency graph; the
  external-working-directory checker passed the same canonical baseline.
- Cross-version installer checks confirmed `pip 26.1.2` supports Python 3.10,
  3.12, and 3.14 according to official metadata and installs successfully on
  every locally available matrix runtime.
- Workflow parsing, shell syntax, and `git diff --check` passed.
- Focused mutations rejected floating, alternate, missing, and duplicate pip
  bootstraps plus incomplete plan and documentation evidence; all focused
  hostile mutations rejected.
- Exact-head hosted evidence remains pending until this successor is pushed.
