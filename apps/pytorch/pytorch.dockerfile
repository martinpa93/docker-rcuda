# Pytorch
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/pytorch/build

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    zip \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    git

WORKDIR $topdir
    
# Anaconda
RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh && \
    bash Anaconda3-5.0.1-Linux-x86_64.sh -b && \
    rm Anaconda3-5.0.1-Linux-x86_64.sh
ENV PATH /root/anaconda3/bin:$PATH
# RUN conda update -y conda && \
    # conda update -y anaconda && \
  # RUN conda update -y --all

# Pytorch
RUN mkdir conda && \
    conda create -y -p conda python=3.6 numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing 
RUN /bin/bash -c 'source activate conda' && \
    conda install -y -c pytorch magma-cuda100 && \
    conda install -y typing_extensions dataclasses && \
    git clone https://github.com/pytorch/pytorch.git && \
    cd pytorch/ && \
    git checkout -b v1.2.0 && \
    git submodule update --init --recursive && \
    MAX_JOBS=$jobs; USE_OPENMP=ON; BUILD_SHARED_LIBS=ON; USE_TENSORRT=OFF; \
    USE_CUDA=1; USE_CUDNN=1; TORCH_CUDA_ARCH_LIST="3.0+PTX 3.5+PTX 3.7+PTX 6.0+PTX 7.0+PTX"; \
    TF_CUDNN_VERSION=7.4.2; TF_CUDA_VERSION=10.0; \
    TORCH_NVCC_FLAGS="--cudart=shared -Xfatbin -compress-all"; \
    USE_NCCL=ON \
    CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}; 
RUN cd pytorch && \
    python setup.py install

# Torchvision