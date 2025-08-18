# 🛠️ SRE Project: Building a Production-Grade Pipeline

This project is a hands-on SRE (Site Reliability Engineering) lab to design, build, and operate a small but realistic production pipeline. It includes app deployment, observability, container orchestration, and CI/CD automation.

---

## 🎯 Goals

- ✅ Build a containerized application (Flask)
- ⚙️ Automate builds, versioning, and deployments
- 📊 Add observability: metrics, logging, alerts
- ☸️ Orchestrate using Docker and Kubernetes
- 🔁 Implement CI/CD workflows
- 📦 Package everything for reproducible environments

---

## 🧱 Stack

| Layer           | Tool / Tech        |
|----------------|--------------------|
| Application     | Python Flask        |
| Containerization| Docker              |
| Orchestration   | Docker Compose / Kubernetes |
| Monitoring      | Prometheus, Grafana |
| Logging         | Loki / Fluent Bit / ELK (TBD) |
| CI/CD           | GitHub Actions |
| Deployment      | GitHub + Docker Hub |

---

## 📦 Components

- `my-flask-app/` – Flask app with health & status endpoints
- `monitoring/` – Prometheus and Grafana configuration
- `k8s/` – Kubernetes manifests and Helm charts (WIP)
- `ci-cd/` – CI/CD pipelines and deployment automation

---

## 🚀 Getting Started

