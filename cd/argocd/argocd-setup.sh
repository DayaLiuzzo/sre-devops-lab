#!/bin/sh

# ArgoCD setup script for K3D cluster

# Create namespaces
echo "Creating namespaces: argocd"
kubectl apply -f /home/vagrant/sre-lab/cd/argocd/namespace.yaml


# Install ArgoCD
echo "Installing ArgoCD in cluster"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD server to be ready
echo "Waiting for ArgoCD server to be ready..."
kubectl wait --for=condition=available --timeout=180s deployment/argocd-server -n argocd

# Argocd is ready
kubectl get all -n argocd

# Deploy CD pipeline
echo "Deploying ArgoCD applications"
kubectl apply -f /home/vagrant/sre-lab/cd/argocd/projects/
kubectl apply -f /home/vagrant/sre-lab/cd/argocd/applications/
