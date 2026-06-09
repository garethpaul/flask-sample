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
PERMISSIONS_HEADERS_PLAN="$ROOT_DIR/docs/plans/2026-06-09-permissions-policy-header.md"
PYTHON=${PYTHON:-python3}

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "app.py" \
  "requirements.txt" \
  "templates/hello.html" \
  "tests/test_app.py" \
  "docs/plans/2026-06-09-content-security-policy-header.md" \
  "docs/plans/2026-06-09-clickjacking-header.md" \
  "docs/plans/2026-06-09-permissions-policy-header.md" \
  "docs/plans/2026-06-09-flask-host-validation.md" \
  "docs/plans/2026-06-09-basic-security-headers.md" \
  "docs/plans/2026-06-09-flask-port-validation.md" \
  "docs/plans/2026-06-09-flask-get-only-root.md" \
  "docs/plans/2026-06-08-flask-sample-debug-baseline.md"; do
  require_file "$path"
done

"$PYTHON" -m py_compile "$ROOT_DIR/app.py" "$ROOT_DIR/tests/test_app.py"
"$PYTHON" -m unittest discover -s "$ROOT_DIR/tests" -p "test*.py"

if grep -Fq "app.debug = True" "$ROOT_DIR/app.py" ||
  grep -Fq "host='0.0.0.0'" "$ROOT_DIR/app.py" ||
  grep -Fq 'host="0.0.0.0"' "$ROOT_DIR/app.py"; then
  printf '%s\n' "Flask debug mode and public host binding must be opt-in." >&2
  exit 1
fi

if ! grep -Fq "FLASK_DEBUG" "$ROOT_DIR/app.py" ||
  ! grep -Fq "127.0.0.1" "$ROOT_DIR/app.py" ||
  ! grep -Fq '@app.route("/")' "$ROOT_DIR/app.py" ||
  grep -Fq 'methods=["GET", "POST"]' "$ROOT_DIR/app.py"; then
  printf '%s\n' "app.py must keep explicit local debug and GET-only root route behavior." >&2
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

if ! grep -Fq "default-src 'self'; frame-ancestors 'none'" "$ROOT_DIR/app.py" ||
  ! grep -Fq "test_root_get_sets_content_security_policy" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Flask responses must keep Content-Security-Policy coverage." >&2
  exit 1
fi

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
  ! grep -Fq "host = host_name()" "$ROOT_DIR/app.py"; then
  printf '%s\n' "FLASK_RUN_HOST parsing must use the validated host helper." >&2
  exit 1
fi

if ! grep -Fq "test_blank_host_values_fall_back_to_localhost" "$ROOT_DIR/tests/test_app.py" ||
  ! grep -Fq "0.0.0.0" "$ROOT_DIR/tests/test_app.py"; then
  printf '%s\n' "Tests must cover blank FLASK_RUN_HOST fallback and explicit overrides." >&2
  exit 1
fi

if ! grep -Fq "Flask>=2.2,<3" "$ROOT_DIR/requirements.txt"; then
  printf '%s\n' "requirements.txt must pin the Flask compatibility range." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FLASK_DEBUG" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Invalid \`PORT\` values fall back to \`5000\`" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Blank \`FLASK_RUN_HOST\` values fall back to \`127.0.0.1\`" "$ROOT_DIR/README.md" ||
  ! grep -Fq "GET-only" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Permissions-Policy" "$ROOT_DIR/README.md" ||
  ! grep -Fq "requirements.txt" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document setup, debug posture, GET-only route behavior, PORT fallback, and verification." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "debug mode" "$ROOT_DIR/VISION.md" ||
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

if ! grep -Fq "status: completed" "$PERMISSIONS_HEADERS_PLAN"; then
  printf '%s\n' "Permissions-Policy header plan must be marked completed." >&2
  exit 1
fi

printf '%s\n' "flask-sample debug baseline checks passed."
