# Defines the main Terraform providers and backend.
terraform {
  backend "s3" {
    bucket                      = "fvilarin-devops"
    key                         = "akamai-vpc-demo.tfstate"
    region                      = "us-east-1"
    endpoint                    = "us-east-1.linodeobjects.com"
    skip_credentials_validation = true
    shared_credentials_file     = "~/.akamai-vpc-demo/.credentials"
  }

  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

# Defines local variables.
locals {
  workDir             = pathexpand("~/.akamai-vpc-demo")
  credentialsFilename = "${local.workDir}/.credentials"
}