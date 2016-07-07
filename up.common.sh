#!/bin/bash

if [[ $1 = 'echo' ]]; then
    ipt=echo
fi
n='-N'
i='-i'
o='-o'
lo='lo'
eth0='eth0'
eth1='eth1'
icmp_type='--icmp-type'
tcp='-p tcp'
udp='-p udp'
tcp_flags='--tcp-flags'
syn='--syn'
s='-s'
d='-d'
sp='--sport'
dp='--dport'
mps='-m multiport'
sps="$mps --sports"
dps="$mps --dports"
st='-m state'
st_n="$st --state NEW"
st_e="$st --state ESTABLISHED"
st_ne="$st --state NEW,ESTABLISHED"
hlmt='-m hashlimit'
hlmt_name='--hashlimit-name'
hlmt_mode='--hashlimit-mode'
hlmt_within='--hashlimit-above'
hlmt_burst='--hashlimit-burst'
hlmt_expire='--hashlimit-htable-expire'
a='-A'
in="$a INPUT"
out="$a OUTPUT"
j='-j'
accept="$j ACCEPT"
drop="$j DROP"
reject="$j REJECT"
return="$j RETURN"
queue="$j QUEUE"
log="$j LOG"
log_pre='--log-prefix'
log_pre_head='ipt:'
log_pre_tail='// '
log_pre_accept='[A]'
log_pre_drop='[D]'
log_pre_noaction='[N]'
log_pre_txt() {
    echo "$log_pre_head $1 $log_pre_tail"
}
log_level='--log-level'
log_level_warning="$log_level warning"
log_level_notice="$log_level notice"
log_level_info="$log_level info"
log_level_debug="$log_level debug"

MTU=1454

DNS=53
HTTP=80
NTP=123
HTTPS=443
SSH=12345


$ipt -F
$ipt -X
$ipt -Z
$ipt -P FORWARD DROP
$ipt -P INPUT DROP
$ipt -P OUTPUT DROP


$ipt $n BAND_LIMIT
$ipt $a BAND_LIMIT $reject
band_limit="$j BAND_LIMIT"


$ipt $n BLACKLIST
$ipt $a BLACKLIST $drop
for ip in ${DENYvn[@]}; do
    $ipt $tcp $s $ip $j BLACKLIST
    $ipt $udp $s $ip $j BLACKLIST
done


$ipt $i $lo $in $s $LOvn $d $LOvn $accept
$ipt $o $lo $out $s $LOvn $d $LOvn $accept

$ipt $i $eth1 $in $s 169.254.101.1 $d 169.254.101.2 $accept
$ipt $o $eth1 $out $s 169.254.101.2 $d 169.254.101.1 $accept

$ipt $n NETWORK_LOCAL_INPUT
$ipt $n NETWORK_LOCAL_OUTPUT
net_lo_in='-A NETWORK_LOCAL_INPUT'
net_lo_out='-A NETWORK_LOCAL_OUTPUT'


$ipt $n DEFENSE
$ipt $a DEFENSE $drop
defense="$j DEFENSE"

$ipt $n DEFENSE_IP_SPOOFING
$ipt $a DEFENSE_IP_SPOOFING $log $log_pre "$(log_pre_txt "$log_pre_drop IP Spoofing")" $log_level_warning
$ipt $a DEFENSE_IP_SPOOFING $defense

$ipt $n DEFENSE_BROADCAST
$ipt $a DEFENSE_BROADCAST $log $log_pre "$(log_pre_txt "$log_pre_drop Broadcast")" $log_level_warning
$ipt $a DEFENSE_BROADCAST $defense

$ipt $n DEFENSE_MULTICAST
$ipt $a DEFENSE_MULTICAST $log $log_pre "$(log_pre_txt "$log_pre_drop Multicast")" $log_level_warning
$ipt $a DEFENSE_MULTICAST $defense

$ipt $n DEFENSE_TCP_AF_F
$ipt $a DEFENSE_TCP_AF_F $log $log_pre "$(log_pre_txt "$log_pre_drop FIN/!ACK edk")" $log_level_warning
$ipt $a DEFENSE_TCP_AF_F $defense

$ipt $n DEFENSE_TCP_AP_P
$ipt $a DEFENSE_TCP_AP_P $log $log_pre "$(log_pre_txt "$log_pre_drop PSH/!ACK edk")" $log_level_warning
$ipt $a DEFENSE_TCP_AP_P $defense

$ipt $n DEFENSE_TCP_AU_U
$ipt $a DEFENSE_TCP_AU_U $log $log_pre "$(log_pre_txt "$log_pre_drop URG/!ACK edk")" $log_level_warning
$ipt $a DEFENSE_TCP_AU_U $defense

$ipt $n DEFENSE_TCP_FR_FR
$ipt $a DEFENSE_TCP_FR_FR $log $log_pre "$(log_pre_txt "$log_pre_drop FIN&RST edk")" $log_level_warning
$ipt $a DEFENSE_TCP_FR_FR $defense

$ipt $n DEFENSE_TCP_SF_SF
$ipt $a DEFENSE_TCP_SF_SF $log $log_pre "$(log_pre_txt "$log_pre_drop SYN&FIN edk")" $log_level_warning
$ipt $a DEFENSE_TCP_SF_SF $defense

$ipt $n DEFENSE_TCP_SR_SR
$ipt $a DEFENSE_TCP_SR_SR $log $log_pre "$(log_pre_txt "$log_pre_drop SYN&RST edk")" $log_level_warning
$ipt $a DEFENSE_TCP_SR_SR $defense

$ipt $n DEFENSE_TCP_ALL_ALL
$ipt $a DEFENSE_TCP_ALL_ALL $log $log_pre "$(log_pre_txt "$log_pre_drop FULLBIT")" $log_level_warning
$ipt $a DEFENSE_TCP_ALL_ALL $defense

$ipt $n DEFENSE_TCP_ALL_NONE
$ipt $a DEFENSE_TCP_ALL_NONE $log $log_pre "$(log_pre_txt "$log_pre_drop NONEBIT")" $log_level_warning
$ipt $a DEFENSE_TCP_ALL_NONE $defense

$ipt $n DEFENSE_TCP_ALL_FPU
$ipt $a DEFENSE_TCP_ALL_FPU $log $log_pre "$(log_pre_txt "$log_pre_drop FIN&PSH&URG Xmas")" $log_level_warning
$ipt $a DEFENSE_TCP_ALL_FPU $defense

$ipt $n DEFENSE_TCP_ALL_SFPU
$ipt $a DEFENSE_TCP_ALL_SFPU $log $log_pre "$(log_pre_txt "$log_pre_drop ALL w/o ACK&RST")" $log_level_warning
$ipt $a DEFENSE_TCP_ALL_SFPU $defense

$ipt $n DEFENSE_TCP_ALL_SRAFU
$ipt $a DEFENSE_TCP_ALL_SRAFU $log $log_pre "$(log_pre_txt "$log_pre_drop ALL w/o PSH")" $log_level_warning
$ipt $a DEFENSE_TCP_ALL_SRAFU $defense

$ipt $n DEFENSE_TCP_SYNLESS_NEW
$ipt $a DEFENSE_TCP_SYNLESS_NEW $log $log_pre "$(log_pre_txt "$log_pre_drop un-SYN NEW")" $log_level_warning
$ipt $a DEFENSE_TCP_SYNLESS_NEW $defense

$ipt $n DEFENSE_TCP_FRAGMENT
$ipt $a DEFENSE_TCP_FRAGMENT $log $log_pre "$(log_pre_txt "$log_pre_drop Fragment")" $log_level_warning
$ipt $a DEFENSE_TCP_FRAGMENT $defense

$ipt $n DEFENSE_TCP_SYN_FLOOD_NEW
$ipt $a DEFENSE_TCP_SYN_FLOOD_NEW $log $log_pre "$(log_pre_txt "$log_pre_drop SYN Flood NEW")" $log_level_warning
$ipt $a DEFENSE_TCP_SYN_FLOOD_NEW $defense
$ipt $n DEFENSE_TCP_SYN_FLOOD_EST
$ipt $a DEFENSE_TCP_SYN_FLOOD_EST $log $log_pre "$(log_pre_txt "$log_pre_drop SYN Flood EST")" $log_level_warning
$ipt $a DEFENSE_TCP_SYN_FLOOD_EST $defense

$ipt $n DEFENSE_TCP_SCAN
$ipt $a DEFENSE_TCP_SCAN $tcp $st_e $return
#$ipt $a DEFENSE_TCP_SCAN $tcp $sp $DNS $return
#$ipt $a DEFENSE_TCP_SCAN $tcp $sp $HTTP $return
#$ipt $a DEFENSE_TCP_SCAN $tcp $sp $HTTPS $return
$ipt $a DEFENSE_TCP_SCAN $tcp $dp $HTTP $return
$ipt $a DEFENSE_TCP_SCAN $tcp $dp $HTTPS $return
$ipt $a DEFENSE_TCP_SCAN $tcp $dp $SSH $return
$ipt $a DEFENSE_TCP_SCAN $log $log_pre "$(log_pre_txt "$log_pre_drop TCP Scan")" $log_level_warning
$ipt $a DEFENSE_TCP_SCAN $defense

$ipt $n DEFENSE_UDP_SCAN
$ipt $a DEFENSE_UDP_SCAN $udp $st_e $return
#$ipt $a DEFENSE_UDP_SCAN $udp $sp $DNS $return
#$ipt $a DEFENSE_UDP_SCAN $udp $sp $NTP $return
$ipt $a DEFENSE_UDP_SCAN $log $log_pre "$(log_pre_txt "$log_pre_noaction UDP Scan")" $log_level_warning
$ipt $a DEFENSE_UDP_SCAN $defense
#$ipt $a DEFENSE_UDP_SCAN $return

$ipt $n DEFENSE_INPUT
def_in='-A DEFENSE_INPUT'
for ip in ${IP_SPOOFINGvn[@]}; do
    $ipt $def_in $tcp $s $ip $j DEFENSE_IP_SPOOFING
    $ipt $def_in $udp $s $ip $j DEFENSE_IP_SPOOFING
done
$ipt $def_in $tcp $s $MULTICASTvn $j DEFENSE_MULTICAST
$ipt $def_in $tcp $s $BROADCASTvn $j DEFENSE_BROADCAST
$ipt $def_in $tcp $tcp_flags ACK,FIN FIN $j DEFENSE_TCP_AF_F
$ipt $def_in $tcp $tcp_flags ACK,PSH PSH $j DEFENSE_TCP_AP_P
$ipt $def_in $tcp $tcp_flags ACK,URG URG $j DEFENSE_TCP_AU_U
$ipt $def_in $tcp $tcp_flags FIN,RST FIN,RST $j DEFENSE_TCP_FR_FR
$ipt $def_in $tcp $tcp_flags SYN,FIN SYN,FIN $j DEFENSE_TCP_SF_SF
$ipt $def_in $tcp $tcp_flags SYN,RST SYN,RST $j DEFENSE_TCP_SR_SR
$ipt $def_in $tcp $tcp_flags ALL ALL $j DEFENSE_TCP_ALL_ALL
$ipt $def_in $tcp $tcp_flags ALL NONE $j DEFENSE_TCP_ALL_NONE
$ipt $def_in $tcp $tcp_flags ALL FIN,PSH,URG $j DEFENSE_TCP_ALL_FPU
$ipt $def_in $tcp $tcp_flags ALL SYN,FIN,PSH,URG $j DEFENSE_TCP_ALL_SFPU
$ipt $def_in $tcp $tcp_flags ALL SYN,RST,ACK,FIN,URG $j DEFENSE_TCP_ALL_SRAFU
$ipt $def_in $tcp ! $syn $st_n $j DEFENSE_TCP_SYNLESS_NEW
#$ipt $def_in $tcp -f $j DEFENSE_TCP_FRAGMENT
#$ipt $def_in $tcp $syn $st_n $hlmt $hlmt_name defense_tcp_syn_flood $hlmt_mode srcip $hlmt_within 20/s $hlmt_burst 50 $hlmt_expire 60000 $j DEFENSE_TCP_SYN_FLOOD_NEW
$ipt $def_in $tcp $j DEFENSE_TCP_SCAN
$ipt $def_in $udp $j DEFENSE_UDP_SCAN

$ipt $i $devn $in $j DEFENSE_INPUT

$ipt $n SERVICE_LOCAL_INPUT
$ipt $n SERVICE_LOCAL_OUTPUT
srv_lo_in='-A SERVICE_LOCAL_INPUT'
srv_lo_out='-A SERVICE_LOCAL_OUTPUT'

#$ipt $n SERVICE_LOCAL_DNS
#$ipt $a SERVICE_LOCAL_DNS $accept
for ip in ${DNSvn[@]}; do
    $ipt $i $devn $in $tcp $s $ip $sp $DNS $st_e $accept
    $ipt $i $devn $in $udp $s $ip $sp $DNS $st_e $accept
    $ipt $o $devn $out $tcp $d $ip $dp $DNS $st_ne $accept
    $ipt $o $devn $out $udp $d $ip $dp $DNS $st_ne $accept
done

$ipt $n SERVICE_LOCAL_HTTP
$ipt $a SERVICE_LOCAL_HTTP $accept
$ipt $srv_lo_in $tcp $sp $HTTP $st_e $j SERVICE_LOCAL_HTTP
$ipt $srv_lo_out $tcp $dp $HTTP $st_ne $j SERVICE_LOCAL_HTTP

$ipt $n SERVICE_LOCAL_NTP
$ipt $a SERVICE_LOCAL_NTP $accept
for ip in ${NTPvn[@]}; do
    $ipt $srv_lo_in $udp $s $ip $sp $NTP $dp $NTP $st_e $j SERVICE_LOCAL_NTP
    $ipt $srv_lo_out $udp $sp $NTP $d $ip $dp $NTP $st_ne $j SERVICE_LOCAL_NTP
done

$ipt $n SERVICE_LOCAL_HTTPS
$ipt $a SERVICE_LOCAL_HTTPS $accept
$ipt $srv_lo_in $tcp $sp $HTTPS $st_e $j SERVICE_LOCAL_HTTPS
$ipt $srv_lo_out $tcp $dp $HTTPS $st_ne $j SERVICE_LOCAL_HTTPS

$ipt $n SERVICE_LOCAL_ICMP
$ipt $a SERVICE_LOCAL_ICMP $accept

$ipt $i $devn $in $j SERVICE_LOCAL_INPUT
$ipt $o $devn $out $j SERVICE_LOCAL_OUTPUT


$ipt $n SERVICE_PUBLIC_INPUT
$ipt $n SERVICE_PUBLIC_OUTPUT
srv_pub_in='-A SERVICE_PUBLIC_INPUT'
srv_pub_out='-A SERVICE_PUBLIC_OUTPUT'

$ipt $n DEFENSE_HTTP_BURST
$ipt $a DEFENSE_HTTP_BURST $log $log_pre "$(log_pre_txt "$log_pre_drop HTTP Burst")" $log_level_warning
$ipt $a DEFENSE_HTTP_BURST $defense
$ipt $n BAND_LIMIT_HTTP
$ipt $a BAND_LIMIT_HTTP $log $log_pre "$(log_pre_txt "$log_pre_drop HTTP Band Limit")" $log_level_notice
$ipt $a BAND_LIMIT_HTTP $band_limit
$ipt $n SERVICE_PUBLIC_HTTP_INPUT
$ipt $a SERVICE_PUBLIC_HTTP_INPUT $tcp $st_ne $hlmt $hlmt_name def_http_bst $hlmt_mode srcip $hlmt_within 100/s $hlmt_burst 500 $hlmt_expire 600000 $j BAND_LIMIT_HTTP
$ipt $a SERVICE_PUBLIC_HTTP_INPUT $accept
$ipt $n SERVICE_PUBLIC_HTTP_OUTPUT
$ipt $a SERVICE_PUBLIC_HTTP_OUTPUT $accept
$ipt $srv_pub_in $tcp $s $ANYvn $dps $HTTP,$HTTPS $st_ne $j SERVICE_PUBLIC_HTTP_INPUT
$ipt $srv_pub_out $tcp $sps $HTTP,$HTTPS $d $ANYvn $st_e $j SERVICE_PUBLIC_HTTP_OUTPUT

$ipt $n DEFENSE_SSH_BURST
$ipt $a DEFENSE_SSH_BURST $log $log_pre "$(log_pre_txt "$log_pre_drop SSH Burst")" $log_level_warning
$ipt $a DEFENSE_SSH_BURST $defense
$ipt $n SERVICE_PUBLIC_SSH_INPUT
$ipt $a SERVICE_PUBLIC_SSH_INPUT $tcp $st_n $log $log_pre "$(log_pre_txt "$log_pre_accept SSH New")" $log_level_notice
$ipt $a SERVICE_PUBLIC_SSH_INPUT $tcp $st_n $hlmt $hlmt_name def_ssh_bst $hlmt_mode srcip $hlmt_within 5/m $hlmt_burst 5 $hlmt_expire 600000 $j DEFENSE_SSH_BURST
$ipt $a SERVICE_PUBLIC_SSH_INPUT $accept
$ipt $n SERVICE_PUBLIC_SSH_OUTPUT
$ipt $a SERVICE_PUBLIC_SSH_OUTPUT $accept
$ipt $srv_pub_in $tcp $s $ANYvn $dp $SSH $st_ne $j SERVICE_PUBLIC_SSH_INPUT
$ipt $srv_pub_out $tcp $sp $SSH $d $ANYvn $st_e $j SERVICE_PUBLIC_SSH_OUTPUT

$ipt $i $devn $in $j SERVICE_PUBLIC_INPUT
$ipt $o $devn $out $j SERVICE_PUBLIC_OUTPUT


$ipt $i $devn $in $log $log_pre "$(log_pre_txt "$log_pre_drop")"
$ipt $o $devn $out $log $log_pre "$(log_pre_txt "$log_pre_drop")"
