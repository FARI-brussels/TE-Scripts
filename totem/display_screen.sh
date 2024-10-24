while ! pgrep -x Xorg > /dev/null; do
    sleep 1
done
export DISPLAY=:0
sleep 10 
gnome-terminal -- bash -c "xdotool key Escape; echo 'Press Enter to exit'; read"
mpv --fullscreen --loop /home/fari/Documents/TE-Scripts/totem/conference.mp4

