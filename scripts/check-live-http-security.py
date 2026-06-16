#!/usr/bin/env python3
import sys
from pathlib import Path


def require(source: str, value: str, message: str) -> None:
    if value not in source:
        raise SystemExit(message)


def test_body(source: str, test_name: str) -> str:
    marker = "    def " + test_name + "(self):"
    start = source.find(marker)
    if start == -1:
        raise SystemExit("Live HTTP security test is missing: " + test_name)
    end = source.find("\n    def test_", start + len(marker))
    return source[start:] if end == -1 else source[start:end]


def main(test_path: Path, plan_path: Path) -> None:
    source = test_path.read_text(encoding="utf-8")
    live_test = test_body(
        source,
        "test_live_http_root_sets_every_managed_security_header",
    )
    live_static_test = test_body(
        source,
        "test_live_http_static_path_is_hardened_not_found_response",
    )
    plan = plan_path.read_text(encoding="utf-8")

    contracts = (
        (
            '"127.0.0.1",\n            0,\n            app,',
            "Live HTTP test must bind only to loopback on an ephemeral port.",
        ),
        (
            "request_handler=SilentRequestHandler",
            "Live HTTP test must keep routine access logs out of test output.",
        ),
        (
            "threading.Thread(target=server.serve_forever)",
            "Live HTTP test must run the WSGI server in a controlled thread.",
        ),
        (
            'client = HTTPConnection("127.0.0.1", server.server_port, timeout=2)',
            "Live HTTP client must connect directly to loopback with a bounded lifetime.",
        ),
        (
            'client.request("GET", "/")',
            "Live HTTP test must request the rendered root route.",
        ),
        ("client.close()", "Live HTTP test must close its client connection."),
        (
            "for header, expected_value in BASIC_SECURITY_HEADERS.items():",
            "Live HTTP test must cover every managed security header.",
        ),
        ("server.shutdown()", "Live HTTP test must stop the serving loop."),
        (
            "server_thread.join(timeout=2)",
            "Live HTTP test must bound thread cleanup.",
        ),
        ("server.server_close()", "Live HTTP test must close its listening socket."),
        (
            "self.assertFalse(server_thread.is_alive())",
            "Live HTTP test must prove the server thread stopped.",
        ),
    )
    for value, message in contracts:
        require(live_test, value, message)

    static_contracts = (
        ('client.request("GET", "/static/app.js")', "Live static test must request the disabled route."),
        ("self.assertEqual(404, response.status)", "Live static test must require a not-found response."),
        ("response.read()", "Live static test must consume the response body."),
        (
            "for header, expected_value in BASIC_SECURITY_HEADERS.items():",
            "Live static test must cover every managed security header.",
        ),
        ("client.close()", "Live static test must close its client connection."),
        ("server.shutdown()", "Live static test must stop the serving loop."),
        ("server_thread.join(timeout=2)", "Live static test must bound thread cleanup."),
        ("server.server_close()", "Live static test must close its listening socket."),
        (
            "self.assertFalse(server_thread.is_alive())",
            "Live static test must prove the server thread stopped.",
        ),
    )
    for value, message in static_contracts:
        require(live_static_test, value, message)

    require(
        source,
        "class SilentRequestHandler(WSGIRequestHandler):",
        "Live HTTP test must define its quiet request handler.",
    )

    for value in (
        "status: completed",
        "live HTTP",
        "hostile mutations were rejected",
        "make check",
    ):
        require(
            plan,
            value,
            "Live HTTP security plan must record completed verification: " + value,
        )


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("usage: check-live-http-security.py TEST_FILE PLAN_FILE")
    main(Path(sys.argv[1]), Path(sys.argv[2]))
