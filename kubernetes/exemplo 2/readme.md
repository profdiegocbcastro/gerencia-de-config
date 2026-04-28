# Kubernetes com k3d (NodePort)

## Pré-requisitos

- Docker instalado
- k3d instalado
- kubectl instalado

---

## 1. Criar o cluster

```bash
k3d cluster create meucluster \
  --servers 1 \
  --agents 2 \
  -p "30001:30001@loadbalancer"
```

## 2. Aplicar os manifests

Certifique-se de que os arquivos YAML (Deployment e Service) estão na pasta k8s/.

```bash
kubectl apply -f ./k8s
```

#### Acessar pelo localhost na porta 30001

## 3. Alternativa com port-forward

```bash
kubectl port-forward svc/node-service 8080:80
```

## Util para não precisar importar do dockerhub

```bash
docker build -t diegocbcastroo/node-pod-demo:1.0 .
k3d image import diegocbcastroo/node-pod-demo:1.0 -c meucluster
```