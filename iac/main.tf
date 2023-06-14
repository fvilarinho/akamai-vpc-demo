# Defines the main Terraform providers and backend.
terraform {
  backend "s3" {
    bucket                      = "fvilarin-devops"
    key                         = "akamai-vpc-demo.tfstate"
    region                      = "us-east-1"
    endpoint                    = "us-east-1.linodeobjects.com"
    skip_credentials_validation = true
  }

  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

# Defines local variables.
locals {
  credentialsFilename = pathexpand(var.credentialsFilename)
}

# Defines the Akamai Connected Cloud credentials.
provider "linode" {
  config_path    = local.credentialsFilename
  config_profile = "linode"
}