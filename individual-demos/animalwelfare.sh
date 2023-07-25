#!/bin/bash

# Demo repo and demo directory path on the sbc here
DEMO_ID="0"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen-Fari_Internship"
DEMO_REPO="https://github.com/FARI-brussels/demo-iridia-animal-welfare.git"
DEMO_DIR="/home/fari/Documents/"
DEMO_FOLDER="demo-iridia-animal-welfare"

cd "$WELCOME_SCREEN_DIR"
git pull origin main
#run welcome screen
gnome-terminal --working-directory=$WELCOME_SCREEN_DIR -e 'nohup python server.py' -T "Welcome Screen"

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
gnome-terminal --working-directory=$DEMO_DIR/$DEMO_FOLDER -e 'bash -c "nohup python -m flask --app=app --debug run --host=0.0.0.0"' -T "Demo"

chromium-browser --kiosk "http://localhost:8080/$DEMO_ID"