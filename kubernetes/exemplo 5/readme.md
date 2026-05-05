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
  -p "4000:80@loadbalancer"
```

## 2. Rod eo script de inicialização
```bash
bash ./script.sh
```

- Acessar pelo localhost na porta 4000

