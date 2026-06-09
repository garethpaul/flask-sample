# Changes

## 2026-06-09

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
