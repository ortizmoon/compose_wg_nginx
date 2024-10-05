#!/bin/bash

###### Install docker

# Install dependencies
install_dependencies() {
    apt install -y ca-certificates curl gnupg
}

# Docker repository
setup_docker_repo() {
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

# Update packages
update_package_list() {
    apt update
}

# Install docker
install_docker() {
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
}

# Start service and add it to autostart
enable_docker_service() {
    systemctl enable docker.service
}

# Installing docker-compose:latest
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# List of functions:
install_dependencies
setup_docker_repo
update_package_list
install_docker
enable_docker_service

######