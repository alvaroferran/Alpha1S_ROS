FROM ubuntu:20.04

ARG ROS_DISTRO

# Install packages
RUN apt-get update \
    && apt-get upgrade -yqq \
    && apt-get install -yqq \
    sudo \
    git \
    screen \
    locales \
    curl \
    gnupg2 \
    lsb-release \
    && apt-get -yqq clean

# Setup locales
RUN locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && export LANG=en_US.UTF-8

# Add ROS2 repository
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && sh -c 'echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
    http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) \
    main" > /etc/apt/sources.list.d/ros2.list'

# Install ROS2 desktop
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
    ros-${ROS_DISTRO}-desktop \
    libpython3-dev \
    python3-pip \
    python3-rosdep \
    python3-argcomplete \
    python3-colcon-common-extensions \
    && apt-get -yqq clean \
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc \
    && mkdir -p /root/dev_ws/src

# Install Alpha1S library
RUN apt-get install -yqq \
    bluez-hcidump \
    libbluetooth-dev \
    && pip3 install git+https://github.com/alvaroferran/Alpha1S.git
