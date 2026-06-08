import os

from flask import Flask
from flask import render_template
from flask import request

DEBUG_ENV_VAR = 'FLASK_SAMPLE_DEBUG'
DEBUG_TRUE_VALUES = {'1', 'true', 'yes', 'on'}


def debug_enabled():
    return os.environ.get(DEBUG_ENV_VAR, '').lower() in DEBUG_TRUE_VALUES


app = Flask(__name__)
app.static_dir = os.getcwd() + '/static'
app.debug = debug_enabled()

@app.route("/")
def hello():
	if request.method == 'POST':
	    #post = request.args.get('data', '')
		return render_template('hello.html')
	else:
		#request.cookies.set('username', 'value')
		#username = request.cookies.get('username')
		#get = request.args.get('data', '')
		return render_template('hello.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
