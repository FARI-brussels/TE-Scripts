#!/bin/bash

CMS_URL="http://46.226.110.124:1337/api/devices"
SSH_TO_DEVICE_SCRIPT="./ssh_to_device.sh" # Path to the ssh_to_device script

# Function to get all device names from CMS
get_device_names_from_cms() {
    curl -s "$CMS_URL" | jq -r '.data[].attributes.device_id'
}

# For each device, run command.sh using SSH
for device_name in $(get_device_names_from_cms); do
    echo "Running command.sh on $device_name..."
    "$SSH_TO_DEVICE_SCRIPT" "$device_name" "./command.sh"
done
