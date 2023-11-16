#!/bin/bash

# Get the list of devices from the CMS
response=$(curl -s http://46.226.110.124:1337/api/devices)

# Run arp-scan once and store the results in a variable
arp_results=$(sudo arp-scan -l)

# Function to extract IP from arp-scan results
get_ip_from_arp() {
    local mac="$1"
    echo "$arp_results" | grep "$mac" | awk '{print $1}'
}

# For each device in CMS data
echo "$response" | jq -r '.data[] | @base64' | while read device_encoded; do
    device=$(echo "$device_encoded" | base64 --decode)
    mac=$(echo "$device" | jq -r '.attributes.mac')
    id=$(echo "$device" | jq -r '.id')
    ip_from_api=$(echo "$device" | jq -r '.attributes.ip')
    echo $id
    # Get IP from arp-scan results
    current_ip=$(get_ip_from_arp "$mac")
    echo $ip_from_api
    echo $current_ip

    # Check if IPs differ
    # ... [rest of the script]

# Check if IPs differ
    if [ "$current_ip" != "$ip_from_api" ] && [ -n "$current_ip" ]; then
        echo "IP mismatch for device $id with MAC $mac. Current IP: $current_ip, API IP: $ip_from_api."
        # Construct POST request to update Strapi entry UNSAAAAAAAAAAAFFFFFE should implement authorisation in CMS
        echo $id
        curl -X PUT "http://46.226.110.124:1337/api/devices/$id" \
             -H "Content-Type: application/json" \
             -d "{
                \"data\": {
                   \"ip\": \"$current_ip\"
                    }
                
                }"

    fi

done
