#!/bin/bash
# Demo repo and demo directory path on the sbc here
DEMO_ID="12"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
DEMO_REPO="https://github.com/FARI-brussels/demo-fari-which-content-is-real.git"
DEMO_DIR="/home/fari/Documents/demo-fari-which-content-is-real"


# Assuming git_sync.sh and launch_demo.sh are in the same directory as this script
SCRIPT_DIR="$(dirname "$0")"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

# Launch the welcome screen using launch_welcome_screen.sh
"$SCRIPT_DIR/launch_welcome_screen.sh" "$WELCOME_SCREEN_DIR" "$DEMO_ID"


#run demo
#kill process on port 8000
kill -9 $(lsof -t -i:8000)
gnome-terminal --working-directory=$DEMO_DIR/$DEMO_FOLDER -- bash -c "nohup python server.py" 
>>>>>>> 8b9b733 (unix fix)
