FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
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
    make -j$(nproc) && mkdir -p /data/lib64 && mkdir -p /data/bin && \
    cp -a darknet /data/bin && \
    cp -a libdarknet.so /data/lib64 && \
    cp -a libdarknet.a /data/lib64 && \
    cp -a cfg/ /data