#!/usr/bin/env bash
# CIS Ubuntu Linux 22.04 LTS Benchmark v1.0.0
# 3.5.1.6 Ensure ufw firewall rules exist for all open ports

#!/usr/bin/env bash

ufw_out="$(ufw status verbose)"
ss -tuln | awk '($5!~/%lo:/ && $5!~/127.0.0.1:/ && $5!~/::1/) {split($5, a, ":"); print a[2]}' | sort | uniq | while read -r lpn; do
   # if explicit rule
   if ! grep -Pq "^\h*(?:[^\s]+\s+){3}(?:${lpn}\b|(\d+):(\d+))" <<< "${ufw_out}"; then
        # if range rule
        while read -r rule; do
            start_port=$(echo "${rule}" | awk '{split($1, range, ":"); print range[1]}')
            end_port=$(echo "${rule}" | awk '{split($1, range, ":"); print range[2]}')

            if [[ ${lpn} -ge ${start_port} && ${lpn} -le ${end_port} ]]; then
                covered=true
                break
            fi
    done < <(echo "${ufw_out}" | grep -P "^\h*(?:[^\s]+\s+){3}(\d+):(\d+)")


        if [[ "${covered}" != true ]]; then
            echo "- Port: \"${lpn}\" is missing a firewall rule"
        fi
    fi
done
