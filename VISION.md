## Flask Sample Vision

Flask Sample is a minimal Flask application that serves a `hello.html` template
from the root route.

The repository is useful as a tiny Flask starting point for learning request
handling, templates, and local development.

The goal is to keep the sample simple, runnable, and honest about its debug
development posture.

The current focus is:

Priority:

- Preserve the minimal route and template rendering flow
- Keep local execution straightforward
- Avoid adding production claims while debug mode is enabled
- Make dependencies and setup explicit

Next priorities:

- Add README setup commands and dependency requirements
- Turn debug configuration into an environment-controlled setting
- Add a minimal test for the root route
- Document how to run locally on port 5000

Contribution rules:

- One PR = one focused Flask, template, test, or documentation change.
- Keep the sample small and readable.
- Add tests when changing route behavior.
- Do not introduce production deployment complexity without a clear reason.

## Security

Debug mode is for local development only. Future deployment notes must disable
debug behavior and avoid exposing Werkzeug debugger access.

Do not add secrets or credentials to source code.

## What We Will Not Merge (For Now)

- Production deployment claims while debug mode is hardcoded
- Secret keys or credentials in source
- Framework-heavy rewrites that hide the basic Flask lesson
- Route changes without a simple verification path
