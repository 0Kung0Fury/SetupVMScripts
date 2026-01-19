#!/bin/bash
set -e

echo "Installing DHCP server..."

apt update
apt install -y isc-dhcp-server

INTERFACE="eth1"

echo "Configuring DHCP to run on $INTERFACE"

sed -i "s/^INTERFACESv4=.*/INTERFACESv4=\"$INTERFACE\"/" /etc/default/isc-dhcp-server

echo "Backing up original config..."
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak

cat > /etc/dhcp/dhcpd.conf <<EOF
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.168.77.0 netmask 255.255.255.0 {
    range 192.168.77.2 192.168.77.254;
    option routers 192.168.77.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.168.77.255;
    option domain-name-servers 1.1.1.1, 8.8.8.8;
}
EOF

echo "Restarting DHCP service..."
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server

echo "DHCP Server is now active."
echo "Range: 192.168.77.2 - 192.168.77.254"
echo "Gateway: 192.168.77.1"
