# get_and_play_video.sh
#!/bin/bash

# Function to get MAC address
get_mac_address() {
    local mac
    local interface

    # Find the active network interface (excluding loopback)
    if command -v ip >/dev/null 2>&1; then
        interface=$(ip route get 1 | awk '{print $5;exit}')
    else
        interface=$(route -n | grep '^0.0.0.0' | awk '{print $8}' | head -n1)
    fi

    # Get MAC address for the interface
    if [ -z "$interface" ]; then
        echo "Error: Could not determine network interface"
        exit 1
    fi

    if command -v ip >/dev/null 2>&1; then
        mac=$(ip link show "$interface" | awk '/ether/ {print $2}')
    elif command -v ifconfig >/dev/null 2>&1; then
        mac=$(ifconfig "$interface" | awk '/ether/ {print $2}')
    else
        echo "Error: Neither 'ip' nor 'ifconfig' command found"
        exit 1
    fi

    # Format MAC address to match API format (lowercase with colons)
    mac=$(echo "$mac" | tr -d ':' | tr '[:upper:]' '[:lower:]')
    mac=$(echo "$mac" | sed 's/.\{2\}/&:/g' | sed 's/:$//')
    
    echo "$mac"
}

# Function to find device ID from MAC address
find_device_id() {
    local mac=$1
    local response
    local device_id
    
    response=$(curl -s "https://fari-cms.directus.app/items/devices")
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch devices data"
        exit 1
    fi
    
    if command -v jq >/dev/null 2>&1; then
        if ! device_id=$(echo "$response" | jq -r --arg mac "$mac" '.data[] | select(.mac == $mac and .status=="published") | .device_id' 2>/dev/null); then
            echo "Error: Failed to parse devices JSON"
            exit 1
        fi
    else
        device_id=$(echo "$response" | grep -B2 "\"mac\":\"$mac\"" | grep -o '"device_id":"[^"]*"' | cut -d'"' -f4 | head -n 1)
    fi
    
    if [ -z "$device_id" ]; then
        echo "Error: No device found with MAC address $mac"
        exit 1
    fi
    
    echo "$device_id"
}

# Main script execution
main() {
    # Get MAC address
    mac_address=$(get_mac_address)
    echo "MAC Address: $mac_address"
    
    # Find device ID
    device_id=$(find_device_id "$mac_address")
    echo "Device ID: $device_id"
    
    # Call Python script with device ID
    gnome-terminal -- bash -c "python3 /home/fari/Documents/TE-Scripts/displays/media_server.py '$device_id'; read -p 'Press enter to continue...'"

    sleep 5
    gnome-terminal -- bash -c "firefox --kiosk --new-window 'http://localhost:8000'; read -p 'Press enter to continue...'"

}

# Run main function
main

sleep 10
xdotool key Escape