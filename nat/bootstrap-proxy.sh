#!/bin/bash

# enable routing
echo 1 > /proc/sys/net/ipv4/ip_forward
# allow SNAT to 192.168.15.0/24 (ping 192.168.15.21)
iptables -t nat -A POSTROUTING -o eth2 -j SNAT --to 192.168.15.10
# allow SNAT to default gw network (ping www.google.com)
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to 10.0.2.15

## From "How Linux Works"
# sysctl -w net.ipv4.ip_forward
# iptables -P FORWARD DROP
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# iptables -A FORWARD -i eth0 -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
