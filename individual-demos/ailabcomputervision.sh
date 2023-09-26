
DEMO_ID="2"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen-Flet"
WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/Welcome-Screen-Flet"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"


xfce4-terminal --working-directory=$WELCOME_SCREEN_DIR -e "bash -c 'python main.py --id $DEMO_ID'" &
echo lol
killall chromium-browser
chromium-browser --kiosk "http://127.0.0.1:8550"