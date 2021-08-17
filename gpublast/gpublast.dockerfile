FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen
    
WORKDIR /install/gpublast
# For security questions, do wget dont ADD
RUN wget --no-check-certificate https://sahinidis.coe.gatech.edu/public/content/gpublast/gpu-blast-1.1_ncbi-blast-2.2.28.tar.gz && \
    tar xzf gpu-blast-1.1_ncbi-blast-2.2.28.tar.gz && \
    chmod +x install && no | ./install

    # Broken links 