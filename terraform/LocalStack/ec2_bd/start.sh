#!/bin/bash
set -e

docker compose up -d --wait

cd terraform
terraform init -input=false -upgrade
terraform apply -auto-approve
cd ..

ansible-playbook -i ansible/hosts.ini ansible/deploy.yaml \
  -e "localstack_endpoint=http://localstack:4566"

curl -s http://localhost:5000/alunos
