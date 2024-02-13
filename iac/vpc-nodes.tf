# Defines the VPC nodes for site 1 and subnet 1.
resource "linode_instance" "vpcNodesSite1Subnet1" {
  count            = var.vpcNodesSite1.countPerSubnet
  label            = "${var.vpcNodesSite1.id}${count.index + 1}-subnet1"
  tags             = [ var.identifier ]
  type             = var.vpcNodesSite1.type
  region           = var.vpcGatewaySite1.region
  image            = var.vpcNodesSetup.os
  root_pass        = random_password.vpcNode.result
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcNodeSetup.id
  stackscript_data = {
    name               = "${var.vpcNodesSite1.id}${count.index + 1}-subnet1"
    ssh_private_key    = chomp(tls_private_key.vpc.private_key_openssh)
    default_gateway_ip = "${var.vpcNodesSite1.subnetsNetworkPrefix}.1.1"
  }

  # Subnet 1 (eth0).
  interface {
    purpose      = "vlan"
    label        = "subnet1"
    ipam_address = "${var.vpcNodesSite1.subnetsNetworkPrefix}.1.${count.index + 2}/${var.vpcNodesSite1.subnetsNetworkMask}"
  }

  depends_on = [
    random_password.vpcNode,
    tls_private_key.vpc,
    linode_stackscript.vpcNodeSetup,
    linode_instance.vpcGatewaySite1
  ]
}

# Defines the VPC nodes for site 1 and subnet 2.
resource "linode_instance" "vpcNodesSite1Subnet2" {
  count            = var.vpcNodesSite1.countPerSubnet
  label            = "${var.vpcNodesSite1.id}${count.index + 1}-subnet2"
  tags             = [ var.identifier ]
  type             = var.vpcNodesSite1.type
  region           = var.vpcGatewaySite1.region
  image            = var.vpcNodesSetup.os
  root_pass        = random_password.vpcNode.result
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcNodeSetup.id
  stackscript_data = {
    name               = "${var.vpcNodesSite1.id}${count.index + 1}-subnet2"
    ssh_private_key    = chomp(tls_private_key.vpc.private_key_openssh)
    default_gateway_ip = "${var.vpcNodesSite1.subnetsNetworkPrefix}.2.1"
  }

  # Subnet 2 (eth0).
  interface {
    purpose      = "vlan"
    label        = "subnet2"
    ipam_address = "${var.vpcNodesSite1.subnetsNetworkPrefix}.2.${count.index + 2}/${var.vpcNodesSite1.subnetsNetworkMask}"
  }

  depends_on = [
    random_password.vpcNode,
    tls_private_key.vpc,
    linode_stackscript.vpcNodeSetup,
    linode_instance.vpcGatewaySite1
  ]
}

# Defines the VPC nodes for site 2 and subnet 1.
resource "linode_instance" "vpcNodesSite2Subnet1" {
  count            = var.vpcNodesSite2.countPerSubnet
  label            = "${var.vpcNodesSite2.id}${count.index + 1}-subnet1"
  tags             = [ var.identifier ]
  type             = var.vpcNodesSite2.type
  region           = var.vpcGatewaySite2.region
  image            = var.vpcNodesSetup.os
  root_pass        = random_password.vpcNode.result
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcNodeSetup.id
  stackscript_data = {
    name               = "${var.vpcNodesSite2.id}${count.index + 1}-subnet1"
    ssh_private_key    = chomp(tls_private_key.vpc.private_key_openssh)
    default_gateway_ip = "${var.vpcNodesSite2.subnetsNetworkPrefix}.1.1"
  }

  # Subnet 1 (eth0).
  interface {
    purpose      = "vlan"
    label        = "subnet1"
    ipam_address = "${var.vpcNodesSite2.subnetsNetworkPrefix}.1.${count.index + 2}/${var.vpcNodesSite2.subnetsNetworkMask}"
  }

  depends_on = [
    random_password.vpcNode,
    tls_private_key.vpc,
    linode_stackscript.vpcNodeSetup,
    linode_instance.vpcGatewaySite2
  ]
}

# Defines the VPC nodes for site 2 and subnet 2.
resource "linode_instance" "vpcNodesSite2Subnet2" {
  count            = var.vpcNodesSite2.countPerSubnet
  label            = "${var.vpcNodesSite2.id}${count.index + 1}-subnet2"
  tags             = [ var.identifier ]
  type             = var.vpcNodesSite2.type
  region           = var.vpcGatewaySite2.region
  image            = var.vpcNodesSetup.os
  root_pass        = random_password.vpcNode.result
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcNodeSetup.id
  stackscript_data = {
    name               = "${var.vpcNodesSite2.id}${count.index}-subnet2"
    ssh_private_key    = chomp(tls_private_key.vpc.private_key_openssh)
    default_gateway_ip = "${var.vpcNodesSite2.subnetsNetworkPrefix}.2.1"
  }

  # Subnet 2 (eth0).
  interface {
    purpose      = "vlan"
    label        = "subnet2"
    ipam_address = "${var.vpcNodesSite2.subnetsNetworkPrefix}.2.${count.index + 2}/${var.vpcNodesSite2.subnetsNetworkMask}"
  }

  depends_on = [
    random_password.vpcNode,
    tls_private_key.vpc,
    linode_stackscript.vpcNodeSetup,
    linode_instance.vpcGatewaySite2
  ]
}