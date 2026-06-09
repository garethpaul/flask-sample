# Changes

## 2026-06-08

- Added basic security headers for Flask responses and unit/static baseline
  coverage for them.
- Made Flask debug mode opt-in through `FLASK_DEBUG`.
- Defaulted local execution to `127.0.0.1` instead of binding publicly.
- Added `requirements.txt`, route tests, and `make check` for repeatable
  verification.
- Limited the root route to GET requests and added POST rejection coverage.
- Added validated `PORT` parsing so bad local environment values fall back to
  port 5000 instead of crashing startup.
- Added validated `FLASK_RUN_HOST` parsing so blank host values fall back to
  localhost while explicit overrides still work.
