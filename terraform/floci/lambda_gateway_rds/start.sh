#!/bin/bash
set -e

docker compose up -d --wait

cd terraform
terraform init -input=false -upgrade
terraform apply -auto-approve

API_URL=$(terraform output -raw api_url)
cd ..


echo "API URL: $API_URL"
curl -s "$API_URL/health"
curl -s "$API_URL/alunos"
