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
- Local execution binds to `127.0.0.1` unless the developer explicitly sets
  `FLASK_RUN_HOST`.
- Blank `FLASK_RUN_HOST` values fall back to 127.0.0.1 instead of bypassing the
  localhost default.
- URL-shaped, path-like, and host-plus-port `FLASK_RUN_HOST` values fall back
  to 127.0.0.1; `PORT` remains the separate port configuration.
- Invalid `PORT` values fall back to 5000 rather than crashing local startup.
- Responses include basic security headers for content sniffing, clickjacking
  protection, and referrer policy.
- Responses include a minimal Content-Security-Policy for same-origin assets
  and no frame ancestors.
- Responses include a Permissions-Policy that disables unused camera,
  microphone, and geolocation capabilities.
- `make lint`, `make test`, and `make build` run the local baseline or unit
  tests while this sample has no narrower installed gates.
- Python environments, bytecode, and `.env` files are ignored.

Next priorities:

- Keep README setup commands and dependency requirements current
- Add more route tests only when route behavior grows
- Keep local port behavior documented as startup configuration evolves
- Keep local host parsing documented as startup configuration evolves
- Keep host shape validation covered when changing startup binding behavior
- Keep debug mode loopback-only when changing startup binding behavior
- Preserve the basic response header hook when adding routes
- Keep frame embedding disabled unless a documented use case is added
- Keep the CSP updated if templates begin loading external assets
- Keep unused browser capabilities disabled unless the sample gains a feature
  that needs them

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
