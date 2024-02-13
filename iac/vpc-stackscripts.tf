# Defines the VPC gateway setup recipe.
resource "linode_stackscript" "vpcGatewaySetup" {
  label       = var.vpcGatewaySetup.id
  description = var.vpcGatewaySetup.description
  images      = [ var.vpcGatewaySetup.os ]
  is_public   = true
  script      = <<EOF
#!/bin/bash
# <UDF name="name" label="Define the VPC gateway name" default="vpc-gateway">
# <UDF name="ssh_private_key" label="Define the SSH private key to secure the remote connection" default="">
# <UDF name="vpn_server_network_prefix" label="Define the VPN server network prefix" default="10.8.0.0">
# <UDF name="vpn_server_network_mask" label="Define the VPN server network mask" default="24">

# Prepare the environment to execute the commands of this script.
function prepareToExecute() {
  echo -e "\033c" > /dev/ttyS0

  # VPC files/paths.
  export HOME_DIR=/opt/vpcGateway
  export BIN_DIR="$HOME_DIR"/bin
  export ETC_DIR="$HOME_DIR"/etc

  # Create VPC files/paths.
  mkdir -p "$BIN_DIR" 2> /dev/null
  mkdir -p "$ETC_DIR" 2> /dev/null

  createEnvironmentFile
}

# Creates environment file.
function createEnvironmentFile() {
  ENV_FILE="$HOME"/.env

  if [ ! -f "$ENV_FILE" ]; then
    echo "Creating environment file..." > /dev/ttyS0

    echo "export HOME_DIR=/opt/vpcGateway" > "$ENV_FILE"
    echo "export BIN_DIR=\"$HOME_DIR\"/bin" >> "$ENV_FILE"
    echo "export ETC_DIR=\"$HOME_DIR\"/etc" >> "$ENV_FILE"

    echo "Environment file was created!" > /dev/ttyS0
  fi
}

# Defines the hostname.
function setHostname() {
  if [ -n "$NAME" ]; then
    echo "Defining hostname..." > /dev/ttyS0

    hostnamectl set-hostname "$NAME"

    echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts

    echo "Hostname defined!" > /dev/ttyS0
  fi
}

# Enables the traffic forward between network interfaces.
function enableTrafficForwarding() {
  echo "Enabling traffic forwarding between network interfaces..." > /dev/ttyS0

  echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf

  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  iptables-save > /etc/firewall.conf

  echo "#!/bin/sh" > /etc/network/if-up.d/run-iptables
  echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/run-iptables

  chmod +x /etc/network/if-up.d/run-iptables

  echo "Traffic forwarding enabled!" > /dev/ttyS0
}

# Installs all required software.
function installRequiredSoftware() {
  echo "Installing all required software. It may take some minutes to complete. PLease wait..." > /dev/ttyS0

  export DEBIAN_FRONTEND=noninteractive

  apt update > /dev/null
  apt -y upgrade > /dev/null
  apt -y install locales-all \
                 tzdata \
                 htop \
                 curl \
                 wget \
                 zip \
                 vim \
                 net-tools \
                 dnsutils \
                 openvpn > /dev/null

  echo "All required software were installed!" > /dev/ttyS0
}

# Installs the SSH private key to secure the connection between VPC gateways and nodes.
function installSshPrivateKey() {
  if [ -n "$SSH_PRIVATE_KEY" ]; then
    PRIVATE_KEY_DIR="$HOME"/.ssh
    PRIVATE_KEY_FILENAME="$PRIVATE_KEY_DIR"/id_rsa

    echo "Installing the SSH private key to secure the connection between VPC gateways and nodes..." > /dev/ttyS0

    mkdir -p "$PRIVATE_KEY_DIR" 2> /dev/null

    echo "$SSH_PRIVATE_KEY" > "$PRIVATE_KEY_FILENAME"

    chmod og-rwx "$PRIVATE_KEY_FILENAME"

    echo "The SSH private key was installed!" > /dev/ttyS0
  fi
}

# Installs VPN server.
function installVpnServer() {
  if [ -n "$NAME" ]; then
    if [ -n "$VPN_SERVER_NETWORK_PREFIX" ]; then
      if [ -n "$VPN_SERVER_NETWORK_MASK" ]; then
        echo "Installing VPN server..." > /dev/ttyS0

        wget https://raw.githubusercontent.com/fvilarinho/openvpn-setup/main/setup.sh -O "$BIN_DIR"/vpnSetup.sh
        wget https://raw.githubusercontent.com/fvilarinho/akamai-vpc-demo/main/iac/downloadVpnClient.sh -O "$BIN_DIR"/downloadVpnClient.sh
        wget https://raw.githubusercontent.com/fvilarinho/akamai-vpc-demo/main/iac/connectToSite.sh -O "$HOME"/connectToSite.sh

        chmod +x "$BIN_DIR"/*.sh
        chmod +x "$HOME"/*.sh

        export AUTO_INSTALL=y
        export CLIENT="$NAME"
        export SERVER_NETWORK_PREFIX=$VPN_SERVER_NETWORK_PREFIX
        export SERVER_NETWORK_MASK=$VPN_SERVER_NETWORK_MASK

        $BIN_DIR/vpnSetup.sh

        echo "VPN server was installed!" > /dev/ttyS0
      fi
    fi
  fi
}

# Startup script.
function main() {
  prepareToExecute
  setHostname
  enableTrafficForwarding
  installSshPrivateKey
  installRequiredSoftware
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
  is_public   = true
  script      = <<EOF
#!/bin/bash
# <UDF name="name" label="Defines the VPC node name" default="vpc-node">
# <UDF name="ssh_private_key" label="Define the SSH private key to secure the remote connection" default="">
# <UDF name="default_gateway_ip" label="Defines the default gateway IP" default="1.2.3.4">

# Prepare the environment to execute the commands of this script.
function prepareToExecute() {
  echo -e "\033c" > /dev/ttyS0
}

# Defines the hostname.
function setHostname() {
  if [ -n "$NAME" ]; then
    echo "Defining hostname..." > /dev/ttyS0

    hostnamectl set-hostname "$NAME"

    echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts

    echo "Hostname defined!" > /dev/ttyS0
  fi
}

# Adds the default gateway route.
function addDefaultRoutes() {
  if [ -n "$DEFAULT_GATEWAY_IP" ]; then
    echo "Adding the default gateway route..." > /dev/ttyS0

    route add default gw "$DEFAULT_GATEWAY_IP" eth0

    echo "The default default route was defined!" > /dev/ttyS0
  fi
}

# Installs all required software.
function installRequiredSoftware() {
  echo "Installing all required software. It may take some minutes to complete. PLease wait..." > /dev/ttyS0

  export DEBIAN_FRONTEND=noninteractive

  apt update > /dev/null
  apt -y upgrade > /dev/null
  apt -y install locales-all \
                 tzdata \
                 htop \
                 curl \
                 wget \
                 zip \
                 vim \
                 net-tools \
                 dnsutils > /dev/null

  echo "All required software were installed!" > /dev/ttyS0
}

# Installs the SSH private key to secure the connection between VPC gateways and nodes.
function installSshPrivateKey() {
  if [ -n "$SSH_PRIVATE_KEY" ]; then
    PRIVATE_KEY_DIR="$HOME"/.ssh
    PRIVATE_KEY_FILENAME="$PRIVATE_KEY_DIR"/id_rsa

    echo "Installing the SSH private key to secure the connection between VPC gateways and nodes..." > /dev/ttyS0

    mkdir -p "$PRIVATE_KEY_DIR" 2> /dev/null

    echo "$SSH_PRIVATE_KEY" > "$PRIVATE_KEY_FILENAME"

    chmod og-rwx "$PRIVATE_KEY_FILENAME"

    echo "The SSH private key was installed!" > /dev/ttyS0
  fi
}

# Startup script.
function main() {
  prepareToExecute
  setHostname
  addDefaultRoutes
  installSshPrivateKey
  installRequiredSoftware
}

main
EOF
}