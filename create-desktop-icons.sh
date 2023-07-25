#!/bin/bash
TITLES=("Animal Welfare" "Etro Computer Vision" "Simplex" "Smart prothese" "Exoskeletons" "Which Content is real" "Brickiebot")
PREFIX=("animalwelfare" "etrocomputervision" "simplex" "smartprothesis" "exoskeletons" "whichcontentisreal" "brickiebot.sh")
cd /home/fari/Desktop
for ((i=0; i< ${#TITLES[@]}; i++));
do  
content="[Desktop Entry]
Name=${TITLES[${i}]}
Exec=/home/fari/Documents/TE-Scripts/individual-demos/${PREFIX[$i]}.sh
Icon=/home/fari/Pictures/fari.svg
Terminal=true
Type=Application
Comment=Start demo"
echo "$content"> "${PREFIX[$i]}.desktop"
gio set /home/fari/Desktop/${PREFIX[$i]}.desktop metadata::trusted true
done