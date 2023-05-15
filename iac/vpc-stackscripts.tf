# Define the VPC Gateway Setup recipe.
resource "linode_stackscript" "vpcGatewaySetup" {
  label       = var.vpcGatewaySetup.label
  description = var.vpcGatewaySetup.description
  images      = [ var.vpcGatewaySetup.image ]
  script      = <<EOF
#!/bin/bash
# <UDF name="name" label="Define the VPC Gateway Name" default="vpc-gateway">
# <UDF name="sshPrivateKey" label="Define the SSH Private Key to be installed" default="">
# <UDF name="isVpnServer" label="Do you want to enable a VPN Server (OpenVPN)?" oneOf="Yes,No" default="No">
# <UDF name="vpnServerNetworkAddressPrefix" label="Define the VPN Server Network Address Prefix" default="10.8.0.0">
# <UDF name="vpnServerIpToConnect" label="Define the VPN Server IP/Hostname that you want to connect" default="">

# Create environment file.
function createEnvironmentFile() {
  if [ -f "/root/.env" ]; then
    source /root/.env
  else
    echo "Creating environment file..."

    echo "export NAME=\"$NAME\"" > /root/.env
    echo "export SSHPRIVATEKEY=\"$SSHPRIVATEKEY\"" >> /root/.env
    echo "export ISVPNSERVER=\"$ISVPNSERVER\"" >> /root/.env
    echo "export VPNSERVERNETWORKADDRESSPREFIX=\"$VPNSERVERNETWORKADDRESSPREFIX\"" >> /root/.env
    echo "export VPNSERVERIPTOCONNECT=\"$VPNSERVERIPTOCONNECT\"" >> /root/.env
  fi
}

# Define the hostname.
function setHostname() {
  echo "Defining hostname..."

  hostnamectl set-hostname "$NAME"
  echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts
}

# Enable traffic forward between network interfaces.
function enableTrafficForwarding() {
  echo "Enabling traffic forward between network interfaces..."

  echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
  sysctl -p
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  iptables-save > /etc/firewall.conf
  echo "#!/bin/sh" > /etc/network/if-up.d/run-iptables
  echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/run-iptables
  chmod +x /etc/network/if-up.d/run-iptables
}

# Install all required software.
function installRequiredSoftware() {
  echo "Installing all required software..."

  apt update
  apt -y upgrade
  apt -y install htop curl wget zip vim net-tools dnsutils tzdata openvpn locales-all
}

# Install SSH private key to enable communication between VPC gateways and nodes.
function installSshPrivateKey() {
  echo "Installing SSH private key to enable communication between VPC gateways and nodes..."

  if [ -n "$SSHPRIVATEKEY" ]; then
    echo "$SSHPRIVATEKEY" > /root/.ssh/id_rsa

    chmod og-rwx /root/.ssh/id_rsa
  fi
}

# Download VPN Server setup file.
function downloadVpnServerSetupFile() {
  echo "Downloading VPN Server setup file..."

  mkdir -p "$HOME_DIR"/bin

  wget https://raw.githubusercontent.com/fvilarinho/openvpn-setup/main/setup.sh -O "$HOME_DIR"/bin/openvpn-setup.sh

  chmod +x "$HOME_DIR"/bin/openvpn-setup.sh
}

# Install VPN Server based on the defined variables.
function installVpnServer() {
  echo "Installing VPN Server based on the defined variables..."

  export HOME_DIR=/opt/vpcGateway

  downloadVpnServerSetupFile

  export AUTO_INSTALL=y
  export CLIENT="$NAME"
  export SERVER_NETWORK_ADDRESS_PREFIX="$VPNSERVERNETWORKADDRESSPREFIX"

  "$HOME_DIR"/bin/openvpn-setup.sh
}

# Connect into the VPN Server.
function connectToTheVpnServer() {
  echo "Connecting into the VPN Server..."

  ETC_DIR="$HOME_DIR"/etc

  while true; do
    echo "Waiting for the VPN client configuration be available..."

    # Get the VPN client ID.
    CLIENT=$(ssh -q -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@"$VPNSERVERIPTOCONNECT" "cat /etc/hostname")

    if [ -n "$CLIENT" ]; then
      # Check if the VPN client configuration exists.
      VPN_IS_OK=$(ssh -q -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@"$VPNSERVERIPTOCONNECT" "ls $ETC_DIR 2> /dev/null" | grep "$CLIENT.ovpn")

      if [ -n "$VPN_IS_OK" ]; then
        break
      fi
    fi

    sleep 1
  done

  # Download the VPN client configuration.
  scp -q -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@"$VPNSERVERIPTOCONNECT:$ETC_DIR/$CLIENT.ovpn" /etc/openvpn

  openvpn --config /etc/openvpn/$CLIENT.ovpn
}

# Startup script.
function main() {
  createEnvironmentFile
  setHostname
  enableTrafficForwarding
  installRequiredSoftware
  installSshPrivateKey

  if [ "$ISVPNSERVER" == "Yes" ]; then
    installVpnServer
  fi

  if [ -n "$VPNSERVERIPTOCONNECT" ]; then
    connectToTheVpnServer
  fi
}

main
EOF
}

# Define the VPC Nodes Setup recipe.
resource "linode_stackscript" "vpcNodeSetup" {
  label       = var.vpcNodesSetup.label
  description = var.vpcNodesSetup.description
  images      = [ var.vpcNodesSetup.image ]
  script      = <<EOF
#!/bin/bash
# <UDF name="name" label="Define the VPC Node Name" default="vpc-node">
# <UDF name="sshPrivateKey" label="Define the SSH Private Key to be installed" default="">
# <UDF name="defaultGatewayIp" label="Define the VPC Default Gateway IP" default="1.2.3.4">

# Create environment file.
function createEnvironmentFile() {
  if [ -f "/root/.env" ]; then
    source /root/.env
  else
    echo "Creating environment file..."

    echo "export NAME=\"$NAME\"" > /root/.env
    echo "export SSHPRIVATEKEY=\"$SSHPRIVATEKEY\"" >> /root/.env
    echo "export DEFAULTGATEWAYIP=\"$DEFAULTGATEWAYIP\"" >> /root/.env
  fi
}

# Define the hostname.
function setHostname() {
  echo "Defining hostname..."

  hostnamectl set-hostname "$NAME"
  echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts
}

# Add default VPC routes.
function addDefaultRoutes() {
  echo "Adding default VPC routes..."

  route add default gw "$DEFAULTGATEWAYIP" eth0
}

# Install all required software.
function installRequiredSoftware() {
  echo "Installing all required software..."

  apt update
  apt -y upgrade
  apt -y install htop curl wget zip vim net-tools dnsutils tzdata locales-all

  touch /var/lib/cloud/instance/locale-check.skip
}

# Install SSH private key to enable communication between VPC gateways and nodes.
function installSshPrivateKey() {
  echo "Installing SSH private key to enable communication between VPC gateways and nodes..."

  if [ -n "$SSHPRIVATEKEY" ]; then
    echo "$SSHPRIVATEKEY" > /root/.ssh/id_rsa

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