# Define the default password for the VPC Gateways and Nodes.
resource "random_string" "vpcDefaultPassword" {
  length = 16
}

# Define the SSH Public Key to be installed in the VPC Gateways and Nodes and used for remote access.
resource "linode_sshkey" "vpcSshPublicKey" {
  label   = "vpc-ssh-public-key"
  ssh_key = chomp(file(var.sshPublicKeyFile))
}