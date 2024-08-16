#!/bin/bash

# Flush all existing rules
iptables -F
ip6tables -F

# Set default policies to DROP all traffic
iptables -P INPUT DROP
ip6tables -P INPUT DROP

iptables -P FORWARD DROP
ip6tables -P FORWARD DROP

iptables -P OUTPUT ACCEPT
ip6tables -P OUTPUT ACCEPT

# Allow loopback interface (lo) traffic
iptables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT

# Allow established and related connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow incoming SSH on port 22
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming HTTP on port 80
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow incoming HTTPS on port 443
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 443 -j ACCEPT

# Log dropped packets (optional)
iptables -A INPUT -j LOG --log-prefix "iptables-drop: "
ip6tables -A INPUT -j LOG --log-prefix "ip6tables-drop: "

# Save the iptables rules (depends on your OS, example for Ubuntu)
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

echo "Firewall rules successfully applied!"
