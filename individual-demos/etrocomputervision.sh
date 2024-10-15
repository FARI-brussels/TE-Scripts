#!/bin/bash

# Demo repo and demo directory path on the sbc here
DEMO_ID="53"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
DEMO_REPO="git@github.com:FARI-brussels/demo-etro-visual-question-answering.git"
DEMO_DIR="/home/fari/Documents/demo-etro-visual-question-answering"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

#kill process on port 8551
kill -9 $(lsof -t -i:8551)
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "nohup python3 main.py"
#run demo

sleep 10

# Launch the welcome screen using launch_welcome_screen.sh
"$SCRIPT_DIR/launch_welcome_screen.sh" "$WELCOME_SCREEN_DIR" "$DEMO_ID"



sleep 10
chromium-browser --kiosk "http://localhost:8080/$DEMO_ID" &

