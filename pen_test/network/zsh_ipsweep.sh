#!/bin/zsh

if [ -z "$1" ]; then 
    echo "Add IP network subnet (e.g., xxx.xxx.xxx.0/24)."
    echo "Syntax: ./zsh_ipsweep.sh xxx.xxx.xxx.0/24"
else
    subnet=$(echo $1 | cut -d '/' -f 1 | sed 's/\.[0-9]*$//')
    for ip in {1..254}; do
        ping -c 1 $subnet.$ip | grep "64 bytes" | awk '{print $4}' | tr -d ":" &
    done
    wait
fi
