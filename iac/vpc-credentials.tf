# Define the default password for the VPC Gateways and Nodes.
resource "random_password" "vpcDefaultPassword" {
  length = 16
}

# Define the SSH Private Key to be used to connect in the VPC Gateways and Nodes.
resource "tls_private_key" "vpc" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Save the SSH Private Key locally to be used to connect in the VPC Gateways and Nodes.
resource "local_sensitive_file" "privateKey" {
  filename = "/tmp/.id_rsa"
  content = tls_private_key.vpc.private_key_openssh
}

# Download the VPN client configuration file.
resource "null_resource" "downloadVpnClientConfigurationFile" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "./downloadVpnClientConfigurationFile.sh ${linode_instance.vpcGatewaySite1.ip_address}"
  }

  depends_on = [
    local_sensitive_file.privateKey,
    linode_instance.vpcGatewaySite1,
    linode_instance.vpcGatewaySite2,
    linode_instance.vpcNodesSite1Subnet1,
    linode_instance.vpcNodesSite1Subnet2,
    linode_instance.vpcNodesSite2Subnet1,
    linode_instance.vpcNodesSite2Subnet2
  ]
}