#!/bin/bash

# Define the VPN server IP based on the command line argument.
export VPN_SERVER_IP_TO_CONNECT=$1

# Download the VPN client configuration file.
"$BIN_DIR"/downloadVpnClient.sh || exit 1

# List all available VPN client configuration files.
CLIENTS=$(ls *.ovpn)

for CLIENT in $CLIENTS
do
  echo "Connecting using $CLIENT..."

  openvpn --config "$HOME/$CLIENT" > "$HOME/$CLIENT".log 2>&1 &

  # Wait until the connection is established.
  while true; do
    if [ -f "$HOME/$CLIENT".log ]; then
      IS_CONNECTED=$(cat "$CLIENT".log | grep "Initialization Sequence Completed")

      # Check if the connection was established.
      if [ -n "$IS_CONNECTED" ]; then
        echo "Connection using $CLIENT was established!"

        break
      fi
    fi

    sleep 1
  done
done