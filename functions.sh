#!/bin/bash

# Checks the dependencies of this script.
function checkDependencies() {
  # Finds terraform binary.
  TERRAFORM_CMD=$(which terraform)

  # Checks if terraform is installed.
  if [ -z "$TERRAFORM_CMD" ]; then
    echo "Please install Terraform to continue!"

    exit 1
  fi
}

checkDependencies