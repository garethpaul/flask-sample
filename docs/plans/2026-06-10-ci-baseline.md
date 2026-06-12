# Flask Sample CI Baseline

status: completed

## Context

The repository already has a deterministic local baseline through `make check`.
The missing maintenance guard was a hosted workflow that runs the same gate for
pull requests and pushes.

## Changes

- Added `.github/workflows/check.yml` for GitHub Actions.
- Configured the workflow to install `requirements.txt` on Python 3.12.
- Wired the workflow to run `make check`, matching the local verification path.
- Extended `scripts/check-baseline.sh` and project docs so the CI gate remains
  part of the maintained baseline.

## Verification

- `make check`
- `git diff --check`
