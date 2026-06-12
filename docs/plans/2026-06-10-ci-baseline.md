# Flask Sample CI Baseline

status: completed

## Context

The repository already has a deterministic local baseline through `make check`.
The missing maintenance guard was a hosted workflow that runs the same gate for
pull requests and pushes.

## Changes

- Added a least-privilege GitHub Actions workflow for pushes, pull requests,
  and manual runs.
- Pinned checkout and Python setup actions by commit, disabled persisted
  checkout credentials, and bounded superseded runs with concurrency
  cancellation and a timeout.
- Installed `requirements.txt` and ran `pip check` plus `make check` on Python
  3.10, 3.12, and 3.14.
- Extended `scripts/check-baseline.sh` and project docs so the CI gate remains
  part of the maintained baseline.

## Verification

- `make check`
- `git diff --check`
- Workflow YAML parse
- Hosted Python 3.10, 3.12, and 3.14 GitHub Actions jobs
