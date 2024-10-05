#!/bin/bash

###### Deploy nginx-proxy-manager image (founded on GitHub by @nginxproxymanager) from docker-compose file

# Data input
read -p "Disable IPv6 support (values true/false): " 'ipv6_status_value'
read -p "Enter the name of the new MySQL database: " 'mysql_base_value'
read -p "Enter the username of the new MySQL database: " 'mysql_base_user'
read -p "Enter the password of the new MySQL database user: " 'mysql_base_pass'
read -p "Enter the root SQL password: " 'mysql_root_pass'
cat <<EOF > docker-compose.yaml
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

# Deployment
docker-compose up -d

# Clean
rm -r docker-compose*
history -c

### ATTENTION
echo "Default data for npm:"
echo "Email:    admin@example.com"
echo "Password: changeme"
echo "MAKE SURE TO REPLACE THEM WITH YOURS"

######