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
  tags             = [ "Site 1 (${data.linode_region.vpcGatewaySite1.label})" ]
  type             = var.vpcGatewaySite1.type
  region           = var.vpcGatewaySite1.region
  image            = var.vpcGatewaySetup.os
  root_pass        = random_password.vpcGateway.result
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcGatewaySetup.id
  stackscript_data = {
    name                              = var.vpcGatewaySite1.id
    vpn_server_network_address_prefix = "10.8.0.0"
    ssh_private_key                   = chomp(tls_private_key.vpc.private_key_openssh)
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
    random_password.vpcGateway,
    tls_private_key.vpc,
    linode_stackscript.vpcGatewaySetup
  ]
}

# Define the VPC gateway for site 1.
resource "linode_instance" "vpcGatewaySite2" {
  label            = var.vpcGatewaySite2.id
  tags             = [ "Site 2 (${data.linode_region.vpcGatewaySite2.label})" ]
  type             = var.vpcGatewaySite2.type
  region           = var.vpcGatewaySite2.region
  image            = var.vpcGatewaySetup.os
  root_pass        = random_password.vpcGateway.result
  authorized_keys  = [ chomp(tls_private_key.vpc.public_key_openssh) ]
  stackscript_id   = linode_stackscript.vpcGatewaySetup.id
  stackscript_data = {
    name                              = var.vpcGatewaySite2.id
    vpn_server_network_address_prefix = "10.9.0.0"
    ssh_private_key                   = chomp(tls_private_key.vpc.private_key_openssh)
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

  depends_on = [
    random_password.vpcGateway,
    tls_private_key.vpc,
    linode_stackscript.vpcGatewaySetup
  ]
}