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


gnome-terminal --working-directory=$DEMO_DIR -- bash -c "npm run dev -- --port=5000; echo 'Press Enter to exit'; read"
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "npm run backend:dev; echo 'Press Enter to exit'; read"