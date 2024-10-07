#!/bin/bash

###### Deploying the wg-easy image (founded by @WeeJeWel) from a docker-compose file

# Data input
read -p "Enter the public IP address of the server where this script is running: " wg_host_value
read -p "Select the language for the future WireGuard admin panel (supported values like ru, en, de, etc.): " wg_lang_value
read -p "Enter the password for the future WireGuard admin panel (WARNING! Save this pass!): " wg_pass_value
cat <<EOF > docker-compose.yaml
version: "3.8"
volumes:
  etc_wireguard:

services:
  wg-easy:
    environment:
      - LANG=$wg_lang_value
      - WG_HOST=$wg_host_value
      - PASSWORD=$wg_pass_value
    image: ghcr.io/wg-easy/wg-easy
    container_name: wg-easy
    volumes:
      - etc_wireguard:/etc/wireguard
    ports:
      - "51820:51820/udp"
      - "51821:51821/tcp"
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
EOF

# Deployment
docker-compose up -d

# Clean
rm -r docker-compose*
history -c
######