#!/bin/bash

# Demo repo and demo directory path on the sbc here
DEMO_ID="0"

WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
DEMO_REPO="https://github.com/FARI-brussels/demo-iridia-animal-welfare.git"
DEMO_DIR="/home/fari/Documents/demo-iridia-animal-welfare"


# Check if the welcome screen directory exists
if [ -d "$WELCOME_SCREEN_DIR" ]; then
  # If the directory exists, navigate to it and pull the latest from Git
  cd "$WELCOME_SCREEN_DIR"
  git pull origin main
else
  # If the directory doesn't exist, clone the repo into the directory
  git clone "$WELCOME_SCREEN_REPO" "$WELCOME_SCREEN_DIR"
fi
#kill process on port 8080
kill -9 $(lsof -t -i:8080)
#remove chromium cache
rm -rf ~/.cache/chromium
#launch welcome screen
gnome-terminal --working-directory=$WELCOME_SCREEN_DIR -- bash -c 'nohup python server.py' -T "Welcome Screen"

# Check if the directory exists
if [ -d "$DEMO_DIR" ]; then
  # If the directory exists, navigate to it and pull the latest from Git
  cd "$DEMO_DIR"
  git pull origin main
else
  # If the directory doesn't exist, clone the repo into the directory
  git clone "$DEMO_REPO" "$DEMO_DIR"
fi


#run demo
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "nohup python -m flask --app=app --debug run --host=0.0.0.0"

chromium-browser --kiosk "http://localhost:8080/$DEMO_ID"