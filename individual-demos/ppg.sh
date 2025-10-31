#!/bin/bash
# Demo repo and demo directory path on the sbc here
DEMO_REPO="https://github.com/FARI-brussels/demo-fari-etro-ppg.git"
DEMO_DIR="/home/fari/Documents/demo-fari-etro-ppg"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Clone or pull the latest version of the repository
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

# Remove chromium cache
rm -rf ~/.cache/chromium

# Kill any process using port 5173 (if running)
kill -9 $(lsof -t -i:5173)

# Set the correct Node.js version using nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use a specific Node.js version
nvm use node

# Navigate to the demo directory and run npm install
cd "$DEMO_DIR"
npm install

# Launch welcome screen in a new gnome terminal after npm install completes
gnome-terminal --working-directory=$DEMO_DIR -- bash -c "npm run dev; echo 'Press Enter to exit'; read"

# Open Chromium in kiosk mode
gnome-terminal -- bash -c 'chromium-browser --kiosk "http://localhost:5173"'

# Wait for the system to initialize (sleep for 20 seconds)
sleep 5

# Press Escape to exit the menu in Gnome (if needed)
xdotool key Escape
