#!/bin/bash

source "$HOME"/.env

export ACTION=connect
export VPN_SERVER_IP_TO_CONNECT=$1

"$BIN_DIR"/vpcClient.sh