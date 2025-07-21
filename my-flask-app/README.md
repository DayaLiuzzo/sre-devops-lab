# My Flask App

A simple Flask web application containerized using Docker.

## 🐳 Dockerized Flask App

This app exposes a basic HTTP API including a health and status endpoint. It is packaged and deployed via Docker for portability and consistency.

### 🔧 Requirements

- Docker
- (Optional) Python 3.8+ for local development

### 🚀 Getting Started

#### 1. Build the Docker image

```bash
docker build -t dliuzzo/my-flask-app:v1 --build-arg APP_VERSION=v1 .
