# flask-sample

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/flask-sample` is a static web project. Flask sample

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: Python (1).

## Repository Contents

- `README.md` - project overview and local usage notes
- `app.py`
- `requirements.txt` - Flask dependency compatibility range
- `Makefile` and `scripts/check-baseline.sh` - local verification commands
- `SECURITY.md` - security reporting and disclosure guidance
- `templates` - source or example code
- `tests` - root-route test coverage
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: templates
- Dependency and build manifests: none detected
- Entry points or build surfaces: app.py
- Test-looking files: no obvious test files detected

## Getting Started

### Prerequisites

- Git
- Python 3

### Setup

```bash
git clone https://github.com/garethpaul/flask-sample.git
cd flask-sample
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Run `python app.py` for local development. The app binds to `127.0.0.1:5000`
  by default.
- The root route is GET-only and renders `templates/hello.html`.
- Set `FLASK_DEBUG=1` only for local debugging.
- Set `FLASK_RUN_HOST` or `PORT` locally when you need a different bind host or
  port.
- Blank `FLASK_RUN_HOST` values fall back to `127.0.0.1`.
- Invalid `PORT` values fall back to `5000`.

## Testing and Verification

Run the baseline:

```bash
make check
```

The baseline compiles the app, runs the route tests, and verifies debug mode is
opt-in rather than hardcoded. It also verifies the root route stays GET-only and
startup port parsing falls back safely for invalid local environment values.
Blank host values also fall back to localhost.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file is needed. Keep `.env` files local if
  future integrations add configuration.

## Security and Privacy Notes

- Review changes touching network requests, sockets, or service endpoints; examples from the scan include app.py.
- Debug mode is local-only. Do not expose the Werkzeug debugger on a public
  interface.

## Maintenance Notes

- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.
- See `docs/plans/2026-06-09-flask-get-only-root.md` for the GET-only root
  route contract.
- See `docs/plans/2026-06-09-flask-port-validation.md` for local port parsing
  guardrails.
- See `docs/plans/2026-06-09-flask-host-validation.md` for local host parsing
  guardrails.
- Run `make check` before pushing Flask route or configuration changes.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
