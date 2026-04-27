#!/bin/bash

echo "================================================="
echo " Launching REAL UFACTORY xArm 7"
echo "================================================="

# ---- CRITICAL: Remove Anaconda/Miniforge from library paths ----
export LD_LIBRARY_PATH=$(echo "$LD_LIBRARY_PATH" | tr ':' '\n' | grep -v "miniforge\|anaconda\|conda\|miniconda" | tr '\n' ':' | sed 's/:$//')
export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "miniforge\|anaconda\|conda\|miniconda" | tr '\n' ':' | sed 's/:$//')
export PYTHONPATH=$(echo "$PYTHONPATH" | tr ':' '\n' | grep -v "miniforge\|anaconda\|conda\|miniconda" | tr '\n' ':' | sed 's/:$//')

# ---- CRITICAL: Isolate this simulation on its own ROS 2 domain ----
export ROS_DOMAIN_ID=42

# ---- Kill any leftover processes from previous runs ----
echo "=> Cleaning up stale processes..."
killall -9 gzserver gzclient rviz2 move_group xarm_planner_node robot_state_publisher static_transform_publisher 2>/dev/null
sleep 2

# The workspace is the current directory
WORKSPACE_DIR="$(pwd)"

if [ ! -f "$WORKSPACE_DIR/install/setup.bash" ]; then
    echo "Error: Workspace is not built! Please run ./setup.sh first."
    exit 1
fi

source /opt/ros/humble/setup.bash
source "$WORKSPACE_DIR/install/setup.bash"

echo "=> ROS_DOMAIN_ID = $ROS_DOMAIN_ID (isolated from other projects)"
echo "=> Connecting to Real Robot at IP: 192.168.1.230"
echo "   (Make sure the robot is powered on and E-stop is released)"

ros2 launch xarm_planner xarm7_planner_realmove.launch.py robot_ip:=192.168.1.230 add_gripper:=false
