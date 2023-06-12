# Connect the site 1 with site 2.
resource "null_resource" "connectSite1ToSite2" {
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.vpcGatewaySite1.ip_address
      user        = "root"
      password    = random_password.vpcGateway.result
      private_key = chomp(tls_private_key.vpc.private_key_openssh)
    }

    inline = [ "./connectToSite.sh ${linode_instance.vpcGatewaySite2.ip_address}" ]
  }

  depends_on = [ null_resource.downloadVpnClient ]
}

# Connect the site 2 with site 1.
resource "null_resource" "connectSite2ToSite1" {
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.vpcGatewaySite2.ip_address
      user        = "root"
      password    = random_password.vpcGateway.result
      private_key = chomp(tls_private_key.vpc.private_key_openssh)
    }

    inline = [ "./connectToSite.sh ${linode_instance.vpcGatewaySite1.ip_address}" ]
  }

  depends_on = [
    null_resource.downloadVpnClient,
    null_resource.connectSite1ToSite2
  ]
}