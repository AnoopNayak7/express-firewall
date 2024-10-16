#!/bin/bash

# Flush existing rules
sudo iptables -F

# Set default policies to drop all incoming and outgoing traffic
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP

# Allow traffic on loopback interface
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (port 22) for remote access
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

# Allow HTTP (port 80) and HTTPS (port 443) traffic
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT

# Allow DNS (port 53)
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Custom rules for blocking specific IP addresses (example: block 192.168.1.100)
sudo iptables -A INPUT -s 192.168.1.100 -j DROP

echo "Firewall rules applied!"
