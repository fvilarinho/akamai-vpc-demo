#!/bin/bash

# Check if its running in a pipeline.
if [ -z "$RUNNING_IN_A_PIPELINE" ]; then
  # Set default variables.
  HOME_DIR=/opt/vpcGateway
  ETC_DIR="$HOME_DIR"/etc
  VPNSERVERIPTOCONNECT=$1

  # Check if the VPN Server IP was defined.
  if [ -z "$VPNSERVERIPTOCONNECT" ]; then
    echo "Please specify the VPN Server"

    exit 1
  fi

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
  scp -q -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@"$VPNSERVERIPTOCONNECT:$ETC_DIR/$CLIENT.ovpn" ..
fi