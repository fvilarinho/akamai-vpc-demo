#!/bin/bash

# Shows the labels.
function showLabel() {
  if [[ "$0" == *"undeploy.sh"* ]]; then
    echo "== Undeploying the stack remotely == "
  elif [[ "$0" == *"deploy.sh"* ]]; then
    echo "== Deploying the stack remotely == "
  fi

  echo
}

# Shows the banner.
function showBanner() {
  if [ -f "banner.txt" ]; then
    cat banner.txt
  fi

  showLabel
}

# Gets a credential value.
function getCredential() {
  value=$(awk -F'=' '/'$1'/,/^\s*$/{if($1~/'$2'/){print $2}}' "$CREDENTIALS_FILENAME" | xargs)

  echo "$value"
}

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

# Prepares the environment to execute the commands of this script.
function prepareToExecute() {
  showBanner

  # Provisioning files/paths.
  export WORK_DIR="$PWD/iac"
  export CREDENTIALS_FILENAME="$WORK_DIR"/.credentials
  export PRIVATE_KEY_FILENAME="$WORK_DIR"/.id_rsa
}

# Creates the credentials file.
function createCredentialsFile() {
  if [ -n "$CREDENTIALS" ]; then
    if [ ! -f "$CREDENTIALS_FILENAME" ]; then
      echo "$CREDENTIALS" > "$CREDENTIALS_FILENAME"
    fi
  fi

  # Loads the mandatory credentials.
  if [ -f "$CREDENTIALS_FILENAME" ]; then
    export AWS_ACCESS_KEY_ID=$(getCredential "linode" "aws_access_key_id")
    export AWS_SECRET_ACCESS_KEY=$(getCredential "linode" "aws_secret_access_key")
  fi
}

checkDependencies
prepareToExecute
createCredentialsFile