DEMO_ID="14"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
DEMO_REPO="https://github.com/FARI-brussels/demo-iridia-swarm-robotics.git"
DEMO_DIR="/home/fari/Documents/demo-iridia-swarm-robotics"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

# Launch the welcome screen using launch_welcome_screen.sh
"$SCRIPT_DIR/launch_welcome_screen.sh" "$WELCOME_SCREEN_DIR" "$DEMO_ID"

#run demo
#kill process on port 5000
kill -9 $(lsof -t -i:5000)
gnome-terminal --working-directory=$DEMO_DIR/frontend -- bash -c "nohup python server.py"