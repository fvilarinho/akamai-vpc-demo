#!/bin/bash

# Prepares the environment to execute the scripts.
function prepareToExecute() {
  source functions.sh

  cd iac || exit 1
}

prepareToExecute

# Start the provisioning of the infrastructure.
$TERRAFORM_CMD init \
               --upgrade \
               --migrate-state
$TERRAFORM_CMD apply \
               -auto-approve