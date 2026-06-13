import unittest
from importlib.metadata import version

from app import (
    BASIC_SECURITY_HEADERS,
    app,
    debug_allowed_for_host,
    debug_enabled,
    host_name,
    port_number,
    set_basic_security_headers,
    trusted_hosts,
)


class FlaskSampleTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_supported_flask_version_is_installed(self):
        release = tuple(int(part) for part in version("Flask").split(".")[:3])

        self.assertGreaterEqual(release, (3, 1, 3))
        self.assertLess(release, (3, 2, 0))

    def test_root_get_renders_hello_template(self):
        response = self.client.get("/")

        self.assertEqual(200, response.status_code)
        self.assertIn(b"Hello", response.data)

    def test_root_get_sets_basic_security_headers(self):
        response = self.client.get("/")

        self.assertEqual(
            "nosniff",
            response.headers.get("X-Content-Type-Options"),
        )
        self.assertEqual(
            "DENY",
            response.headers.get("X-Frame-Options"),
        )
        self.assertEqual(
            "no-referrer",
            response.headers.get("Referrer-Policy"),
        )
        self.assertEqual(
            "geolocation=(), microphone=(), camera=()",
            response.headers.get("Permissions-Policy"),
        )
        self.assertEqual(
            "same-origin",
            response.headers.get("Cross-Origin-Opener-Policy"),
        )
        self.assertEqual(
            "same-origin",
            response.headers.get("Cross-Origin-Resource-Policy"),
        )

    def test_security_header_hook_overrides_weaker_existing_values(self):
        response = app.response_class("Hello")
        for header in BASIC_SECURITY_HEADERS:
            response.headers[header] = "unsafe"

        hardened_response = set_basic_security_headers(response)

        self.assertIs(response, hardened_response)
        for header, expected_value in BASIC_SECURITY_HEADERS.items():
            self.assertEqual(expected_value, response.headers.get(header))

    def test_security_headers_cover_error_responses(self):
        responses = (
            (400, self.client.get("/", base_url="http://attacker.example")),
            (404, self.client.get("/missing")),
            (405, self.client.post("/")),
        )

        for expected_status, response in responses:
            with self.subTest(status=expected_status):
                self.assertEqual(expected_status, response.status_code)
                for header, expected_value in BASIC_SECURITY_HEADERS.items():
                    self.assertEqual(expected_value, response.headers.get(header))

    def test_root_get_sets_content_security_policy(self):
        response = self.client.get("/")

        self.assertEqual(
            "default-src 'none'; object-src 'none'; base-uri 'none'; "
            "form-action 'self'; frame-ancestors 'none'",
            response.headers.get("Content-Security-Policy"),
        )

    def test_root_post_is_not_allowed(self):
        response = self.client.post("/")

        self.assertEqual(405, response.status_code)

    def test_loopback_host_headers_are_trusted(self):
        for base_url in (
            "http://localhost:5000",
            "http://127.0.0.1:5000",
            "http://[::1]:5000",
        ):
            with self.subTest(base_url=base_url):
                response = self.client.get("/", base_url=base_url)
                self.assertEqual(200, response.status_code)

    def test_untrusted_host_header_is_rejected(self):
        for base_url in ("http://attacker.example", "http://0.0.0.0:5000"):
            with self.subTest(base_url=base_url):
                response = self.client.get("/", base_url=base_url)
                self.assertEqual(400, response.status_code)
                self.assertEqual(
                    "nosniff",
                    response.headers.get("X-Content-Type-Options"),
                )

    def test_trusted_hosts_include_validated_non_wildcard_bind_host(self):
        self.assertEqual(
            ["localhost", "127.0.0.1", "[::1]"],
            trusted_hosts("0.0.0.0"),
        )
        self.assertEqual(
            ["localhost", "127.0.0.1", "[::1]"],
            trusted_hosts("::"),
        )
        self.assertIn("example.com", trusted_hosts("example.com"))
        self.assertIn("[2001:db8::1]", trusted_hosts("2001:db8::1"))
        self.assertEqual(trusted_hosts(), app.config["TRUSTED_HOSTS"])

    def test_debug_flag_is_opt_in(self):
        self.assertFalse(debug_enabled(""))
        self.assertFalse(debug_enabled("0"))
        self.assertTrue(debug_enabled("1"))
        self.assertTrue(debug_enabled("true"))

    def test_debug_flag_normalizes_whitespace_and_case(self):
        self.assertTrue(debug_enabled(" TRUE "))
        self.assertTrue(debug_enabled("\ton\n"))
        self.assertFalse(debug_enabled(" false "))

    def test_debug_flag_requires_loopback_host(self):
        self.assertTrue(debug_allowed_for_host("127.0.0.1", "1"))
        self.assertTrue(debug_allowed_for_host("localhost", "true"))
        self.assertTrue(debug_allowed_for_host("::1", "yes"))
        self.assertFalse(debug_allowed_for_host("0.0.0.0", "1"))
        self.assertFalse(debug_allowed_for_host("example.com", "1"))
        self.assertFalse(debug_allowed_for_host("127.0.0.1", "0"))

    def test_invalid_port_values_fall_back_to_default(self):
        self.assertEqual(5000, port_number(""))
        self.assertEqual(5000, port_number("not-a-port"))
        self.assertEqual(5000, port_number("0"))
        self.assertEqual(5000, port_number("70000"))
        self.assertEqual(8080, port_number("8080"))

    def test_blank_host_values_fall_back_to_localhost(self):
        self.assertEqual("127.0.0.1", host_name(""))
        self.assertEqual("127.0.0.1", host_name("   "))
        self.assertEqual("0.0.0.0", host_name(" 0.0.0.0 "))

    def test_invalid_host_shapes_fall_back_to_localhost(self):
        self.assertEqual("127.0.0.1", host_name("http://127.0.0.1"))
        self.assertEqual("127.0.0.1", host_name("127.0.0.1:5000"))
        self.assertEqual("127.0.0.1", host_name("local/host"))
        self.assertEqual("localhost", host_name("localhost"))
        self.assertEqual("::1", host_name("::1"))


if __name__ == "__main__":
    unittest.main()
