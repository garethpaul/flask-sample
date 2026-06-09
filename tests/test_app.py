import unittest

from app import app, debug_enabled, port_number


class FlaskSampleTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_root_get_renders_hello_template(self):
        response = self.client.get("/")

        self.assertEqual(200, response.status_code)
        self.assertIn(b"Hello", response.data)

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


if __name__ == "__main__":
    unittest.main()
