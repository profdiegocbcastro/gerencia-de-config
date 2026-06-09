# EC2 + DynamoDB + Ansible com LocalStack

Provisiona EC2 e tabela DynamoDB no LocalStack via Terraform. O Ansible deploya uma API Express que lista alunos do DynamoDB.

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

**Ansible**
```bash
sudo apt install ansible -y
```

## Rodar

```bash
./start.sh
```

## Testar

```bash
curl http://localhost:5000/alunos
curl http://localhost:5000/alunos/1
```

## Parar

```bash
docker compose down
```
