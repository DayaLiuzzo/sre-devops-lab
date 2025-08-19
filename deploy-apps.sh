


echo "Waiting for namespace to be ready..."
until kubectl get namespace dev >/dev/null 2>&1; do
    echo "Waiting for namespace dev to be available..."
    sleep 2
done
echo "Namespace dev is ready!"

echo "Applying application configurations..."
kubectl apply -f /home/vagrant/sre-lab/apps/dev/ --recursive



echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available deployment/my-flask-app -n dev --timeout=300s

echo "k3s cluster setup complete!"
echo "Your cluster is ready with the following resources:"
kubectl get all -n dev
