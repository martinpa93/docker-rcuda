# Cudameme 
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/cudameme/build

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    openmpi-bin libopenmpi-dev

WORKDIR /install/cudameme

RUN wget https://sourceforge.net/projects/cuda-meme/files/cuda-meme-3.0.16.tar.gz && \
    tar xzf cuda-meme-3.0.16.tar.gz && \
    cd cuda-meme-3.0.16 && \ 
    cd src && \
    sed -i -e '/^DEVICE_FLAGS/c\DEVICE_FLAGS = -arch sm_30 -gencode arch=compute_30,code=[sm_30,compute_30] -gencode arch=compute_35,code=[sm_35,compute_35] -gencode arch=compute_37,code=[sm_37,compute_37] -gencode arch=compute_60,code=[sm_60,compute_60] --ptxas-options=-v -Xcompiler -fopenmp --cudart=shared' Makefile.gpu && \
    sed -i -e 's/^inline //g' red-black-tree.c && \
    mkdir ../objs && \
    # serial
    make -f Makefile.gpu -j$jobs && \
    mkdir -p $topdir/bin && \
    cp -a cuda-meme $topdir/bin && \
    # MPI
    sed -i -e '/^DEVICE_FLAGS/c\DEVICE_FLAGS = -arch sm_30 -gencode arch=compute_30,code=[sm_30,compute_30] -gencode arch=compute_35,code=[sm_35,compute_35] -gencode arch=compute_37,code=[sm_37,compute_37] -gencode arch=compute_60,code=[sm_60,compute_60] --ptxas-options=-v -Xcompiler -fopenmp --cudart=shared' \
           -e 's|/usr/lib/openmpi|/usr/lib/x86_64-linux-gnu/openmpi|g' \
        Makefile.mgpu && \
    make -f Makefile.mgpu -j$jobs && \
    cp -a mcuda-meme $topdir/bin


