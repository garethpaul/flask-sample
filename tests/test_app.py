import unittest

from app import app, debug_enabled, host_name, port_number


class FlaskSampleTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

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

    def test_root_get_sets_content_security_policy(self):
        response = self.client.get("/")

        self.assertEqual(
            "default-src 'self'; frame-ancestors 'none'",
            response.headers.get("Content-Security-Policy"),
        )

    def test_root_post_is_not_allowed(self):
        response = self.client.post("/")

        self.assertEqual(405, response.status_code)

    def test_debug_flag_is_opt_in(self):
        self.assertFalse(debug_enabled(""))
        self.assertFalse(debug_enabled("0"))
        self.assertTrue(debug_enabled("1"))
        self.assertTrue(debug_enabled("true"))

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


if __name__ == "__main__":
    unittest.main()
