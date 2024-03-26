ARG BASE_IMAGE=ubuntu:22.04
FROM $BASE_IMAGE

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt update && \
    apt install -y git && \
    apt clean && \
    rm -rf /var/lib/apt/lists/

RUN mkdir -p /ros_noetic_base/catkin_ws/src
RUN cd /ros_noetic_base/catkin_ws/src && \
git clone https://github.com/ros/actionlib.git -b 1.14.0 && \
git clone https://github.com/ros/bond_core.git -b 1.8.6 && \
git clone https://github.com/ros/catkin.git -b 0.8.10 && \
git clone https://github.com/ros/class_loader.git -b 0.5.0 && \
git clone https://github.com/ros/cmake_modules.git -b 0.5.0 && \
git clone https://github.com/ros/common_msgs.git -b 1.13.1 && \
git clone https://github.com/ros/dynamic_reconfigure.git -b 1.7.3 && \
git clone https://github.com/ros/gencpp.git -b 0.7.0 && \
git clone https://github.com/jsk-ros-pkg/geneus.git -b 3.0.0 && \
git clone https://github.com/ros/genlisp.git -b 0.4.18 && \
git clone https://github.com/ros/genmsg.git -b 0.6.0 && \
git clone https://github.com/RethinkRobotics-opensource/gennodejs.git -b 2.0.1 && \
git clone https://github.com/ros/genpy.git -b 0.6.16 && \
git clone https://github.com/ros/message_generation.git -b 0.4.1 && \
git clone https://github.com/ros/message_runtime.git -b 0.4.13 && \
git clone https://github.com/ros/nodelet_core.git -b 1.10.2 && \
git clone https://github.com/ros/pluginlib.git -b 1.13.0 && \
git clone https://github.com/ros/ros.git -b 1.15.8 && \
git clone https://github.com/ros/ros_comm.git -b 1.16.0 && \
git clone https://github.com/ros/ros_comm_msgs.git -b 1.11.3 && \
git clone https://github.com/ros/ros_environment.git -b 1.3.2 && \
git clone https://github.com/ros/rosbag_migration_rule.git -b 1.0.1 && \
git clone https://github.com/ros/rosconsole.git -b 1.14.3 && \
git clone https://github.com/ros/rosconsole_bridge.git -b 0.5.4 && \
git clone https://github.com/ros/roscpp_core.git -b 0.7.2 && \
git clone https://github.com/ros/roslisp.git -b 1.9.25 && \
git clone https://github.com/ros/rospack.git -b 2.6.2 && \
git clone https://github.com/ros/std_msgs.git -b 0.5.13

RUN cd /ros_noetic_base && \
git clone https://github.com/ros-infrastructure/catkin_pkg.git -b 0.5.2 && \
git clone https://github.com/ros-infrastructure/rospkg.git -b 1.5.0

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    cmake \
    build-essential \
    python3 \
    pip \
    libboost-thread-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-regex-dev \
    libboost-program-options-dev \
    libconsole-bridge-dev \
    libpoco-dev \
    libtinyxml2-dev \
    liblz4-dev \
    libbz2-dev \
    uuid-dev \
    liblog4cxx-dev \
    libgpgme-dev \
    libgtest-dev \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-empy \
    python3-nose \
    python3-pycryptodome \
    python3-defusedxml \
    python3-mock \
    python3-netifaces \
    python3-gnupg \
    python3-numpy \
    python3-psutil \
    wget && \
    apt clean && \
    rm -rf /var/lib/apt/lists/

# 改行コード入れないとpatchが当たらないので注意
RUN wget https://gist.githubusercontent.com/Crcodlus/111f25ac48fed5004a86aae7a9d758c7/raw/e21c3fb9ddd04e67f1873855eeef2bcb50ac883a/ros_comm.patch && \
    wget https://gist.githubusercontent.com/Crcodlus/111f25ac48fed5004a86aae7a9d758c7/raw/e21c3fb9ddd04e67f1873855eeef2bcb50ac883a/rosconsole.patch && \
    echo "" >> /ros_comm.patch && \
    cd  /ros_noetic_base/catkin_ws/src/ros_comm && git apply --ignore-whitespace /ros_comm.patch && \
    cd  /ros_noetic_base/catkin_ws/src/rosconsole && git apply --ignore-whitespace /rosconsole.patch && \
    cd /ros_noetic_base/catkin_ws/src/pluginlib/pluginlib && sed -i.bk 's/11/17/g' CMakeLists.txt

RUN cd /ros_noetic_base/catkin_pkg && python3 setup.py install && \
cd /ros_noetic_base/rospkg && python3 setup.py install && \
cd /ros_noetic_base/catkin_ws  && \
./src/catkin/bin/catkin_make install \
      -DCMAKE_BUILD_TYPE=Release \
      -DPYTHON_EXECUTABLE=/usr/bin/python3


RUN cd /ros_noetic_base/catkin_ws  && \
./src/catkin/bin/catkin_make install \
      -DCMAKE_BUILD_TYPE=Release \
      -DPYTHON_EXECUTABLE=/usr/bin/python3 \
      run_tests
      