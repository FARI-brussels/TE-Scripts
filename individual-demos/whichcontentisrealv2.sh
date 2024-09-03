#!/bin/bash
# Demo repo and demo directory path on the sbc here
DEMO_REPO="https://github.com/FARI-brussels/demo-which-content-is-real-v2.git"
DEMO_DIR="/home/fari/Documents/demo-fari-which-content-is-real-v2"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"


"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

# Remove chromium cache
rm -rf ~/.cache/chromium

kill -9 $(lsof -t -i:5173)



# Launch welcome screen in a new gnome terminal
gnome-terminal --working-directory=$TOTEM_INTERFACE_DIR -- bash -c 'npm run dev'
gnome-terminal --working-directory=$TOTEM_INTERFACE_DIR -- bash -c 'npm run backend:dev'

gnome-terminal -- bash -c 'chromium-browser --kiosk "http://localhost:5173"' 

sleep 20
#press escape for exiting menu in gnome (the menu mode is lauched on startup)
xdotool key Escape
