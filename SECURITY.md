# Security Policy

## Supported Versions

The supported security scope for `flask-sample` is the current default branch, `master`. Older commits, tags, branches, forks, demos, and generated artifacts are not actively supported unless the repository explicitly marks them as maintained.

Project summary: Flask sample

## Reporting a Vulnerability

Please report suspected vulnerabilities through GitHub's private vulnerability reporting or by opening a draft GitHub Security Advisory for `garethpaul/flask-sample` when that option is available. If GitHub does not show a private reporting option for this repository, contact the repository owner through GitHub and avoid posting exploit details publicly until the issue can be assessed.

Do not open a public issue that includes exploit code, secrets, personal data, or detailed reproduction steps for an unpatched vulnerability.

## What to Include

Helpful reports include:

- the affected file, endpoint, permission, dependency, or workflow
- a concise impact statement explaining what an attacker could do
- reproduction steps using test data and accounts you control
- the branch, commit SHA, platform version, device, runtime, or dependency versions used
- logs, screenshots, or proof-of-concept snippets that demonstrate impact without exposing private data

## Project Security Posture

- This repository appears to be a public sample, documentation, or utility project. The active security scope is the code and documentation on the default branch.
- Review found network clients, sockets, web APIs, or service endpoints; changes in those areas should receive security-focused review before merge.
- Debug mode should stay opt-in and loopback-only so the Werkzeug debugger is
  not exposed on public host bindings.
- `FLASK_DEBUG` values should be trimmed and case-normalized before checking
  the opt-in allowlist.
- Response headers should keep explicit object, base URL, form-action, and
  frame-ancestor Content-Security-Policy boundaries unless a documented need
  changes them.
- Keep the default-deny subresource policy unless a reviewed template change
  adds a narrow CSP exception for a required asset type.
- Local host binding should reject URL-shaped, path-like, or host-plus-port
  values and keep port selection in `PORT`.
- Flask `TRUSTED_HOSTS` should reject unexpected request Host headers and must
  not treat wildcard bind addresses as trusted hostnames. See Flask's official
  guidance: https://flask.palletsprojects.com/en/stable/web-security/#host-header-validation
- Response headers should keep unused browser capabilities disabled with
  `Permissions-Policy` unless a documented feature needs them.
- GitHub Actions uses read-only repository permissions and runs the same
  `make check` baseline as local development without persisting checkout
  credentials; do not add secrets or deployment steps without a separate
  security review.
- Dependency manifest detected: `requirements.txt`. Review dependency range
  changes deliberately and keep hosted compatibility checks green.
- The supported framework line is Flask `>=3.1.3,<3.2`; the lower bound keeps
  the 3.1.3 security fix while the upper bound requires deliberate review
before adopting a later feature series.

## Service and API Notes

For web services, APIs, sockets, or scraping workflows, prioritize reports involving authentication bypass, authorization errors, injection, server-side request forgery, unsafe deserialization, credential leakage, data exposure, or denial-of-service conditions. Use test accounts and minimal proof-of-concept traffic only.

## Dependency and Supply Chain Security

Dependency updates should come from trusted package managers and should keep lockfiles in sync when lockfiles exist. Do not commit credentials, private keys, tokens, generated secrets, or machine-local configuration. If a vulnerability depends on a compromised package, typosquatting risk, insecure transitive dependency, or unsafe build step, include the package name, affected version, and the path through which it is used.

## Safe Research Guidelines

Good-faith research is welcome when it stays within these boundaries:

- use only accounts, devices, data, and infrastructure that you own or have explicit permission to test
- avoid destructive actions, persistence, spam, phishing, social engineering, or denial-of-service testing
- minimize access to personal data and stop testing immediately if private data is exposed
- do not exfiltrate secrets or third-party data; report the minimum evidence needed to verify impact
- keep vulnerability details confidential until the maintainer has assessed the report

## Maintainer Response

The maintainer will review complete reports as availability allows, prioritize issues by exploitability and impact, and coordinate a fix or mitigation when the affected code is still maintained. For sample, archived, or educational repositories, the likely remediation may be documentation, dependency updates, or clearly marking unsupported code rather than a production-style patch release.
