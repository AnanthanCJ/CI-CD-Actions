import os
import socket
from datetime import datetime, timezone

from flask import Flask, jsonify

app = Flask(__name__)

APP_VERSION = os.environ.get("APP_VERSION", "dev")


@app.route("/")
def index():
    return jsonify(
        message="Hello from the CI/CD sample app",
        version=APP_VERSION,
        hostname=socket.gethostname(),
        time=datetime.now(timezone.utc).isoformat(),
    )


@app.route("/health")
def health():
    return jsonify(status="ok"), 200


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "5000"))
    app.run(host="0.0.0.0", port=port)
