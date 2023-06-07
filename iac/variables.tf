# Attributes of the VPC gateway for Site 1.
variable "vpcGatewaySite1" {
  default = {
    id     = "vpc-site1-gateway"
    type   = "g6-standard-2"
    region = "us-east"
  }
}

# Attributes of the VPC gateway for Site 2.
variable "vpcGatewaySite2" {
  default = {
    id     = "vpc-site2-gateway"
    type   = "g6-standard-2"
    region = "us-iad"
  }
}

# Attributes of the VPC nodes for Site 1.
variable "vpcNodesSite1" {
  default = {
    id             = "vpc-site1-node"
    type           = "g6-standard-1"
    countPerSubnet = 2
  }
}

# Attributes of the VPC nodes for Site 2.
variable "vpcNodesSite2" {
  default = {
    id             = "vpc-site2-node"
    type           = "g6-standard-1"
    countPerSubnet = 2
  }
}

# Attributes of the VPC gateway setup.
variable "vpcGatewaySetup" {
  default = {
    id          = "vpc-gateway"
    description = "Setup a VPC Gateway at the boot."
    os          = "linode/debian10"
  }
}

# Attributes of the VPC nodes setup.
variable "vpcNodesSetup" {
  default = {
    id          = "vpc-node"
    description = "Setup a VPC Node at the boot."
    os          = "linode/debian10"
  }
}