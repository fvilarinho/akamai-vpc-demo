# Attributes of the site 1 region.
data "linode_region" "vpcGatewaySite1" {
  id = var.vpcGatewaySite1.region
}

# Attributes of the site 2 region.
data "linode_region" "vpcGatewaySite2" {
  id = var.vpcGatewaySite2.region
}

# Define the VPC gateway for site 1.
resource "linode_instance" "vpcGatewaySite1" {
  label            = var.vpcGatewaySite1.id
  tags             = [
    var.vpcLabel,
    "${var.vpcLabel} (${var.vpcGatewaySite1.label} - ${data.linode_region.vpcGatewaySite1.label})"
  ]
  type             = var.vpcGatewaySite1.type
  region           = var.vpcGatewaySite1.region
  image            = var.vpcGatewaySetup.os
  root_pass        = random_password.vpcGateway.result
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcGatewaySetup.id
  stackscript_data = {
    name                      = var.vpcGatewaySite1.id
    ssh_private_key           = chomp(tls_private_key.vpc.private_key_openssh)
    vpn_server_network_prefix = var.vpcGatewaySite1.vpnServerNetworkPrefix
    vpn_server_network_mask   = var.vpcGatewaySite1.vpnServerNetworkMask
  }

  # WAN (eth0)
  interface {
    purpose = "public"
  }

  # Subnet 1 (eth1)
  interface {
    purpose      = "vlan"
    label        = "subnet1"
    ipam_address = "${var.vpcNodesSite1.subnetsNetworkPrefix}.1.1/${var.vpcNodesSite1.subnetsNetworkMask}"
  }

  # Subnet 2 (eth2)
  interface {
    purpose      = "vlan"
    label        = "subnet2"
    ipam_address = "${var.vpcNodesSite1.subnetsNetworkPrefix}.2.1/${var.vpcNodesSite1.subnetsNetworkMask}"
  }

  depends_on = [
    random_password.vpcGateway,
    tls_private_key.vpc,
    linode_stackscript.vpcGatewaySetup
  ]
}

# Define the VPC gateway for site 1.
resource "linode_instance" "vpcGatewaySite2" {
  label            = var.vpcGatewaySite2.id
  tags             = [
    var.vpcLabel,
    "${var.vpcLabel} (${var.vpcGatewaySite2.label} - ${data.linode_region.vpcGatewaySite2.label})"
  ]
  type             = var.vpcGatewaySite2.type
  region           = var.vpcGatewaySite2.region
  image            = var.vpcGatewaySetup.os
  root_pass        = random_password.vpcGateway.result
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcGatewaySetup.id
  stackscript_data = {
    name                      = var.vpcGatewaySite2.id
    ssh_private_key           = chomp(tls_private_key.vpc.private_key_openssh)
    vpn_server_network_prefix = var.vpcGatewaySite2.vpnServerNetworkPrefix
    vpn_server_network_mask   = var.vpcGatewaySite2.vpnServerNetworkMask
  }

  # WAN (eth0)
  interface {
    purpose = "public"
  }

  # Subnet 1 (eth1)
  interface {
    purpose      = "vlan"
    label        = "subnet1"
    ipam_address = "${var.vpcNodesSite2.subnetsNetworkPrefix}.1.1/${var.vpcNodesSite2.subnetsNetworkMask}"
  }

  # Subnet 2 (eth2)
  interface {
    purpose      = "vlan"
    label        = "subnet2"
    ipam_address = "${var.vpcNodesSite2.subnetsNetworkPrefix}.2.1/${var.vpcNodesSite2.subnetsNetworkMask}"
  }

  depends_on = [
    random_password.vpcGateway,
    tls_private_key.vpc,
    linode_stackscript.vpcGatewaySetup
  ]
}