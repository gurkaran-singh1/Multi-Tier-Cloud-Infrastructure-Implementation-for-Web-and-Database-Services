#!/bin/bash

# Flush existing rules and delete any user-defined chains
iptables -F
iptables -X

# Input rules
# Change the IPs accordingly
iptables -A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.39.0/27 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 10.17.70.0/24 --dport 22 -j ACCEPT
iptables -A INPUT -p all -m limit --limit 10/s -j LOG --log-prefix "TO_DROP_INPUT"

# Forward and output rules
iptables -A FORWARD -j DROP
iptables -A OUTPUT -j ACCEPT

# Save the rules and restart iptables service
iptables-save | sudo tee /etc/sysconfig/iptables
systemctl restart iptables

echo "Iptables rules configured and saved successfully for LS."
