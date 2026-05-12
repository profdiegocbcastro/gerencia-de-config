# Kubernetes com K3D + React + HPA + Ingress

Projeto desenvolvido para estudos de Kubernetes utilizando:

- Docker
- Kubernetes
- K3D
- Ingress
- Deployments
- ReplicaSets
- HPA (Horizontal Pod Autoscaler)
- Namespaces
- Resource Limits
- Balanceamento de carga

---

# Arquitetura

O projeto possui dois ambientes:

| Ambiente | Aplicação | Namespace | Escalabilidade |
|---|---|---|---|
| DEV | React Azul | dev | até 1 pods |
| HOMOLOG | React Laranja | homolog | até 2 pods |

---

# Criando o Cluster K3D

```bash
k3d cluster create meucluster \
  --servers 1 \
  --agents 2 \
  -p "4000:80@loadbalancer"
```

  # Verificando o cluster

```bash
kubectl cluster-info
kubectl get nodes
kubectl apply -Rf ./k8s
```

