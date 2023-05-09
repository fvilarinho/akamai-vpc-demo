#!/bin/bash

TERRAFORM_CMD=$(which terraform)

if [ -z "$TERRAFORM_CMD" ]; then
  echo "Please install Terraform to continue!"

  exit 1
fi

cd iac || exit 1

$TERRAFORM_CMD init || exit 1
$TERRAFORM_CMD destroy -var "linodeToken=$LINODE_TOKEN" \
                       -auto-approve || exit 1

cd ..