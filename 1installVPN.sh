#!/bin/bash
set -e

echo "=== System Update & ProtonVPN CLI Install ==="

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

echo "Updating package lists..."
apt update

echo "installing vmwaretools on the VM..."
apt-get install open-vm-tools open-vm-tooks-dekstop net-tools git 

echo "Upgrading installed packages..."
apt upgrade -y

echo "Installing ProtonVPN CLI..."
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb   
sudo dpkg -i ./protonvpn-stable-release_1.0.8_all.deb && sudo apt update
sudo apt install proton-vpn-gnome-desktop proton-vpn-cli -y 
sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator

echo "Removing unused packages..."
apt autoremove -y

echo "Cleaning package cache..."
apt autoclean

echo "=== Done! ==="
echo "You can now run: protonvpn --help"
