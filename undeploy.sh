#!/bin/bash

# Prepares the environment to execute the commands of this script.
function prepareToExecute() {
  source functions.sh

  cd iac || exit 1
}

# Clean-up.
function cleanUp() {
  rm -f *.ovpn
}

prepareToExecute

# Destroys the provisioned infrastructure.
$TERRAFORM_CMD init \
               -upgrade \
               -migrate-state
$TERRAFORM_CMD destroy \
               -var "credentialsFilename=$CREDENTIALS_FILENAME" \
               -var "privateKeyFilename=$PRIVATE_KEY_FILENAME" \
               -auto-approve

cleanUp