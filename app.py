from flask import Flask
from flask import render_template
from flask import request
import os
app = Flask(__name__)
app.static_dir = os.getcwd() + '/static'
app.debug = True

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