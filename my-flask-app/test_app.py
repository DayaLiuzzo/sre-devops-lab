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
    response = client.get('/health')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'

def test_status_route(client):
    """Test the status route returns system information."""
    response = client.get('/status')
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

def test_fail():
    assert False, "This test should fail"