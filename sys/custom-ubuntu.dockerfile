FROM ubuntu:18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
RUN apt update && apt upgrade -y && \
    apt install -y git python3-pip gcc cmake \
      curl net-tools \
      openssh-server nmap \
      freeglut3 freeglut3-dev libxi-dev libxmu-dev gcc-6 g++-6
RUN apt update && \
    # add-apt-repository ppa:graphics-drivers/ppa && \
    apt install -y nvidia-driver-415 && \
    wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux && \
    sh cuda_10.0.130_410.48_linux && \
    # add PATH and LD_CONFIG variables
    echo 'export PATH=$PATH:/usr/local/cuda/bin' >> ~/.bashrc && \
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64' >> ~/.bashrc && \
    source ~/.bashrc 

    # Install CUDNN
    # (use my private cache)
RUN wget https://storage.googleapis.com/public-fony/cudnn-10.0-linux-x64-v7.4.2.24.tgz && \
    tar xvf cudnn-10.0-linux-x64-v7.4.2.24.tgz && \
    cp -P cuda/include/cudnn.h /usr/local/cuda/include && \
    cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64 && \
    chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn* 