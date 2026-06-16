# AGENTS.md

## Repository purpose

`garethpaul/flask-sample` is a minimal server-rendered Flask application used
to demonstrate safe local startup configuration, a GET-only route, and secure
default response headers.

The sample intentionally serves no static assets. Preserve
`static_folder=None` so Flask does not register an unused `/static/<path>`
endpoint, and keep static-path 404 responses under the shared header policy.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `tests` - tests and fixtures
- `templates` - server-rendered templates
- `requirements.txt` - Python runtime dependencies

## Development commands

- Install dependencies: `python3 -m pip install --require-hashes -r requirements.lock`
- Full baseline: `make check`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Support the declared Flask `>=3.1.3,<3.2` range and Python 3.10, 3.12, and
  3.14 compatibility matrix.
- Keep `constraints.txt` aligned with the reviewed CI graph without narrowing
  the compatibility range in `requirements.txt`.
- Regenerate `requirements.lock` with hashes whenever the reviewed constraints
  change, and keep hosted installs in `--require-hashes` mode.
- `requirements.lock` is the universal hash-verified install graph; pip must consume it with `--require-hashes`.
- Prefer dependency-free tests or stdlib checks when legacy packages are unavailable.

## Testing guidance

- Test-related files detected: `tests/`, `tests/test_app.py`
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- No required secret or credential file is needed. Keep `.env` files local if future integrations add configuration.
- Debug mode is local-only. Do not expose the Werkzeug debugger on a public interface.
- `FLASK_DEBUG` should only enable debug mode for loopback host bindings.
- Keep response headers such as `X-Content-Type-Options` and `Referrer-Policy` in place when adding routes.
- Keep the shared response hook authoritative for managed security headers; do
  not preserve weaker values supplied by routes, error handlers, or extensions.
- Keep `Cross-Origin-Embedder-Policy: require-corp` with the same-origin opener
  and resource policies; review compatibility before adding cross-origin assets.
- Keep `X-Frame-Options: DENY` in place unless a documented embedding use case is added.
- Keep the default-deny Content-Security-Policy in place when adding new templates, routes, or external assets; add only narrow reviewed exceptions for required asset types.
- Keep `Permissions-Policy` disabling camera, microphone, and geolocation unless a documented feature requires one of those capabilities.
- Treat `FLASK_RUN_HOST` and `PORT` as separate inputs. Reject URL-shaped, path-like, and host-plus-port host values, and retain safe localhost/default-port fallbacks.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
