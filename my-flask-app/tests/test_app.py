import pytest
import json
from app.app import app

@pytest.fixture
def client():
    """Create a test client for the Flask app."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_hello_route(client):
    """Test the hello route returns the expected message."""
    response = client.get('/')
    assert response.status_code == 200
    assert response.data.decode() == "Hello, World!"

def test_health_route(client):
    """Test the health check route."""
    response = client.get('/api/health')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'

def test_status_route(client):
    """Test the status route returns system information."""
    response = client.get('/api/status')
    assert response.status_code == 200
    data = json.loads(response.data)
    
    # Check that all expected fields are present
    assert 'status' in data
    assert 'memory_total' in data
    assert 'memory_used' in data
    assert 'memory_percent' in data
    assert 'version' in data
    
    # Check that status is ok
    assert data['status'] == 'ok'
    
    # Check that memory_percent is a number between 0 and 100
    assert isinstance(data['memory_percent'], (int, float))
    assert 0 <= data['memory_percent'] <= 100

def test_metrics_route(client):
    """Test the Prometheus /metrics endpoint."""
    response = client.get('/api/metrics')
    assert response.status_code == 200
    # Check that the content type is Prometheus plaintext
    assert response.content_type.startswith("text/plain")
    # Optionally check that some known metric is present
    assert b"app_request_count" in response.data or b"app_memory_total_bytes" in response.data
