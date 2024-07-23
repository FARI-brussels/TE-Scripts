#!/bin/bash
# Demo repo and demo directory path on the sbc here
DEMO_REPO="https://github.com/FARI-brussels/guesswho-POC.git"
DEMO_DIR="/home/fari/Documents/guesswho-POC"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"


"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

# Launch the welcome screen using launch_welcome_screen.sh



#run demo
#kill process on port 8000
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "nohup python server.py"

DISPLAY=:0 chromium-browser --kiosk "http://localhost:5000" &
DISPLAY=:1 chromium-browser --kiosk "http://localhost:5000/robot_view" &
