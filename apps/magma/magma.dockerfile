FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/magma/build
ENV topdir $topdir

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    zip \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    libopenblas-dev \
    gfortran \
    libssl-dev \
    chrpath

WORKDIR /install/magma

# Install Cmake
RUN version=3.21 && \
    build=1 && \
    mkdir cmake && \
    cd cmake && \
    wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz && \
    tar -xzvf cmake-$version.$build.tar.gz && \
    cd cmake-$version.$build/ && \
    ./bootstrap && \
    make -j$jobs && \
    make install && \
    rm -rf ../../cmake

RUN wget http://icl.utk.edu/projectsfiles/magma/downloads/magma-2.5.4.tar.gz && \
    tar zxf magma-2.5.4.tar.gz && \
    cd magma-2.5.4 && \
    mkdir build && \
    cd build && \
    cmake -DCUDA_NVCC_FLAGS:STRING="--cudart=shared" -DGPU_TARGET="sm_30 sm_35 sm_37 sm_60" \
          -DCMAKE_CUDA_RUNTIME_LIBRARY:STRING="Shared" -DCUDA_USE_STATIC_CUDA_RUNTIME:BOOL=OFF \
          .. && \
    make -j$jobs && \
    chrpath -r '' lib/libm*.so && \
    chrpath -r '' lib/libt*.so && \
    chrpath -r '' testing/* && \
    mkdir -p $topdir && \
    cp -a lib $topdir && \
    cp -a testing $topdir

# Clean space
RUN rm -rf magma-2.5.4/ magma-2.5.4.tar.gz
