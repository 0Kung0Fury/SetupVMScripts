#!/bin/bash
# Locked-down Linux Router Firewall (Configurable Interfaces)

set -e

echo "=== Locked-down Router Firewall Setup ==="

read -p "Enter VPN interface (e.g. eth0, proton0): " $VPN
read -p "Enter LAN interface (e.g. eth1): " LAN

if [[ -z "$VPN" || -z "$LAN" ]]; then
    echo "ERROR: Both WAN and LAN interfaces must be specified."
    exit 1
fi

echo "WAN Interface: $VPN"
echo "LAN Interface: $LAN"

echo "Applying firewall rules..."

### Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

### Flush existing rules
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

### Default policies (LOCKED DOWN)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

### Allow loopback
iptables -A INPUT -i lo -j ACCEPT

### Allow established/related
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

### Drop invalid packets
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A FORWARD -m conntrack --ctstate INVALID -j DROP


### LAN → WAN forwarding
iptables -A FORWARD -i "$LAN" -o "$VPN" -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

### Block WAN → LAN
iptables -A FORWARD -i "$VPN" -o "$LAN" -j DROP

### NAT
iptables -t nat -A POSTROUTING -o "$VPN" -j MASQUERADE

### Router management from LAN only
# SSH
iptables -A INPUT -i "$LAN" -p tcp --dport 22 -j ACCEPT

# ICMP (ping)
iptables -A INPUT -i "$LAN" -p icmp -j ACCEPT

echo "Firewall applied successfully."
