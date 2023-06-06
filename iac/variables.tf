variable "linodeToken" {
  default = "linodeToken"
}

variable "vpcGatewaySite1" {
  default = {
    id     = "vpc-site1-gateway"
    region = "us-east"
    type   = "g6-standard-2"
  }
}

variable "vpcGatewaySite2" {
  default = {
    id     = "vpc-site2-gateway"
    region = "us-iad"
    type   = "g6-standard-2"
  }
}

variable "vpcNodesSite1" {
  default = {
    id             = "vpc-site1-node"
    type           = "g6-standard-1"
    countPerSubnet = 2
  }
}

variable "vpcNodesSite2" {
  default = {
    id             = "vpc-site2-node"
    type           = "g6-standard-1"
    countPerSubnet = 2
  }
}

variable "vpcGatewaySetup" {
  default = {
    id          = "VPC Gateway"
    description = "Setup a VPC Gateway at the boot."
    os          = "linode/debian10"
  }
}

variable "vpcNodesSetup" {
  default = {
    id          = "VPC Node"
    description = "Setup a VPC Node at the boot."
    os          = "linode/debian10"
  }
}