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
# <UDF name="vpn_server_ip_to_connect" label="Define the VPN server IP/Hostname that you want to connect" default="">

# Creates environment file.
function createEnvironmentFile() {
  if [ -f "/root/.env" ]; then
    source /root/.env
  else
    echo "Creating environment file..."

    echo "export NAME=\"$NAME\"" > /root/.env
    echo "export SSH_PRIVATE_KEY=\"$SSH_PRIVATE_KEY\"" >> /root/.env
    echo "export VPN_SERVER_NETWORK_ADDRESS_PREFIX=\"$VPN_SERVER_NETWORK_ADDRESS_PREFIX\"" >> /root/.env
    echo "export VPN_SERVER_IP_TO_CONNECT=\"$VPN_SERVER_IP_TO_CONNECT\"" >> /root/.env
  fi
}

# Defines the hostname.
function setHostname() {
  echo "Defining hostname..."

  hostnamectl set-hostname "$NAME"

  echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts
}

# Enables the traffic forward between network interfaces.
function enableTrafficForwarding() {
  echo "Enabling traffic forward between network interfaces..."

  echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf

  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  iptables-save > /etc/firewall.conf

  echo "#!/bin/sh" > /etc/network/if-up.d/run-iptables
  echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/run-iptables

  chmod +x /etc/network/if-up.d/run-iptables
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
                 dnsutils \
                 openvpn
}

# Installs the SSH private key to secure the connection between VPC gateways and nodes.
function installSshPrivateKey() {
  echo "Installing the SSH private key to secure the connection between VPC gateways and nodes..."

  if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa

    chmod og-rwx /root/.ssh/id_rsa
  fi
}

# Downloads VPN server setup file.
function downloadVpnServerSetupFile() {
  echo "Downloading VPN server setup file..."

  mkdir -p "$HOME_DIR"/bin

  wget https://raw.githubusercontent.com/fvilarinho/openvpn-setup/main/setup.sh -O "$HOME_DIR"/bin/openvpn-setup.sh

  chmod +x "$HOME_DIR"/bin/openvpn-setup.sh
}

# Installs VPN server.
function installVpnServer() {
  echo "Installing VPN server..."

  export HOME_DIR=/opt/vpcGateway

  downloadVpnServerSetupFile

  export AUTO_INSTALL=y
  export CLIENT="$NAME"
  export SERVER_NETWORK_ADDRESS_PREFIX="$VPN_SERVER_NETWORK_ADDRESS_PREFIX"

  "$HOME_DIR"/bin/openvpn-setup.sh
}

# Connects in the VPN server.
function connectToTheVpnServer() {
  echo "Connecting int the VPN server..."

  CLIENT_DIR="$HOME_DIR"/etc

  while true; do
    echo "Waiting for the VPN client configuration be available..."

    # Gets the VPN client ID.
    CLIENT=$(ssh -q \
                 -o "UserKnownHostsFile=/dev/null" \
                 -o "StrictHostKeyChecking=no" \
                 root@"$VPN_SERVER_IP_TO_CONNECT" "cat /etc/hostname")

    if [ -n "$CLIENT" ]; then
      # Checks if the VPN client configuration exists.
      VPN_IS_OK=$(ssh -q \
                      -o "UserKnownHostsFile=/dev/null" \
                      -o "StrictHostKeyChecking=no" \
                      root@"$VPN_SERVER_IP_TO_CONNECT" "ls $CLIENT_DIR 2> /dev/null" | grep "$CLIENT.ovpn")

      if [ -n "$VPN_IS_OK" ]; then
        break
      fi
    fi

    sleep 1
  done

  # Downloads the VPN client configuration.
  scp -q \
      -o "UserKnownHostsFile=/dev/null" \
      -o "StrictHostKeyChecking=no" \
      root@"$VPN_SERVER_IP_TO_CONNECT:$CLIENT_DIR/$CLIENT.ovpn" /etc/openvpn

  openvpn --config /etc/openvpn/$CLIENT.ovpn
}

# Startup script.
function main() {
  createEnvironmentFile
  setHostname
  enableTrafficForwarding
  installRequiredSoftware
  installSshPrivateKey
  installVpnServer

  if [ -n "$VPN_SERVER_IP_TO_CONNECT" ]; then
    connectToTheVpnServer
  fi
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