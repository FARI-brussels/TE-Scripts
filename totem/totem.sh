DEMO_ID="3"
TOTEM_INTERFACE_DIR="/home/fari/Documents/Totem-Interface"
TOTEM_INTERFACE_REPO="https://github.com/FARI-brussels/Totem-Interface"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$TOTEM_INTERFACE_DIR" "$TOTEM_INTERFACE_REPO"

# Launch the welcome screen using launch_welcome_screen.sh
# Kill process on port 8080
kill -9 $(lsof -t -i:8080)

# Remove chromium cache
rm -rf ~/.cache/chromium

# Launch welcome screen in a new gnome terminal
gnome-terminal --working-directory=$TOTEM_INTERFACE_DIR -- bash -c 'nohup python -m http.server 8080'
chromium-browser --kiosk "http://localhost:8080" 
