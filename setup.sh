#!/bin/bash
set -e

echo "================================================="
echo " Setting up UFACTORY xArm 7 ROS 2 Workspace"
echo "================================================="

WORKSPACE_DIR="$HOME/xarm_ros2_ws"

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

# Create workspace and pull source
echo "=> Creating workspace at $WORKSPACE_DIR..."
mkdir -p "$WORKSPACE_DIR/src"
cd "$WORKSPACE_DIR/src"

if [ ! -d "xarm_ros2" ]; then
    echo "=> Cloning xarm_ros2 repository (humble branch)..."
    git clone https://github.com/xArm-Developer/xarm_ros2.git --branch humble
fi

echo "=> Updating submodules..."
cd xarm_ros2
git pull
git submodule sync
git submodule update --init --remote

# Ignore realsense plugin to avoid extra heavy dependencies if not needed
touch thirdparty/realsense_gazebo_plugin/COLCON_IGNORE

# Install ROS 2 dependencies
echo "=> Installing ROS 2 dependencies (this may ask for your password)..."
cd "$WORKSPACE_DIR"
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
