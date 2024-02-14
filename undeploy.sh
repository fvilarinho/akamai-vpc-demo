#!/bin/bash

# Checks the dependencies of this script.
function checkDependencies() {
  if [ ! -f "$CREDENTIALS_FILENAME" ]; then
    echo "The credentials filename was not found! Please finish the setup!"

    exit 1
  fi

  if [ -z "$TERRAFORM_CMD" ]; then
    echo "Terraform is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  source functions.sh

  showBanner

  cd iac || exit 1
}

# Destroys the provisioned infrastructure.
function undeploy() {
  $TERRAFORM_CMD init \
                 -upgrade \
                 -migrate-state

  $TERRAFORM_CMD destroy \
                 -auto-approve
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  undeploy
}

main