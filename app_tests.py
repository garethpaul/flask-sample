import importlib
import os
import sys
import types
import unittest


class FakeFlask(object):
    def __init__(self, name):
        self.name = name
        self.debug = None
        self.routes = []
        self.static_dir = None

    def route(self, path):
        def decorator(func):
            self.routes.append((path, func))
            return func

        return decorator


def install_fake_flask():
    flask = types.ModuleType('flask')
    flask.Flask = FakeFlask
    flask.render_template = lambda template: template
    flask.request = types.SimpleNamespace(method='GET')
    sys.modules['flask'] = flask


def load_app():
    sys.modules.pop('app', None)
    install_fake_flask()
    return importlib.import_module('app')


class AppDebugTest(unittest.TestCase):
    def setUp(self):
        self.original_debug = os.environ.get('FLASK_SAMPLE_DEBUG')

    def tearDown(self):
        if self.original_debug is None:
            os.environ.pop('FLASK_SAMPLE_DEBUG', None)
        else:
            os.environ['FLASK_SAMPLE_DEBUG'] = self.original_debug
        sys.modules.pop('app', None)

    def test_debug_is_disabled_by_default(self):
        os.environ.pop('FLASK_SAMPLE_DEBUG', None)

        module = load_app()

        self.assertFalse(module.app.debug)

    def test_debug_requires_explicit_truthy_env(self):
        os.environ['FLASK_SAMPLE_DEBUG'] = 'yes'

        module = load_app()

        self.assertTrue(module.app.debug)

    def test_debug_rejects_falsey_env(self):
        os.environ['FLASK_SAMPLE_DEBUG'] = 'false'

        module = load_app()

        self.assertFalse(module.app.debug)


if __name__ == '__main__':
    unittest.main()
