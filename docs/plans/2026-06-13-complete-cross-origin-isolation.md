---
title: Complete Cross-Origin Isolation
type: security
status: completed
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

- Added `Cross-Origin-Embedder-Policy: require-corp` to the authoritative
  shared response-header map.
- Added an exact success-response assertion while retaining complete-map
  precedence and 400, 404, and 405 error-response coverage.
- Extended the static baseline to require the exact policy, explicit success
  assertion, complete error coverage, repository guidance, and completed plan
  evidence.
- Updated contributor, security, maintenance, vision, and change guidance with
  the complete embedder, opener, and resource policy boundary.

## Verification Completed

- The three focused embedder-policy tests passed in the constrained Flask 3.1.3
  environment.
- The complete 16-test unit suite passed in the constrained environment.
- `pip check` reported no broken requirements for the reviewed seven-package
  graph.
- `make check`, `make lint`, `make test`, and `make build` passed.
- The missing-policy mutation failed the unit and static baseline.
- The weakened-value mutation failed the exact response assertions.
- The success-assertion mutation failed the static baseline.
- The error-coverage mutation failed the static baseline while remaining valid
  Python.
- The plan-evidence mutation failed the static baseline.
- Python compilation, shell syntax, `git diff --check`, and intended-file
  secret and artifact scans are included in final-tree verification.
- The bounded exact-head hosted verification will be recorded after push in the
  engineering tracker without a watch loop.
