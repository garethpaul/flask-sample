---
title: Flask Trusted Hosts
date: 2026-06-12
status: completed
execution: code
---

## Context

The sample validates `FLASK_RUN_HOST` before binding the development server,
but Flask still accepts every incoming `Host` header. Flask 3.1 added the
`TRUSTED_HOSTS` configuration specifically to reject untrusted host values
during routing. The official security guidance recommends configuring it when
deploying an application:
https://flask.palletsprojects.com/en/stable/web-security/#host-header-validation

## Goals

- Trust `localhost`, `127.0.0.1`, and `[::1]` for the local-first sample.
- Add a validated configured hostname or concrete IP address to the trusted
  list when it is not already present.
- Do not treat wildcard bind addresses such as `0.0.0.0` or `::` as trusted
  request hostnames.
- Reject unexpected Host headers with Flask's standard 400 response.
- Preserve the existing bind-host, debug, route, and response-header behavior.

## Implementation

- Add a `trusted_hosts` helper that reuses `host_name` validation.
- Configure `app.config["TRUSTED_HOSTS"]` before requests are handled.
- Add tests for the default list, a validated custom host, wildcard exclusion,
  accepted loopback requests, and an untrusted request.
- Extend `scripts/check-baseline.sh`, README, VISION, SECURITY, and CHANGES to
  preserve and explain the Host-header boundary.

## Verification

- `python -m unittest discover -s tests -p "test*.py"`
- `sh -n scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
- GitHub Actions on Python 3.10, 3.12, and 3.14
