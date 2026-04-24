# UFACTORY xArm 7 Simulation with MoveIt 2 and Gazebo

This repository provides a complete, 1-click setup to simulate the UFACTORY xArm 7 robotic arm in ROS 2 Humble using Gazebo Classic and MoveIt 2. 

## 🚀 Getting Started

### Prerequisites
- Ubuntu 22.04
- ROS 2 Humble installed
- Gazebo Classic installed

### 1. Setup the Workspace
We have provided an automated setup script that creates a Colcon workspace, downloads the official `xarm_ros2` repository (along with its submodules), installs missing dependencies via `rosdep`, and compiles everything with the correct CMake flags.

Open a terminal and run:
```bash
chmod +x setup.sh
./setup.sh
```
*(Note: You will be prompted for your `sudo` password to install ROS 2 dependencies).*

### 2. Launch the Simulation
Once the build is complete, you can launch Gazebo and RViz simultaneously using the launch script. This script automatically handles a known bug where Gazebo gets stuck downloading models.

```bash
chmod +x launch_simulation.sh
./launch_simulation.sh
```

## 🎮 Controlling the Robot
1. Once **RViz** opens, look at the left-hand panel under **Displays**.
2. Click on the `MotionPlanning` display to highlight it.
3. Go to the top menu bar, click **Panels**, and ensure the checkbox next to **MotionPlanning** is ticked. A dock window will appear.
4. In the 3D view, drag the cyan interactive marker at the tip of the robot arm to set a goal pose.
5. In the MotionPlanning dock window, click **Plan** to see the calculated path.
6. Click **Execute** to move the physical arm in the Gazebo window!

## 🐛 Troubleshooting
- **Gazebo is empty (no robot):** Ensure you run `./launch_simulation.sh` instead of launching it manually, as the script clears the `GAZEBO_MODEL_DATABASE_URI` variable to prevent Gazebo from hanging on startup.
- **Compilation errors (libssl or libcurl):** If you use Anaconda/Miniforge, it may interfere with CMake. The `setup.sh` script ignores conda paths, but if you build manually, make sure conda is fully deactivated.
