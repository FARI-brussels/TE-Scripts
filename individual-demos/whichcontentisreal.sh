#!/bin/bash

# Demo repo and demo directory path on the sbc here
DEMO_ID="12"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen-Fari_Internship"
DEMO_REPO="https://github.com/FARI-brussels/demo-fari-which-content-is-real.git"
DEMO_DIR="/home/fari/Documents/"
DEMO_FOLDER="demo-fari-which-content-is-real"

cd "$WELCOME_SCREEN_DIR"
#git pull origin main
#run welcome screen
terminator --working-directory=$WELCOME_SCREEN_DIR -e 'nohup python server.py' -T "Welcome Screen"

# Check if the directory exists
if [ -d "$DEMO_DIR/$DEMO_FOLDER" ]; then
  # If the directory exists, navigate to it and pull the latest from Git
  cd "$DEMO_DIR"
  git pull origin master
else
  # If the directory doesn't exist, clone the repo into the directory
  ECHO lol
  git clone "$DEMO_REPO" "$DEMO_DIR/$DEMO_FOLDER"
  cd "$DEMO_DIR"
fi

#run demo
chromium-browser --kiosk "http://localhost:8080/$DEMO_ID"
terminator --working-directory=$DEMO_DIR/$DEMO_FOLDER -e 'bash -c "nohup python server.py"' -T "Demo"
