FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    # libxml2
    zlibc zlib1g zlib1g-dev
    
# MPI
# gfortran fort77 build-essential curl libibverbs-dev libibverbs1 libibcm1 librdmacm1 librdmacm-dev rdmacm-utils libibmad-dev libibmad5 byacc libibumad-dev libibumad3 infiniband-diags libmlx5-1 libmlx5-dev perftest ibverbs-utils opensm flex alien && apt-get clean
# curl http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.2.tar.gz |tar xzf - && cd mvapich2-2.2 && ./configure --without-cma --enable-threads=multiple MV2_USE_CUDA=1 RSH_CMD=/usr/bin/ssh SSH_CMD=/usr/bin/ssh && make -j2 && make install && cd .. && rm -rf mvapich2-2.2
# curl -O http://mvapich.cse.ohio-state.edu/download/mvapich/gdr/2.2/mofed-3.2/mvapich2-gdr-cuda8.0-gnu-2.2-2.el7.centos.x86_64.rpm && alien -c *.rpm && dpkg --install *.deb && rm -f *.rpm *.deb
WORKDIR /install/cudameme
# For security questions, do wget dont ADD
RUN wget https://sourceforge.net/projects/cuda-meme/files/cuda-meme-3.0.16.tar.gz && \
    tar xzf cuda-meme-3.0.16.tar.gz
WORKDIR cuda-meme-3.0.16

RUN sed -i -e '/^DEVICE_FLAGS/c\DEVICE_FLAGS = -arch=sm_30 -gencode arch=compute_30,code=[sm_30,compute_30] -gencode arch=compute_35,code=[sm_35,compute_35] -gencode arch=compute_37,code=[sm_37,compute_37] -gencode arch=compute_60,code=[sm_60,compute_60] --ptxas-options=-v -Xcompiler -fopenmp --cudart=shared' src/Makefile.gpu \
    # make -f src/Makefile.gpu -j$(nproc) \
    # mkdir /data && \
    # cp -a cudameme /data

# MPI



# For test with system interaction
# docker volume create --name rCUDA
# docker run -it --name cudameme -v rCUDA:/data cudameme