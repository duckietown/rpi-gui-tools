FROM duckietown/rpi-duckiebot-base-qemu3

RUN ["cross-build-start"]

RUN apt-get update && \
    apt-get install -q -y \
    ros-kinetic-rqt \
    libqt5gui5 \
    ros-kinetic-rqt-common-plugins && \
    rm -rf /var/lib/apt/lists/*

RUN systemctl enable avahi-daemon

RUN ["cross-build-end"]
