#!/bin/bash

echo "=================================================="
echo "FINAL MINIKUBE DEPLOYMENT SCRIPT"
echo "Computer: $(hostname)"
echo "Date: $(date)"
echo "=================================================="

echo ""
echo "📋 1. Checking Minikube status..."
minikube status

echo ""
echo "🐳 2. Building Docker image..."
docker build -t my-ci-app:minikube-v1 .

echo ""
echo "⬆️  3. Loading image to Minikube..."
minikube image load my-ci-app:minikube-v1

echo ""
echo "🚀 4. Deploying to Kubernetes..."
kubectl create deployment my-final-app --image=my-ci-app:minikube-v1 --port=80 --dry-run=client -o yaml > deployment.yaml
kubectl apply -f deployment.yaml

kubectl expose deployment my-final-app --type=NodePort --port=80 --dry-run=client -o yaml > service.yaml
kubectl apply -f service.yaml

echo ""
echo "⏳ 5. Waiting for pods to be ready..."
sleep 40

echo ""
echo "✅ 6. Deployment completed!"
echo ""
echo "📊 DEPLOYMENT STATUS:"
echo "---------------------"
echo "PODS:"
kubectl get pods -o wide
echo ""
echo "SERVICES:"
kubectl get services
echo ""
echo "DEPLOYMENTS:"
kubectl get deployments
echo ""
echo "🌐 HOW TO ACCESS YOUR APPLICATION:"
echo "---------------------------------"
echo "Option 1: Port forwarding"
echo "  kubectl port-forward service/my-final-app 8080:80"
echo "  Then open: http://localhost:8080"
echo ""
echo "Option 2: Minikube service"
echo "  minikube service my-final-app --url"
echo ""
echo "Option 3: Direct NodePort"
NODE_PORT=$(kubectl get service my-final-app -o jsonpath='{.spec.ports[0].nodePort}')
MINIKUBE_IP=$(minikube ip)
echo "  Open: http://${MINIKUBE_IP}:${NODE_PORT}"
echo ""
echo "🛠️  MANAGEMENT COMMANDS:"
echo "-----------------------"
echo "View logs: kubectl logs -f deployment/my-final-app"
echo "Delete: kubectl delete -f deployment.yaml -f service.yaml"
echo "Dashboard: minikube dashboard"
echo ""
echo "=================================================="
echo "SCRIPT EXECUTED SUCCESSFULLY ON: $(hostname)"
echo "=================================================="