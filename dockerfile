FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo

RUN apt -y update \
    && apt -y install git cmake g++ wget unzip \
    && apt -y install python3-dev python3-numpy \
    libzstd-dev libjpeg-turbo8-dev libjpeg8-dev \
    libopenjp2-7-dev libopenjp2-tools \
    libpng-dev libtiff-dev \
    libopenblas-dev liblapack-dev liblapacke-dev

# ${ARCH} == x86_64 (Intel) or aarch64 (Arm)
# ENV ARCH="x86_64"
ENV ARCH="aarch64"
RUN ln -s /usr/include/lapack* /usr/include/${ARCH}-linux-gnu

WORKDIR /tmp
RUN wget https://github.com/opencv/opencv/archive/refs/tags/4.9.0.zip \
    && unzip 4.9.0.zip \
    && mkdir -p build \
    && cd build \
    && cmake ../opencv-4.9.0 \
    -D OpenBLAS_INCLUDE_DIR=/usr/include/${ARCH}-linux-gnu \
    -D OpenBLAS_LIB=/lib/${ARCH}-linux-gnu/ \
    -D LAPACK_LIBRARIES=/lib/${ARCH}-linux-gnu/liblapack.so \
    && cmake --build . -- -j4

WORKDIR /mnt
