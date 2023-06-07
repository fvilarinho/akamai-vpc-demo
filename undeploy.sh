#!/bin/bash

# Prepares the environment to execute the commands of this script.
function prepareToExecute() {
  source functions.sh

  rm -rf *.ovpn

  cd iac || exit 1
}

prepareToExecute

# Destroys the provisioned infrastructure.
$TERRAFORM_CMD init \
               --upgrade \
               --migrate-state
$TERRAFORM_CMD destroy \
               -auto-approve