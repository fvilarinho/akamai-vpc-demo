# Define the Akamai Cloud token.
provider "linode" {
  token = chomp(var.linodeToken)
}