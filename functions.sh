#!/bin/bash

# Shows the labels.
function showLabel() {
  if [[ "$0" == *"undeploy.sh"* ]]; then
    echo "** Undeploys **"
  elif [[ "$0" == *"deploy.sh"* ]]; then
    echo "** Deploys **"
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
  if [ -f "$CREDENTIALS_FILENAME" ]; then
    value=$(awk -F'=' '/'$1'/,/^\s*$/{ if($1~/'$2'/) { print substr($0, length($1) + 2) } }' "$CREDENTIALS_FILENAME" | tr -d '"' | tr -d ' ')
  else
    value=
  fi

  echo "$value"
}

# Prepares the environment to execute the commands of this script.
function prepareToExecute() {
  # Required files/paths.
  export WORK_DIR="$PWD/iac"
  export CREDENTIALS_FILENAME="$WORK_DIR"/.credentials
  export PRIVATE_KEY_FILENAME="$WORK_DIR"/.id_rsa

  # Required binary.
  export TERRAFORM_CMD=$(which terraform)

  # Environment variables.
  export TF_VAR_credentialsFilename="$CREDENTIALS_FILENAME"
  export TF_VAR_privateKeyFilename="$PRIVATE_KEY_FILENAME"
}

prepareToExecute