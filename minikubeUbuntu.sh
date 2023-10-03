#!/bin/bash

# Check if curl is installed, if not, install it
if ! command -v curl &>/dev/null; then
  sudo apt-get update & sudo apt upgrade -y
  sudo apt-get install -y curl
fi

# Check if Docker is installed, if not, install it
if ! command -v docker &>/dev/null; then
  # Install Docker dependencies
  sudo apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common

  # Add Docker repository and GPG key
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Install Docker
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker ubuntu && newgrp docker

  # Start Docker service
  sudo systemctl start docker
  sudo systemctl enable docker
fi

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod 755 /usr/local/bin/minikube

# Install kubectl (if not already installed)
if ! command -v kubectl &>/dev/null; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
fi

# Install Helm
if ! command -v helm &>/dev/null; then
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  chmod +x get_helm.sh
  ./get_helm.sh
  rm get_helm.sh
fi

# Start Minikube cluster
minikube start --driver=docker

# Configure kubectl to use Minikube cluster
kubectl config use-context minikube

# Verify Minikube installation
minikube status
