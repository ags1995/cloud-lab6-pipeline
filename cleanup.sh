#!/bin/bash
echo "=== Cleaning up Lab 5 resources ==="
cd terraform
terraform destroy -auto-approve
echo "Resources destroyed"
