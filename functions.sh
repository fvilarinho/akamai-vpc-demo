#!/bin/bash

# Get a credential value.
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
  # Provisioning files/paths.
  export WORK_DIR="$PWD/iac"
  export CREDENTIALS_FILENAME="$WORK_DIR"/.credentials
  export PRIVATE_KEY_FILENAME="$WORK_DIR"/.id_rsa

  # VPC files/paths.
  export HOME_DIR=/opt/vpcGateway
  export ETC_DIR="$HOME_DIR"/etc
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