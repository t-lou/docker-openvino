FROM ubuntu:20.04

ARG FN
COPY ${FN} /opt/target.tgz

RUN apt update && \
    apt install -y cpio sudo lsb-release libpng++-dev && \
    DEBIAN_FRONTEND="noninteractive" apt -y install tzdata keyboard-configuration && \
    echo ====================================================================== && \
    echo prepare the file for installation && \
    echo ====================================================================== && \
    cd /opt && \
    tar xf target.tgz && \
    rm target.tgz && \
    cd l_openvino_toolkit* && \
    echo ====================================================================== && \
    echo change lsb-release data to install like ubuntu18.04 && \
    echo ====================================================================== && \
    mv /etc/lsb-release /etc/lsb-release.back && \
    echo "DISTRIB_ID=Ubuntu" > /etc/lsb-release && \
    echo "DISTRIB_RELEASE=18.04" >> /etc/lsb-release && \
    echo "DISTRIB_CODENAME=bionic" >> /etc/lsb-release && \
    echo "DISTRIB_DESCRIPTION=\"Ubuntu 18.04.4 LTS\"" >> /etc/lsb-release && \
    echo ====================================================================== && \
    echo install && \
    echo ====================================================================== && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    cd /opt && \
    echo ====================================================================== && \
    echo clean && \
    echo ====================================================================== && \
    rm -r l_openvino_toolkit* && \
    mv /etc/lsb-release.back /etc/lsb-release && \
    echo ====================================================================== && \
    echo install dependencies && \
    echo ====================================================================== && \
    cp /opt/intel/openvino/install_dependencies/install_openvino_dependencies.sh copy.sh && \
    sed -i "s/gudev-1.0/libgudev-1.0-dev/g" copy.sh && \
    sed -i "s/libusb-1.0.0-dev/libusb-1.0-0-dev/g" copy.sh && \
    sed -i "s/libfluidsynth1/libfluidsynth-dev/g" copy.sh && \
    sed -i "s/libnettle6/libnettle7/g" copy.sh && \
    sed -i "s/libopenexr22/libopenexr24/g" copy.sh && \
    sed -i "s/libpython3.6/libpython3.8/g" copy.sh && \
    sed -i "s/python3.6/python3.8/g" copy.sh && \
    ./copy.sh && \
    rm copy.sh && \
    echo ====================================================================== && \
    echo prepare a user usr with password usr && \
    echo ====================================================================== && \
    useradd -m usr && \
    echo "usr:usr" | chpasswd && \
    usermod -aG sudo usr && \
    echo ====================================================================== && \
    echo install MO prerequisites && \
    echo ====================================================================== && \
    cd /opt/intel/openvino/deployment_tools/model_optimizer/install_prerequisites && \
    cp install_prerequisites.sh install_prerequisites.sh.back && \
    sed -i "s/libgfortran3/libgfortran5/g" install_prerequisites.sh && \
    ./install_prerequisites.sh && \
    mv install_prerequisites.sh.back install_prerequisites.sh && \
    apt clean && apt autoclean && rm -rf /var/cache/apt/archives/*

# install intel GPU dependencies
RUN cd /opt/intel/openvino/install_dependencies && \
    cp install_NEO_OCL_driver.sh copy.sh && \
    sed -i "s/ _check_distro_version/ #_check_distro_version/" copy.sh && \
    sed -i "s/ add_user_to_video_group/ #add_user_to_video_group/" copy.sh && \
    ./copy.sh && \
    rm copy.sh && \
    usermod -aG video usr && \
    apt clean && apt autoclean && rm -rf /var/cache/apt/archives/*

# install some more dependencies
RUN apt install -y build-essential python3-pip virtualenv cmake libcairo2-dev libpango1.0-dev \
    libglib2.0-dev libgtk2.0-dev libswscale-dev libavcodec-dev libavformat-dev libgstreamer1.0-0 gstreamer1.0-plugins-base && \
    apt clean && apt autoclean && rm -rf /var/cache/apt/archives/*
