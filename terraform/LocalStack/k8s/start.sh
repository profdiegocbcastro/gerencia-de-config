#!/bin/bash
set -e

# LocalStack
docker compose up -d --wait

# Kind cluster
if ! kind get clusters 2>/dev/null | grep -q cefet; then
  kind create cluster --name cefet --config kind-config.yaml
fi

# Metrics-server (necessario para o HPA)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.7.2/components.yaml
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

# Build e carrega imagem no kind
docker build -t cefet-api:latest ./app
kind load docker-image cefet-api:latest --name cefet

# Manifests
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/

echo ""
echo "API: http://localhost:3000/alunos"
echo "HPA: kubectl get hpa -n cefet -w"
echo "Pods: kubectl get pods -n cefet -w"
