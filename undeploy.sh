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

# Remove all VPN client configurations.
rm -f *.ovpn 2> /dev/null

cd iac || exit 1

# Deprovision the infrastructure.
$TERRAFORM_CMD init || exit 1
$TERRAFORM_CMD destroy -var "linodeToken=$LINODE_TOKEN" \
                       -var "sshPrivateKey=$SSH_PRIVATE_KEY" \
                       -var "sshPublicKey=$SSH_PUBLIC_KEY" \
                       -auto-approve || exit 1

cd ..