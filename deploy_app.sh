#!/bin/bash

key_file_path=Terraform/terraform/test-app-key.pem

if [ -f "$key_file_path" ]
then

    echo "Deleting App....."
    terraform -chdir="./Terraform/terraform/" init
    terraform -chdir="./Terraform/terraform/" destroy -auto-approve -var-file=variables.tfvars

else

    echo "Deploying App....."
    echo "Provisioning Infrastructure with terraform....."
    terraform -chdir="./Terraform/terraform/" init
    terraform -chdir="./Terraform/terraform/" apply -auto-approve -var-file=variables.tfvars
    chmod 400 $key_file_path
    echo "Configure app with ansible ....."
    cd Ansible;export ANSIBLE_SSH_RETRIES=10 && ansible-playbook config-test-app.yml
    echo "Inventory Details are as below"
    cat ../Terraform/terraform/inventory

fi