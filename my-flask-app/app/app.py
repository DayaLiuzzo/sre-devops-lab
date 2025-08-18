from flask import Flask, jsonify, Response
import humanize
import psutil
import os
from flask_cors import CORS
from prometheus_client import Counter, Gauge, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)
CORS(app)

# --- Prometheus metrics ---
REQUEST_COUNT = Counter('app_request_count', 'Total HTTP Requests', ['endpoint'])
MEMORY_TOTAL = Gauge('app_memory_total_bytes', 'Total system memory in bytes')
MEMORY_USED = Gauge('app_memory_used_bytes', 'Used system memory in bytes')
MEMORY_PERCENT = Gauge('app_memory_percent', 'Percentage of memory used')

# --- App routes ---
@app.route("/")
def hello():
    REQUEST_COUNT.labels(endpoint="/").inc()
    return "Hello, World!"

@app.route('/api/health')
def health():
    REQUEST_COUNT.labels(endpoint="/api/health").inc()
    return jsonify(status="healthy"), 200

@app.route('/api/status')
def status():
    REQUEST_COUNT.labels(endpoint="/api/status").inc()
    version = os.getenv("APP_VERSION", "unknown")
    memory = psutil.virtual_memory()

    # Update Prometheus gauges
    MEMORY_TOTAL.set(memory.total)
    MEMORY_USED.set(memory.used)
    MEMORY_PERCENT.set(memory.percent)

    status_info = {
        "status": "ok",
        "memory_total": humanize.naturalsize(memory.total),
        "memory_used": humanize.naturalsize(memory.used),
        "memory_percent": memory.percent,
        "version": version
    }
    return jsonify(status_info), 200

@app.route("/api/metrics")
def metrics():
    """Prometheus scrape endpoint"""
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)
