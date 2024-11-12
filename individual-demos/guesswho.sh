#!/bin/bash
# Demo repo and demo directory path on the sbc here


BACKEND_REPO="https://github.com/FARI-brussels/demo-fari-guess-who-backend.git"
FRONTEND_REPO="https://github.com/FARI-brussels/demo-fari-guess-who-frontend.git"
BACKEND_DIR="/home/fari/Documents/demo-fari-guess-who-backend"
FRONTEND_DIR="/home/fari/Documents/demo-fari-guess-who-frontend"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"
# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$BACKEND_DIR" "$BACKEND_REPO"
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$FRONTEND_DIR" "$FRONTEND_REPO"


xinput set-prop 11 'Coordinate Transformation Matrix' 0 -0.5 1 1 0 0 0 0 1


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



gnome-terminal --working-directory=$FRONTEND_DIR -- bash -c "npm run backend:dev; read -p 'Press enter to continue...'"


DISPLAY=:0 chromium-browser --kiosk "http://localhost:5173" &
DISPLAY=:1 chromium-browser --kiosk "http://localhost:5173" &