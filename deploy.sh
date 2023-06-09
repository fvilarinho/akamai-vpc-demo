#!/bin/bash

# Prepares the environment to execute the scripts.
function prepareToExecute() {
  source functions.sh

  cd iac || exit 1
}

prepareToExecute

# Starts the provisioning of the infrastructure.
$TERRAFORM_CMD init \
               -upgrade \
               -migrate-state
$TERRAFORM_CMD apply \
               -var "credentialsFilename=$CREDENTIALS_FILENAME" \
               -var "privateKeyFilename=$PRIVATE_KEY_FILENAME" \
               -auto-approve