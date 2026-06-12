# Flask 3.1 Modernization

status: completed

## Context

The sample currently declares `Flask>=2.2,<3`, which excludes the maintained
Flask 3 series and permits releases predating later security and compatibility
fixes. Flask 3.1.3 is the current upstream release and supports Python 3.9 and
newer, which is compatible with the repository's Python 3.10, 3.12, and 3.14
verification matrix.

The application uses only stable Flask APIs (`Flask`, `render_template`, route
decorators, response hooks, and the test client), so no compatibility shim is
required.

## Priority

Framework support and security fixes are higher-value than adding features to
this intentionally small sample. The dependency contract should require the
patched maintained line and prove that the existing security behavior still
works on it.

## Prioritized Engineering Backlog

1. Upgrade the declared Flask range to the current patched 3.1 line now.
2. Add reproducible dependency locking with hashes if the sample gains a
   deployment artifact rather than remaining a teaching example.
3. Add production WSGI deployment guidance only if the repository stops being
   a local development sample.

## Requirements

- R1. Runtime dependencies must require Flask 3.1.3 or newer within the 3.1
  compatibility line.
- R2. The supported Python 3.10, 3.12, and 3.14 matrix must remain compatible.
- R3. Root route behavior, debug/host/port guards, and exact response security
  headers must remain unchanged.
- R4. Repository verification must install the declared dependencies and fail
  if the Flask lower or upper bound regresses to the legacy 2.x contract.
- R5. Dependency consistency, import smoke tests, route tests, and bytecode
  compilation must pass in an isolated environment.
- R6. README, security guidance, vision, and change history must document the
  maintained framework line and verification boundary.

## Implementation Units

### U1. Modernize the runtime requirement

- **Files:** `requirements.txt`
- Require `Flask>=3.1.3,<3.2` to receive patched 3.1 releases without silently
  crossing a future feature-series boundary.

### U2. Strengthen dependency contracts

- **Files:** `scripts/check-baseline.sh`, `tests/test_app.py`
- Assert the maintained range, verify installed dependency consistency, and
  retain exact route/header coverage on Flask 3.1.

### U3. Update maintenance documentation

- **Files:** `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`
- Record the current upstream line, Python compatibility, and upgrade checks.

## Scope Boundaries

- Do not add application features or routes.
- Do not introduce a production WSGI server or deployment claims.
- Do not loosen existing debug, host, method, or response-header protections.
- Do not pin transitive dependencies independently of Flask's maintained
  dependency metadata.

## Verification

- `make check`
- `python -m pip check`
- `python -m unittest discover -s tests -p "test*.py"`
- `python -m py_compile app.py tests/test_app.py`
- `python -c "from importlib.metadata import version; print(version('Flask'))"`
- `git diff --check`
- Mutations restoring a Flask 2.x-compatible lower bound or removing the 3.1
  upper boundary must fail the repository contract.

## Upstream Evidence

- PyPI lists Flask 3.1.3 as released on 2026-02-19.
- The official Flask 3.1 changelog records the 3.1.3 security fix and Python
  3.8 support removal in 3.1.0, leaving this repository's Python matrix
  supported.

Completed on 2026-06-12 with an isolated Flask 3.1.3 environment, dependency
consistency checks, the full route/security suite, bytecode compilation, and
diff hygiene checks passing.
