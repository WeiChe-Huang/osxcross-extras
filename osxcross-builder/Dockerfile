# [base image] not the final image
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get full-upgrade -y
RUN apt-get install -y build-essential clang wget python2.7 python3 \
 python3-pip python3-distutils cmake git p7zip-full libarchive-tools curl \
 cpio xz-utils patch pixz llvm sudo libxml2-dev libssl-dev \
 zlib1g-dev liblzma-dev libbz2-dev \
 gcc g++ libmpc-dev libmpfr-dev libgmp-dev llvm-dev uuid-dev

COPY * /tmp/
ARG XCODE_USERNAME
ARG XCODE_PASSWORD
ENV XCODE_PASSWORD=$XCODE_PASSWORD
ENV XCODE_USERNAME=$XCODE_USERNAME
RUN /tmp/ci.sh

# [second stage]
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get full-upgrade -y
RUN apt-get install -y build-essential clang cmake wget git p7zip-full ccache ninja-build
COPY --from=0 /opt/osxcross /opt/osxcross
ENV PATH="${PATH}:/opt/osxcross/bin/"
RUN osxcross-macports install libusb

# [manual stage]
# please install libusb and change camke default compiler by following steps:
#   1. create container from second stage docker image
#       host terminal - 1:
#           $ docker run -it --name {container_name} {builded_second_stage_image_id} /bin/bash
#   2. manually initial macports repo by run osxcross-macports upgrade with interactive command
#       docker container bash:
#           $ osxcross-macports upgrade
#           $ osxcross-macports install libusb
#   3. manually change cmake default compiler
#       docker container bash:
#           $ apt install vim
#           $ vim /opt/osxcross/toolchain.cmake
#       specify your gcc cross compiler at line 23, 24 of /opt/osxcross/toolchain.cmake by
#           [line 23] # specify the cross compiler
#           [line 24] set(CMAKE_C_COMPILER "${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-gcc")
#           [line 25] set(CMAKE_CXX_COMPILER "${OSXCROSS_TARGET_DIR}/bin/${OSXCROSS_HOST}-g++")
#   4. commit docker image by second host terminal
#       host terminal - 2:
#           $ docker commit {container_name} {new_image_name}