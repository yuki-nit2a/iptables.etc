#!/bin/bash

ipt=/sbin/iptables
devn="eth0"
icmp='-p icmp'

LOvn='127.0.0.1'
#ETH0vn=`ip addr | grep inet | grep eth0 | awk -F ' ' '{print $2}' | sed -e 's/\/.*$//'`
#PPP0vn=`ip addr | grep inet | grep ppp0 | awk -F ' ' '{print $2}' | sed -e 's/\/.*$//'`

ANYvn='0.0.0.0/0'
MULTICASTvn='224.0.0.0/4'
BROADCASTvn='225.225.225.225'
IP_SPOOFINGvn=('0.0.0.0/8' '127.0.0.1/8' '10.0.0.0/8' '169.254.0.0/16' '172.16.0.0/12' '192.168.0.0/16' '192.168.0.0/24')

DNSvn=('8.8.8.8' '8.8.4.4')
#NTPfqdn=('ntp.nict.jp' 'ntp-a1.nict.go.jp' 'ntp-a2.nict.go.jp' 'ntp-a3.nict.go.jp' 'ntp-a4.nict.go.jp' 'ntp-b1.nict.go.jp' 'ntp-b2.nict.go.jp' 'ntp-b3.nict.go.jp' 'ntp-b4.nict.go.jp')
NTPvn=('133.243.238.242' '133.243.238.243' '133.243.238.244' '133.243.238.245' '133.243.238.162' '133.243.238.163' '133.243.238.164' '133.243.238.168')
DENYvn=()


. /etc/iptables/up.common.sh


$ipt $n SERVICE_LOCAL_ICMP_PING
$ipt $a SERVICE_LOCAL_ICMP_PING $j SERVICE_LOCAL_ICMP
$ipt $net_lo_in $icmp $icmp_type 0 $st_e $j SERVICE_LOCAL_ICMP_PING
$ipt $net_lo_out $icmp $icmp_type 8 $st_ne $j SERVICE_LOCAL_ICMP_PING

