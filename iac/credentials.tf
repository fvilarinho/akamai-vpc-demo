# Defines the Akamai Connected Cloud credentials.
provider "linode" {
  config_path    = local.credentialsFilename
  config_profile = "default"
}