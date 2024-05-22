DEMO_ID="CMS_ID"
# WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
# WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
DEMO_REPO="https://github.com/m0satron/demo-smart-grid.git"
DEMO_DIR="/home/fari/Documents/demo-smart-grid"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
# "$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"

# Launch the welcome screen using launch_welcome_screen.sh
# "$SCRIPT_DIR/launch_welcome_screen.sh" "$WELCOME_SCREEN_DIR" "$DEMO_ID"

"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"


# Kill process on port 8080
kill -9 $(lsof -t -i:3000)
kill -9 $(lsof -t -i:5000)

gnome-terminal --working-directory=$DEMO_DIR -- bash -c "npm run dev -- --port=5000; echo 'Press Enter to exit'; read"
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "npm run backend:dev; echo 'Press Enter to exit'; read"

gnome-terminal -- bash -c "firefox --kiosk http://localhost:5000; echo 'Press Enter to exit'; read"


# sleep 20
# #press escape for exiting menu in gnome (the menu mode is lauched on startup)
# xdotool key Escape