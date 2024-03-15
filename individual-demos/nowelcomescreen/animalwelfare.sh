#!/bin/bash

DEMO_REPO="https://github.com/FARI-brussels/demo-iridia-animal-welfare.git"
DEMO_DIR="/home/fari/Documents/demo-iridia-animal-welfare"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"


#run demo
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "flask run --port=8000; echo 'Press any key to exit'; read" 
chromium-browser --kiosk "http://localhost:8000" &

sleep 20
#press escape for exiting menu in gnome (the menu mode is lauched on startup)
xdotool key Escape
