## Flask Sample Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Flask Sample is a minimal Flask application that serves a `hello.html` template
from the root route.

The repository is useful as a tiny Flask starting point for learning request
handling, templates, and local development.

The goal is to keep the sample simple, runnable, and honest about its debug
development posture.

The current focus is:

Priority:

- Preserve the minimal route and template rendering flow
- Keep the root route GET-only while it only renders a template
- Keep local execution straightforward
- Avoid adding production claims while debug mode is enabled
- Make dependencies and setup explicit

Current baseline:

- `scripts/check-baseline.sh` and `make check` compile the app and run root
  route tests.
- The root route is GET-only and rejects unsupported POST requests with Flask's
  default method handling.
- Debug mode is controlled by `FLASK_DEBUG` instead of being hardcoded, and it
  is enabled only for loopback host bindings.
- `FLASK_DEBUG` values are trimmed and case-normalized before the opt-in
  allowlist is checked.
- Local execution binds to `127.0.0.1` unless the developer explicitly sets
  `FLASK_RUN_HOST`.
- Blank `FLASK_RUN_HOST` values fall back to 127.0.0.1 instead of bypassing the
  localhost default.
- URL-shaped, path-like, and host-plus-port `FLASK_RUN_HOST` values fall back
  to 127.0.0.1; `PORT` remains the separate port configuration.
- Flask rejects untrusted request Host headers; loopback names and one validated
  non-wildcard bind host are trusted.
- Invalid `PORT` values fall back to 5000 rather than crashing local startup.
- Responses include basic security headers for content sniffing, clickjacking
  protection, and referrer policy.
- Responses include a default-deny subresource policy with explicit object,
  base URL, form-action, and framing boundaries.
- Responses include a Permissions-Policy that disables unused camera,
  microphone, and geolocation capabilities.
- `make lint`, `make test`, and `make build` run the local baseline or unit
  tests while this sample has no narrower installed gates.
- GitHub Actions runs dependency consistency checks and `make check` on Python
  3.10, 3.12, and 3.14 without persisting checkout credentials, so hosted
  verification covers the declared Flask range.
- The declared runtime uses the patched Flask 3.1 line (`>=3.1.3,<3.2`) and a
  route test verifies the installed framework remains inside that boundary.
- Python environments, bytecode, and `.env` files are ignored.

Next priorities:

- Keep README setup commands and the maintained Flask 3.1 requirement current
- Add more route tests only when route behavior grows
- Keep local port behavior documented as startup configuration evolves
- Keep local host parsing documented as startup configuration evolves
- Keep host shape validation covered when changing startup binding behavior
- Keep request Host validation aligned with Flask's `TRUSTED_HOSTS` behavior
- Keep debug mode loopback-only when changing startup binding behavior
- Keep debug flag value normalization covered when changing startup config
- Preserve the basic response header hook when adding routes
- Keep frame embedding disabled unless a documented use case is added
- Keep the CSP updated if templates begin loading external assets
- Keep unused browser capabilities disabled unless the sample gains a feature
  that needs them
- Keep the hosted CI workflow aligned with `make check`
- Keep the exact pip bootstrap compatible with every hosted Python version

Contribution rules:

- One PR = one focused Flask, template, test, or documentation change.
- Keep the sample small and readable.
- Add tests when changing route behavior.
- Do not introduce production deployment complexity without a clear reason.

## Security

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Debug mode is for local development only. Future deployment notes must disable
debug behavior and avoid exposing Werkzeug debugger access.

Do not add secrets or credentials to source code.

## What We Will Not Merge (For Now)

- Production deployment claims while debug mode is hardcoded
- Secret keys or credentials in source
- Framework-heavy rewrites that hide the basic Flask lesson
- Route changes without a simple verification path

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
