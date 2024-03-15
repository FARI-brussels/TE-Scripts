#!/bin/bash

DEMO_REPO="https://github.com/FARI-brussels/demo-iridia-animal-welfare.git"
DEMO_DIR="/home/fari/Documents/demo-iridia-animal-welfare"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"


#run demo
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "nohup python -m flask --app=app --debug run --host=0.0.0.0 --port 8000 &"
chromium-browser --kiosk "http://localhost:8000" &

sleep 20
#press escape for exiting menu in gnome (the menu mode is lauched on startup)
xdotool key Escape
