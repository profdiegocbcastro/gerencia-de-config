#!/bin/bash
set -e

docker compose up -d --wait

cd terraform
terraform init -input=false -upgrade
terraform apply -auto-approve

EC2_IP=$(terraform output -raw instance_public_ip)
SSH_KEY=$(terraform output -raw private_key_path)
cd ..

until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -i "$SSH_KEY" ubuntu@"$EC2_IP" "echo ok" 2>/dev/null; do
  sleep 10
done

cat > ansible/hosts.ini <<EOF
[api_server]
${EC2_IP}

[api_server:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${SSH_KEY}
ansible_ssh_extra_args=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
EOF

ansible-playbook -i ansible/hosts.ini ansible/deploy.yaml

curl -s "http://$EC2_IP:5000/health"
curl -s "http://$EC2_IP:5000/"
