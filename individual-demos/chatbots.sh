#!/bin/bash

# Demo repo and demo directory path on the sbc here
DEMO_ID="13"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen-Fari_Internship"
DEMO_REPO="https://github.com/ShadhviVR/Chatbot-fari.git"
DEMO_DIR="/home/fari/Documents/"
DEMO_FOLDER="demo-fari-chatbots"

cd "$WELCOME_SCREEN_DIR"
#git pull origin main
#run welcome screen
gnome-terminal --working-directory=$WELCOME_SCREEN_DIR -- 'nohup python server.py'

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

gnome-terminal --working-directory=$DEMO_DIR/$DEMO_FOLDER -- bash -c "npm run dev" 
chromium-browser --kiosk "http://localhost:8080/$DEMO_ID"