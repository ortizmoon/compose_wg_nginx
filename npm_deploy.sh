#!/bin/bash

# Env input
read -p "Disable IPv6 support (values true/false): " IPV6_STATUS_VALUE
read -p "Enter new MySQL database name: " MYSQL_BASE_VALUE
read -p "Enter new MySQL database username: " MYSQL_BASE_USER
read -s -p "Enter password of new MySQL database user: " MYSQL_BASE_PASS; echo
read -s -p "Enter new SQL root password: " MYSQL_ROOT_PASS; echo

# Create .env file
cat <<EOF > .env
DB_MYSQL_USER=$MYSQL_BASE_USER
DB_MYSQL_PASSWORD=$MYSQL_BASE_PASS
DB_MYSQL_NAME=$MYSQL_BASE_VALUE
DISABLE_IPV6=$IPV6_STATUS_VALUE
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASS
EOF

# Autocreate docker-compose file
cat <<EOF > docker-compose.yaml
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
      DB_MYSQL_USER: \${DB_MYSQL_USER}
      DB_MYSQL_PASSWORD: \${DB_MYSQL_PASSWORD}
      DB_MYSQL_NAME: \${DB_MYSQL_NAME}
      DISABLE_IPV6: \${DISABLE_IPV6}
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    depends_on:
      - db

  db:
    image: 'jc21/mariadb-aria:latest'
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: \${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: \${DB_MYSQL_NAME}
      MYSQL_USER: \${DB_MYSQL_USER}
      MYSQL_PASSWORD: \${DB_MYSQL_PASSWORD}
      MARIADB_AUTO_UPGRADE: '1'
    volumes:
      - ./mysql:/var/lib/mysql
EOF

# Deployment
sudo docker compose --env-file .env up -d

# Clean sensitive data
shred -u .env
shred -u docker-compose.yaml
history -c && history -w

# ATTENTION
echo "Admin panel: <your-server-ip:81>"
echo "Default cred for Nginx Proxy Manager:"
echo "Email:    admin@example.com"
echo "Password: changeme"
