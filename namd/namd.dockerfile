FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen

WORKDIR /install/namd
COPY namd/NAMD_2.14_Source.tar.gz .
RUN tar xzf NAMD_2.14_Source.tar.gz && \
    cd NAMD_2.14_Source/ && \
    tar xf charm-6.10.2.tar && \
    cd charm-6.10.2 && \ 
    ./build charm++ multicore-linux64 --with-production && \
    cd multicore-linux64/tests/charm++/megatest && \
    make pgm -j$(nproc) && \
    ./pgm +p4 && \
    cd ../../../../.. && \
    sed -i -e 's/lcudart_static/lcudart/' \
           -e 's/-lcufft_static -lculibos/-lcufft/' \
           -e '10s/$/ --shared/' \
        arch/Linux-x86_64.cuda && \
    sed -i -e 's/-lcufft_static/-lcufft/' \
        Makefile && \
    ./config Linux-x86_64-g++ --charm-arch multicore-linux64 --without-tcl --without-fftw --with-cuda \
        --cuda-gencode arch=compute_30,code=sm_30 \
        --cuda-gencode arch=compute_35,code=sm_35 \
        --cuda-gencode arch=compute_37,code=sm_37 \
        --cuda-gencode arch=compute_60,code=sm_60 && \
    cd Linux-x86_64-g++ && \
    make && \
    mkdir /data && cp -a namd2 /data/
