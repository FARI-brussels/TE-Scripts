DEMO_ID="14"
WELCOME_SCREEN_DIR="/home/fari/Documents/Welcome-Screen"
WELCOME_SCREEN_REPO="https://github.com/FARI-brussels/welcome-screen"
DEMO_REPO="https://github.com/FARI-brussels/demo-iridia-swarm-robotics.git"
DEMO_DIR="/home/fari/Documents/demo-iridia-swarm-robotics"
SCRIPT_DIR="/home/fari/Documents/TE-Scripts"
# Common ROS setup commands
ROS_SETUP="source /opt/ros/noetic/setup.bash && export ROS_MASTER_URI=http://192.168.2.4:11311 && export ROS_HOSTNAME=192.168.2.4 && source ~/catkin_ws/devel/setup.bash &&"


# Use git_sync.sh to sync both repositories
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$WELCOME_SCREEN_DIR" "$WELCOME_SCREEN_REPO"
"$SCRIPT_DIR/clone_or_pull_repo.sh" "$DEMO_DIR" "$DEMO_REPO"

#run demo
#kill process on port 5000
kill -9 $(lsof -t -i:5000)



gnome-terminal -- bash -c "bash /home/fari/Documents/demo-iridia-swarm-robotics/launch_ros_and_arena-Ongoing.sh"

sleep 10


gnome-terminal --working-directory=$DEMO_DIR/swarmcity -- bash -c "$ROS_SETUP npm run dev -- --port=5000; echo 'Press Enter to exit'; read"
gnome-terminal --working-directory=$DEMO_DIR/swarmcity -- bash -c "$ROS_SETUP node server.js; echo 'Press Enter to exit'; read"

gnome-terminal --working-directory=$DEMO_DIR/swarmexp -- bash -c "BROWSER=None PORT=3030 npm start 'Press Enter to exit'; read"

# Launch the welcome screen using launch_welcome_screen.sh
"$SCRIPT_DIR/launch_welcome_screen.sh" "$WELCOME_SCREEN_DIR" "$DEMO_ID"
