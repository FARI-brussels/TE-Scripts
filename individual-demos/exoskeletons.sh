

DEMO_ID="9"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen-Fari_Internship"


cd "$WELCOME_SCREEN_DIR"
git pull origin main
#run welcome screen

gnome-terminal --working-directory=$WELCOME_SCREEN_DIR -- bash -c 'nohup python server.py'

chromium-browser --kiosk "http://localhost:8080/$DEMO_ID"



