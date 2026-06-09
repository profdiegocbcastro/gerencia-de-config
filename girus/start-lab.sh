#!/bin/bash
set -e

if ! docker info &>/dev/null; then
  echo "ERRO: Docker não está rodando. Inicie o Docker e tente novamente."
  exit 1
fi

if ! command -v girus &>/dev/null || ! command -v kind &>/dev/null; then
  curl -sSL girus.linuxtips.io | bash
fi

if girus list clusters 2>&1 | grep -q "girus"; then
  echo "Cluster Girus já está rodando."
else
  girus create cluster --skip-browser
fi

girus create lab terraform-aws-infraestrutura

echo "Lab iniciado! Acesse: http://localhost:8000"
