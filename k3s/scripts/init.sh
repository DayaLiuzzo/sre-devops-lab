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

# Set KUBECONFIG environment variable
export KUBECONFIG=/home/vagrant/.kube/config

echo "Waiting for k3s API server to be ready..."
until kubectl get nodes >/dev/null 2>&1; do
    echo "Waiting for API server..."
    sleep 5
done

echo "Creating namespace..."
kubectl apply -f /home/vagrant/sre-lab/k3s/confs/namespace.yaml

echo "Waiting for namespace to be ready..."
until kubectl get namespace dev >/dev/null 2>&1; do
    echo "Waiting for namespace dev to be available..."
    sleep 2
done
echo "Namespace dev is ready!"

echo "Applying application configurations..."
kubectl apply -f /home/vagrant/sre-lab/k3s/confs/my-flask-app/
kubectl apply -f /home/vagrant/sre-lab/k3s/confs/my-frontend/


echo "Applying ingress configuration..."
kubectl apply -f /home/vagrant/sre-lab/k3s/confs/ingress.yaml

echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available deployment/my-flask-app -n dev --timeout=300s

echo "k3s cluster setup complete!"
echo "Your cluster is ready with the following resources:"
kubectl get all -n dev