# GPUblast
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ENV jobs=$jobs

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    ncbi-blast+
    
WORKDIR /install/gpublast
# Broken links 
COPY apps/gpublast/gpu-blast-1.1_ncbi-blast-2.2.28.tar.gz .
RUN tar xzf gpu-blast-1.1_ncbi-blast-2.2.28.tar.gz && \
    chmod +x install 
    # ./install dont found and cant extrat /usr/bin/blastp