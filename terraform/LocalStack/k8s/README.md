# K8s + RDS + HPA com LocalStack

Provisiona RDS no LocalStack via Terraform. Sobe API Express com PostgreSQL no Kubernetes (kind). Cada pod aceita no maximo 10 requests — o HPA escala automaticamente sob carga.

## Pre-requisitos

**Docker**
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

**Terraform**
```bash
sudo snap install terraform --classic
```

**kind**
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
```

**kubectl**
```bash
sudo snap install kubectl --classic
```

## Rodar

```bash
./start.sh
```

## Testar

```bash
curl http://localhost:3000/alunos

# Testar escalonamento
./load-test.sh
kubectl get hpa -n escola -w
kubectl get pods -n escola -w
```

## Parar

```bash
kind delete cluster --name escola
docker compose down
```
