#!/bin/bash
set -e

echo "=== Lab 5: Terraform + Ansible Deployment ==="
echo "Starting at: $(date)"

# Step 1: Initialize Terraform
cd terraform
echo "1. Initializing Terraform..."
terraform init

# Step 2: Plan Terraform deployment
echo "2. Planning Terraform deployment..."
terraform plan

# Step 3: Apply Terraform
echo "3. Applying Terraform configuration..."
terraform apply -auto-approve

# Step 4: Get server IP
SERVER_IP=$(terraform output -raw floating_ip)
echo "4. Server deployed at: $SERVER_IP"

# Step 5: Wait for server to be ready
echo "5. Waiting for server to be ready..."
sleep 60

# Step 6: Update Ansible inventory with actual IP
cd ../ansible
sed "s/\${SERVER_IP}/$SERVER_IP/g" inventory.yml > inventory_generated.yml

# Step 7: Run Ansible playbook
echo "6. Running Ansible playbook..."
ansible-playbook -i inventory_generated.yml playbook.yml

echo "=== Deployment Complete ==="
echo "Server IP: $SERVER_IP"
echo "SSH: ssh -i ~/.ssh/id_rsa ubuntu@$SERVER_IP"
echo "Completed at: $(date)"
