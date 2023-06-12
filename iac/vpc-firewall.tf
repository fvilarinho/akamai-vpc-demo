# Defines the Firewall rules to access the VPC of site 1.
resource "linode_firewall" "vpcGatewaySite1" {
  label           = "${var.vpcGatewaySite1.id}-firewall"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = [ "0.0.0.0/0" ]
  }

  inbound {
    label    = "allow-openvpn"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "1194"
    ipv4     = [ "0.0.0.0/0" ]
  }

  linodes    = [ linode_instance.vpcGatewaySite1.id ]
  depends_on = [
    linode_instance.vpcGatewaySite1,
    null_resource.connectSite1ToSite2
  ]
}

# Defines the Firewall rules to access the VPC of site 2.
resource "linode_firewall" "vpcGatewaySite2" {
  label           = "${var.vpcGatewaySite2.id}-firewall"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = [ "${linode_instance.vpcGatewaySite1.ip_address}/32" ]
  }

  inbound {
    label    = "allow-openvpn"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "1194"
    ipv4     = [ "${linode_instance.vpcGatewaySite1.ip_address}/32" ]
  }

  linodes    = [ linode_instance.vpcGatewaySite2.id ]
  depends_on = [
    linode_instance.vpcGatewaySite2,
    null_resource.connectSite2ToSite1
  ]
}