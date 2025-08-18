import logo from './logo.svg';
import './App.css';
import { useState, useEffect } from 'react';

function App() {
  const [statusData, setStatusData] = useState(null);
  const [healthData, setHealthData] = useState(null);
  const [statusLoading, setStatusLoading] = useState(true);
  const [healthLoading, setHealthLoading] = useState(true);
  const [statusError, setStatusError] = useState(null);
  const [healthError, setHealthError] = useState(null);

  // Safe access to window._env_ with fallbacks
  const env = window._env_ || {};
  const apiUrl = env.API_URL || 'Unkown ApiUrl';
  const appName = env.APP_NAME || 'Unknown App';
  const podName = env.POD_NAME || 'Unknown Pod';

  useEffect(() => {
    // Fetch status endpoint
    const fetchStatus = async () => {
      try {
        setStatusLoading(true);
        const response = await fetch(`${apiUrl}/status`);
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setStatusData(data);
        setStatusError(null);
      } catch (error) {
        setStatusError(error.message);
        setStatusData(null);
      } finally {
        setStatusLoading(false);
      }
    };

    // Fetch health endpoint
    const fetchHealth = async () => {
      try {
        setHealthLoading(true);
        const response = await fetch(`${apiUrl}/health`);
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setHealthData(data);
        setHealthError(null);
      } catch (error) {
        setHealthError(error.message);
        setHealthData(null);
      } finally {
        setHealthLoading(false);
      }
    };

    fetchStatus();
    fetchHealth();

    // Set up polling every 30 seconds
    const interval = setInterval(() => {
      fetchStatus();
      fetchHealth();
    }, 30000);

    return () => clearInterval(interval);
  }, [apiUrl]);

  const renderStatusCard = () => {
    if (statusLoading) {
      return <div className="loading">Loading...</div>;
    }
    
    if (statusError) {
      return <div className="error">Error: {statusError}</div>;
    }

    if (statusData) {
      return (
        <div className="status-content">
          <div className="status-item">
            <span className="label">Status:</span>
            <span className={`value ${statusData.status === 'ok' ? 'success' : 'error'}`}>
              {statusData.status}
            </span>
          </div>
          <div className="status-item">
            <span className="label">Version:</span>
            <span className="value">{statusData.version}</span>
          </div>
          <div className="status-item">
            <span className="label">Memory Total:</span>
            <span className="value">{statusData.memory_total}</span>
          </div>
          <div className="status-item">
            <span className="label">Memory Used:</span>
            <span className="value">{statusData.memory_used}</span>
          </div>
          <div className="status-item">
            <span className="label">Memory Usage:</span>
            <span className="value">{statusData.memory_percent}%</span>
          </div>
        </div>
      );
    }

    return <div className="no-data">No data available</div>;
  };

  const renderHealthCard = () => {
    if (healthLoading) {
      return <div className="loading">Loading...</div>;
    }
    
    if (healthError) {
      return <div className="error">Error: {healthError}</div>;
    }

    if (healthData) {
      return (
        <div className="health-content">
          <div className="health-status">
            <span className={`status-indicator ${healthData.status === 'healthy' ? 'healthy' : 'unhealthy'}`}>
              ●
            </span>
            <span className="status-text">{healthData.status}</span>
          </div>
        </div>
      );
    }

    return <div className="no-data">No data available</div>;
  };

  return (
    <div className="App">
      <header className="App-header">
        <div className="info-section">
          <div className="info-item">
            <span className="info-label">API URL:</span>
            <span className="info-value">{apiUrl}</span>
          </div>
          <div className="info-item">
            <span className="info-label">App Name:</span>
            <span className="info-value">{appName}</span>
          </div>
          <div className="info-item">
            <span className="info-label">Pod Name:</span>
            <span className="info-value">{podName}</span>
          </div>
        </div>
        
        <div className='container'>
          <div className='card'>
            <h3>API Status</h3>
            {renderStatusCard()}
          </div>
          <div className='card'>
            <h3>API Health</h3>
            {renderHealthCard()}
          </div>
        </div>
      </header>
    </div>
  );
}

export default App;
