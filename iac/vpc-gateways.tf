# Define the VPC Gateway for Site 1.
resource "linode_instance" "vpcGatewaySite1" {
  label            = var.vpcGatewaySite1.id
  tags             = [ "Site 1 (${var.vpcGatewaySite1.region})" ]
  type             = var.vpcGatewaySite1.type
  region           = var.vpcGatewaySite1.region
  image            = var.vpcGatewaySetup.os
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcGatewaySetup.id
  stackscript_data = {
    name                          = var.vpcGatewaySite1.id
    vpnServerNetworkAddressPrefix = "10.8.0.0"
    vpnServerIpToConnect          = linode_instance.vpcGatewaySite2.ip_address
    sshPrivateKey                 = chomp(tls_private_key.vpc.private_key_openssh)
  }

  # WAN (eth0)
  interface {
    purpose = "public"
  }

  # Subnet 1 (eth1)
  interface {
    purpose      = "vlan"
    label        = "subnet1"
    ipam_address = "10.1.1.1/24"
  }

  # Subnet 2 (eth2)
  interface {
    purpose      = "vlan"
    label        = "subnet2"
    ipam_address = "10.1.2.1/24"
  }

  depends_on = [
    linode_stackscript.vpcGatewaySetup,
    linode_instance.vpcGatewaySite2
  ]
}

# Define the VPC Gateway for Site 2.
resource "linode_instance" "vpcGatewaySite2" {
  label            = var.vpcGatewaySite2.id
  tags             = [ "Site 2 (${var.vpcGatewaySite2.region})" ]
  type             = var.vpcGatewaySite2.type
  region           = var.vpcGatewaySite2.region
  image            = var.vpcGatewaySetup.os
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcGatewaySetup.id
  stackscript_data = {
    name                          = var.vpcGatewaySite2.id
    vpnServerNetworkAddressPrefix = "10.9.0.0"
    sshPrivateKey                 = chomp(tls_private_key.vpc.private_key_openssh)
  }

  # WAN (eth0)
  interface {
    purpose = "public"
  }

  # Subnet 1 (eth1)
  interface {
    purpose      = "vlan"
    label        = "subnet1"
    ipam_address = "10.2.1.1/24"
  }

  # Subnet 2 (eth2)
  interface {
    purpose      = "vlan"
    label        = "subnet2"
    ipam_address = "10.2.2.1/24"
  }

  depends_on = [ linode_stackscript.vpcGatewaySetup ]
}