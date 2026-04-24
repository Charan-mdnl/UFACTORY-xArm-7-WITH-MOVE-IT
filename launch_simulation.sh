#!/bin/bash

echo "================================================="
echo " Launching UFACTORY xArm 7 Simulation"
echo "================================================="

# Prevent Gazebo from hanging on startup by bypassing the model database
export GAZEBO_MODEL_DATABASE_URI=""

# The workspace is the current directory
WORKSPACE_DIR="$(pwd)"

if [ ! -f "$WORKSPACE_DIR/install/setup.bash" ]; then
    echo "Error: Workspace is not built! Please run ./setup.sh first."
    exit 1
fi

source /opt/ros/humble/setup.bash
source "$WORKSPACE_DIR/install/setup.bash"

echo "=> Starting Gazebo and RViz with MoveIt 2..."
ros2 launch xarm_planner xarm7_planner_gazebo.launch.py add_gripper:=false
