DEMO_ID="15"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
DEMO_REPO="https://github.com/FARI-brussels/demo-fari-robotic-arm"
DEMO_DIR="/home/fari/Documents/demo-fari-robotic-arm"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

# Launch the welcome screen using launch_welcome_screen.sh
"$SCRIPT_DIR/launch_welcome_screen.sh" "$WELCOME_SCREEN_DIR" "$DEMO_ID"

#run demo
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "source /home/fari/anaconda3/etc/profile.d/conda.sh && conda activate demo-fari-robotic-arm && python main.py; read -p 'Press enter to continue...'"

#kill process on port 5000
kill -9 $(lsof -t -i:5000)
gnome-terminal --working-directory=$DEMO_DIR/frontend -- bash -c "nohup python server.py"

