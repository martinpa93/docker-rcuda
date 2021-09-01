# Darknet
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/darknet/build
ENV topdir $topdir

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    git
    
WORKDIR /install/darknet

RUN git clone https://github.com/pjreddie/darknet.git && \
    cd darknet && \
    sed -i -e 's/GPU=0/GPU=1/' \
           -e 's/CUDNN=0/CUDNN=1/' \  
           -e 's/OPENMP=0/OPENMP=1/' \  
           -e '/gencode/ d' \  
           -e '6 a ARCH= -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_37,code=sm_37 -gencode arch=compute_60,code=sm_60' \
           Makefile && \
    make -j$jobs && \
    mkdir -p $topdir/lib && \
    mkdir -p $topdir/bin && \
    cp darknet $topdir/bin && \
    cp libdarknet.so $topdir/lib && \
    cp libdarknet.a $topdir/lib && \
    cp -r cfg/ $topdir

# Clean space
RUN rm -rf darknet/
