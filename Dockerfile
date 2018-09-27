@channel - I have completed up to and including kinematic and camera calibrations today - once my PR merges and the docs are built I consider everything functional so please report to me any errors you find.FROM ros:kinetic-ros-base-xenial

MAINTAINER Breandan Considine breandan.considine@umontreal.com

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

# python libraries
RUN pip install --upgrade \
	PyContracts==1.8.2 \
	compmake==3.5.23 \
	comptests==1.4.22 \
	DecentLogs==1.1.2 \
	QuickApp==1.3.12 \
	conftools==1.9.1 \
	procgraph==1.10.10 \
	beautifulsoup4==4.6.0 \
	PyGeometry==1.3 \
	numpy \
	#matplotlib \
	jpeg4py \
	networkx
	
ENV READTHEDOCS True

WORKDIR /home
RUN git clone https://github.com/duckietown/software
RUN cp /home/software/docker/machines.xml /home/software/catkin_ws/src/00-infrastructure/duckietown/machines
RUN /bin/bash -c "cd /home/software/ && source /opt/ros/kinetic/setup.bash && catkin_make -C catkin_ws/"
RUN echo "source /home/software/docker/env.sh" >> ~/.bashrc

WORKDIR /home/software

CMD ["bash"]
