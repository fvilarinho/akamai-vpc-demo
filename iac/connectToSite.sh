#!/bin/bash

source "$HOME"/.env

export VPN_SERVER_IP_TO_CONNECT=$1

"$BIN_DIR"/vpnClient.sh

CLIENTS=$(ls *.ovpn)

for CLIENT in $CLIENTS
do
  echo "Connecting using $CLIENT..."

  openvpn --config "$HOME/$CLIENT" > "$HOME/$CLIENT".log 2>&1 &

  while true; do
    IS_CONNECTED=$(cat "$CLIENT".log | grep "Initialization Sequence Completed")

    if [ -n "$IS_CONNECTED" ]; then
      echo "Connection using $CLIENT was established!"

      break
    fi

    sleep 1
  done
done