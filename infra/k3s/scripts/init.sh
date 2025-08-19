#!/bin/bash
set -e  # Exit on any error

echo "Installing k3s cluster..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=192.168.56.110" sh -

echo "Waiting for k3s to be ready..."
sleep 10

# Wait for k3s to be fully ready
until sudo k3s kubectl get nodes | grep -q Ready; do
    echo "Waiting for k3s node to be ready..."
    sleep 5
done

echo "Setting up kubeconfig for vagrant user..."
mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube
sudo chmod 600 /home/vagrant/.kube/config


HOST_ENTRY="192.168.56.110 myapp.com"

if ! grep -q "myapp.com" /etc/hosts; then
    echo "$HOST_ENTRY" | sudo tee -a /etc/hosts
    echo "Added $HOST_ENTRY to /etc/hosts"
else
    echo "Entry already exists in /etc/hosts"
fi


# Set KUBECONFIG environment variable
export KUBECONFIG=/home/vagrant/.kube/config

echo "Waiting for k3s API server to be ready..."
until kubectl get nodes >/dev/null 2>&1; do
    echo "Waiting for API server..."
    sleep 5
done

echo "Creating namespace..."
kubectl apply -f /home/vagrant/sre-lab/cluster/dev/namespace.yaml

echo "Applying ingress configuration..."
kubectl apply -f /home/vagrant/sre-lab/cluster/dev/ingress.yaml

echo "Running monitoring setup script"
bash /home/vagrant/sre-lab/monitoring/scripts/deploy-monitoring.sh

echo "ArgoCD setup script"
bash /home/vagrant/sre-lab/cd/argocd/argocd-setup.sh
