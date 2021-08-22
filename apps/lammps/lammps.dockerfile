# Lammps
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/lammps/build

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    cmake cmake-curses-gui \
    mpich libmpich-dev   

WORKDIR /install/lammps

RUN wget https://github.com/lammps/lammps/archive/refs/tags/stable_3Mar2020.tar.gz && \
    tar zxfv stable_3Mar2020.tar.gz && \
    cd lammps-stable_3Mar2020/ && \
    cd lib/gpu && \
    sed -i -e '/CUDA_CODE =/, +3d' \
           -e '/CUDA_ARCH = -arch=sm_30/a CUDA_CODE = -gencode arch=compute_30,code=[sm_30,compute_30] -gencode arch=compute_35,code=[sm_35,compute_35] -gencode arch=compute_37,code=[sm_37,compute_37] -gencode arch=compute_60,code=[sm_60,compute_60]' \
        Makefile.linux_multi && \
    make -f Makefile.linux_multi -j$jobs && \
    cd ../../src && \
    make yes-gpu && \
    mkdir -p $topdir/bin && \
    # serial
    make serial -j$jobs && \
    cp -a lmp_serial $topdir/bin && \
    # mpi
    make mpi -j$jobs && \
    cp -a lmp_mpi $topdir/bin
  
