#!/bin/bash

# Env input
read -p "Enter your server public IP:" WG_HOST_VALUE
read -p "Enter DNS IP:" WG_DNS_VALUE
read -p "Select language for admin panel (supported values: ru, en, de, etc.):" WG_LANG_VALUE
read -p "Enable expire time for clients (values true/false):" WG_EXPIRES_TIME_VALUE
read -p "Enable Prometheus metrics (values true/false):" WG_METRICS_VALUE
read -s -p "Enter password for admin panel (WARNING! Save this pass!):" PASS_VALUE

# Hash the password using the wgpw script inside the Docker container
HASHED_PASSWORD=$(docker run --rm -it ghcr.io/wg-easy/wg-easy wgpw "$PASS_VALUE" | awk -F"'" '{print "$" $2}')

# Autocreate docker-compose file
cat <<EOF > docker-compose.yaml
volumes:
  etc_wireguard:

services:
  wg-easy:
    environment:
      - LANG=${WG_LANG_VALUE}
      - WG_HOST=${WG_HOST_VALUE}
      - PASSWORD_HASH=${HASHED_PASSWORD}
      - WG_DEFAULT_DNS=${WG_DNS_VALUE}
      - WG_ENABLE_EXPIRES_TIME=${WG_EXPIRES_TIME_VALUE}
      - ENABLE_PROMETHEUS_METRICS=${WG_METRICS_VALUE}
      - UI_ENABLE_SORT_CLIENTS=true
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
sudo docker compose up -d

# Clean sensitive data
shred -u docker-compose.yaml
history -c && history -w

# ATTENTION
echo "Admin panel: http://$WG_HOST_VALUE:51821"
echo "Make sure to save your WireGuard Admin panel password!"