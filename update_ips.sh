#!/bin/bash

# Get the list of devices from Directus
response=$(curl -s "https://fari-cms.directus.app/items/devices")

# Run arp-scan once and store the results in a variable
arp_results=$(sudo arp-scan -l)

# Function to extract IP from arp-scan results
get_ip_from_arp() {
    local mac="$1"
    echo "$arp_results" | grep -i "$mac" | awk '{print $1}'
}

# For each device in Directus data
echo "$response" | jq -r '.data[] | @base64' | while read device_encoded; do
    device=$(echo "$device_encoded" | base64 --decode)
    
    # Extract device information
    mac=$(echo "$device" | jq -r '.mac')
    id=$(echo "$device" | jq -r '.id')
    ip_from_api=$(echo "$device" | jq -r '.ip')
    status=$(echo "$device" | jq -r '.status')
    
    # Skip if device is in draft status
    if [ "$status" != "published" ]; then
        echo "Skipping device $id (status: $status)"
        continue
    fi
    
    # Get IP from arp-scan results
    current_ip=$(get_ip_from_arp "$mac")
    
    echo "Processing device $id:"
    echo "  MAC: $mac"
    echo "  Current IP: $current_ip"
    echo "  API IP: $ip_from_api"
    
    # Check if IPs differ and current_ip is not empty
    if [ "$current_ip" != "$ip_from_api" ] && [ -n "$current_ip" ]; then
        echo "IP mismatch for device $id with MAC $mac. Current IP: $current_ip, API IP: $ip_from_api"
        
        # Construct PUT request to update Directus entry
        # Note: You should add proper authentication here
        curl -X PATCH "https://fari-cms.directus.app/items/devices/$id" \
            -H "Content-Type: application/json" \
            -d "{
                \"ip\": \"$current_ip\"
            }"
        
        echo "Updated device $id with new IP: $current_ip"
    fi
done