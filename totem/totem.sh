TOTEM_INTERFACE_DIR="/home/fari/Documents/totem-v1"
TOTEM_INTERFACE_REPO="https://github.com/FARI-brussels/totem-v1.git"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$TOTEM_INTERFACE_DIR" "$TOTEM_INTERFACE_REPO"

# Launch the welcome screen using launch_welcome_screen.sh
# Kill process on port 8080
kill -9 $(lsof -t -i:5173)

cd $TOTEM_INTERFACE_DIR
npm install 

# Remove chromium cache
rm -rf ~/.cache/chromium

xinput set-prop 7 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1

# Launch welcome screen in a new gnome terminal
gnome-terminal --working-directory=$TOTEM_INTERFACE_DIR -- bash -c 'npm run dev'
# gnome-terminal --working-directory=$TOTEM_INTERFACE_DIR -- bash -c 'npm run backend:dev'

gnome-terminal -- bash -c 'chromium-browser --kiosk "http://localhost:5173"' 

sleep 20
#press escape for exiting menu in gnome (the menu mode is lauched on startup)
xdotool key Escape
