#!/bin/bash
# Demo repo and demo directory path on the sbc here
FRONTEND_REPO="https://github.com/FARI-brussels/Welcome-Screen-v2.git"
FRONTEND_DIR="/home/fari/Documents/Welcome-Screen-v2"

SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Clone or pull the latest version of the repository
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$FRONTEND_DIR" "$FRONTEND_REPO"

# Set the correct Node.js version using nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use a specific Node.js version
nvm use node

# Remove chromium cache
rm -rf ~/.cache/chromium

# Kill any process using port 5173 (if running)
kill -9 $(lsof -t -i:5173)

# Navigate to the demo directory and run npm install
cd "$FRONTEND_DIR"
npm install

# Launch welcome screen in a new gnome terminal after npm install completes
gnome-terminal --working-directory=$FRONTEND_DIR -- bash -c "npm run demo --slug=animal-welfare; echo 'Press Enter to exit'; read"

# Open Chromium in kiosk mode
gnome-terminal -- bash -c 'chromium-browser --kiosk "http://localhost:5173"'

# Press Escape to exit the menu in Gnome (if needed)
xdotool key Escape
