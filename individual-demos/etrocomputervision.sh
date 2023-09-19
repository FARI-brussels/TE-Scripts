#!/bin/bash

# Demo repo and demo directory path on the sbc here
DEMO_ID="1"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen-Fari_Internship"
DEMO_REPO="git@github.com:FARI-brussels/demo-etro-visual-question-answering.git"
DEMO_DIR="/home/fari/Documents/"
DEMO_FOLDER="demo-etro-visual-question-answering"

# Assuming git_sync.sh and launch_demo.sh are in the same directory as this script
SCRIPT_DIR="$(dirname "$0")"

# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

# Launch the welcome screen using launch_welcome_screen.sh
"$SCRIPT_DIR/launch_welcome_screen.sh" "$WELCOME_SCREEN_DIR" "$DEMO_ID"


gnome-terminal --working-directory=$DEMO_DIR/$DEMO_FOLDER -- bash -c "nohup python3 main.py"
#run demo

