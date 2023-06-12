# Defines the VPC gateway setup recipe.
resource "linode_stackscript" "vpcGatewaySetup" {
  label       = var.vpcGatewaySetup.id
  description = var.vpcGatewaySetup.description
  images      = [ var.vpcGatewaySetup.os ]
  script      = <<EOF
#!/bin/bash
# <UDF name="name" label="Define the VPC gateway name" default="vpc-gateway">
# <UDF name="ssh_private_key" label="Define the SSH private key to secure the remote connection" default="">
# <UDF name="vpn_server_network_address_prefix" label="Define the VPN server network address prefix" default="10.8.0.0">

# Prepare the environment to execute the commands of this script.
function prepareToExecute() {
  echo -e "\033c"

  export HOME_DIR=/opt/vpcGateway
  export BIN_DIR="$HOME_DIR"/bin
  export ETC_DIR="$HOME_DIR"/etc

  mkdir -p "$BIN_DIR" 2> /dev/null
  mkdir -p "$ETC_DIR" 2> /dev/null

  createEnvironmentFile
}

# Creates environment file.
function createEnvironmentFile() {
  if [ -f "$HOME"/.env ]; then
    source "$HOME"/.env
  else
    echo "Creating environment file..." > /dev/ttyS0

    echo "export HOME_DIR=/opt/vpcGateway" > $HOME/.env
    echo "export BIN_DIR=\"$HOME_DIR\"/bin" >> $HOME/.env
    echo "export ETC_DIR=\"$HOME_DIR\"/etc" >> $HOME/.env
    echo "export NAME=\"$NAME\"" >> $HOME/.env
    echo "export SSH_PRIVATE_KEY=\"$SSH_PRIVATE_KEY\"" >> $HOME/.env
    echo "export VPN_SERVER_NETWORK_ADDRESS_PREFIX=$VPN_SERVER_NETWORK_ADDRESS_PREFIX" >> $HOME/.env
  fi
}

# Defines the hostname.
function setHostname() {
  echo "Defining hostname..." > /dev/ttyS0

  hostnamectl set-hostname "$NAME"

  echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts
}

# Enables the traffic forward between network interfaces.
function enableTrafficForwarding() {
  echo "Enabling traffic forward between network interfaces..." > /dev/ttyS0

  echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf

  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  iptables-save > /etc/firewall.conf

  echo "#!/bin/sh" > /etc/network/if-up.d/run-iptables
  echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/run-iptables

  chmod +x /etc/network/if-up.d/run-iptables
}

# Installs all required software.
function installRequiredSoftware() {
  echo "Installing all required software..." > /dev/ttyS0

  apt update > /dev/ttyS0
  apt -y upgrade > /dev/ttyS0
  apt -y install locales-all \
                 tzdata \
                 htop \
                 curl \
                 wget \
                 zip \
                 vim \
                 net-tools \
                 dnsutils \
                 openvpn > /dev/ttyS0
}

# Installs the SSH private key to secure the connection between VPC gateways and nodes.
function installSshPrivateKey() {
  if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo "Installing the SSH private key to secure the connection between VPC gateways and nodes..." > /dev/ttyS0

    mkdir -p "$HOME"/.ssh 2> /dev/null

    echo "$SSH_PRIVATE_KEY" > "$HOME"/.ssh/id_rsa

    chmod og-rwx "$HOME"/.ssh/id_rsa
  fi
}

# Installs VPN server.
function installVpnServer() {
  echo "Installing VPN server..." > /dev/ttyS0

  wget https://raw.githubusercontent.com/fvilarinho/openvpn-setup/main/setup.sh -O "$BIN_DIR"/vpnSetup.sh > /dev/ttyS0
  wget https://raw.githubusercontent.com/fvilarinho/akamai-vpc-demo/main/iac/vpnClient.sh -O "$BIN_DIR"/vpnClient.sh > /dev/ttyS0
  wget https://raw.githubusercontent.com/fvilarinho/akamai-vpc-demo/main/iac/connectToSite.sh -O "$HOME"/connectToSite.sh > /dev/ttyS0

  chmod +x "$BIN_DIR"/*.sh
  chmod +x "$HOME"/*.sh

  export AUTO_INSTALL=y
  export CLIENT="$NAME"
  export SERVER_NETWORK_ADDRESS_PREFIX=$VPN_SERVER_NETWORK_ADDRESS_PREFIX

  $BIN_DIR/vpnSetup.sh > /dev/ttyS0
}

# Startup script.
function main() {
  prepareToExecute
  setHostname
  enableTrafficForwarding
  installRequiredSoftware
  installSshPrivateKey
  installVpnServer
}

main
EOF
}

# Defines the VPC node setup recipe.
resource "linode_stackscript" "vpcNodeSetup" {
  label       = var.vpcNodesSetup.id
  description = var.vpcNodesSetup.description
  images      = [ var.vpcNodesSetup.os ]
  script      = <<EOF
#!/bin/bash
# <UDF name="name" label="Defines the VPC node name" default="vpc-node">
# <UDF name="ssh_private_key" label="Define the SSH private key to secure the remote connection" default="">
# <UDF name="default_gateway_ip" label="Defines the default gateway IP" default="1.2.3.4">

# Creates the environment file.
function createEnvironmentFile() {
  if [ -f "/root/.env" ]; then
    source /root/.env
  else
    echo "Creating environment file..."

    echo "export NAME=\"$NAME\"" > /root/.env
    echo "export SSH_PRIVATE_KEY=\"$SSH_PRIVATE_KEY\"" >> /root/.env
    echo "export DEFAULT_GATEWAY_IP=\"$DEFAULT_GATEWAY_IP\"" >> /root/.env
  fi
}

# Defines the hostname.
function setHostname() {
  echo "Defining hostname..."

  hostnamectl set-hostname "$NAME"

  echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts
}

# Adds the default gateway route.
function addDefaultRoutes() {
  echo "Adding default gateway route..."

  route add default gw "$DEFAULT_GATEWAY_IP" eth0
}

# Installs all required software.
function installRequiredSoftware() {
  echo "Installing all required software..."

  apt update
  apt -y upgrade
  apt -y install locales-all \
                 tzdata \
                 htop \
                 curl \
                 wget \
                 zip \
                 vim \
                 net-tools \
                 dnsutils
}

# Installs the SSH private key to secure the connection between VPC gateways and nodes.
function installSshPrivateKey() {
  echo "Installing the SSH private key secure the connection between VPC gateways and nodes..."

  if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa

    chmod og-rwx /root/.ssh/id_rsa
  fi
}

# Startup script.
function main() {
  createEnvironmentFile
  setHostname
  addDefaultRoutes
  installRequiredSoftware
  installSshPrivateKey
}

main
EOF
}