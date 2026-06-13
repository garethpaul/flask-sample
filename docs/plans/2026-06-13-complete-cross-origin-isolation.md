---
title: Complete Cross-Origin Isolation
type: security
status: planned
date: 2026-06-13
---

# Complete Cross-Origin Isolation

## Summary

Complete the browser isolation policy by adding the missing
`Cross-Origin-Embedder-Policy: require-corp` response header alongside the
existing same-origin opener and resource policies.

## Priority

1. Make the documented cross-origin isolation boundary technically complete.
2. Prove the embedder policy is authoritative on success and error responses.
3. Preserve the current route, trusted-host, startup, dependency, and header
   behavior.

## Requirements

- R1. `BASIC_SECURITY_HEADERS` must include
  `Cross-Origin-Embedder-Policy: require-corp`.
- R2. Exact header tests must cover the root response and 400, 404, and 405
  responses through the complete managed map.
- R3. The authoritative-header regression must prove a weak preexisting
  embedder policy is replaced with the reviewed value.
- R4. The static gate must reject a missing or weakened embedder policy,
  reduced runtime assertions, documentation drift, or incomplete plan
  evidence.
- R5. README, SECURITY, VISION, CHANGES, and AGENTS must describe the complete
  opener/embedder/resource policy and its asset-loading constraint.
- R6. The completed plan must record actual focused, full-suite, mutation, and
  hosted verification evidence.

## Non-Goals

- Adding cross-origin scripts, styles, frames, images, workers, or other
  subresources.
- Weakening the default-deny Content Security Policy or same-origin resource
  policy.
- Changing route methods, templates, trusted hosts, debug settings, startup
  parsing, dependency constraints, or CI configuration.
- Claiming protection from headers modified by an upstream deployment proxy.

## Implementation Units

### 1. Embedder Policy

Files: `app.py`

- Add the reviewed `require-corp` value to the authoritative shared map.

### 2. Response Regressions

Files: `tests/test_app.py`

- Assert the exact embedder policy on the root and representative 400, 404,
  and 405 responses.
- Keep the complete-map precedence regression mutation-sensitive.

### 3. Static Contracts

Files: `scripts/check-baseline.sh`

- Require the exact source policy, response assertions, documentation, and
  completed evidence.

### 4. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record the completed isolation triad and require narrow review before future
  cross-origin assets are introduced.

## Verification Plan

- Run the focused embedder-policy tests and `make check`, `make lint`,
  `make test`, and `make build` in the constrained environment.
- Remove the policy, weaken its value, remove success/error assertions, and
  regress plan evidence; each mutation must be rejected by unit or static
  gates.
- Run `pip check`, Python compilation, shell syntax, `git diff --check`, and
  intended-file secret/artifact scans.
- Take bounded exact-head pull-request, workflow, and code-scanning snapshots
  after push; do not start a watch loop.

## Work Completed

Pending implementation.

## Verification Completed

Pending implementation and verification.
