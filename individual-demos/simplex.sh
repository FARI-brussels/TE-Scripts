DEMO_ID="3"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"

# Launch the welcome screen using launch_welcome_screen.sh
"$SCRIPT_DIR/launch_welcome_screen.sh" "$WELCOME_SCREEN_DIR" "$DEMO_ID" firefox


