import os
import logging
from logging.handlers import RotatingFileHandler
from flask import Flask, request

# --- App & Logger Configuration ---

# Initialize the Flask application
app = Flask(__name__)

# Define the log directory and ensure it exists
LOG_DIR = "/app/logs"
os.makedirs(LOG_DIR, exist_ok=True)

# Create a handler that writes logs to a rotating file
# This prevents log files from growing indefinitely
handler = RotatingFileHandler(
    os.path.join(LOG_DIR, "app.log"),
    maxBytes=10000,
    backupCount=5
)

# Define the format for each log entry to ensure consistent, readable logs
log_formatter = logging.Formatter(
    '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
)
handler.setFormatter(log_formatter)

# Configure the app's logger to use our handler and set the logging level
app.logger.setLevel(logging.INFO)
app.logger.addHandler(handler)


# --- Application Logic ---

@app.before_request
def log_request_info():
    app.logger.info('Incoming request: %s %s', request.method, request.path)

@app.route('/')
def hello_world():
    """Handle requests to the root URL."""
    app.logger.info("Hello World endpoint was accessed.")
    return 'Hello World!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)