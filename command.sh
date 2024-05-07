#!/bin/bash

# Set your Wi-Fi SSID and password here
SSID="fari-test-and-experience-cent_5G"
PASSWORD="fari.brussels"

# Function to disconnect from current Wi-Fi network
disconnect_wifi() {
    echo "Disconnecting from Wi-Fi..."
    echo "$PASSWORD" | sudo -S nmcli dev disconnect wlan0
    echo "Disconnected from Wi-Fi"
}

# Function to connect to a new Wi-Fi network
connect_wifi() {
    local ssid="$1"
    local password="$2"
    
    echo "Connecting to Wi-Fi network: $ssid..."
    sudo -S nmcli device wifi connect "$ssid" password "$password"
    echo "Connected to Wi-Fi network: $ssid"
}

# Main script
disconnect_wifi
connect_wifi "$SSID" "$PASSWORD"
