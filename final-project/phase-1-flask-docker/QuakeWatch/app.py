import logging
from flask import Flask
# Create logs directory and configure logging
logging.basicConfig(filename='/app/logs/app.log',
                    level=logging.INFO,
                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
