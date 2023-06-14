#!/bin/bash

# Checks the dependencies of this script.
function checkDependencies() {
  # Checks if the SSH private key filename was defined.
  if [ -z "$PRIVATE_KEY_FILENAME" ]; then
    PRIVATE_KEY_FILENAME="$HOME"/.ssh/id_rsa
  fi

  if [ ! -f "$PRIVATE_KEY_FILENAME" ]; then
    echo "Please specify the SSH private key filename to connect to the VPN server!"

    exit 1
  fi

  # Checks if the VPN Server IP was defined.
  if [ -z "$VPN_SERVER_IP_TO_CONNECT" ]; then
    echo "Please specify the VPN server IP/Hostname to connect!"

    exit 1
  fi
}

# Prepares the environment to execute the commands scripts.
function prepareToExecute() {
  if [ -z "$HOME_DIR" ]; then
    export HOME_DIR=/opt/vpcGateway
  fi

  if [ -z "$ETC_DIR" ]; then
    export ETC_DIR="$HOME_DIR"/etc
  fi
}

# Waits for the VPN client configuration be available.
function waitForVPNClientConfiguration(){
  while true; do
    echo "Waiting for the VPN client configuration be available..."

    # Gets the VPN client ID.
    CLIENT=$(ssh -q \
                 -i "$PRIVATE_KEY_FILENAME" \
                 -o "UserKnownHostsFile=/dev/null" \
                 -o "StrictHostKeyChecking=no" \
                 root@"$VPN_SERVER_IP_TO_CONNECT" "hostname")

    if [ -n "$CLIENT" ]; then
      # Checks if the VPN client configuration exists.
      VPN_IS_OK=$(ssh -q \
                      -i "$PRIVATE_KEY_FILENAME" \
                      -o "UserKnownHostsFile=/dev/null" \
                      -o "StrictHostKeyChecking=no" \
                      root@"$VPN_SERVER_IP_TO_CONNECT" "ls \"$ETC_DIR\" 2> /dev/null" | grep "$CLIENT.ovpn")

      if [ -n "$VPN_IS_OK" ]; then
        break
      fi
    fi

    sleep 1

  done
}

# Downloads the VPN client configuration.
function downloadVPNClientConfiguration() {
  echo "Downloading the VPN client configuration..."

  scp -q \
      -i "$PRIVATE_KEY_FILENAME" \
      -o "UserKnownHostsFile=/dev/null" \
      -o "StrictHostKeyChecking=no" \
      root@"$VPN_SERVER_IP_TO_CONNECT:$ETC_DIR/$CLIENT".ovpn .
}

checkDependencies
prepareToExecute
waitForVPNClientConfiguration
downloadVPNClientConfiguration