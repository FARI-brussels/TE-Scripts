#!/bin/bash
# Demo repo and demo directory path on the sbc here


BACKEND_REPO="https://github.com/FARI-brussels/demo-heatmap-poc.git"
FRONTEND_REPO="https://github.com/FARI-brussels/demo-heatmap-poc.git"
BACKEND_DIR="/home/fari/Documents/demo-heatmap-poc/backend"
FRONTEND_DIR="/home/fari/Documents/demo-heatmap-poc/frontend"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"
# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$BACKEND_DIR" "/home/fari/Documents/demo-heatmap-poc/"

# Remove chromium cache
rm -rf ~/.cache/chromium

# Kill any process using port 5173 (if running)
kill -9 $(lsof -t -i:5173)

# Navigate to the demo directory and run npm install
cd "$FRONTEND_DIR"
npm install

#run backend
#gnome-terminal --working-directory=$BACKEND_DIR -- bash -c "source /home/fari/miniconda3/etc/profile.d/conda.sh && conda activate tictactoe && python main.py --modes REAL;"

gnome-terminal --working-directory=$BACKEND_DIR -- bash -c "python app.py; read -p 'Press enter to continue...'"


#run frontend
gnome-terminal --working-directory=$FRONTEND_DIR -- bash -c "npm run dev; read -p 'Press enter to continue...'"

gnome-terminal -- bash -c "firefox --kiosk 'http://localhost:5173'; read -p 'Press enter to continue...'"


sleep 10
xdotool key Escape
