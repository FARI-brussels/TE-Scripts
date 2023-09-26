#!/bin/bash

CMS_URL="http://46.226.110.124:1337/api/devices"
UPDATE_IPS_SCRIPT="./update_ips.sh" # You should provide the correct path to your script

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <device_name>"
    exit 1
fi

device_name="$1"

# Function to get IP from CMS
get_ip_from_cms() {
    local name="$1"
    curl -s "$CMS_URL" | jq -r --arg name "$name" '.data[] | select(.attributes.device_id == $name) | .attributes.ip'
}

# Get IP from CMS
ip=$(get_ip_from_cms "$device_name")


# Ping the IP
if ! ping -c 1 "$ip" &> /dev/null; then
    echo "IP $ip is not accessible. Running the update_ips script..."
    "$UPDATE_IPS_SCRIPT"
    
    # Look up CMS for the new IP
    ip=$(get_ip_from_cms "$device_name")
fi

# SSH to the device
if [ -n "$ip" ]; then
    echo "SSHing to $device_name with IP $ip..."
    ssh "fari@$ip"
else
    echo "Couldn't find an IP for $device_name."
    exit 1
fi
