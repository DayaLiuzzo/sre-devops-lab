# 🛠️ SRE DevOps Lab: End-to-End Observability & GitOps

> **Portfolio Project**: A comprehensive Site Reliability Engineering laboratory demonstrating production-grade DevOps practices, container orchestration, observability, and GitOps workflows.

## 🎯 Project Vision

This project showcases a complete microservices infrastructure with enterprise-grade practices:

- **Full-Stack Application**: Python Flask API + React frontend with health checks and metrics
- **Container Orchestration**: K3s Kubernetes cluster with Traefik ingress
- **Observability Stack**: Prometheus metrics collection + Grafana visualization  
- **GitOps Deployment**: ArgoCD for continuous delivery and configuration management
- **Infrastructure as Code**: Vagrant for reproducible development environments
- **Future Enhancement**: ELK stack integration for centralized logging

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                          🖥️  Host Machine                           │
│  🌐 Browser  ───► /etc/hosts: myapp.com → 192.168.56.110           │
└─────────────────────────────┬───────────────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────────────┐
│             📦 Vagrant VM (192.168.56.110)                         │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              ☸️  K3s Kubernetes Cluster                     │   │
│  │                                                             │   │
│  │  myapp.com ───► 🌐 Traefik Ingress                         │   │
│  │                      │                                      │   │
│  │                      ├─────► 🐍 Flask API                  │   │
│  │                      │        │                            │   │
│  │                      └─────► ⚛️ React Frontend             │   │
│  │                               │                            │   │
│  │                               │ /metrics                   │   │
│  │                               ▼                            │   │
│  │  📊 Prometheus ◄─────────────────────────────────────────  │   │
│  │      │                                                     │   │
│  │      ▼                                                     │   │
│  │  🎨 Grafana                   🔄 ArgoCD                    │   │
│  │                                 │                          │   │
│  │                                 │ GitOps                   │   │
│  │                                 ▼                          │   │
│  │                            📝 Git Repo                     │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Bootstrap Guide

### Prerequisites
- VirtualBox installed
- Vagrant installed  
- 4GB+ RAM available for VM

### 1. Infrastructure Setup
```bash
# Clone and enter project
git clone <your-repo-url>
cd sre-lab

# Start Vagrant VM (auto-provisions Docker, k3d, kubectl)
cd infra/vagrant
vagrant up

# SSH into the VM
vagrant ssh
```

### 2. 🎯 One-Command Bootstrap
```bash
# Navigate to project in VM
cd /home/vagrant/sre-lab

# 🚀 Initialize EVERYTHING with one command!
./infra/k3s/scripts/init.sh
```

*This magical script automatically:*
- Installs K3s Kubernetes cluster
- Configures `myapp.com` domain mapping  
- Deploys Prometheus & Grafana monitoring
- Sets up ArgoCD GitOps pipeline
- Auto-deploys applications from GitHub!

### 3. 🎉 That's it! 
Your entire stack is now running! ArgoCD will automatically sync and deploy your applications from the Git repository.

## 🌐 Service Access Points

| Service | Access Method | Purpose |
|---------|---------------|---------|
| **Main App** | `http://myapp.com` | Flask API + React UI |
| **Grafana** | Port forward required | Monitoring dashboards |
| **Prometheus** | Port forward required | Metrics collection UI |
| **ArgoCD** | Port forward required | GitOps management |

### 🔗 Required Host Configuration
```bash
# Add to your HOST machine's /etc/hosts file:
echo "192.168.56.110 myapp.com" | sudo tee -a /etc/hosts
```

### 📊 Access Monitoring & GitOps Services
```bash
# Forward Grafana to localhost (run inside VM)
kubectl port-forward -n monitoring svc/grafana 3000:80 --address 0.0.0.0
# Then access: http://192.168.56.110:3000

# Forward Prometheus to localhost (run inside VM)  
kubectl port-forward -n monitoring svc/prometheus 9090:9090 --address 0.0.0.0
# Then access: http://192.168.56.110:9090

# Forward ArgoCD to localhost (run inside VM)
kubectl port-forward -n argocd svc/argocd-server 8080:80 --address 0.0.0.0
# Then access: http://192.168.56.110:8080
```

## 📊 Observability Features

### Application Health
- **Health Endpoints**: 
  - `GET /api/health` - Basic health check
  - `GET /api/status` - Detailed system status with memory usage
- **Prometheus Metrics**: `GET /api/metrics` - Custom application metrics
  - Request counters per endpoint
  - System memory usage (total, used, percentage)
  - Application version tracking

### Monitoring Stack
- **Prometheus**: Metrics collection with ServiceMonitor configuration
- **Grafana**: Pre-configured dashboards for application and infrastructure metrics
- **Alert Manager**: (Ready for configuration)

### GitOps Observability  
- **ArgoCD**: Application deployment status and sync health
- **Git-based Configuration**: All Kubernetes manifests tracked in Git

## 🔧 Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Infrastructure** | Vagrant + VirtualBox | Reproducible dev environment |
| **Container Platform** | K3s Kubernetes | Lightweight container orchestration |
| **Ingress Controller** | Traefik | Load balancing and SSL termination |
| **Backend API** | Python Flask + gunicorn | RESTful API with metrics |
| **Frontend** | React + NGINX | Single-page application |
| **Monitoring** | Prometheus + Grafana | Metrics collection and visualization |
| **GitOps** | ArgoCD | Continuous deployment |
| **Service Mesh** | *Future: Istio* | Traffic management and security |

## 🗂️ Project Structure

```
sre-lab/
├── infra/                          # Infrastructure automation
│   ├── vagrant/Vagrantfile         # VM definition and provisioning
│   └── k3s/scripts/init.sh         # 🚀 MAIN BOOTSTRAP SCRIPT
├── apps/dev/                       # Kubernetes application manifests  
│   ├── my-flask-app/               # Flask API K8s resources
│   └── my-frontend/                # React frontend K8s resources
├── cd/argocd/                      # GitOps configuration
│   ├── argocd-setup.sh             # ArgoCD installation script
│   ├── applications/               # ArgoCD application definitions
│   └── projects/                   # ArgoCD project definitions
├── cluster/dev/                    # Cluster-wide configurations
│   ├── namespace.yaml              # Environment namespaces
│   └── ingress.yaml                # myapp.com routing rules
├── monitoring/                     # Observability stack
│   ├── scripts/deploy-monitoring.sh # Monitoring deployment
│   ├── helm/                       # Helm charts for Grafana/Prometheus  
│   └── servicemonitors/            # Prometheus targets
├── my-flask-app/                   # Backend application source
│   ├── Dockerfile                  # Container definition
│   ├── app/app.py                  # Flask application with metrics
│   └── tests/                      # Unit tests
└── my-frontend/                    # Frontend application source
    ├── Dockerfile                  # Multi-stage React build
    ├── src/                        # React components
    └── conf/nginx.conf             # NGINX configuration
```

## 🔮 Future Enhancements

### Logging Integration (Next Phase)
```bash
# Planned ELK Stack integration
└── logging/
    ├── elasticsearch/             # Log storage and indexing
    ├── logstash/                  # Log processing pipeline  
    ├── kibana/                    # Log visualization
    └── fluentbit/                 # Log collection agents
```

### Additional Roadmap
- **Infrastructure**: Terraform for multi-cloud deployment
- **Security**: Pod Security Standards, Network Policies, Vault integration
- **CI/CD**: GitHub Actions for automated testing and deployment
- **Service Mesh**: Istio for advanced traffic management
- **Chaos Engineering**: Chaos Monkey integration for resilience testing

## 🎓 Learning Outcomes

This project demonstrates practical knowledge of:

- **Site Reliability Engineering**: Health checks, metrics, alerting
- **Container Orchestration**: Kubernetes deployment patterns
- **GitOps Workflows**: Infrastructure and application management through Git
- **Observability**: Three pillars - metrics, logs (planned), traces (future)
- **Infrastructure as Code**: Reproducible environment provisioning
- **Microservices Architecture**: Service communication and monitoring

## 🛠️ Troubleshooting

### Common Issues
```bash
# Reset cluster if needed
sudo systemctl stop k3s
sudo /usr/local/bin/k3s-uninstall.sh
./infra/k3s/scripts/init.sh

# Check pod status
kubectl get pods -A

# View application logs
kubectl logs -n dev deployment/my-flask-app
kubectl logs -n dev deployment/my-frontend

# Port forward for debugging
kubectl port-forward -n dev svc/my-flask-app 5000:5000
```

### Service Verification
```bash
# Test API endpoints
curl http://myapp.com/api/health
curl http://myapp.com/api/status  
curl http://myapp.com/api/metrics

# Check ArgoCD sync status
kubectl get applications -n argocd
```

---

**🎯 Built as a portfolio demonstration of modern SRE and DevOps practices**

---

## 📊 Observability Features

### Prometheus Metrics
- **Application Metrics**: Request counts, response times, error rates
- **System Metrics**: Memory usage, CPU utilization
- **Custom Metrics**: Business logic metrics via `/api/metrics` endpoint

### Grafana Dashboards
- Application performance monitoring
- Infrastructure resource utilization
- Service health overview

### Health Checks
- **Liveness**: `/api/health` for container health
- **Readiness**: `/api/status` with system information
- **Metrics**: `/api/metrics` for Prometheus scraping

---

## � GitOps Workflow

1. **Code Changes** → Pushed to repository
2. **ArgoCD Detection** → Monitors Git repository for changes  
3. **Automatic Sync** → Deploys changes to Kubernetes cluster
4. **Health Monitoring** → Prometheus monitors application health
5. **Alerting** → Grafana alerts on anomalies

---

## 💻 Development

