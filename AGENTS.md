# AGENTS.md

## Repository purpose

`garethpaul/flask-sample` is a static web project. Flask sample

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `tests` - tests and fixtures
- `templates` - server-rendered templates
- `requirements.txt` - Python runtime dependencies

## Development commands

- Install dependencies: `python3 -m pip install -r requirements.txt`
- Full baseline: `make check`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: Python (1).
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
- Keep `X-Frame-Options: DENY` in place unless a documented embedding use case is added.
- Keep the minimal Content-Security-Policy in place when adding new templates, routes, or external assets.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
