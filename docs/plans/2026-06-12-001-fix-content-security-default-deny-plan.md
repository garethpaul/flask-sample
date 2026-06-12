---
title: Content Security Default Deny
type: fix
date: 2026-06-12
---

# Content Security Default Deny

## Summary

Change the Flask sample's Content Security Policy from a same-origin resource
default to a deny-by-default resource policy that matches the asset-free page.

## Problem Frame

`templates/hello.html` contains only static text, but `default-src 'self'`
allows same-origin scripts, styles, images, fonts, frames, and connections. The
sample can block those resource classes without changing rendered behavior.

## Requirements

- R1. Responses must set `default-src 'none'` as the CSP fallback.
- R2. Existing `object-src`, `base-uri`, `form-action`, and `frame-ancestors`
  restrictions must remain unchanged.
- R3. The root page must continue to render successfully without browser
  assets.
- R4. Tests and the source baseline must preserve the exact policy.
- R5. README, SECURITY, VISION, and CHANGES must document the default-deny
  resource posture.

## Key Technical Decisions

- **Use the CSP fallback instead of enumerating resource types:**
  `default-src 'none'` covers current and future fetch directives unless a
  deliberate exception is added.
- **Keep form submissions explicit:** `form-action 'self'` remains independent
  of `default-src` and preserves same-origin form behavior for future examples.
- **Keep an exact header assertion:** The sample has one fixed policy, so an
  exact test provides clearer regression protection than partial matching.

## Implementation Units

### U1. Deny subresources by default

- **Goal:** Replace the same-origin fallback with a no-resource fallback.
- **Files:** `app.py`, `tests/test_app.py`
- **Verification:** `python3 -m unittest discover -s tests -p "test*.py"`.

### U2. Preserve the hardened policy contract

- **Goal:** Require the new directive and plan from the static baseline.
- **Files:** `scripts/check-baseline.sh`
- **Verification:** `make check`.

### U3. Document deliberate CSP exceptions

- **Goal:** Explain that future assets require explicit directive updates.
- **Files:** `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`
- **Verification:** `make check` and `git diff --check`.

## Acceptance Examples

- AE1. Given a GET request to `/`, when the response is returned, then its CSP
  begins with `default-src 'none'`. Covers R1.
- AE2. Given the hardened response, when existing policy boundaries are
  inspected, then object, base, form, and framing directives remain present.
  Covers R2.
- AE3. Given the asset-free template, when `/` renders under the new policy,
  then the response remains HTTP 200 and contains `Hello`. Covers R3.

## Scope Boundaries

- Do not add external or same-origin assets.
- Do not add nonce, hash, or report-only CSP infrastructure.
- Do not change Flask dependency versions or route behavior.

## Risks And Mitigations

- Future assets will be blocked until explicitly allowed. Document that policy
  changes and asset additions must land together.
- Form behavior could be accidentally denied by the fallback. Retain the
  explicit `form-action 'self'` directive and exact header test.
