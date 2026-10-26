# Exemplo prático: Kubernetes com k3d

Uma API mínima em Express com duas rotas:

| Rota | O que faz |
|---|---|
| `/info` | Mostra qual Pod e qual node responderam |
| `/cpu` | Gasta 50ms de CPU, usada para acionar o HPA |

## Pré-requisitos

- Docker, kubectl e k3d instalados

## 1. Build e teste local

```bash
cd "kubernetes/exemplo prático"
docker build -t api:1.0 ./api
docker run --rm -p 3000:3000 api:1.0
curl localhost:3000/info
```

## 2. Criar o cluster

```bash
k3d cluster create aula9 --servers 1 --agents 2 -p "8080:80@loadbalancer" -p "30001:30001@loadbalancer"
kubectl get nodes
k3d image import api:1.0 -c aula9
```

## 3. Um Pod sozinho

```bash
kubectl apply -f extras/pod.yaml
kubectl get pods -o wide
kubectl port-forward pod/api-pelado 3000:3000
curl localhost:3000/info
kubectl logs api-pelado
kubectl delete pod api-pelado
kubectl get pods
```

## 4. Deployment

```bash
kubectl apply -f k8s/deployment.yaml
kubectl get deployment,replicaset,pods
kubectl get pods --show-labels
kubectl get pods -l app=api -o wide
```

## 5. Services e Ingress

```bash
kubectl apply -f k8s/service.yaml
kubectl get svc api
kubectl get endpoints api
kubectl run teste --rm -it --restart=Never --image=busybox:1.36 -- wget -qO- http://api/info

kubectl apply -f k8s/service-nodeport.yaml
curl localhost:30001/info

kubectl apply -f k8s/ingress.yaml
kubectl get ingress
for i in $(seq 1 6); do curl -s localhost:8080/info; echo; done
```

O Traefik leva cerca de 1 minuto para subir depois que o cluster é criado. Se der 404, confira com `kubectl get pods -n kube-system`.

## 6. Pods subindo e descendo

Terminal 1:

```bash
kubectl get pods -o wide -w
```

Terminal 2:

```bash
kubectl scale deployment api --replicas=6
kubectl apply -f k8s/deployment.yaml
kubectl delete pod <nome-de-um-pod>
```

## 7. Investigar

```bash
kubectl exec <pod> -- sh -c 'hostname; echo $NODE_NAME'
kubectl describe pod <pod>
kubectl logs <pod>
```

## 8. Rollout e rollback

```bash
docker tag api:1.0 api:2.0
k3d image import api:2.0 -c aula9
kubectl set image deployment/api api=api:2.0
kubectl annotate deployment/api kubernetes.io/change-cause="versão 2.0"
kubectl rollout status deployment/api
kubectl get rs
kubectl rollout history deployment/api
kubectl rollout undo deployment/api
kubectl get deployment api -o wide
```

## 9. Mais nodes

```bash
k3d node create extra --cluster aula9 --role agent --replicas 2
k3d image import api:1.0 -c aula9
kubectl get nodes
```

## 10. HPA

```bash
kubectl apply -f k8s/hpa.yaml
kubectl get hpa
```

Terminal 1: `kubectl get hpa -w`

Terminal 2: `kubectl get pods -o wide -w`

Terminal 3:

```bash
kubectl apply -f extras/carga.yaml
kubectl delete -f extras/carga.yaml
```

## 11. Tirar os nodes extras

```bash
kubectl drain k3d-extra-0 --ignore-daemonsets --delete-emptydir-data
k3d node delete k3d-extra-0
kubectl delete node k3d-extra-0
kubectl drain k3d-extra-1 --ignore-daemonsets --delete-emptydir-data
k3d node delete k3d-extra-1
kubectl delete node k3d-extra-1
```

## 12. Limpar

```bash
k3d cluster delete aula9
```
