#!/bin/bash
# Demo repo and demo directory path on the sbc here
REPO="https://github.com/FARI-brussels/demo-etro-heat-island.git"
DIR="/home/fari/Documents/demo-etro-heat-island"
FRONTEND_DIR="$DIR/frontend"
BACKEND_DIR="$DIR/backend"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"
# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DIR" "$REPO"

# Remove chromium cache
rm -rf ~/.cache/chromium

# Kill any process using port 5173 (if running)
kill -9 $(lsof -t -i:5173)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use a specific Node.js version
nvm use node


# Navigate to the demo directory and run npm install
cd $FRONTEND_DIR
npm install

#run backend
#gnome-terminal --working-directory=$BACKEND_DIR -- bash -c "source /home/fari/miniconda3/etc/profile.d/conda.sh && conda activate tictactoe && python main.py --modes REAL;"

gnome-terminal --working-directory="$BACKEND_DIR" -- bash -c ".venv/bin/python app.py; read -p 'Press enter to continue...'"



#run frontend
gnome-terminal --working-directory=$FRONTEND_DIR -- bash -c "npm run dev; read -p 'Press enter to continue...'"

gnome-terminal -- bash -c "firefox --kiosk 'http://localhost:5173'; read -p 'Press enter to continue...'"


sleep 10
xdotool key Escape
