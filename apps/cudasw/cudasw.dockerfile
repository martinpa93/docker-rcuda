# Cudasw++
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/cudasw/build

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen

WORKDIR /install/cudasw

RUN wget https://sourceforge.net/projects/cudasw/files/cudasw%2B%2B%203.0/cudasw%2B%2Bv3.1.2.tar.gz && \
    tar xzfv cudasw++v3.1.2.tar.gz && \
    cd cudasw++v3.1.2 && \
    sed -i -e '/^ARCH/c\ARCH = sm_30 -gencode arch=compute_30,code=[sm_30,compute_30] -gencode arch=compute_35,code=[sm_35,compute_35] -gencode arch=compute_37,code=[sm_37,compute_37] -gencode arch=compute_60,code=[sm_60,compute_60]' \
        -e '/^NVCCLIBS/c\NVCCLIBS = -lm -lpthread' \
        -e '/^NVCCFLAGS/c\NVCCFLAGS = -O3 $(NVCCOPTIONS) --cudart=shared -I.' \
        Makefile && \
    make -j$jobs && mkdir -p $topdir/bin && cp -a cudasw $topdir/bin


