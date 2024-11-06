#!/bin/bash

# Flush existing rules and delete any user-defined chains
iptables -F
iptables -X

# Basic forwarding and masquerading rules
iptables -A FORWARD -i eth0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Input rules
iptables -A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p all -m limit --limit 10/s -j LOG --log-prefix "TO_DROP_INPUT"
iptables -A INPUT -j DROP

# Forwarding rules for specific IP ranges and ports
# Change the IPs accordingly
iptables -A FORWARD -p tcp -s 10.17.70.0/24 -d 172.17.39.0/27 --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s 172.17.39.0/27 -d 10.17.70.0/24 --sport 22 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.17.70.0/24 -d 172.17.39.0/27 --dport 3389 -j ACCEPT
iptables -A FORWARD -p tcp -s 172.17.39.0/27 -d 10.17.70.0/24 --sport 3389 -j ACCEPT
iptables -A FORWARD -p tcp -d 172.17.39.4 --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -s 172.17.39.4 --sport 53 -j ACCEPT
iptables -A FORWARD -p udp -d 172.17.39.4 --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -s 172.17.39.4 --sport 53 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.17.70.0/24 -d 172.17.39.5 --dport 3306 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.17.70.0/24 -s 172.17.39.5 --sport 3306 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.17.70.0/24 -d 172.17.39.5 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.17.70.0/24 -s 172.17.39.5 --sport 80 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.17.70.0/24 -d 172.17.39.4 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.17.70.0/24 -s 172.17.39.4 --sport 80 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.17.70.0/24 -d 172.17.39.4 --dport 21 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.17.70.0/24 -s 172.17.39.4 --sport 21 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.17.70.0/24 -d 172.17.39.4 --dport 50000:51000 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.17.70.0/24 -s 172.17.39.4 --sport 50000:51000 -j ACCEPT

# Logging and drop rule for forwarding chain
iptables -A FORWARD -p all -m limit --limit 10/s -j LOG --log-prefix "TO_DROP_FORWARD"
iptables -A FORWARD -j DROP

# Output rules
iptables -A OUTPUT -j ACCEPT

# Save the rules and restart iptables service
iptables-save | sudo tee /etc/sysconfig/iptables
systemctl restart iptables

echo "Iptables rules configured and saved successfully."
