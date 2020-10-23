#!/bin/bash

iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT ! -s 127.0.0.1/32 --to-port 10000 -m owner '!' --uid-owner 0
