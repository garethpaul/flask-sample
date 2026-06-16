# Hash-Verify the Flask Dependency Lock

Status: Planned

## Context

`constraints.txt` pins the reviewed Flask graph, but pip still accepts any
artifact that satisfies those versions. A compromised or unexpectedly replaced
artifact would therefore pass version-only resolution. The Python 3.10, 3.12,
and 3.14 matrix needs one reviewed lock with hashes that pip can enforce before
the application tests run.

## Goals

- Generate a universal lock for the existing seven-package Flask graph.
- Include hashes for the compatible distributions needed across the declared
  Python matrix.
- Install CI dependencies with pip's `--require-hashes` enforcement.
- Keep `requirements.txt` as the direct Flask compatibility declaration and
  `constraints.txt` as the human-reviewable exact graph.
- Protect the lock, workflow command, cache inputs, documentation, and completed
  verification evidence with static contracts.

## Non-Goals

- Do not change Flask or transitive dependency versions.
- Do not add a production WSGI server or claim production deployment support.
- Do not weaken the Python 3.10, 3.12, and 3.14 hosted matrix.
- Do not commit virtual environments, wheels, caches, or credentials.

## Implementation

1. Generate `requirements.lock` from `requirements.txt` and `constraints.txt`
   with a deterministic hash-producing compiler.
2. Change the hosted install to consume only the lock with
   `--require-hashes`, and include it in the pip cache key.
3. Document the lock refresh and verification boundary in repository guidance.
4. Extend `scripts/check-baseline.sh` to validate the exact pinned graph,
   required hashes, workflow enforcement, guidance, and completed plan.
5. Record the change in `CHANGES.md` and remove the resolved integrity risk
   from the roadmap.

## Validation

- Parse the generated lock and prove all seven reviewed packages remain pinned
  to the exact `constraints.txt` versions with at least one SHA-256 hash each.
- Install the lock with `--require-hashes` in clean Python 3.12 and 3.14 virtual
  environments and run `python -m pip check` plus the test suite.
- Run `sh -n scripts/check-baseline.sh` and the focused dependency contracts.
- Run repository and external-directory `make check`.
- Reject mutations that remove a package hash, `--require-hashes`, the lock
  cache input, version parity, guidance, completed status, or verification
  evidence.
- Audit the exact diff, generated artifacts, dependency versions, credentials,
  conflict markers, modes, and whitespace before commit.

## Risks

- The lock must remain portable across the declared Python versions rather
  than recording only one local wheel.
- Hash refreshes are intentionally explicit and must accompany any dependency
  version change.
- PR #12 will be stacked on open PR #11 and requires base-first ordering;
  neither pull request may be merged or closed without explicit authorization.
