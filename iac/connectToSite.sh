#!/bin/bash

source "$HOME"/.env

export VPN_SERVER_IP_TO_CONNECT=$1

"$BIN_DIR"/vpnClient.sh

openvpn "$HOME/$CLIENT".ovpn &