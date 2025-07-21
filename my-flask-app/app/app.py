from flask import Flask, jsonify
import humanize
import psutil
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World!"

@app.route('/health')
def health():
    return jsonify(status="healthy"), 200

@app.route('/status')
def status():
    version = os.getenv("APP_VERSION", "unknown")
    memory = psutil.virtual_memory()
    status_info = {
        "status": "ok",
        "memory_total": humanize.naturalsize(memory.total),
        "memory_used": humanize.naturalsize(memory.used),
        "memory_percent": memory.percent,
        "version": version
    }
    return jsonify(status_info), 200

