FROM ros:kinetic-ros-base-xenial

LABEL maintainer="Breandan Considine breandan.considine@umontreal.ca"

# switch on systemd init system in container
ENV INITSYSTEM off
# setup environment
ENV TERM "xterm"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO kinetic
ENV QT_X11_NO_MITSHM 1

# install packages
RUN apt-get update && apt-get install -q -y \
        dirmngr \
        gnupg2 \
        sudo \
        apt-utils \
        apt-file \
        locales \
        locales-all \
        iputils-ping \
        man \
        ssh \
        htop \
        atop \
        iftop \
        less \
        lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install additional ros packages
RUN apt-get update && apt-get install -y \
        ros-kinetic-robot \
        ros-kinetic-perception \
        ros-kinetic-navigation \
        ros-kinetic-robot-localization \
        ros-kinetic-roslint \
        ros-kinetic-hector-trajectory-server \
        ros-kinetic-rqt \
        ros-kinetic-rqt-common-plugins \
        ros-kinetic-rqt \
        ros-kinetic-rviz \
        libqt5gui5 \
        ros-kinetic-rqt-common-plugins \
    && rm -rf /var/lib/apt/lists/*

# development tools & libraries
RUN apt-get update && apt-get install --no-install-recommends -y \
        emacs \
        vim \
        byobu \
        zsh \
        libxslt-dev \
        libnss-mdns \
        libffi-dev \
        libturbojpeg \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        mesa-utils \
        libgl1-mesa-glx \
        # Python Dependencies
        ipython \
        python-pip \
        python-wheel \
        python-sklearn \
        python-smbus \
        python-termcolor \
        python-tables \
        python-lxml \
        python-bs4 \
        python-catkin-tools \
        python-frozendict \
        python-pymongo \
        python-ruamel.yaml \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home

# TODO: Remove this! `git clone` is a recipe for chaos
RUN git clone --depth 1 -b master18 https://github.com/duckietown/software

# python libraries
ENV READTHEDOCS True
RUN pip install --upgrade -r /home/software/requirements.txt

RUN cp /home/software/docker/machines.xml /home/software/catkin_ws/src/00-infrastructure/duckietown/machines
RUN /bin/bash -c "cd /home/software/ && source /opt/ros/kinetic/setup.bash && catkin_make -C catkin_ws/"
RUN echo "source /home/software/docker/env.sh" >> ~/.bashrc

WORKDIR /home/software

CMD ["bash"]
