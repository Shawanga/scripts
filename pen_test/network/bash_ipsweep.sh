#!/bin/bash
# Ip-sweep script to scan only given subnet
# Prerequisite: bash, ipcalc (sudo apt install ipcalc)
# equivalent to nmap -sn x.x.x.x/24

if [[ "$1" == "" ]]; then
    echo "Add IP network subnet (e.g., 192.168.0/24)."
    echo "Syntax: ./bash_ipsweep.sh x.x.x.x/x"
else
    # calculating network range with ipcalc
    network=$(ipcalc -n $1 | grep Network | awk '{print $2}')
    start_ip=$(ipcalc -b $1 | grep HostMin | awk '{print $2}')
    end_ip=$(ipcalc -b $1 | grep HostMax | awk '{print $2}')

    # IP octets to integers
    echo "Scanning network: ${network}"
    echo "Range: ${start_ip} - ${end_ip}"

    for ((a=s1; a<=e1; a++)); do
        for ((b=s2; b<=e2; b++)); do
            for ((c=s3; c<=e3; c++)); do
                for ((d=s4; d<=e4; d++)); do
                    ip="${a}.${b}.${c}.${d}"
                    ping -c 1 $ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
                done
            done
        done
    done
    wait # wait gifor all background jobs to finish
fi
