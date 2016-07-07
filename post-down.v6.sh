#!/bin/bash

ipt=/sbin/ip6tables

$ipt -F
$ipt -X
$ipt -Z
$ipt -P FORWARD DROP
$ipt -P INPUT DROP
$ipt -P OUTPUT DROP
