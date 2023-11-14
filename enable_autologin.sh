#!/bin/bash
#script to enable autologin at startup (to not have to put the password when a sbc is powered on)

# Define the file path
FILE_PATH="/etc/lightdm/lightdm.conf.d/11-armbian.conf"

# Check if the file exists
if [[ -f $FILE_PATH ]]; then
    # Append the lines to the file
    sudo echo "autologin-user=fari" >> $FILE_PATH
    sudo echo "autologin-user-timeout=0" >> $FILE_PATH
    echo "Lines appended successfully!"
else
    echo "Error: $FILE_PATH does not exist!"
fi
