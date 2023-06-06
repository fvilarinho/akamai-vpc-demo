#!/bin/bash

# Check for dependencies of this script.
function checkDependencies() {
  VPNSERVERIPTOCONNECT=$1

  # Check if the VPN Server IP was defined.
  if [ -z "$VPNSERVERIPTOCONNECT" ]; then
    echo "Please specify the VPN Server IP/Hostname to connect!"

    exit 1
  fi
}

# Prepare the environment to execute the commands of this script.
function prepareToExecute() {
  # Set default variables.
  HOME_DIR=/opt/vpcGateway
  ETC_DIR="$HOME_DIR"/etc
}

# Wait until the VPN client configuration is available.
function waitForVPNClientConfiguration() {
  while true; do
    echo "Waiting for the VPN client configuration be available..."

    # Get the VPN client ID.
    CLIENT=$(ssh -i /tmp/.id_rsa \
                 -q \
                 -o "UserKnownHostsFile=/dev/null" \
                 -o "StrictHostKeyChecking=no" \
                 root@"$VPNSERVERIPTOCONNECT" "cat /etc/hostname")

    if [ -n "$CLIENT" ]; then
      # Check if the VPN client configuration exists.
      VPN_IS_OK=$(ssh -i /tmp/.id_rsa \
                      -q \
                      -o "UserKnownHostsFile=/dev/null" \
                      -o "StrictHostKeyChecking=no" \
                      root@"$VPNSERVERIPTOCONNECT" "ls $ETC_DIR 2> /dev/null" | grep "$CLIENT.ovpn")

      if [ -n "$VPN_IS_OK" ]; then
        break
      fi
    fi

    sleep 1
  done
}

# Download the VPN client configuration.
function downloadVPNClientConfiguration(){
  scp -i /tmp/.id_rsa \
      -q \
      -o "UserKnownHostsFile=/dev/null" \
      -o "StrictHostKeyChecking=no" \
      root@"$VPNSERVERIPTOCONNECT:$ETC_DIR/$CLIENT.ovpn" ..
 }

 checkDependencies "$1"
 prepareToExecute
 waitForVPNClientConfiguration
 downloadVPNClientConfiguration