# ThunderSVM
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/thundersvm/build

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    cmake cmake-curses-gui \
    chrpath

WORKDIR /install/thundersvm

RUN wget https://github.com/Xtra-Computing/thundersvm/archive/refs/tags/v0.3.4.tar.gz && \
    tar zxfv v0.3.4.tar.gz && \
    cd thundersvm-0.3.4/ && \
    mkdir build && \
    cd build && \
    mkdir -p $topdir && \
    # Build without install target
    cmake -DCUDA_NVCC_FLAGS:STRING="--cudart=shared" -DCMAKE_CUDA_RUNTIME_LIBRARY:STRING="Shared" -DCUDA_USE_STATIC_CUDA_RUNTIME:BOOL=OFF \
        -DCUDA_NVCC_FLAGS:STRING="-gencode arch=compute_30,code=[sm_30,compute_30] -gencode arch=compute_35,code=[sm_35,compute_35] -gencode arch=compute_37,code=[sm_37,compute_37] -gencode arch=compute_60,code=[sm_60,compute_60]" \
        .. && \
    make -j$jobs && \
    # Remove runpaths
    chrpath -r '' lib/libthundersvm.so && \
    chrpath -r '' bin/thundersvm-train && \
    chrpath -r '' bin/thundersvm-predict && \
    # Move to their directories
    cp -a ../dataset/test_dataset.txt  $topdir && \
    cp -a bin $topdir && \
    cp -a lib $topdir
