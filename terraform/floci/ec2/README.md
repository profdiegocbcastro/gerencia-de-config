# EC2 + Floci — API Hello World

API Express rodando em um container criado automaticamente pelo Floci.
Infraestrutura provisionada com Terraform, deploy feito com Ansible via SSH.

## Como funciona

Ao criar um `aws_instance`, o Floci sobe automaticamente um container Docker
real com Ubuntu, injeta a chave SSH e atribui um IP. Nao e necessario criar
nenhum container manualmente.

```
docker compose up
     |
     v
  Floci (porta 4566)
     |
terraform apply
     |
     v
  Container EC2 (Ubuntu + SSH)  <--- Floci cria automaticamente
     |
ansible-playbook
     |
     v
  API Express :5000
```

## Requisitos

| Ferramenta     | Instalacao (Arch Linux)         |
|----------------|---------------------------------|
| Docker         | sudo pacman -S docker           |
| Docker Compose | incluido no Docker              |
| Terraform      | sudo pacman -S terraform        |
| Ansible        | sudo pacman -S ansible          |

Nao precisa de conta AWS nem credenciais reais.

## Instalar o Floci

```bash
curl -fsSL https://floci.io/install.sh | sh
```

Ou usar via Docker (o docker-compose.yml ja cuida disso).

## Como rodar

```bash
cd terraform/floci/ec2
bash ./start.sh
```

Sequencia:
1. docker compose up    -- sobe o Floci
2. terraform apply      -- cria key pair + EC2 (Floci sobe o container)
3. aguarda SSH          -- espera o container estar pronto
4. ansible-playbook     -- instala Node.js e sobe a API como servico systemd

## Endpoints

```bash
curl http://<IP>:5000/
curl http://<IP>:5000/health
```

O IP e exibido ao final do start.sh.

## Parar

```bash
docker compose down
```

## Estrutura

```
ec2/
+-- docker-compose.yml     so o Floci (sem container vm manual)
+-- terraform/
|   +-- main.tf            provider apontando para Floci
|   +-- keypair.tf         gera chave SSH e registra no Floci
|   +-- ec2.tf             aws_instance com Ubuntu 22.04
|   +-- outputs.tf         IP e caminho da chave
+-- ansible/
|   +-- hosts.ini          gerado dinamicamente pelo start.sh
|   +-- deploy.yaml        instala Node.js e sobe a API
|   +-- app/
|       +-- api.js
|       +-- package.json
+-- floci-api.pem          chave SSH gerada (criada ao rodar)
+-- start.sh
```
