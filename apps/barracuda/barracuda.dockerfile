# Barracuda
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/barracuda/build
ENV topdir $topdir

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    libcunit1-dev \
    libhdf5-dev \
    libopenblas-dev 

WORKDIR /install/barracuda

RUN wget https://downloads.sourceforge.net/project/seqbarracuda/Source%20Code/Version%200.7.0/barracuda_0.7.107h.tar.gz && \
    tar xzf barracuda_0.7.107h.tar.gz && \
    cd barracuda && \
    sed -i -e 's/#LIB += -lcudart/LIB += -lcudart/' -e 's/LIB +=  -lcudart_static/#LIB +=  -lcudart_static/' \
           -e '/^NVCCFLAGS :=/c\NVCCFLAGS := "--cudart=shared"' \
           -e 's/sm_20/sm_30/g' \
            Makefile && \
    make -j$jobs && \
    mkdir -p $topdir/bin && \
    cp -a bin/barracuda $topdir/bin

# Clean space
RUN rm -rf barracuda/ barracuda_0.7.107h.tar.gz

