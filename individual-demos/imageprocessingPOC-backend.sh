#!/bin/bash
# Demo repo and demo directory path on the sbc here
DEMO_REPO="https://github.com/FARI-brussels/imageprocessingPOC.git"
DEMO_DIR="/home/fari/Documents/imageprocessingPOC"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"


"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

# Launch the welcome screen using launch_welcome_screen.sh



#run demo
#kill process on port 5000
kill -9 $(lsof -t -i:8080)


gnome-terminal --working-directory=$DEMO_DIR -- bash -c "source /home/fari/miniconda3/etc/profile.d/conda.sh && conda activate ultralytics && python backend.py; read -p 'Press enter to continue...'"

