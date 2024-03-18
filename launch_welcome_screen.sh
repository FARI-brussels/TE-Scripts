#!/bin/bash

# Check if the number of arguments is less than 2
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 WELCOME_SCREEN_DIR DEMO_ID [BROWSER]"
    exit 1
fi

WELCOME_SCREEN_PATH="$1"
DEMO_ID="$2"
BROWSER=${3:-chromium} # Default to chromium if not specified

# Kill process on port 8080
kill -9 $(lsof -t -i:8080)

# Check which browser to use and remove its cache
if [ "$BROWSER" = "firefox" ]; then
    CACHE_DIR=~/.cache/mozilla/firefox
else
    CACHE_DIR=~/.cache/chromium
fi

rm -rf "$CACHE_DIR"

# Launch welcome screen in a new gnome terminal
gnome-terminal --working-directory="$WELCOME_SCREEN_PATH" -- bash -c 'nohup python server.py &'

# Launch the specified browser
if [ "$BROWSER" = "firefox" ]; then
    firefox --kiosk "http://localhost:8080/$DEMO_ID" &
else
    chromium-browser --kiosk "http://localhost:8080/$DEMO_ID" &
fi





