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

    # Convert mac to uppercase and remove colons to match API format
    mac=$(echo "$mac" | tr '[:lower:]' '[:upper:]' | tr -d ':')
    echo "$mac"
}

# Function to find device ID from MAC address
find_device_id() {
    local mac=$1
    local response
    local device_id
    
    # Get devices data
    response=$(curl -s "https://fari-cms.directus.app/items/devices")
    
    # Check if curl request was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch devices data"
        exit 1
    fi
    
    # Parse JSON response to find matching device
    if command -v jq >/dev/null 2>&1; then
        # Using jq with error handling
        if ! device_id=$(echo "$response" | jq -r --arg mac "$mac" '.data[] | select(.mac == $mac and .status=="published") | .device_id' 2>/dev/null); then
            echo "Error: Failed to parse devices JSON"
            exit 1
        fi
    else
        # Fallback to grep with basic parsing
        device_id=$(echo "$response" | grep -B2 "\"mac\":\"$mac\"" | grep -o '"device_id":"[^"]*"' | cut -d'"' -f4 | head -n 1)
    fi
    
    if [ -z "$device_id" ]; then
        echo "Error: No device found with MAC address $mac"
        exit 1
    fi
    
    echo "$device_id"
}

# Function to get content ID from device ID
get_content_id() {
    local device_id=$1
    local response
    local content_id
    
    # Get displays data
    response=$(curl -s "https://fari-cms.directus.app/items/displays")
    
    # Check if curl request was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch displays data"
        exit 1
    fi
    
    # Parse JSON response to find content ID
    if command -v jq >/dev/null 2>&1; then
        # Using jq with error handling
        if ! content_id=$(echo "$response" | jq -r '.data[0].content' 2>/dev/null); then
            echo "Error: Failed to parse displays JSON"
            exit 1
        fi
    else
        # Fallback to grep with basic parsing
        content_id=$(echo "$response" | grep -o '"content":"[^"]*"' | cut -d'"' -f4 | head -n 1)
    fi
    
    if [ -z "$content_id" ]; then
        echo "Error: No content found for device ID $device_id"
        exit 1
    fi
    
    echo "$content_id"
}

# Function to check if content is video and play it
play_video() {
    local content_id=$1
    local video_path="/path/to/videos/$content_id.mp4"  # Adjust path as needed
    
    # Check if file exists and is a video
    if [ -f "$video_path" ] && file --mime-type "$video_path" | grep -q "video"; then
        # Check for available video players and play in loop
        if command -v vlc >/dev/null 2>&1; then
            vlc --loop "$video_path"
        elif command -v mplayer >/dev/null 2>&1; then
            mplayer -loop 0 "$video_path"
        elif command -v ffplay >/dev/null 2>&1; then
            while true; do
                ffplay -autoexit "$video_path"
            done
        else
            echo "Error: No suitable video player found"
            exit 1
        fi
    else
        echo "Error: Content is not a video or file not found"
        exit 1
    fi
}

# Main script execution
main() {
    # Get MAC address
    mac_address=$(get_mac_address)
    echo "MAC Address: $mac_address"
    
    # Find device ID
    device_id=$(find_device_id "$mac_address")
    echo "Device ID: $device_id"
    
    # Get content ID
    content_id=$(get_content_id "$device_id")
    echo "Content ID: $content_id"
    
    # Play video if content is video
    play_video "$content_id"
}

# Run main function
main