snap install helm --classic

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

kubectl apply -f /home/vagrant/sre-lab/monitoring/servicemonitors/flask-app-servicemonitor.yaml