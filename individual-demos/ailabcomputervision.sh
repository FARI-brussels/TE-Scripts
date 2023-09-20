
DEMO_ID="2"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen-Flet"

cd "$WELCOME_SCREEN_DIR"
git pull origin main
#run welcome screen
terminator --working-directory=$WELCOME_SCREEN_DIR -e "bash -c 'python main.py --id $DEMO_ID'" -T "Welcome Screen"
pkill chromium-browser
chromium-browser --kiosk "http://127.0.0.1:8550