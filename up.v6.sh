#!/bin/bash

ipt=/sbin/ip6tables
devn="eth0"
icmp='-p ipv6-icmp'

LOvn='::1'

ANYvn='::'
MULTICASTvn='ff00::/8'
BROADCASTvn='ff02::1'
IP_SPOOFINGvn=('::1' 'fc00::/7' 'fe80::/10' 'fec0::/10')

DNSvn=('2001:4860:4860::8888' '2001:4860:4860::8844')
NTPvn=()
DENYvn=()


. /etc/iptables/up.common.sh


$ipt $n SERVICE_LOCAL_DHCP
$ipt $a SERVICE_LOCAL_DHCP $accept
#$ipt $srv_lo_in $udp $s ff02::/16 $sp 547 $dp 546 $j SERVICE_LOCAL_DHCP
$ipt $srv_lo_out $udp $sp 546 $d ff02::/16 $dp 547 $j SERVICE_LOCAL_DHCP

$ipt $n SERVICE_LOCAL_ICMP_ALL
$ipt $a SERVICE_LOCAL_ICMP_ALL $j SERVICE_LOCAL_ICMP
$ipt $srv_lo_in $icmp $s ff80::/10 $st_ne $j SERVICE_LOCAL_ICMP_ALL
$ipt $srv_lo_out $icmp $d ff80::/10 $st_ne $j SERVICE_LOCAL_ICMP_ALL
$ipt $srv_lo_in $icmp $s ff02::/16 $st_ne $j SERVICE_LOCAL_ICMP_ALL
$ipt $srv_lo_out $icmp $d ff02::/16 $st_ne $j SERVICE_LOCAL_ICMP_ALL

