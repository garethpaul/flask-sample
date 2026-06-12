# Changes

## 2026-06-12

- Upgraded the runtime contract from legacy Flask 2.x compatibility to the
  patched Flask 3.1 line (`>=3.1.3,<3.2`).
- Added installed-version, dependency-range, route, and security-header
  regressions across the existing Python 3.10, 3.12, and 3.14 matrix.
- Changed the Content Security Policy to a default-deny subresource policy for
  the asset-free hello page while retaining explicit form and framing rules.
- Extended exact header tests, baseline checks, and security documentation for
  the tightened fallback.

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
