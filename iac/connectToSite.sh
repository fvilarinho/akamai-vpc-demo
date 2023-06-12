#!/bin/bash

source "$HOME"/.env

export VPN_SERVER_IP_TO_CONNECT=$1

"$BIN_DIR"/vpnClient.sh

CLIENTS=$(ls *.ovpn)

for CLIENT in $CLIENTS
do
  echo "Connecting using $CLIENT..."

  openvpn "$HOME/$CLIENT"
done


