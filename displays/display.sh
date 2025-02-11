#!/bin/bash

# Function to get local IP address
get_local_ip() {
    # Try different methods to get IP address
    local ip
    if command -v ip >/dev/null 2>&1; then
        ip=$(ip route get 1 | awk '{print $(NF-2);exit}')
    elif command -v ifconfig >/dev/null 2>&1; then
        ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n 1)
    else
        echo "Error: Neither 'ip' nor 'ifconfig' command found"
        exit 1
    fi
    echo "$ip"
}

# Function to find device ID from IP
find_device_id() {
    local ip=$1
    local response
    local device_id
    
    # Get devices data
    response=$(curl -s "https://fari-cms.directus.app/items/devices")
    
    # Check if curl request was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch devices data"
        exit 1
    }
    
    # Parse JSON response to find matching device
    # Using jq for JSON parsing if available, otherwise using grep
    if command -v jq >/dev/null 2>&1; then
        device_id=$(echo "$response" | jq -r --arg ip "$ip" '.data[] | select(.ip == $ip) | .device_id')
    else
        device_id=$(echo "$response" | grep -o '"device_id":"[^"]*"' | grep -o '[^"]*$' | head -n 1)
    fi
    
    if [ -z "$device_id" ]; then
        echo "Error: No device found with IP $ip"
        exit 1
    fi
    
    echo "$device_id"


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
    }
    
    # Parse JSON response to find content ID
    if command -v jq >/dev/null 2>&1; then
        content_id=$(echo "$response" | jq -r --arg device_id "$device_id" '.data[] | select(.connected_device == ($device_id | tonumber)) | .content')
    else
        content_id=$(echo "$response" | grep -o '"content":"[^"]*"' | grep -o '[^"]*$' | head -n 1)
    fi
    
    if [ -z "$content_id" ]; then
        echo "Error: No content found for device ID $device_id"
        exit 1
    
    
    echo "$content_id"


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
    # Get local IP
    local_ip=$(get_local_ip)
    echo "Local IP: $local_ip"
    
    # Find device ID
    device_id=$(find_device_id "$local_ip")
    echo "Device ID: $device_id"
    
    # Get content ID
    content_id=$(get_content_id "$device_id")
    echo "Content ID: $content_id"
    
    # Play video if content is video
    play_video "$content_id"
}

# Run main function
main