#!/bin/bash

set -e

k3d kubeconfig merge meucluster

kubectl delete -f k8s/hpa/ --ignore-not-found
kubectl delete -f k8s/app/ --ignore-not-found
kubectl delete -f k8s/postgres/ --ignore-not-found

kubectl delete configmap postgres-init --ignore-not-found

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --validate=false

sleep 5

kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"},
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-preferred-address-types=InternalIP"}
  ]'

kubectl create configmap postgres-init \
  --from-file=k8s/postgres/init.sql


kubectl apply -f k8s/app/service.yaml
kubectl apply -f k8s/app/deploy.yaml
kubectl apply -f k8s/app/ingress.yaml

kubectl apply -f k8s/postgres/service.yaml
kubectl apply -f k8s/postgres/deploy.yaml

kubectl apply -f k8s/hpa/

kubectl wait --for=condition=available deployment/postgres --timeout=60s
kubectl wait --for=condition=available deployment/api-users --timeout=60s

kubectl get pods
kubectl get svc
kubectl get hpa
kubectl get ingress