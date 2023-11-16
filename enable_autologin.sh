#!/bin/bash
# Script to enable autologin at startup (to not have to put the password when an SBC is powered on)

# Define the file path
FILE_PATH="/etc/lightdm/lightdm.conf.d/11-armbian.conf"

# Temporary file
TEMP_FILE=$(mktemp)

# Check if the file exists
if [[ -f $FILE_PATH ]]; then
    # Write new lines to the temporary file
    echo "autologin-user=fari" > "$TEMP_FILE"
    echo "autologin-user-timeout=0" >> "$TEMP_FILE"
    
    # Append the content of the original file to the temporary file
    cat "$FILE_PATH" >> "$TEMP_FILE"
    
    # Replace the original file with the temporary file
    sudo cp "$TEMP_FILE" "$FILE_PATH"
    rm "$TEMP_FILE" # Remove the temporary file

    echo "Lines appended successfully at the start of the file!"
else
    echo "Error: $FILE_PATH does not exist!"
    rm "$TEMP_FILE" # Clean up the temporary file
fi
