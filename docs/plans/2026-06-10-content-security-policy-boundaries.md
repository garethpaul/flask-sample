# Content Security Policy Boundaries

status: completed

## Context

The sample set a same-origin default and denied framing, but left plugin
objects, document base URL changes, and form destinations implicit.

## Work Completed

- Added `object-src 'none'` and `base-uri 'none'`.
- Restricted form submissions with `form-action 'self'`.
- Kept `frame-ancestors 'none'` and exact response-header regression coverage.
- Extended the static baseline and security documentation.

## Verification

- `python3 -m unittest discover -s tests -p "test*.py"`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
