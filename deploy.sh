#!/bin/bash

# Check for dependencies of this script.
function checkDependencies() {
  # Find terraform binary.
  TERRAFORM_CMD=$(which terraform)

  # Check if terraform is installed.
  if [ -z "$TERRAFORM_CMD" ]; then
    echo "Terraform is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Prepare the environment to execute the commands of this script.
function prepareToExecute() {
  cd iac || exit 1
}

checkDependencies
prepareToExecute

# Provision the infrastructure.
$TERRAFORM_CMD init \
               --upgrade \
               --migrate-state
$TERRAFORM_CMD apply -var "linodeToken=$LINODE_TOKEN" \
                     -auto-approve