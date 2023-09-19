#!/bin/bash

# Check if both arguments were passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 WELCOME_SCREEN_DIR DEMO_ID"
    exit 1
fi

WELCOME_SCREEN_PATH="$1"
DEMO_ID="$2"

# Kill process on port 8080
kill -9 $(lsof -t -i:8080)

# Remove chromium cache
rm -rf ~/.cache/chromium

# Launch welcome screen in a new gnome terminal
gnome-terminal --working-directory=$WELCOME_SCREEN_PATH -- bash -c 'nohup python server.py' -T "Welcome Screen"

# Give a few seconds for the server to start
sleep 3

# Launch welcome screen in chromium-browser
chromium-browser --kiosk "http://localhost:8080/$DEMO_ID"
