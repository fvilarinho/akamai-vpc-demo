# Define the main Terraform Provides.
terraform {
  backend "s3" {
    bucket                      = "fvilarin-devops"
    key                         = "akamai-vpc-demo.tfstate"
    region                      = "us-east-1"
    endpoint                    = "us-east-1.linodeobjects.com"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}