# flask-sample

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/flask-sample` is a static web project. Flask sample

The application serves no static assets and explicitly disables Flask's default
`/static/<path>` endpoint. Requests under that path return a normal hardened
`404` with the same authoritative security headers as every other response.

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: Python (1).

## Repository Contents

- `README.md` - project overview and local usage notes
- `app.py`
- `requirements.txt` - Flask dependency compatibility range
- `constraints.txt` - reviewed exact dependency graph used by CI
- `requirements.lock` - universal hash-verified install graph used by CI
- `Makefile` and `scripts/check-baseline.sh` - local verification commands
- `SECURITY.md` - security reporting and disclosure guidance
- `templates` - source or example code
- `tests` - root-route test coverage
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: templates
- Dependency and build manifests: `requirements.txt`, `constraints.txt`, `requirements.lock`
- Entry points or build surfaces: app.py
- Test-looking files: no obvious test files detected

## Getting Started

### Prerequisites

- Git
- Python 3
- Flask 3.1.3 or a newer compatible 3.1 release

### Setup

```bash
git clone https://github.com/garethpaul/flask-sample.git
cd flask-sample
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --require-hashes -r requirements.lock
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Run `python app.py` for local development. The app binds to `127.0.0.1:5000`
  by default.
- The root route is GET-only and renders `templates/hello.html`.
- Set `FLASK_DEBUG=1` only for local debugging; debug mode is enabled only when
  the resolved bind host is loopback.
- `FLASK_DEBUG` values are trimmed and case-normalized before matching `1`,
  `true`, `yes`, or `on`.
- Set `FLASK_RUN_HOST` or `PORT` locally when you need a different bind host or
  port.
- Blank `FLASK_RUN_HOST` values fall back to `127.0.0.1`.
- URL-shaped, path-like, and host-plus-port `FLASK_RUN_HOST` values fall back
  to `127.0.0.1`; set the port with `PORT`.
- Invalid `PORT` values fall back to `5000`.
- Requests trust loopback Host headers plus a validated non-wildcard
  `FLASK_RUN_HOST`; unexpected Host headers receive a 400 response.

## Testing and Verification

Run the baseline:

```bash
make check
```

Use the absolute Makefile path to run every gate from another working directory.
Verification resolves both the checker and unittest discovery paths relative to
the loaded Makefile rather than the caller's directory.

The baseline compiles the app, runs the route tests, and verifies debug mode is
opt-in rather than hardcoded and remains loopback-only when enabled. It also
verifies `FLASK_DEBUG` value normalization before the opt-in check, the
GET-only root route, and startup port parsing fallback for invalid local
environment values. Blank or malformed host values also fall back to localhost.
Flask 3.1 `TRUSTED_HOSTS` validation accepts loopback request hosts and a
validated concrete bind host while excluding wildcard bind addresses.
Responses include basic security headers for content sniffing, clickjacking
protection, referrer policy, and a Content-Security-Policy with a default-deny
subresource policy that also blocks plugin objects, base URL rewriting,
cross-origin form targets, and framing. It keeps a `Permissions-Policy` header
that disables unused camera, microphone, and geolocation capabilities.
Cross-origin embedder, opener, and resource policies also apply to successful
and error responses. The `require-corp` embedder policy completes the isolation
boundary for the asset-free page; future cross-origin assets require deliberate
compatibility review. The hook authoritatively replaces weaker preexisting
values for every managed header name; an upstream proxy can still change
headers after Flask returns the response.

The `make lint`, `make test`, and `make build` aliases run the same local
baseline or unit tests while this sample has no narrower installed gates.
The test suite also starts an ephemeral loopback-only Werkzeug server and
verifies the rendered root plus every managed security header over live HTTP.
GitHub Actions installs `requirements.lock` with `--require-hashes`, verifies dependency consistency,
and runs `make check` on Python 3.10, 3.12, and 3.14 for pull requests and
pushes. The runtime requirement stays within Flask 3.1 (`>=3.1.3,<3.2`) so the
sample receives current security fixes without silently crossing a future
feature-series boundary. The workflow uses read-only repository permissions and
does not persist checkout credentials.

Hosted installs use `requirements.lock` to freeze and hash-verify the reviewed
Flask graph across the matrix. It preserves the public Flask range and the
seven exact cross-platform pins in `constraints.txt`, plus conditional
`colorama` metadata for Windows portability.
Hosted installation bootstraps exact `pip 26.1.2` before applying those files,
avoiding a floating installer input across the Python matrix.
`requirements.lock` is the universal hash-verified install graph; pip must consume it with `--require-hashes`.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file is needed. Keep `.env` files local if
  future integrations add configuration.

## Security and Privacy Notes

- Review changes touching network requests, sockets, or service endpoints; examples from the scan include app.py.
- Debug mode is local-only. Do not expose the Werkzeug debugger on a public
  interface.
- `FLASK_DEBUG` should only enable debug mode for loopback host bindings.
- Keep Flask `TRUSTED_HOSTS` aligned with validated bind hosts, and do not trust
  wildcard addresses as request Host values.
- Keep response headers such as `X-Content-Type-Options` and `Referrer-Policy`
  in place when adding routes.
- Keep `X-Frame-Options: DENY` in place unless a documented embedding use case
  is added.
- Keep the default-deny subresource policy in place when adding new templates
  or routes, and add narrow CSP directives alongside any deliberate assets.
- Keep the `Permissions-Policy` header in place unless a documented browser
  capability is intentionally added.
- Keep the embedder, opener, and resource policies on both route and error
  responses unless a documented cross-origin integration requires a change.
- Keep the shared response hook authoritative for every managed security header
  rather than preserving weaker route- or extension-provided values.

## Maintenance Notes

- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.
- See `docs/plans/2026-06-09-flask-get-only-root.md` for the GET-only root
  route contract.
- See `docs/plans/2026-06-09-flask-port-validation.md` for local port parsing
  guardrails.
- See `docs/plans/2026-06-09-flask-host-validation.md` for local host parsing
  guardrails.
- See `docs/plans/2026-06-09-flask-host-shape-validation.md` for host shape
  validation guardrails.
- See `docs/plans/2026-06-12-flask-trusted-hosts.md` for request Host-header
  validation guardrails.
- See `docs/plans/2026-06-09-flask-loopback-debug-guard.md` for loopback-only
  debug guardrails.
- See `docs/plans/2026-06-09-basic-security-headers.md` for response header
  guardrails.
- See `docs/plans/2026-06-09-clickjacking-header.md` for the frame-embedding
  header guard.
- See `docs/plans/2026-06-09-content-security-policy-header.md` for the
  Content-Security-Policy header guard.
- See `docs/plans/2026-06-09-permissions-policy-header.md` for the browser
  capability policy guard.
- See `docs/plans/2026-06-13-cross-origin-isolation-headers.md` for same-origin
  opener/resource policy and error-response coverage.
- See `docs/plans/2026-06-13-authoritative-security-header-enforcement.md` for
  managed-header precedence coverage.
- See `docs/plans/2026-06-13-complete-cross-origin-isolation.md` for the
  completed embedder, opener, and resource policy boundary.
- See `docs/plans/2026-06-10-ci-baseline.md` for the GitHub Actions baseline.
- Run `make check` before pushing Flask route or configuration changes.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
