# Define the VPC domain (It must be already created).
data  "linode_domain" "vpcDomain" {
  domain = var.vpcDomain
}

# Define the VPC domain record.
resource "linode_domain_record" "vpcDomainRecord" {
  domain_id   = data.linode_domain.vpcDomain.id
  name        = var.vpcGatewaySite1.label
  record_type = "A"
  target      = linode_instance.vpcGatewaySite1.ip_address
}