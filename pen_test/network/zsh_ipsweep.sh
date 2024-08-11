#!/bin/zsh

if [ -z "$1" ]; then 
    echo "Add IP network prefix."
    echo "Syntax: ./zsh_ipsweep.sh xxx.xxx.xxx"
else
    for ip in {1..254}; do
        ping -c 1 $1.$ip | grep "64 bytes" | awk '{print $4}' | tr -d ":" &
    done
    wait
fi
