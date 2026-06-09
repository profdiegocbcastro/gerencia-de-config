# EC2 + Ansible com LocalStack

Provisiona uma EC2 no LocalStack via Terraform. O Ansible deploya uma API Express no container que representa essa VM.


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
curl http://localhost:5000/health
```

## Parar

```bash
docker compose down
```
