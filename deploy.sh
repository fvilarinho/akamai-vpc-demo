#!/bin/bash

# Find terraform binary.
TERRAFORM_CMD=$(which terraform)

# Check if terraform is installed.
if [ -z "$TERRAFORM_CMD" ]; then
  echo "Please install Terraform to continue!"

  exit 1
fi

source ./functions.sh

# Create terraform state credentials.
createTerraformStateCredentials

cd iac || exit 1

# Provision the infrastructure.
$TERRAFORM_CMD init || exit 1
$TERRAFORM_CMD apply -var "linodeToken=$LINODE_TOKEN" \
                     -auto-approve || exit 1

cd ..