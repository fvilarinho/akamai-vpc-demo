variable "linodeToken" {
  default = "linodeToken"
}

variable "sshPublicKeyFile" {
  default = "~/.ssh/id_rsa.pub"
}

variable "sshPrivateKeyFile" {
  default = "~/.ssh/id_rsa"
}

variable "vpcGatewaySite1" {
  default = {
    label  = "vpc-site1-gateway"
    region = "us-east"
    type   = "g6-standard-2"
  }
}

variable "vpcGatewaySite2" {
  default = {
    label  = "vpc-site2-gateway"
    region = "us-iad"
    type   = "g6-standard-2"
  }
}

variable "vpcNodesSite1" {
  default = {
    label          = "vpc-site1-node"
    type           = "g6-standard-1"
    countPerSubnet = 2
  }
}

variable "vpcNodesSite2" {
  default = {
    label          = "vpc-site2-node"
    type           = "g6-standard-1"
    countPerSubnet = 2
  }
}

variable "vpcGatewaySetup" {
  default = {
    label       = "VPC Gateway"
    description = "Setup a VPC Gateway at the boot."
    image       = "linode/debian10"
  }
}

variable "vpcNodesSetup" {
  default = {
    label       = "VPC Node"
    description = "Setup a VPC Node at the boot."
    image       = "linode/debian10"
  }
}