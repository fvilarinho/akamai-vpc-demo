variable "credentialsFilename" {
  default = ".credentials"
}

variable "privateKeyFilename" {
  default = ".id_rsa"
}

variable "identifier" {
  default = "vpc"
}

# Attributes of the VPC gateway for Site 1.
variable "vpcGatewaySite1" {
  default = {
    id                     = "vpc-site1-gateway"
    label                  = "Site 1"
    type                   = "g6-standard-2"
    region                 = "us-east"
    vpnServerNetworkPrefix = "10.8.0.0"
    vpnServerNetworkMask   = "24"
  }
}

# Attributes of the VPC gateway for Site 2.
variable "vpcGatewaySite2" {
  default = {
    id                     = "vpc-site2-gateway"
    label                  = "Site 2"
    type                   = "g6-standard-2"
    region                 = "us-iad"
    vpnServerNetworkPrefix = "10.9.0.0"
    vpnServerNetworkMask   = "24"
  }
}

# Attributes of the VPC nodes for Site 1.
variable "vpcNodesSite1" {
  default = {
    id                   = "vpc-site1-node"
    type                 = "g6-standard-1"
    subnetsNetworkPrefix = "10.1"
    subnetsNetworkMask   = "24"
    countPerSubnet       = 2
  }
}

# Attributes of the VPC nodes for Site 2.
variable "vpcNodesSite2" {
  default = {
    id                   = "vpc-site2-node"
    type                 = "g6-standard-1"
    subnetsNetworkPrefix = "10.2"
    subnetsNetworkMask   = "24"
    countPerSubnet       = 2
  }
}

# Attributes of the VPC gateway setup.
variable "vpcGatewaySetup" {
  default = {
    id          = "VPC Gateway"
    description = "Setup a VPC Gateway at the boot."
    os          = "linode/debian10"
  }
}

# Attributes of the VPC nodes setup.
variable "vpcNodesSetup" {
  default = {
    id          = "VPC Node"
    description = "Setup a VPC Node at the boot."
    os          = "linode/debian10"
  }
}