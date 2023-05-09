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

function setHostname() {
  hostnamectl set-hostname "$NAME"
  echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts
}

function enableTrafficForwarding() {
  echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
  sysctl -p
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  iptables-save > /etc/firewall.conf
  echo "#!/bin/sh" > /etc/network/if-up.d/run-iptables
  echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/run-iptables
  chmod +x /etc/network/if-up.d/run-iptables
}

function installRequiredSoftware() {
  apt update
  apt -y upgrade
  apt -y install htop curl wget zip vim net-tools dnsutils tzdata openvpn locales-all

  touch /var/lib/cloud/instance/locale-check.skip
}

function installSshPrivateKey() {
  if [ -n "$SSHPRIVATEKEY" ]; then
    echo "$SSHPRIVATEKEY" > /root/.ssh/id_rsa

    chmod og-rwx /root/.ssh/id_rsa
  fi
}

function downloadVpnServerSetupFile() {
  mkdir -p "$HOME_DIR"/bin

  wget https://raw.githubusercontent.com/fvilarinho/openvpn-setup/main/setup.sh -O "$HOME_DIR"/bin/openvpn-setup.sh

  chmod +x "$HOME_DIR"/bin/openvpn-setup.sh
}

function installVpnServer() {
  export HOME_DIR=/opt/vpcGateway

  downloadVpnServerSetupFile

  export AUTO_INSTALL=y
  export CLIENT="$NAME"
  export SERVER_NETWORK_ADDRESS_PREFIX="$VPNSERVERNETWORKADDRESSPREFIX"

  "$HOME_DIR"/bin/openvpn-setup.sh
}

function connectToTheVpnServer() {
  ETC_DIR="$HOME_DIR"/etc

  while true; do
    echo "Waiting for the VPN Server client configuration be available..."

    CLIENT=$(ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@"$VPNSERVERIPTOCONNECT" "cat /etc/hostname")

    if [ -n "$CLIENT" ]; then
      VPN_IS_OK=$(ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -q root@"$VPNSERVERIPTOCONNECT" "ls $ETC_DIR" | grep "$CLIENT.ovpn")

      if [ -n "$VPN_IS_OK" ]; then
        break
      fi
    fi

    sleep 1
  done

  scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@"$VPNSERVERIPTOCONNECT":"$ETC_DIR/$CLIENT.ovpn" /etc/openvpn

  openvpn --config /etc/openvpn/$CLIENT.ovpn
}

function main() {
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

function setHostname() {
  hostnamectl set-hostname "$NAME"
  echo "$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')" "$NAME" >> /etc/hosts
}

function addDefaultRoutes() {
  route add default gw "$DEFAULTGATEWAYIP" eth0
}

function installRequiredSoftware() {
  apt update
  apt -y upgrade
  apt -y install htop curl wget zip vim net-tools dnsutils tzdata locales-all

  touch /var/lib/cloud/instance/locale-check.skip
}

function installSshPrivateKey() {
  if [ -n "$SSHPRIVATEKEY" ]; then
    echo "$SSHPRIVATEKEY" > /root/.ssh/id_rsa

    chmod og-rwx /root/.ssh/id_rsa
  fi
}

function main() {
  setHostname
  addDefaultRoutes
  installRequiredSoftware
  installSshPrivateKey
}

main
EOF
}