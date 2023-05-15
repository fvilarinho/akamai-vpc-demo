# Define the VPC Nodes instances for Site 1 and Subnet 1.
resource "linode_instance" "vpcNodesSite1Subnet1" {
  count            = var.vpcNodesSite1.countPerSubnet
  label            = "${var.vpcNodesSite1.label}${count.index + 1}-subnet1"
  tags             = [ "Site 1 (${var.vpcGatewaySite1.region})" ]
  type             = var.vpcNodesSite1.type
  region           = var.vpcGatewaySite1.region
  image            = var.vpcNodesSetup.image
  root_pass        = random_string.vpcDefaultPassword.result
  authorized_keys  = [ linode_sshkey.vpcSshPublicKey.ssh_key ]
  stackscript_id   = linode_stackscript.vpcNodeSetup.id
  stackscript_data = {
    name             = "${var.vpcNodesSite1.label}${count.index + 1}-subnet1"
    defaultGatewayIp = "10.1.1.1"
    sshPrivateKey    = chomp(var.sshPrivateKey)
  }

  # Subnet 1 (eth0).
  interface {
    purpose      = "vlan"
    label        = "subnet1"
    ipam_address = "10.1.1.${count.index + 2}/24"
  }

  depends_on = [
    linode_stackscript.vpcNodeSetup,
    linode_instance.vpcGatewaySite1
  ]
}

# Define the VPC Nodes instances for Site 1 and Subnet 2.
resource "linode_instance" "vpcNodesSite1Subnet2" {
  count            = var.vpcNodesSite1.countPerSubnet
  label            = "${var.vpcNodesSite1.label}${count.index + 1}-subnet2"
  tags             =  [ "Site 1 (${var.vpcGatewaySite1.region})" ]
  type             = var.vpcNodesSite1.type
  region           = var.vpcGatewaySite1.region
  image            = var.vpcNodesSetup.image
  root_pass        = random_string.vpcDefaultPassword.result
  authorized_keys  = [ linode_sshkey.vpcSshPublicKey.ssh_key ]
  stackscript_id   = linode_stackscript.vpcNodeSetup.id
  stackscript_data = {
    name             = "${var.vpcNodesSite1.label}${count.index + 1}-subnet2"
    defaultGatewayIp = "10.1.2.1"
    sshPrivateKey    = chomp(var.sshPrivateKey)
  }

  # Subnet 2 (eth0).
  interface {
    purpose      = "vlan"
    label        = "subnet2"
    ipam_address = "10.1.2.${count.index + 2}/24"
  }

  depends_on = [
    linode_stackscript.vpcNodeSetup,
    linode_instance.vpcGatewaySite1
  ]
}

# Define the VPC Nodes instances for Site 2 and Subnet 1.
resource "linode_instance" "vpcNodesSite2Subnet1" {
  count            = var.vpcNodesSite2.countPerSubnet
  label            = "${var.vpcNodesSite2.label}${count.index + 1}-subnet1"
  tags             = [ "Site 2 (${var.vpcGatewaySite2.region})" ]
  type             = var.vpcNodesSite2.type
  region           = var.vpcGatewaySite2.region
  image            = var.vpcNodesSetup.image
  root_pass        = random_string.vpcDefaultPassword.result
  authorized_keys  = [ linode_sshkey.vpcSshPublicKey.ssh_key ]
  stackscript_id   = linode_stackscript.vpcNodeSetup.id
  stackscript_data = {
    name             = "${var.vpcNodesSite2.label}${count.index + 1}-subnet1"
    defaultGatewayIp = "10.2.1.1"
    sshPrivateKey    = chomp(var.sshPrivateKey)
  }

  # Subnet 1 (eth0).
  interface {
    purpose      = "vlan"
    label        = "subnet1"
    ipam_address = "10.2.1.${count.index + 2}/24"
  }

  depends_on = [
    linode_stackscript.vpcNodeSetup,
    linode_instance.vpcGatewaySite2
  ]
}

# Define the VPC Nodes instances for Site 2 and Subnet 2.
resource "linode_instance" "vpcNodesSite2Subnet2" {
  count            = var.vpcNodesSite2.countPerSubnet
  label            = "${var.vpcNodesSite2.label}${count.index + 1}-subnet2"
  tags             = [ "Site 2 (${var.vpcGatewaySite2.region})" ]
  type             = var.vpcNodesSite2.type
  region           = var.vpcGatewaySite2.region
  image            = var.vpcNodesSetup.image
  root_pass        = random_string.vpcDefaultPassword.result
  authorized_keys  = [ linode_sshkey.vpcSshPublicKey.ssh_key ]
  stackscript_id   = linode_stackscript.vpcNodeSetup.id
  stackscript_data = {
    name             = "${var.vpcNodesSite2.label}${count.index}-subnet2"
    defaultGatewayIp = "10.2.2.1"
    sshPrivateKey    = chomp(var.sshPrivateKey)
  }

  # Subnet 2 (eth0).
  interface {
    purpose      = "vlan"
    label        = "subnet2"
    ipam_address = "10.2.2.${count.index + 2}/24"
  }

  depends_on = [
    linode_stackscript.vpcNodeSetup,
    linode_instance.vpcGatewaySite2
  ]
}