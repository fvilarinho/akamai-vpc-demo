# Defines the Firewall rules to access the VPC of site 1.
resource "linode_firewall" "vpcGatewaySite1" {
  label           = "${var.vpcGatewaySite1.id}-firewall"
  tags            = [ var.identifier ]
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    label    = "allow-openvpn"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "1194"
    ipv4     = [ "0.0.0.0/0" ]
  }

  linodes    = [ linode_instance.vpcGatewaySite1.id ]
  depends_on = [ null_resource.connectSite1ToSite2 ]
}

# Defines the Firewall rules to access the VPC of site 2.
resource "linode_firewall" "vpcGatewaySite2" {
  label           = "${var.vpcGatewaySite2.id}-firewall"
  tags            = [ var.identifier ]
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    label    = "allow-openvpn"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "1194"
    ipv4     = [ "${linode_instance.vpcGatewaySite1.ip_address}/32" ]
  }

  linodes    = [ linode_instance.vpcGatewaySite2.id ]
  depends_on = [ null_resource.connectSite1ToSite2 ]
}

# Defines the Firewall rules to access the VPC nodes of the all sites.
resource "linode_firewall" "vpcNodes" {
  label           = "vpc-nodes-firewall"
  tags            = [ var.identifier ]
  inbound_policy  = "ACCEPT"
  outbound_policy = "ACCEPT"

  inbound {
    label    = "block-all-tcp"
    action   = "DROP"
    protocol = "TCP"
    ipv4     = [ "0.0.0.0/0" ]
  }

  inbound {
    label    = "block-all-udp"
    action   = "DROP"
    protocol = "UDP"
    ipv4     = [ "0.0.0.0/0" ]
  }

  inbound {
    label    = "block-all-icmp"
    action   = "DROP"
    protocol = "ICMP"
    ipv4     = [ "0.0.0.0/0" ]
  }

  linodes = concat(linode_instance.vpcNodesSite1Subnet1.*.id,
    linode_instance.vpcNodesSite1Subnet2.*.id,
    linode_instance.vpcNodesSite2Subnet1.*.id,
    linode_instance.vpcNodesSite2Subnet2.*.id)

  depends_on = [
    linode_firewall.vpcGatewaySite1,
    linode_firewall.vpcGatewaySite2
  ]
}