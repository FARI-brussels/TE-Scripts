#!/bin/bash

# Check if both arguments were passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 LOCAL_PATH REPO_URL"
    exit 1
fi

LOCAL_PATH="$1"
REPO_URL="$2"

# Check if the local path exists
if [ -d "$LOCAL_PATH" ]; then
    # If it exists, navigate to the directory and pull the latest changes
    cd "$LOCAL_PATH" || exit
    echo "Updating the existing repo at $LOCAL_PATH ..."
    git pull origin main:main
else
    # If it doesn't exist, clone the repository into the specified path
    echo "Cloning repo from $REPO_URL to $LOCAL_PATH ..."
    git clone "$REPO_URL" "$LOCAL_PATH"
fi
