# Defines the default password for the VPC gateways.
resource "random_password" "vpcGateway" {
  length = 15
}

# Defines the default password for the VPC nodes.
resource "random_password" "vpcNode" {
  length = 15
}

# Generates the SSH private key to secure the remote connection in the VPC gateways and nodes.
resource "tls_private_key" "vpc" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Defines local variables.
locals {
  privateKeyFilename = "${local.workDir}/.id_rsa"
}

# Save the SSH private key locally to be able to download the VPN client configuration file in the VPN server.
resource "local_sensitive_file" "privateKey" {
  filename   = local.privateKeyFilename
  content    = tls_private_key.vpc.private_key_openssh
  depends_on = [ tls_private_key.vpc ]
}

# Downloads the VPN client configuration file.
resource "null_resource" "downloadVpnClientConfigurationFile" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    environment = {
      PRIVATE_KEY_FILENAME     = local.privateKeyFilename
      VPN_SERVER_IP_TO_CONNECT = linode_instance.vpcGatewaySite1.ip_address
    }

    quiet   = true
    command = "./downloadVpnClientConfigurationFile.sh"
  }

  depends_on = [
    local_sensitive_file.privateKey,
    linode_instance.vpcGatewaySite1,
    linode_instance.vpcGatewaySite2
  ]
}