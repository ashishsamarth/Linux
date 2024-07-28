#!/bin/bash

# Prompt for the remote host
read -p "Enter the remote username: " remote_user
read -p "Enter the remote host (e.g., example.com): " remote_host

# Define the path to the SSH key
ssh_key="~/.ssh/id_rsa.pub"

# Check if SSH key exists, generate one if it doesn't
if [ ! -f "$ssh_key" ]; then
    echo "SSH key not found. Generating a new SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f "$ssh_key" -N ""
fi

# Copy the SSH key to the remote host
echo "Copying SSH key to $remote_user@$remote_host..."
ssh-copy-id "$remote_user@$remote_host"

echo "SSH key has been copied to $remote_user@$remote_host."