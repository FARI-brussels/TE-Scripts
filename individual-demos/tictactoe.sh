BACKEND_REPO="https://github.com/FARI-brussels/demo-fari-tic-tac-toe-backend"
FRONTEND_REPO="git@github.com:FARI-brussels/demo-fari-tic-tac-toe-frontend.git"
BACKEND_DIR="/home/fari/Documents/demo-fari-tic-tac-toe-backend"
FRONTEND_DIR="/home/fari/Documents/demo-fari-tic-tac-toe-frontend"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$BACKEND_DIR" "$BACKEND_REPO"
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$FRONTEND_DIR" "$FRONTEND_REPO"

#run backend
gnome-terminal --working-directory=$BACKEND_DIR -- bash -c "source /home/fari/miniconda3/etc/profile.d/conda.sh && conda activate tictactoe && python main.py --modes REAL; read -p 'Press enter to continue...'"



#kill process on port 5000
kill -9 $(lsof -t -i:5000)

#run frontend
gnome-terminal --working-directory=$FRONTEND_DIR -- bash -c "pnpm dev; read -p 'Press enter to continue...'"

gnome-terminal --working-directory=$FRONTEND_DIR -- bash -c "pnpm backend:dev; read -p 'Press enter to continue...'"


chromium-browser --kiosk "http://localhost:5173" &
