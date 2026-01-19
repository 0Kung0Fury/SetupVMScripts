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

echo "Upgrading installed packages..."
apt upgrade -y

echo "Installing ProtonVPN CLI..."
apt install -y proton-vpn-cli

echo "Removing unused packages..."
apt autoremove -y

echo "Cleaning package cache..."
apt autoclean

echo "=== Done! ==="
echo "You can now run: protonvpn --help"
