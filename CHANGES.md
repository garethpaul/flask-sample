# Changes

## 2026-06-08

- Made Flask debug mode opt-in through `FLASK_DEBUG`.
- Defaulted local execution to `127.0.0.1` instead of binding publicly.
- Added `requirements.txt`, route tests, and `make check` for repeatable
  verification.
- Limited the root route to GET requests and added POST rejection coverage.
