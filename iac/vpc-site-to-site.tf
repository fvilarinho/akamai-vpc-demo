resource "null_resource" "connectSite1ToSite2" {
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.vpcGatewaySite2.ip_address
      user        = "root"
      password    = random_password.vpcGateway.result
      private_key = chomp(tls_private_key.vpc.private_key_openssh)
    }

    inline = [
      "export PRIVATE_KEY_FILENAME=$HOME/.ssh/id_rsa",
      "export VPN_SERVER_IP_TO_CONNECT=${linode_instance.vpcGatewaySite2.ip_address}",
      "source \"$HOME\".env",
      "$BIN_DIR/vpnClient.sh"
    ]
  }
}