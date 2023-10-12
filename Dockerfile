# Dockerfile for Turtlebot3 Gazebo Simulation

FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN export LANG=en_US.UTF-8

RUN apt update; apt install -y software-properties-common curl gnupg2 lsb-release
RUN add-apt-repository universe

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - 

RUN apt update && apt upgrade -y
RUN apt-get autoremove

RUN apt install -y \
        python-pip \
	tmux \
        python-tk \
	python3-rospkg \
	python3-catkin-pkg \
        python3-rosdep \
        python3-rosinstall \
        python3-rosinstall-generator \
        python3-wstool \
        build-essential \
	vim

RUN apt install -y -f \
	ros-melodic-desktop-full 

RUN apt update && \
    apt install -y \
	ros-melodic-joy \
        ros-melodic-tf2-sensor-msgs \
        ros-melodic-rosbash \
        ros-melodic-rviz \
        ros-melodic-teleop-twist-joy \
        ros-melodic-teleop-twist-keyboard \
        ros-melodic-laser-proc \
        ros-melodic-rgbd-launch \
        ros-melodic-depthimage-to-laserscan \
        ros-melodic-rosserial-arduino \
        ros-melodic-rosserial-python \
        ros-melodic-rosserial-server \
        ros-melodic-rosserial-client \
        ros-melodic-rosserial-msgs \
        ros-melodic-amcl \
        ros-melodic-people-msgs \
        ros-melodic-map-server \
        ros-melodic-move-base \
        ros-melodic-urdf \
        ros-melodic-robot-state-publisher \
        ros-melodic-xacro \
        ros-melodic-compressed-image-transport \
        ros-melodic-rqt-image-view \
        ros-melodic-gmapping \
        ros-melodic-openslam-gmapping \
        ros-melodic-navigation \
	ros-melodic-twist-mux \
	ros-melodic-twist-mux-msgs \
        ros-melodic-interactive-markers \
	python3-catkin-tools

RUN apt update && \
    apt install -y \
	python3-pyqt5 \
	python3-vcstool


# Build catkin_ws
RUN mkdir -p /catkin_ws/src && \
    rosdep init && \
    rosdep update
WORKDIR /catkin_ws/src

#Broke?
#RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
#    git clone -b melodic-devel https://github.com/ROBOTIS-GIT/turtlebot3.git && \
#    git clone -b melodic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
#COPY turtlebot3 .

#RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws; catkin_make"
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; cd /catkin_ws"
#RUN /bin/bash -c "source /opt/ros/humble/setup.bash; cd /catkin_ws"

#  Source environments
#RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc && \
#    echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc && \
#    echo "export TURTLEBOT3_MODEL=waffle" >> /root/.bashrc
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc && \
    echo "export TURTLEBOT3_MODEL=waffle" >> /root/.bashrc
    

# Cleanup
RUN rm -rf /root/.cache

# Entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /catkin_ws
ENTRYPOINT [ "/entrypoint.sh" ]
