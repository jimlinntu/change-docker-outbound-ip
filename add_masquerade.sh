#!/bin/bash

if [ -z "${INTERFACE}" ]; then
    echo "INTERFACE should not be empty nor unset!"
    exit 1
fi

if [ -z "${OUTBOUND_IP}" ]; then
    echo "OUTBOUND_IP should not be empty nor unset!"
    exit 1
fi

interface="${INTERFACE}"
target_ip="${OUTBOUND_IP}"
cidr_ip=$(ip addr show "$interface" | grep 'inet ' | awk '{print $2}')
if [ -z "$cidr_ip" ]; then
    echo "$interface does not exist!"
    exit 1
fi
network=$(ipcalc "$cidr_ip"  | grep "Network:" | awk '{print $2}')

function add_masquerade {
    iptables -t nat -C POSTROUTING -s "$network" -j SNAT --to "$target_ip" || {
        iptables -t nat -I POSTROUTING 1 -s "$network" -j SNAT --to "$target_ip"   
    }
}

function clear_masquerade {
    iptables -t nat -C POSTROUTING -s "$network" -j SNAT --to "$target_ip" && {
        iptables -t nat -D POSTROUTING -s "$network" -j SNAT --to "$target_ip"   
    }
}

echo "Prepare to add NAT source network from $network to $target_ip"
add_masquerade
echo "Insert a source NAT rule in front of POSTROUTING chain...."
echo "Done!"

# Install signal handlers
trap "clear_masquerade" SIGINT SIGTERM

sleep infinity &
# wait for SIGINT or SIGTERM
wait
echo "Gracefully shutdown!"
exit 0
