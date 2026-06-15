---
title: Live HTTP Security Header Verification
type: testing
date: 2026-06-15
status: pending
execution: code
---

# Live HTTP Security Header Verification

## Summary

Exercise the Flask application through a real loopback HTTP server so the
rendered root response and every managed security header are verified across
the WSGI boundary, not only through Flask's in-process test client.

## Requirements

- R1. Start a deterministic loopback-only Werkzeug server on an ephemeral port
  during the test and always stop it after the request.
- R2. Fetch `/` through the Python standard-library HTTP client and verify the
  successful rendered body.
- R3. Assert every `BASIC_SECURITY_HEADERS` entry on the live HTTP response,
  including the complete embedder, opener, and resource policy boundary.
- R4. Add a maintenance contract that rejects removal of the live-server test,
  loopback binding, deterministic shutdown, or full header iteration.
- R5. Preserve application source, dependency constraints, route behavior,
  startup defaults, and existing unit coverage.

## Scope Boundaries

- Do not add browser automation, external network access, or a new dependency.
- Do not claim production proxy behavior or browser feature availability.
- Do not change the security header values or Flask application runtime.

## Implementation Units

1. Add the loopback HTTP integration test with bounded startup and cleanup.
2. Extend the static baseline with mutation-sensitive live-server contracts and
   completed plan evidence.
3. Run the constrained Python matrix locally where available, repository and
   external-directory gates, mutations, and final artifact/secret audits.

## Verification

Pending implementation and validation.
