# Define the default password for the VPC Gateways and Nodes.
resource "random_string" "vpcDefaultPassword" {
  length = 16
}

# Define the SSH Public Key to be installed in the VPC Gateways and Nodes and used for remote access.
resource "linode_sshkey" "vpcSshPublicKey" {
  label   = "vpc-ssh-public-key"
  ssh_key = chomp(var.sshPublicKey)
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
    linode_instance.vpcGatewaySite1,
    linode_instance.vpcGatewaySite2,
    linode_instance.vpcNodesSite1Subnet1,
    linode_instance.vpcNodesSite1Subnet2,
    linode_instance.vpcNodesSite2Subnet1,
    linode_instance.vpcNodesSite2Subnet2
  ]
}