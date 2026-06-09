import os
from flask import Flask, render_template

app = Flask(__name__)
app.static_dir = os.path.join(os.getcwd(), "static")


def debug_enabled(value=None):
    raw_value = os.environ.get("FLASK_DEBUG", "") if value is None else value
    return raw_value.lower() in ("1", "true", "yes", "on")


def port_number(value=None, default=5000):
    raw_value = os.environ.get("PORT", str(default)) if value is None else value
    try:
        port = int(raw_value)
    except (TypeError, ValueError):
        return default

    if 1 <= port <= 65535:
        return port
    return default


app.debug = debug_enabled()


@app.route("/")
def hello():
    return render_template("hello.html")


if __name__ == "__main__":
    host = os.environ.get("FLASK_RUN_HOST", "127.0.0.1")
    port = port_number()
    app.run(host=host, port=port, debug=debug_enabled())
