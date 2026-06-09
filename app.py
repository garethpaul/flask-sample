import ipaddress
import os
import re
from flask import Flask, render_template

app = Flask(__name__)
app.static_dir = os.path.join(os.getcwd(), "static")

BASIC_SECURITY_HEADERS = {
    "Content-Security-Policy": "default-src 'self'; frame-ancestors 'none'",
    "Permissions-Policy": "geolocation=(), microphone=(), camera=()",
    "X-Content-Type-Options": "nosniff",
    "X-Frame-Options": "DENY",
    "Referrer-Policy": "no-referrer",
}

HOST_LABEL = re.compile(r"^[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?$")


def debug_enabled(value=None):
    raw_value = os.environ.get("FLASK_DEBUG", "") if value is None else value
    normalized_value = str(raw_value).strip().lower()
    return normalized_value in ("1", "true", "yes", "on")


def debug_allowed_for_host(host, value=None):
    if not debug_enabled(value):
        return False

    try:
        return ipaddress.ip_address(host).is_loopback
    except ValueError:
        return host == "localhost"


def port_number(value=None, default=5000):
    raw_value = os.environ.get("PORT", str(default)) if value is None else value
    try:
        port = int(raw_value)
    except (TypeError, ValueError):
        return default

    if 1 <= port <= 65535:
        return port
    return default


def host_name(value=None, default="127.0.0.1"):
    raw_value = os.environ.get("FLASK_RUN_HOST", default) if value is None else value
    host = raw_value.strip()
    if not host:
        return default

    try:
        ipaddress.ip_address(host)
        return host
    except ValueError:
        pass

    if host.endswith(".") or len(host) > 253:
        return default

    labels = host.split(".")
    if all(HOST_LABEL.match(label) for label in labels):
        return host

    return default


app.debug = debug_allowed_for_host(host_name())


@app.after_request
def set_basic_security_headers(response):
    for header, value in BASIC_SECURITY_HEADERS.items():
        response.headers.setdefault(header, value)
    return response


@app.route("/")
def hello():
    return render_template("hello.html")


if __name__ == "__main__":
    host = host_name()
    port = port_number()
    app.run(host=host, port=port, debug=debug_allowed_for_host(host))
