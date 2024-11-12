DEMO_ID="CMS_ID"
# WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
# WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
DEMO_REPO="https://github.com/m0satron/demo-smart-grid.git"
DEMO_DIR="/home/fari/Documents/demo-smart-grid"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"


# Set the correct Node.js version using nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use a specific Node.js version
nvm use node



"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

cd $DEMO_DIR 

npm install

# Kill process on port 8080
kill -9 $(lsof -t -i:5000)

gnome-terminal --working-directory=$DEMO_DIR -- bash -c "npm run dev -- --port=5000; echo 'Press Enter to exit'; read"


gnome-terminal -- bash -c "firefox --kiosk http://localhost:5000; echo 'Press Enter to exit'; read"

sleep 2
# #press escape for exiting menu in gnome (the menu mode is lauched on startup)
xdotool key Escape
