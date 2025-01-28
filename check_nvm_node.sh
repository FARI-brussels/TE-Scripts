# Check if NVM is installed
if command -v nvm &> /dev/null; then
  bold "NVM is already installed."
else
  bold "NVM is not installed. Installing now..."

  # Install NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

  # Load NVM into the current session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \ . "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \ . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  if ! command -v nvm &> /dev/null; then
    echo "Failed to install NVM. Please check the installation script." >&2
    exit 1
  fi

  bold "NVM installed successfully."
fi

# Check the installed Node.js version
node_version=$(node -v 2>/dev/null || echo "not installed")
bold "Current Node.js version: $node_version"

# Check if the installed Node.js version is LTS
if [[ "$node_version" == "not installed" ]]; then
  bold "Node.js is not installed. Installing the latest LTS version..."
  nvm install --lts
elif [[ $(nvm version-remote --lts) == $(node -v) ]]; then
  bold "The installed Node.js version is the LTS version. No action needed."
else
  bold "The installed Node.js version is not LTS. Switching to the LTS version..."
  nvm install --lts
  nvm use --lts
fi

bold "Script execution completed."