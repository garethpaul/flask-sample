# Changes

- Disabled Flask's unused default static endpoint and added test-client plus
  live-HTTP regressions for hardened static-path 404 responses.

- Added `requirements.lock` and made hosted Python 3.10, 3.12, and 3.14
  installs reject package artifacts that are not covered by its SHA-256 hashes.
- `requirements.lock` is the universal hash-verified install graph; pip must consume it with `--require-hashes`.

## 2026-06-15

- Added loopback HTTP integration coverage that verifies the rendered root and
  every managed security header across the live WSGI response boundary.

## 2026-06-13

- Made Flask verification independent of the caller's working directory by
  rooting both the checker and unittest discovery paths in the loaded Makefile.
- Completed the cross-origin isolation boundary with an authoritative
  `Cross-Origin-Embedder-Policy: require-corp` header.
- Covered the exact embedder, opener, and resource policies on successful and
  error responses with mutation-sensitive static contracts.
- Made the shared response hook replace weaker preexisting values for every
  managed security header.
- Added a full-map regression and static contract for authoritative header
  assignment.
- Added same-origin opener and resource policies to the shared Flask response
  security-header map.
- Added full security-header regression coverage for 400, 404, and 405
  responses.

## 2026-06-12

- Pinned the hosted pip bootstrap to 26.1.2 and added exact workflow, plan, and
  documentation contracts that reject floating or duplicate installer upgrades.
- Added a reviewed seven-package constraints graph shared by Python 3.10,
  3.12, and 3.14, wired it into hosted installs and pip cache invalidation, and
  added exact dependency, workflow, documentation, and plan contracts.
- Upgraded the runtime contract from legacy Flask 2.x compatibility to the
  patched Flask 3.1 line (`>=3.1.3,<3.2`).
- Added installed-version, dependency-range, route, and security-header
  regressions across the existing Python 3.10, 3.12, and 3.14 matrix.
- Changed the Content Security Policy to a default-deny subresource policy for
  the asset-free hello page while retaining explicit form and framing rules.
- Extended exact header tests, baseline checks, and security documentation for
  the tightened fallback.
- Added Flask 3.1 `TRUSTED_HOSTS` validation for loopback and configured
  non-wildcard hosts, with request-level rejection tests for unexpected Host
  headers.

## 2026-06-10

- Tightened Content Security Policy with explicit object, base URL,
  form-action, and frame-ancestor boundaries.
- Added a pinned, least-privilege GitHub Actions matrix that verifies
  dependencies and runs `make check` on Python 3.10, 3.12, and 3.14.
- Disabled persisted checkout credentials and added structural workflow
  contracts for the read-only permissions boundary.

## 2026-06-09

- Normalized `FLASK_DEBUG` values before matching the opt-in debug allowlist.
- Restricted opt-in Flask debug mode to loopback host bindings.
- Validated `FLASK_RUN_HOST` shapes so URL-shaped, path-like, and host-plus-port
  values fall back to localhost.
- Added a `Permissions-Policy` response header for unused browser capabilities
  with unit and baseline coverage.
- Added a minimal Content-Security-Policy response header with regression and
  baseline coverage, plus `make lint`/`make build` aliases.

## 2026-06-08

- Added basic security headers for Flask responses and unit/static baseline
  coverage for them.
- Added an `X-Frame-Options: DENY` response header and regression coverage.
- Made Flask debug mode opt-in through `FLASK_DEBUG`.
- Defaulted local execution to `127.0.0.1` instead of binding publicly.
- Added `requirements.txt`, route tests, and `make check` for repeatable
  verification.
- Limited the root route to GET requests and added POST rejection coverage.
- Added validated `PORT` parsing so bad local environment values fall back to
  port 5000 instead of crashing startup.
- Added validated `FLASK_RUN_HOST` parsing so blank host values fall back to
  localhost while explicit overrides still work.
