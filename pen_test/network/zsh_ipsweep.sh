#!/bin/zsh
# Ip-sweep script to scan only given subnet
# Prerequisite: zsh, ipcalc (brew install ipcalc)
# equivalnent to nmap -sn x.x.x.x/24

if [ -z "$1" ]; then 
    echo "Add IP network subnet (e.g., 192.168.1.0/24)."
    echo "Syntax: ./zsh_ipsweep.sh 192.168.1.0/24"
else
    # calculating network range with ipcalc
    network=$(ipcalc -n $1 | grep Network | awk '{print $2}')
    start_ip=$(ipcalc -b $1 | grep HostMin | awk '{print $2}')
    end_ip=$(ipcalc -b $1 | grep HostMax | awk '{print $2}')

    # IP octets to integers
    IFS=. read -r s1 s2 s3 s4 <<< "$start_ip"
    IFS=. read -r e1 e2 e3 e4 <<< "$end_ip"

    for ((a=s1; a<=e1; a++)); do
        for ((b=s2; b<=e2; b++)); do
            for ((c=s3; c<=e3; c++)); do
                for ((d=s4; d<=e4; d++)); do
                    ip="$a.$b.$c.$d"
                    ping -c 1 $ip | grep "64 bytes" | awk '{print $4}' | tr -d ":" &
                done
            done
        done
    done
    wait # wait for all background jobs to finish
fi
