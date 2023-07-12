

DEMO_ID="8"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"


cd "$WELCOME_SCREEN_DIR"
git pull origin main
#run welcome screen
xfce4-terminal --working-directory=$WELCOME_SCREEN_DIR -e 'nohup python server.py' -T "Welcome Screen"


xdg-open "http://localhost:8080/$DEMO_ID"