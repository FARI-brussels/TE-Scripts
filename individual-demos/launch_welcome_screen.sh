#!/bin/bash

# Check if both arguments were passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 WELCOME_SCREEN_DIR DEMO_ID"
    exit 1
fi

WELCOME_SCREEN_PATH="$1"
DEMO_ID="$2"





