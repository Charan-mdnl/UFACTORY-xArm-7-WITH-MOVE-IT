#!/bin/bash
set -e

echo "================================================="
echo " Setting up UFACTORY xArm 7 ROS 2 Workspace"
echo "================================================="

# The workspace is the current directory
WORKSPACE_DIR="$(pwd)"

# Install basic build tools
echo "=> Installing basic tools..."
sudo apt update
sudo apt install -y git python3-rosdep python3-colcon-common-extensions python3-vcstool

# Initialize rosdep
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    echo "=> Initializing rosdep..."
    sudo rosdep init
fi
echo "=> Updating rosdep..."
rosdep update

# Ignore realsense plugin to avoid extra heavy dependencies if not needed
touch src/xarm_ros2/thirdparty/realsense_gazebo_plugin/COLCON_IGNORE || true

# Install ROS 2 dependencies
echo "=> Installing ROS 2 dependencies (this may ask for your password)..."
rosdep install --from-paths src --ignore-src --rosdistro humble -y

# Build the workspace
echo "=> Building the workspace..."
source /opt/ros/humble/setup.bash
# We use CMake Policy 3.5 to bypass a known bug with jsoncpp on Ubuntu 22.04
colcon build --cmake-args -DCMAKE_POLICY_VERSION_MINIMUM=3.5

echo "================================================="
echo " Setup complete! "
echo " Run ./launch_simulation.sh to start the robot."
echo "================================================="
