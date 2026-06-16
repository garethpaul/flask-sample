#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-flask-sample-debug-baseline.md"
GET_ONLY_PLAN="$ROOT_DIR/docs/plans/2026-06-09-flask-get-only-root.md"
PORT_PLAN="$ROOT_DIR/docs/plans/2026-06-09-flask-port-validation.md"
HOST_PLAN="$ROOT_DIR/docs/plans/2026-06-09-flask-host-validation.md"
HEADERS_PLAN="$ROOT_DIR/docs/plans/2026-06-09-basic-security-headers.md"
FRAME_HEADERS_PLAN="$ROOT_DIR/docs/plans/2026-06-09-clickjacking-header.md"
CSP_HEADERS_PLAN="$ROOT_DIR/docs/plans/2026-06-09-content-security-policy-header.md"
CSP_BOUNDARY_PLAN="$ROOT_DIR/docs/plans/2026-06-10-content-security-policy-boundaries.md"
CSP_DEFAULT_DENY_PLAN="$ROOT_DIR/docs/plans/2026-06-12-001-fix-content-security-default-deny-plan.md"
PERMISSIONS_HEADERS_PLAN="$ROOT_DIR/docs/plans/2026-06-09-permissions-policy-header.md"
HOST_SHAPE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-flask-host-shape-validation.md"
DEBUG_HOST_PLAN="$ROOT_DIR/docs/plans/2026-06-09-flask-loopback-debug-guard.md"
DEBUG_VALUE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-flask-debug-value-normalization.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-ci-baseline.md"
FLASK_31_PLAN="$ROOT_DIR/docs/plans/2026-06-12-flask-3-1-modernization.md"
TRUSTED_HOSTS_PLAN="$ROOT_DIR/docs/plans/2026-06-12-flask-trusted-hosts.md"
CONSTRAINTS_PLAN="$ROOT_DIR/docs/plans/2026-06-12-python-dependency-constraints.md"
PIP_BOOTSTRAP_PLAN="$ROOT_DIR/docs/plans/2026-06-12-pip-bootstrap-pin.md"
CROSS_ORIGIN_PLAN="$ROOT_DIR/docs/plans/2026-06-13-cross-origin-isolation-headers.md"
AUTHORITATIVE_HEADERS_PLAN="$ROOT_DIR/docs/plans/2026-06-13-authoritative-security-header-enforcement.md"
COMPLETE_ISOLATION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-complete-cross-origin-isolation.md"
LOCATION_INDEPENDENT_MAKE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-location-independent-make.md"
LIVE_HTTP_SECURITY_PLAN="$ROOT_DIR/docs/plans/2026-06-15-live-http-security-headers.md"
HASH_LOCK_PLAN="$ROOT_DIR/docs/plans/2026-06-16-hash-verified-dependency-lock.md"
STATIC_ROUTE_PLAN="$ROOT_DIR/docs/plans/2026-06-16-disable-unused-static-route.md"
LIVE_HTTP_SECURITY_CHECK="$ROOT_DIR/scripts/check-live-http-security.py"
PYTHON=${PYTHON:-python3}

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".github/workflows/check.yml" \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "app.py" \
  "constraints.txt" \
  "requirements.lock" \
  "requirements.txt" \
  "templates/hello.html" \
  "tests/test_app.py" \
  "scripts/check-live-http-security.py" \
  "docs/plans/2026-06-10-ci-baseline.md" \
  "docs/plans/2026-06-09-content-security-policy-header.md" \
  "docs/plans/2026-06-10-content-security-policy-boundaries.md" \
  "docs/plans/2026-06-12-001-fix-content-security-default-deny-plan.md" \
  "docs/plans/2026-06-12-flask-3-1-modernization.md" \
  "docs/plans/2026-06-12-flask-trusted-hosts.md" \
  "docs/plans/2026-06-12-python-dependency-constraints.md" \
  "docs/plans/2026-06-12-pip-bootstrap-pin.md" \
  "docs/plans/2026-06-13-cross-origin-isolation-headers.md" \
  "docs/plans/2026-06-13-authoritative-security-header-enforcement.md" \
  "docs/plans/2026-06-13-complete-cross-origin-isolation.md" \
  "docs/plans/2026-06-13-location-independent-make.md" \
  "docs/plans/2026-06-15-live-http-security-headers.md" \
  "docs/plans/2026-06-16-hash-verified-dependency-lock.md" \
  "docs/plans/2026-06-16-disable-unused-static-route.md" \
  "docs/plans/2026-06-09-flask-debug-value-normalization.md" \
  "docs/plans/2026-06-09-flask-loopback-debug-guard.md" \
  "docs/plans/2026-06-09-clickjacking-header.md" \
  "docs/plans/2026-06-09-flask-host-shape-validation.md" \
  "docs/plans/2026-06-09-permissions-policy-header.md" \
  "docs/plans/2026-06-09-flask-host-validation.md" \
  "docs/plans/2026-06-09-basic-security-headers.md" \
  "docs/plans/2026-06-09-flask-port-validation.md" \
  "docs/plans/2026-06-09-flask-get-only-root.md" \
  "docs/plans/2026-06-08-flask-sample-debug-baseline.md"; do
  require_file "$path"
done

"$PYTHON" "$LIVE_HTTP_SECURITY_CHECK" "$ROOT_DIR/tests/test_app.py" "$LIVE_HTTP_SECURITY_PLAN"

if ! grep -Fq 'app = Flask(__name__, static_folder=None)' "$ROOT_DIR/app.py" ||
  grep -Fq "app.static_dir" "$ROOT_DIR/app.py" ||
  grep -Fq "os.getcwd()" "$ROOT_DIR/app.py" ||
  ! grep -Fq "test_url_map_excludes_unused_static_endpoint" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq 'self.assertNotIn("static", endpoints)' "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "test_static_path_is_hardened_not_found_response" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "test_live_http_static_path_is_hardened_not_found_response" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Flask must disable and test the unused default static endpoint." >&2
  exit 1
fi

"$PYTHON" - "$STATIC_ROUTE_PLAN" <<'PY'
from pathlib import Path
import re
import sys

plan = Path(sys.argv[1]).read_text(encoding="utf-8")
frontmatter = plan.split("---", 2)[1]
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "focused static-route tests passed",
    "live HTTP static-route test passed",
    "all four Make gates passed",
    "absolute Makefile path passed",
    "six hostile mutations were rejected",
    "hosted pull-request check",
)
if (
    re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE) != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(value not in verification for value in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit("Static-route plan must retain completed verification evidence")
PY

if ! grep -Fq 'ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$ROOT_DIR/Makefile" ||
  ! grep -Fq '"$(ROOT)/scripts/check-baseline.sh"' "$ROOT_DIR/Makefile" ||
  ! grep -Fq 'cd "$(ROOT)" && $(PYTHON) -m unittest discover -s tests' "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile verification must resolve checker and test execution from the loaded Makefile." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "from /tmp" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "absolute Makefile path" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Made Flask verification independent" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Location-independent Make plan and guidance must record completed external verification." >&2
  exit 1
fi

"$PYTHON" -m py_compile "$ROOT_DIR/app.py" "$ROOT_DIR/tests/test_app.py"
(cd "$ROOT_DIR" && "$PYTHON" -m unittest discover -s tests -p "test*.py")

if grep -Fq "app.debug = True" "$ROOT_DIR/app.py" ||
  grep -Fq "host='0.0.0.0'" "$ROOT_DIR/app.py" ||
  grep -Fq 'host="0.0.0.0"' "$ROOT_DIR/app.py"; then
  printf '%s\n' "Flask debug mode and public host binding must be opt-in." >&2
  exit 1
fi

if ! grep -Fq 'LOOPBACK_TRUSTED_HOSTS = ("localhost", "127.0.0.1", "[::1]")' "$ROOT_DIR/app.py" ||
  ! grep -Fq 'WILDCARD_BIND_HOSTS = ("0.0.0.0", "::")' "$ROOT_DIR/app.py" ||
  ! grep -Fq "def trusted_hosts" "$ROOT_DIR/app.py" ||
  ! grep -Fq 'app.config["TRUSTED_HOSTS"] = trusted_hosts()' "$ROOT_DIR/app.py" ||
  ! grep -Fq 'configured_host = "[{}]".format(configured_host)' "$ROOT_DIR/app.py" ||
  ! grep -Fq "test_loopback_host_headers_are_trusted" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "test_untrusted_host_header_is_rejected" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq '"http://attacker.example"' "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq '"http://0.0.0.0:5000"' "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "test_trusted_hosts_include_validated_non_wildcard_bind_host" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Flask must validate request Host headers against loopback and configured non-wildcard hosts." >&2
  exit 1
fi

if ! grep -Fq "FLASK_DEBUG" "$ROOT_DIR/app.py" ||
  ! grep -Fq "str(raw_value).strip().lower()" "$ROOT_DIR/app.py" ||
  ! grep -Fq "debug_allowed_for_host" "$ROOT_DIR/app.py" ||
  ! grep -Fq "127.0.0.1" "$ROOT_DIR/app.py" ||
  ! grep -Fq '@app.route("/")' "$ROOT_DIR/app.py" ||
  grep -Fq 'methods=["GET", "POST"]' "$ROOT_DIR/app.py"; then
  printf '%s\n' "app.py must keep explicit local debug and GET-only root route behavior." >&2
  exit 1
fi

if ! grep -Fq "def debug_allowed_for_host" "$ROOT_DIR/app.py" ||
  ! grep -Fq ".is_loopback" "$ROOT_DIR/app.py" ||
  ! grep -Fq 'host == "localhost"' "$ROOT_DIR/app.py" ||
  ! grep -Fq "app.debug = debug_allowed_for_host(host_name())" "$ROOT_DIR/app.py" ||
  ! grep -Fq "debug=debug_allowed_for_host(host)" "$ROOT_DIR/app.py" ||
  ! grep -Fq "test_debug_flag_requires_loopback_host" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "example.com" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Flask debug mode must remain loopback-only when enabled." >&2
  exit 1
fi

if ! grep -Fq "test_debug_flag_normalizes_whitespace_and_case" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq '" TRUE "' "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq '" false "' "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Tests must cover FLASK_DEBUG value normalization." >&2
  exit 1
fi

if ! grep -Fq "test_root_post_is_not_allowed" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "405" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Route tests must assert unsupported POST requests are rejected." >&2
  exit 1
fi

if ! grep -Fq "@app.after_request" "$ROOT_DIR/app.py" ||
  ! grep -Fq "Content-Security-Policy" "$ROOT_DIR/app.py" ||
  ! grep -Fq "Permissions-Policy" "$ROOT_DIR/app.py" ||
  ! grep -Fq "geolocation=(), microphone=(), camera=()" "$ROOT_DIR/app.py" ||
  ! grep -Fq "X-Content-Type-Options" "$ROOT_DIR/app.py" ||
  ! grep -Fq "X-Frame-Options" "$ROOT_DIR/app.py" ||
  ! grep -Fq "Referrer-Policy" "$ROOT_DIR/app.py" ||
  ! grep -Fq "test_root_get_sets_basic_security_headers" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Flask responses must keep basic security headers and test coverage." >&2
  exit 1
fi

python3 - "$ROOT_DIR/app.py" "$ROOT_DIR/tests/test_app.py" <<'PY'
import sys
from pathlib import Path

app_source = Path(sys.argv[1]).read_text()
test_source = Path(sys.argv[2]).read_text()

header_map = app_source.split("BASIC_SECURITY_HEADERS = {", 1)[-1].split(
    "\n}\n\nHOST_LABEL", 1
)[0]
required_entries = (
    '"Cross-Origin-Embedder-Policy": "require-corp"',
    '"Cross-Origin-Opener-Policy": "same-origin"',
    '"Cross-Origin-Resource-Policy": "same-origin"',
)
if any(header_map.count(entry) != 1 for entry in required_entries):
    raise SystemExit("Flask must keep the exact embedder, opener, and resource policies in the shared header map.")
after_request = app_source.split("@app.after_request", 1)[-1].split("@app.route", 1)[0]
required_hook_contracts = (
    "def set_basic_security_headers(response)",
    "for header, value in BASIC_SECURITY_HEADERS.items()",
    "response.headers[header] = value",
    "return response",
)
if any(after_request.count(item) != 1 for item in required_hook_contracts):
    raise SystemExit("Flask security headers must be assigned authoritatively at the shared boundary.")
if "response.headers.setdefault" in app_source:
    raise SystemExit("Flask security headers must not preserve weaker preexisting values.")

if "BASIC_SECURITY_HEADERS," not in test_source:
    raise SystemExit("Route tests must import the complete security-header map.")
root_header_test = test_source.split(
    "def test_root_get_sets_basic_security_headers", 1
)[-1].split("\n    def ", 1)[0]
required_root_isolation_contracts = (
    '"require-corp"',
    'response.headers.get("Cross-Origin-Embedder-Policy")',
)
if any(item not in root_header_test for item in required_root_isolation_contracts):
    raise SystemExit("The root response test must assert the exact embedder policy.")
error_test = test_source.split("def test_security_headers_cover_error_responses", 1)[-1].split(
    "\n    def ", 1
)[0]
required_test_contracts = (
    '(400, self.client.get("/", base_url="http://attacker.example"))',
    '(404, self.client.get("/missing"))',
    '(405, self.client.post("/"))',
    "for header, expected_value in BASIC_SECURITY_HEADERS.items()",
    "self.assertEqual(expected_value, response.headers.get(header))",
)
if any(item not in error_test for item in required_test_contracts):
    raise SystemExit("Route tests must preserve full security-header coverage for 400, 404, and 405 responses.")

override_name = "def test_security_header_hook_overrides_weaker_existing_values"
if test_source.count(override_name) != 1:
    raise SystemExit("Route tests must keep one authoritative-header override regression.")
override_test = test_source.split(
    override_name, 1
)[-1].split("\n    def ", 1)[0]
required_override_contracts = (
    "for header in BASIC_SECURITY_HEADERS:",
    'response.headers[header] = "unsafe"',
    "hardened_response = set_basic_security_headers(response)",
    "self.assertIs(response, hardened_response)",
    "for header, expected_value in BASIC_SECURITY_HEADERS.items()",
    "self.assertEqual(expected_value, response.headers.get(header))",
)
if any(item not in override_test for item in required_override_contracts):
    raise SystemExit(
        "Route tests must prove the shared hook replaces every weaker managed header."
    )
PY

if ! grep -Fq "default-src 'none'" "$ROOT_DIR/app.py" ||
  ! grep -Fq "object-src 'none'" "$ROOT_DIR/app.py" ||
  ! grep -Fq "base-uri 'none'" "$ROOT_DIR/app.py" ||
  ! grep -Fq "form-action 'self'" "$ROOT_DIR/app.py" ||
  ! grep -Fq "frame-ancestors 'none'" "$ROOT_DIR/app.py" ||
  ! grep -Fq "test_root_get_sets_content_security_policy" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Flask responses must keep Content-Security-Policy coverage." >&2
  exit 1
fi

if ! grep -Fq "Content Security Default Deny" "$CSP_DEFAULT_DENY_PLAN" ||
  ! grep -Fq "make check" "$CSP_DEFAULT_DENY_PLAN"; then
  printf '%s\n' "Default-deny CSP plan must document repository verification." >&2
  exit 1
fi

for document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md"; do
  if ! grep -Fq "default-deny subresource policy" "$document"; then
    printf '%s\n' "$document must document the default-deny subresource policy." >&2
    exit 1
  fi
done

if ! grep -Fq "lint: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "test:" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "build: check" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose lint, test, and build gates." >&2
  exit 1
fi

if ! grep -Fq '"DENY"' "$ROOT_DIR/app.py" ||
  ! grep -Fq 'response.headers.get("X-Frame-Options")' "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Flask responses must keep the clickjacking protection header and test coverage." >&2
  exit 1
fi

if ! grep -Fq "def port_number" "$ROOT_DIR/app.py" ||
  grep -Fq "int(os.environ.get(\"PORT\"" "$ROOT_DIR/app.py" ||
  ! grep -Fq "port = port_number()" "$ROOT_DIR/app.py"; then
  printf '%s\n' "PORT parsing must use the validated port helper." >&2
  exit 1
fi

if ! grep -Fq "test_invalid_port_values_fall_back_to_default" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "70000" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Tests must cover invalid and out-of-range PORT values." >&2
  exit 1
fi

if ! grep -Fq "def host_name" "$ROOT_DIR/app.py" ||
  grep -Fq 'os.environ.get("FLASK_RUN_HOST", "127.0.0.1")' "$ROOT_DIR/app.py" ||
  ! grep -Fq "raw_value.strip()" "$ROOT_DIR/app.py" ||
  ! grep -Fq "ipaddress.ip_address(host)" "$ROOT_DIR/app.py" ||
  ! grep -Fq "HOST_LABEL.match(label)" "$ROOT_DIR/app.py" ||
  ! grep -Fq "host = host_name()" "$ROOT_DIR/app.py"; then
  printf '%s\n' "FLASK_RUN_HOST parsing must use the validated host helper." >&2
  exit 1
fi

if ! grep -Fq "test_blank_host_values_fall_back_to_localhost" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "test_invalid_host_shapes_fall_back_to_localhost" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "127.0.0.1:5000" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "http://127.0.0.1" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "0.0.0.0" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Tests must cover blank FLASK_RUN_HOST fallback and explicit overrides." >&2
  exit 1
fi

if ! grep -Fxq "Flask>=3.1.3,<3.2" "$ROOT_DIR/requirements.txt" ||
  ! grep -Fq "test_supported_flask_version_is_installed" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq 'version("Flask")' "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "requirements.txt and tests must require the patched Flask 3.1 line." >&2
  exit 1
fi

expected_constraints='# Reviewed CI resolution for Python 3.10, 3.12, and 3.14.
blinker==1.9.0
click==8.4.1
Flask==3.1.3
itsdangerous==2.2.0
Jinja2==3.1.6
MarkupSafe==3.0.3
Werkzeug==3.1.8'
actual_constraints=$(cat "$ROOT_DIR/constraints.txt")
if [ "$actual_constraints" != "$expected_constraints" ]; then
  printf '%s\n' "constraints.txt must match the reviewed cross-version Flask graph exactly." >&2
  exit 1
fi

python3 - "$ROOT_DIR/constraints.txt" "$ROOT_DIR/requirements.lock" <<'PY'
import hashlib
import re
import sys
from pathlib import Path


def normalize(name):
    return re.sub(r"[-_.]+", "-", name).lower()


constraints = {}
for line in Path(sys.argv[1]).read_text().splitlines():
    line = line.strip()
    if not line or line.startswith("#"):
        continue
    name, version = line.split("==", 1)
    constraints[normalize(name)] = version

lock_text = Path(sys.argv[2]).read_text()
expected_lock_sha256 = "a36c01fae3da0af4ae4dcafe415cc7f38a5143b17f5ff6a6c3bc5e66bc8bc3ce"
if hashlib.sha256(lock_text.encode()).hexdigest() != expected_lock_sha256:
    raise SystemExit("requirements.lock must match the reviewed universal artifact set exactly.")
if any(token in lock_text.lower() for token in ("--index-url", "--extra-index-url", "--trusted-host", "http://", "https://")):
    raise SystemExit("requirements.lock must not embed package index or network locations.")

entries = []
current = ""
for raw_line in lock_text.splitlines():
    line = raw_line.strip()
    if not line or line.startswith("#"):
        continue
    current = f"{current} {line}".strip()
    if current.endswith("\\"):
        current = current[:-1].rstrip()
        continue
    entries.append(current)
    current = ""
if current:
    raise SystemExit("requirements.lock ends with an incomplete continuation.")

locked = {}
markers = {}
for entry in entries:
    match = re.match(r"^([A-Za-z0-9_.-]+)==([^ ;]+)(?:\s*;\s*([^\\]+?))?\s+--hash=", entry)
    if not match:
        raise SystemExit(f"Unparseable hash-locked requirement: {entry}")
    name = normalize(match.group(1))
    if name in locked:
        raise SystemExit(f"Duplicate locked requirement: {name}")
    hashes = re.findall(r"--hash=sha256:([0-9a-f]{64})(?:\s|$)", entry)
    if not hashes or len(hashes) != len(set(hashes)):
        raise SystemExit(f"Locked requirement must have unique SHA-256 hashes: {name}")
    locked[name] = match.group(2)
    markers[name] = (match.group(3) or "").strip()

expected = dict(constraints)
expected["colorama"] = "0.4.6"
if locked != expected:
    raise SystemExit(f"requirements.lock graph mismatch: expected {expected}, found {locked}")
if markers["colorama"] != "sys_platform == 'win32'":
    raise SystemExit("colorama must remain restricted to the Windows marker.")
if any(markers[name] for name in constraints):
    raise SystemExit("Reviewed cross-platform constraints must not gain environment markers.")
PY

if ! grep -Fq "workflow_dispatch:" "$CI_WORKFLOW" ||
  ! grep -Fq "cancel-in-progress: true" "$CI_WORKFLOW" ||
  ! grep -Fq "runs-on: ubuntu-24.04" "$CI_WORKFLOW" ||
  ! grep -Fq "timeout-minutes: 10" "$CI_WORKFLOW" ||
  ! grep -Fq 'python-version: ["3.10", "3.12", "3.14"]' "$CI_WORKFLOW" ||
  ! grep -Fq "actions/setup-python@a309ff8b426b58ec0e2a45f0f869d46889d02405" "$CI_WORKFLOW" ||
  ! grep -Fq "python -m pip install --upgrade pip==26.1.2" "$CI_WORKFLOW" ||
  ! grep -Fq "python -m pip install --require-hashes -r requirements.lock" "$CI_WORKFLOW" ||
  ! grep -Fq "cache-dependency-path:" "$CI_WORKFLOW" ||
  ! grep -Fq "constraints.txt" "$CI_WORKFLOW" ||
  ! grep -Fq "requirements.lock" "$CI_WORKFLOW" ||
  ! grep -Fq "python -m pip check" "$CI_WORKFLOW" ||
  ! grep -Fq "make check" "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must keep the pinned multi-version Flask check contract." >&2
  exit 1
fi

python3 - "$CI_WORKFLOW" <<'PY'
import sys
from pathlib import Path

workflow = Path(sys.argv[1]).read_text()
bootstrap = "python -m pip install --upgrade pip==26.1.2"
install = "python -m pip install --require-hashes -r requirements.lock"
cache_block = """          cache-dependency-path: |
            requirements.txt
            constraints.txt
            requirements.lock"""
if workflow.count(bootstrap) != 1:
    raise SystemExit("GitHub Actions must bootstrap exactly one pinned pip version.")
if "python -m pip install --upgrade pip\n" in workflow:
    raise SystemExit("GitHub Actions must not resolve a floating pip upgrade.")
if workflow.count("python -m pip install --upgrade pip") != 1:
    raise SystemExit("GitHub Actions must not add duplicate or alternate pip bootstraps.")
if workflow.count(install) != 1 or workflow.count(cache_block) != 1:
    raise SystemExit(
        "GitHub Actions must install once through the hash lock and cache all dependency files."
    )
PY

if ! grep -Fq "status: completed" "$PIP_BOOTSTRAP_PLAN" ||
  ! grep -Fq "pip==26.1.2" "$PIP_BOOTSTRAP_PLAN" ||
  ! grep -Fq "Local Make gates" "$PIP_BOOTSTRAP_PLAN" ||
  ! grep -Fq "external-working-directory checker passed" "$PIP_BOOTSTRAP_PLAN" ||
  ! grep -Fq "hostile mutations rejected" "$PIP_BOOTSTRAP_PLAN"; then
  printf '%s\n' "Pip bootstrap plan must record completed status and verification." >&2
  exit 1
fi

if ! grep -Fq "pip 26.1.2" "$ROOT_DIR/README.md" ||
  ! grep -Fq "pinned installer bootstrap" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "exact pip bootstrap" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Pinned the hosted pip bootstrap" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Repository guidance must document the pinned pip bootstrap boundary." >&2
  exit 1
fi

hash_lock_completed_statuses=$(grep -c '^Status: Completed$' "$HASH_LOCK_PLAN" || true)
hash_lock_all_statuses=$(grep -c '^Status:' "$HASH_LOCK_PLAN" || true)
hash_lock_verification=$(awk '
  /^## Verification Results$/ { in_verification = 1; next }
  in_verification && /^## / { exit }
  in_verification { print }
' "$HASH_LOCK_PLAN")
if [ "$hash_lock_completed_statuses" -ne 1 ] || [ "$hash_lock_all_statuses" -ne 1 ]; then
  printf '%s\n' "Hash-lock plan must record exactly one completed status." >&2
  exit 1
fi
for hash_lock_evidence in \
  'Python 3.12' \
  'Python 3.14' \
  'external-directory `make check`' \
  'hostile mutations'; do
  if ! printf '%s\n' "$hash_lock_verification" | grep -Fq "$hash_lock_evidence"; then
    printf '%s\n' "Hash-lock plan must record completed verification: $hash_lock_evidence" >&2
    exit 1
  fi
done
hash_lock_guidance='`requirements.lock` is the universal hash-verified install graph; pip must consume it with `--require-hashes`.'
for hash_lock_doc in AGENTS.md README.md SECURITY.md VISION.md CHANGES.md; do
  if ! grep -Fq "$hash_lock_guidance" "$ROOT_DIR/$hash_lock_doc"; then
    printf '%s\n' "$hash_lock_doc must document the hash-verified dependency lock." >&2
    exit 1
  fi
done
if printf '%s\n' "$hash_lock_verification" | grep -Eiq '(^|[^[:alnum:]_])(pending|todo|tbd|not run)([^[:alnum:]_]|$)'; then
  printf '%s\n' "Hash-lock verification must not contain placeholders." >&2
  exit 1
fi

if [ "$(grep -Ec '^[[:space:]]+(-[[:space:]]+)?uses: actions/checkout@' "$CI_WORKFLOW")" -ne 1 ]; then
  printf '%s\n' "GitHub Actions must contain exactly one checkout step." >&2
  exit 1
fi

if ! awk '
  function finish_step() {
    if (checkout) {
      checkout_count++
      if (persist_credentials) {
        secure_checkout_count++
      }
    }
    checkout = 0
    with_block = 0
    persist_credentials = 0
  }

  /^      - / {
    finish_step()
  }

  /^        uses: actions\/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10([[:space:]]+#.*)?$/ {
    checkout = 1
  }

  /^      - uses: actions\/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10([[:space:]]+#.*)?$/ {
    checkout = 1
  }

  checkout && /^        with:$/ {
    with_block = 1
  }

  checkout && with_block && /^          persist-credentials: false$/ {
    persist_credentials = 1
  }

  END {
    finish_step()
    exit !(checkout_count == 1 && secure_checkout_count == 1)
  }
' "$CI_WORKFLOW"; then
  printf '%s\n' "The pinned checkout step must disable persisted credentials." >&2
  exit 1
fi

if ! awk '
  /^permissions:$/ {
    permissions_count++
    in_permissions = 1
    next
  }

  in_permissions && /^[^[:space:]]/ {
    in_permissions = 0
  }

  in_permissions && /^  contents: read$/ {
    contents_read++
    next
  }

  in_permissions && /^  [[:alnum:]_-]+:/ {
    unexpected_permission++
  }

  END {
    exit !(permissions_count == 1 && contents_read == 1 && unexpected_permission == 0)
  }
' "$CI_WORKFLOW" ||
  grep -Eq '^[[:space:]]+permissions:' "$CI_WORKFLOW" ||
  grep -Eq '^[[:space:]]*permissions:[[:space:]]*write-all([[:space:]]*(#.*)?)?$' "$CI_WORKFLOW" ||
  grep -Eq '^[[:space:]]+[[:alnum:]_-]+:[[:space:]]*write([[:space:]]*(#.*)?)?$' "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must grant only top-level read access to repository contents." >&2
  exit 1
fi

if ! grep -Fq "does not persist checkout credentials" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the credential-free checkout boundary." >&2
  exit 1
fi

if ! grep -Fq "read-only repository permissions" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq 'Dependency manifests detected: `requirements.txt`, `constraints.txt`, and `requirements.lock`.' "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Python 3.10, 3.12, and 3.14" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "docs/plans/2026-06-10-ci-baseline.md" "$ROOT_DIR/README.md"; then
  printf '%s\n' "Project docs must record the hosted Python compatibility baseline." >&2
  exit 1
fi

if ! grep -Fq "authoritatively replaces weaker" "$ROOT_DIR/README.md" ||
  ! grep -Fq "replace weaker preexisting values" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "authoritatively replaces weaker preexisting" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Made the shared response hook replace weaker" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "shared response hook authoritative" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Repository guidance must document authoritative security-header assignment." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FLASK_DEBUG" "$ROOT_DIR/README.md" ||
  ! grep -Fq "case-normalized" "$ROOT_DIR/README.md" ||
  ! grep -Fq "loopback" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Invalid \`PORT\` values fall back to \`5000\`" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Blank \`FLASK_RUN_HOST\` values fall back to \`127.0.0.1\`" "$ROOT_DIR/README.md" ||
  ! grep -Fq "GET-only" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Permissions-Policy" "$ROOT_DIR/README.md" ||
  ! grep -Fq "requirements.txt" "$ROOT_DIR/README.md" ||
  ! grep -Fq "constraints.txt" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document setup, debug posture, GET-only route behavior, PORT fallback, and verification." >&2
  exit 1
fi

if ! grep -Fq "embedder, opener, and resource policies" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Embedder, opener, and resource policies" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "embedder, opener, and resource policies" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "embedder, opener, and resource policies" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Cross-Origin-Embedder-Policy" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Repository guidance must document the complete cross-origin isolation boundary." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "debug mode" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "case-normalized" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "loopback" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Invalid \`PORT\` values fall back to 5000" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Blank \`FLASK_RUN_HOST\` values fall back to 127.0.0.1" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "GET-only" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current Flask debug, route, and port baseline." >&2
  exit 1
fi

if ! grep -Fq ".venv/" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq "__pycache__/" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' "Python local environment and cache files must stay ignored." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$FLASK_31_PLAN" ||
  ! grep -Fq "make check" "$FLASK_31_PLAN"; then
  printf '%s\n' "Flask 3.1 modernization plan must remain completed with verification recorded." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TRUSTED_HOSTS_PLAN" ||
  ! grep -Fq "make check" "$TRUSTED_HOSTS_PLAN"; then
  printf '%s\n' "Flask trusted hosts plan must remain completed with verification recorded." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$GET_ONLY_PLAN"; then
  printf '%s\n' "GET-only route plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PORT_PLAN"; then
  printf '%s\n' "PORT validation plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$HOST_PLAN"; then
  printf '%s\n' "Host validation plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$HEADERS_PLAN"; then
  printf '%s\n' "Basic security headers plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$FRAME_HEADERS_PLAN"; then
  printf '%s\n' "Clickjacking header plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CSP_HEADERS_PLAN"; then
  printf '%s\n' "Content-Security-Policy header plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CSP_BOUNDARY_PLAN"; then
  printf '%s\n' "Content-Security-Policy boundary plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PERMISSIONS_HEADERS_PLAN"; then
  printf '%s\n' "Permissions-Policy header plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$HOST_SHAPE_PLAN"; then
  printf '%s\n' "Host shape validation plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$DEBUG_HOST_PLAN"; then
  printf '%s\n' "Loopback debug guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$DEBUG_HOST_PLAN"; then
  printf '%s\n' "Loopback debug guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$DEBUG_VALUE_PLAN"; then
  printf '%s\n' "Debug value normalization plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$DEBUG_VALUE_PLAN"; then
  printf '%s\n' "Debug value normalization plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CI_PLAN" ||
  ! grep -Fq "GitHub Actions" "$CI_PLAN" ||
  ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must record completed status and make check verification." >&2
  exit 1
fi

python3 - "$TRUSTED_HOSTS_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "all 14 tests",
    "push run `27392343275`",
    "pull-request run `27392347000`",
    "push run `27392361353`",
    "CodeQL run `27402320555`",
)

if (
    statuses != ["status: completed"]
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Flask trusted-hosts plan must remain completed with actual verification recorded."
    )
PY

python3 - "$CONSTRAINTS_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "31b4b6f562cd66dfa25fd2cd5b8aaca23d41b5f4",
    "27436608774",
    "27436618916",
    "27436616718",
)

if (
    statuses != ["status: completed"]
    or "all Make gates" not in verification
    or "hostile constraints mutations" not in verification
    or any(item not in verification for item in required)
    or re.search(
        r"\b(?:pending|todo|tbd|not run|will be appended|not final)\b",
        verification,
        re.IGNORECASE,
    )
):
    raise SystemExit(
        "Python constraints plan must remain completed with actual verification recorded."
    )
PY

python3 - "$CROSS_ORIGIN_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
required = (
    "missing header mutation failed",
    "weakened value mutation failed",
    "error matrix mutation failed",
    "hosted pull-request check",
)

if statuses != ["status: completed"] or any(item not in plan for item in required):
    raise SystemExit(
        "Cross-origin isolation plan must record completed status and actual verification."
    )
PY

python3 - "$AUTHORITATIVE_HEADERS_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
required = (
    "setdefault mutation failed",
    "weak-value setup mutation failed",
    "map-iteration mutation failed",
    "final-assertion mutation failed",
    "hosted pull-request check",
)

if statuses != ["status: completed"] or any(item not in plan for item in required):
    raise SystemExit(
        "Authoritative security-header plan must record completed status and actual verification."
    )
PY

python3 - "$COMPLETE_ISOLATION_PLAN" <<'PY'
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
required = (
    "status: completed",
    "## Work Completed",
    "## Verification Completed",
    "Cross-Origin-Embedder-Policy: require-corp",
    "focused embedder-policy tests passed",
    "make check`, `make lint`, `make test`, and `make build` passed",
    "missing-policy mutation failed",
    "weakened-value mutation failed",
    "success-assertion mutation failed",
    "error-coverage mutation failed",
    "plan-evidence mutation failed",
    "bounded exact-head hosted verification",
)
if any(item not in plan for item in required):
    raise SystemExit(
        "Complete cross-origin isolation plan must record completed status and verification."
    )
verification = plan.split("## Verification Completed\n", 1)[-1]
if "Pending" in verification:
    raise SystemExit("Complete cross-origin isolation verification must not remain pending.")
PY

printf '%s\n' "flask-sample debug baseline checks passed."
