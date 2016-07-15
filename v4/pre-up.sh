#!/bin/bash

# Initialize

## Policy
iptables -P FORWARD DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP

## Flush
iptables -F
iptables -X
iptables -Z
