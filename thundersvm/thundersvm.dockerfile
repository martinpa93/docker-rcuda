FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    cmake \
WORKDIR /install/lammps
RUN wget https://github.com/lammps/lammps/archive/refs/tags/stable_3Mar2020.tar.gz && \
  
