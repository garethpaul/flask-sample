#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-flask-sample-debug-baseline.md"
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
  ! grep -Fq 'methods=["GET", "POST"]' "$ROOT_DIR/app.py"; then
  printf '%s\n' "app.py must keep explicit local debug and route behavior." >&2
  exit 1
fi

if ! grep -Fq "Flask>=2.2,<3" "$ROOT_DIR/requirements.txt"; then
  printf '%s\n' "requirements.txt must pin the Flask compatibility range." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FLASK_DEBUG" "$ROOT_DIR/README.md" ||
  ! grep -Fq "requirements.txt" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document setup, debug posture, and verification." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "debug mode" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current Flask debug baseline." >&2
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

printf '%s\n' "flask-sample debug baseline checks passed."
