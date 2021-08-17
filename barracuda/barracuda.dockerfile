# Ideally compress our system with (tar --numeric-owner --exclude=/proc --exclude=/sys -cvf $name /), import to image and publish in dockerhub
# CUDNN not use, make -jX can fail, adding gencode to NVCCFLAGS dont work
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    libcunit1-dev \
    libhdf5-dev \
    libopenblas-dev \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen

WORKDIR /install/barracuda
# For security questions, do wget dont ADD
RUN wget https://downloads.sourceforge.net/project/seqbarracuda/Source%20Code/Version%200.7.0/barracuda_0.7.107h.tar.gz && \
    tar xzfv barracuda_0.7.107h.tar.gz
WORKDIR barracuda
RUN sed -i -e 's/#LIB += -lcudart/LIB += -lcudart/' -e 's/LIB +=  -lcudart_static/#LIB +=  -lcudart_static/' \
           -e '/^NVCCFLAGS :=/c\NVCCFLAGS := "--cudart=shared"' \
           -e 's/sm_20/sm_30/g' \
            Makefile && \
    make && mkdir /data && cp -a bin/barracuda /data

# For test with system interaction
# docker volume create --name rCUDA
# docker run -it --name barracuda --gpus all --network host -v rCUDA:/data barracuda
# NVCC_FLAGS="--cudart=shared -gencode arch=compute_30,code=[sm_30,compute_30] -gencode arch=compute_35,code=[sm_35,compute_35] -gencode arch=compute_37,code=[sm_37,compute_37] -gencode arch=compute_60,code=[sm_60,compute_60] --ptxas-optionº