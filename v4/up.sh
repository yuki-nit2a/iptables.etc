#!/usr/bin/env bash

# Initialize

## Policy
iptables -P FORWARD DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP

## Flush
iptables -F
iptables -X
iptables -Z


# System

## Loopback
iptables -i lo -A INPUT  -j ACCEPT
iptables -o lo -A OUTPUT -j ACCEPT


# Defence Input
iptables -N IN_DEF

## IP Spoofing Attack
iptables -N IN_DEF_IP_SPOOFING
iptables -A IN_DEF_IP_SPOOFING -j LOG --log-level warning --log-prefix 'IP Spoofing'
iptables -A IN_DEF_IP_SPOOFING -j DROP
iptables -A IN_DEF -p tcp -s '0.0.0.0/8'      -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p udp -s '0.0.0.0/8'      -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p tcp -s '127.0.0.1/8'    -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p udp -s '127.0.0.1/8'    -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p tcp -s '10.0.0.0/8'     -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p udp -s '10.0.0.0/8'     -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p tcp -s '169.254.0.0/16' -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p udp -s '169.254.0.0/16' -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p tcp -s '172.16.0.0/12'  -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p udp -s '172.16.0.0/12'  -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p tcp -s '192.168.0.0/16' -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p udp -s '192.168.0.0/16' -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p tcp -s '192.168.0.0/24' -j IN_DEF_IP_SPOOFING
iptables -A IN_DEF -p udp -s '192.168.0.0/24' -j IN_DEF_IP_SPOOFING

## Broadcast Attack
iptables -N IN_DEF_BROADCAST
iptables -A IN_DEF_BROADCAST -j LOG --log-level warning --log-prefix 'Broadcast'
iptables -A IN_DEF_BROADCAST -j DROP
iptables -A IN_DEF -p tcp -s 255.255.255.255 -j IN_DEF_BROADCAST

## Multicast Attack
iptables -N IN_DEF_MULTICAST
iptables -A IN_DEF_MULTICAST -j LOG --log-level warning --log-prefix 'Multicast'
iptables -A IN_DEF_MULTICAST -j DROP
iptables -A IN_DEF -p tcp -s 224.0.0.0/4 -j IN_DEF_MULTICAST

## FIN with no ACK Attack
iptables -N IN_DEF_TCP_AF_F
iptables -A IN_DEF_TCP_AF_F -j LOG --log-level warning --log-prefix 'FIN & !ACK'
iptables -A IN_DEF_TCP_AF_F -j DROP
iptables -A IN_DEF -p tcp --tcp-flags ACK,FIN FIN -j IN_DEF_TCP_AF_F

## PSH with no ACK Attack
iptables -N IN_DEF_TCP_AP_P
iptables -A IN_DEF_TCP_AP_P -j LOG --log-level warning --log-prefix 'PSH & !ACK'
iptables -A IN_DEF_TCP_AP_P -j DROP
iptables -A IN_DEF -p tcp --tcp-flags ACK,PSH PSH -j IN_DEF_TCP_AP_P

## URG with no ACK Attack
iptables -N IN_DEF_TCP_AU_U
iptables -A IN_DEF_TCP_AU_U -j LOG --log-level warning --log-prefix 'URG & !ACK'
iptables -A IN_DEF_TCP_AU_U -j DROP
iptables -A IN_DEF -p tcp --tcp-flags ACK,URG URG -j IN_DEF_TCP_AU_U

## FIN with RST Attack
iptables -N IN_DEF_TCP_FR_FR
iptables -A IN_DEF_TCP_FR_FR -j LOG --log-level warning --log-prefix 'FIN & RST'
iptables -A IN_DEF_TCP_FR_FR -j DROP
iptables -A IN_DEF -p tcp --tcp-flags FIN,RST FIN,RST -j IN_DEF_TCP_FR_FR

## SYN with FIN Attack
iptables -N IN_DEF_TCP_SF_SF
iptables -A IN_DEF_TCP_SF_SF -j LOG --log-level warning --log-prefix 'SYN & FIN'
iptables -A IN_DEF_TCP_SF_SF -j DROP
iptables -A IN_DEF -p tcp --tcp-flags SYN,FIN SYN,FIN -j IN_DEF_TCP_SF_SF

## SYN with RST Attack
iptables -N IN_DEF_TCP_SR_SR
iptables -A IN_DEF_TCP_SR_SR -j LOG --log-level warning --log-prefix 'SYN & RST'
iptables -A IN_DEF_TCP_SR_SR -j DROP
iptables -A IN_DEF -p tcp --tcp-flags SYN,RST SYN,RST -j IN_DEF_TCP_SR_SR

## Full bit Attack
iptables -N IN_DEF_TCP_ALL_ALL
iptables -A IN_DEF_TCP_ALL_ALL -j LOG --log-level warning --log-prefix 'Full Bit'
iptables -A IN_DEF_TCP_ALL_ALL -j DROP
iptables -A IN_DEF -p tcp --tcp-flags ALL ALL -j IN_DEF_TCP_ALL_ALL

## None bit Attack
iptables -N IN_DEF_TCP_ALL_NONE
iptables -A IN_DEF_TCP_ALL_NONE -j LOG --log-level warning --log-prefix 'None Bit'
iptables -A IN_DEF_TCP_ALL_NONE -j DROP
iptables -A IN_DEF -p tcp --tcp-flags ALL NONE -j IN_DEF_TCP_ALL_NONE

## FIN PSH URG Attack
iptables -N IN_DEF_TCP_ALL_FPU
iptables -A IN_DEF_TCP_ALL_FPU -j LOG --log-level warning --log-prefix 'FIN & PSH & URG'
iptables -A IN_DEF_TCP_ALL_FPU -j DROP
iptables -A IN_DEF -p tcp --tcp-flags ALL FIN,PSH,URG -j IN_DEF_TCP_ALL_FPU

## Xmas Tree Attack
iptables -N IN_DEF_TCP_ALL_SFPU
iptables -A IN_DEF_TCP_ALL_SFPU -j LOG --log-level warning --log-prefix 'Xmas'
iptables -A IN_DEF_TCP_ALL_SFPU -j DROP
iptables -A IN_DEF -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j IN_DEF_TCP_ALL_SFPU

## SYN RST ACK FIN URG Attack
iptables -N IN_DEF_TCP_ALL_SRAFU
iptables -A IN_DEF_TCP_ALL_SRAFU -j LOG --log-level warning --log-prefix '* & !PSH'
iptables -A IN_DEF_TCP_ALL_SRAFU -j DROP
iptables -A IN_DEF -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j IN_DEF_TCP_ALL_SRAFU

## New State with no SYN Attack
iptables -N IN_DEF_TCP_SYNLESS_NEW
iptables -A IN_DEF_TCP_SYNLESS_NEW -j LOG --log-level warning --log-prefix '!SYN NEW'
iptables -A IN_DEF_TCP_SYNLESS_NEW -j DROP
iptables -A IN_DEF -p tcp ! --syn -m state --state NEW -j IN_DEF_TCP_SYNLESS_NEW

## Fragment
iptables -N IN_DEF_TCP_FRAGMENT
iptables -A IN_DEF_TCP_FRAGMENT -j LOG --log-level warning --log-prefix 'Fragment'
iptables -A IN_DEF_TCP_FRAGMENT -j DROP
#iptables -A IN_DEF -p tcp -f -j IN_DEF_TCP_FRAGMENT

## New State SYN Flood Attack
iptables -N IN_DEF_TCP_SYN_FLOOD_NEW
iptables -A IN_DEF_TCP_SYN_FLOOD_NEW -j LOG --log-level warning --log-prefix 'SYN Flood NEW'
iptables -A IN_DEF_TCP_SYN_FLOOD_NEW -j DROP

## New State RST Flood Attack
iptables -N IN_DEF_TCP_SYN_FLOOD_RST
iptables -A IN_DEF_TCP_SYN_FLOOD_RST -j LOG --log-level warning --log-prefix 'SYN Flood RST'
iptables -A IN_DEF_TCP_SYN_FLOOD_RST -j DROP

## Apply
iptables -A INPUT -j IN_DEF


# Passive Service
iptables -N IN_SRV_PAS
iptables -N OUT_SRV_PAS

## DNS
iptables -N IN_SRV_PAS_DNS
iptables -N OUT_SRV_PAS_DNS
iptables -A IN_SRV_PAS_DNS  -j ACCEPT
iptables -A OUT_SRV_PAS_DNS -j ACCEPT

while read ip; do
    iptables -A IN_SRV_PAS  -p tcp -s $ip --sport 53 -m state --state ESTABLISHED     -j IN_SRV_PAS_DNS
    iptables -A IN_SRV_PAS  -p udp -s $ip --sport 53 -m state --state ESTABLISHED     -j IN_SRV_PAS_DNS
    iptables -A OUT_SRV_PAS -p tcp -d $ip --dport 53 -m state --state NEW,ESTABLISHED -j OUT_SRV_PAS_DNS
    iptables -A OUT_SRV_PAS -p udp -d $ip --dport 53 -m state --state NEW,ESTABLISHED -j OUT_SRV_PAS_DNS
done < './service/passive/dns.allow'

## HTTP
iptables -N IN_SRV_PAS_HTTP
iptables -N OUT_SRV_PAS_HTTP
iptables -A IN_SRV_PAS_HTTP -j ACCEPT
iptables -A OUT_SRV_PAS_HTTP -j ACCEPT

iptables -A IN_SRV_PAS  -p tcp --sport 80 -m state --state ESTABLISHED     -j IN_SRV_PAS_HTTP
iptables -A OUT_SRV_PAS -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j OUT_SRV_PAS_HTTP

## HTTPS
iptables -N IN_SRV_PAS_HTTPS
iptables -N OUT_SRV_PAS_HTTPS
iptables -A IN_SRV_PAS_HTTPS -j ACCEPT
iptables -A OUT_SRV_PAS_HTTPS -j ACCEPT

iptables -A IN_SRV_PAS  -p tcp --sport 443 -m state --state ESTABLISHED     -j IN_SRV_PAS_HTTPS
iptables -A OUT_SRV_PAS -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j OUT_SRV_PAS_HTTPS

## NTP
iptables -N IN_SRV_PAS_NTP
iptables -N OUT_SRV_PAS_NTP
iptables -A IN_SRV_PAS_NTP -j ACCEPT
iptables -A OUT_SRV_PAS_NTP -j ACCEPT

while read ip; do
    iptables -A IN_SRV_PAS  -p udp -s $ip --sport 123 --dport 123 -m state --state ESTABLISHED     -j IN_SRV_PAS_NTP
    iptables -A OUT_SRV_PAS -p udp --sport 123 -d $ip --dport 123 -m state --state NEW,ESTABLISHED -j OUT_SRV_PAS_NTP
done < './service/passive/ntp.allow'

# ICMP
iptables -N IN_SRV_PAS_ICMP
iptables -N OUT_SRV_PAS_ICMP
iptables -A IN_SRV_PAS_ICMP -j ACCEPT
iptables -A OUT_SRV_PAS_ICMP -j ACCEPT

## Apply
iptables -A INPUT  -j IN_SRV_PAS
iptables -A OUTPUT -j OUT_SRV_PAS


# Active Service

iptables -N IN_SRV_ACT
iptables -N OUT_SRV_ACT

## HTTP
iptables -N IN_SRV_ACT_HTTP
iptables -N OUT_SRV_ACT_HTTP
iptables -A IN_SRV_ACT_HTTP  -j ACCEPT
iptables -A OUT_SRV_ACT_HTTP -j ACCEPT

iptables -A IN_SRV_ACT  -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j IN_SRV_ACT_HTTP
iptables -A OUT_SRV_ACT -p tcp --sport 80 -m state --state ESTABLISHED     -j OUT_SRV_ACT_HTTP

## SSH
iptables -N IN_SRV_ACT_SSH_BURST
iptables -A IN_SRV_ACT_SSH_BURST -j LOG --log-level warning --log-prefix 'SSH Burst'
iptables -A IN_SRV_ACT_SSH_BURST -j DROP

iptables -N IN_SRV_ACT_SSH
iptables -N OUT_SRV_ACT_SSH
iptables -A IN_SRV_ACT_SSH -p tcp -m state --state NEW -j LOG --log-level notice --log-prefix 'SSH New'
iptables -A IN_SRV_ACT_SSH \
    -p tcp \
        -m state --state NEW \
    -m hashlimit \
        --hashlimit-name ssh-burst \
        --hashlimit-mode srcip \
        --hashlimit-above 5/m \
        --hashlimit-burst 5 \
        --hashlimit-htable-expire 600000 \
    -j IN_SRV_ACT_SSH_BURST
iptables -A IN_SRV_ACT_SSH  -j ACCEPT
iptables -A OUT_SRV_ACT_SSH -j ACCEPT

port=`head ./port/ssh`

iptables -A IN_SRV_ACT  -p tcp --dport $port -m state --state NEW,ESTABLISHED -j IN_SRV_ACT_SSH
iptables -A OUT_SRV_ACT -p tcp --sport $port -m state --state ESTABLISHED     -j OUT_SRV_ACT_SSH

## Apply
iptables -A INPUT  -j IN_SRV_ACT
iptables -A OUTPUT -j OUT_SRV_ACT


# Drop all unmatched packets
iptables -A INPUT  -j LOG --log-level warning --log-prefix 'Unknown'
iptables -A OUTPUT -j LOG --log-level warning --log-prefix 'Unknown'
