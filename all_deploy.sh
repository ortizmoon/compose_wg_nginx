#!/bin/bash

### Installing docker

# Installing dependencies
install_dependencies() {
    apt install -y ca-certificates curl gnupg
}

# Adding docker repository
setup_docker_repo() {
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

# Updating packages
update_package_list() {
    apt update
}

# Installing docker itself
install_docker() {
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
}

# Starting service and adding it to autostart
enable_docker_service() {
    systemctl enable docker.service
}

# Installing docker-compose:latest
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

### Creating compose for wg-easy (founded on github by @WeeJeWel)

# Data input
read -p "Enter the public IP address of the server where this script is running: " wg_host_value
read -p "Select the language for the future WireGuard admin panel (supported values like ru, en, de, etc.): " wg_lang_value
read -p "Enter the password for the future WireGuard admin panel (WARNING! Save this pass!): " wg_pass_value
cat <<EOF > docker-compose-wg-easy.yml
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



### Creating compose for nginx-proxy-manager (founded on github by @nginxproxymanager)

# Data input
read -p "Disable IPv6 support (values true/false): " 'ipv6_status_value'
read -p "Enter the name of the new MySQL database: " 'mysql_base_value'
read -p "Enter the username of the new MySQL database: " 'mysql_base_user'
read -p "Enter the password of the new MySQL database user: " 'mysql_base_pass'
read -p "Enter the root SQL password: " 'mysql_root_pass'
cat <<EOF > docker-compose-npm-manager.yml
version: '3.8'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
    environment:
      DB_MYSQL_HOST: 'db'
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: '$mysql_base_user'
      DB_MYSQL_PASSWORD: '$mysql_base_pass'
      DB_MYSQL_NAME: '$mysql_base_value'
      DISABLE_IPV6: '$ipv6_status_value'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    depends_on:
      - db

  db:
    image: 'jc21/mariadb-aria:latest'
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: '$mysql_root_pass'
      MYSQL_DATABASE: '$mysql_base_value'
      MYSQL_USER: '$mysql_base_user'
      MYSQL_PASSWORD: '$mysql_base_pass'
      MARIADB_AUTO_UPGRADE: '1'
    volumes:
      - ./mysql:/var/lib/mysql
EOF

# List of functions
install_dependencies
setup_docker_repo
update_package_list
install_docker
enable_docker_service

# Deployment
docker-compose -f docker-compose-wg-easy.yml up -d
docker-compose -f docker-compose-npm-manager.yml up -d

# Clean
rm -r docker-compose*
history -c

### ATTENTION
echo "Default data for npm:"
echo "Email:    admin@example.com"
echo "Password: changeme"
echo "MAKE SURE TO REPLACE THEM WITH YOURS"

######