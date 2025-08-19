#!/bin/bash

#Vagrant Configuration
wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -y
apt install vagrant

apt install make

echo "Installing VirtualBox dependencies..."
# Install VirtualBox and dependencies
apt install -y virtualbox virtualbox-dkms dkms build-essential linux-headers-$(uname -r)

# Optional: Force rebuild of VirtualBox kernel modules
echo "Reconfiguring DKMS modules..."
dpkg-reconfigure virtualbox-dkms

# Load kernel module
echo "Loading VirtualBox kernel module..."
modprobe vboxdrv

# OPTIONAL: Reboot manually after script finishes
echo "✅ VirtualBox setup complete. Reboot manually if needed."


