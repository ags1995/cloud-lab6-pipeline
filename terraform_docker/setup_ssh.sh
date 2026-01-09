#!/bin/bash
echo "Setting up SSH in the container..."

# Update and install SSH
apt-get update
apt-get install -y openssh-server sudo python3

# Configure SSH
echo 'root:password' | chpasswd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create necessary directory
mkdir -p /run/sshd

# Start SSH service
/usr/sbin/sshd

echo "SSH setup complete!"
echo "Connect with: ssh root@localhost -p 2222"
echo "Password: password"
