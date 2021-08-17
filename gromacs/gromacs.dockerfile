FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    cmake    
WORKDIR /install/gromacs
RUN wget http://ftp.gromacs.org/pub/gromacs/gromacs-2019.tar.gz && \
    tar zxfv gromacs-2019.tar.gz && \
    cd gromacs-2019 && \
    mkdir build && cd build && \
    cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_GPU=CUDA \
         -DCMAKE_INSTALL_PREFIX=/install/gromacs \
         -DCUDA_NVCC_FLAGS:STRING="-gencode;arch=compute_30,code=sm_30;-gencode;arch=compute_35,code=sm_35;-gencode;arch=compute_37,code=sm_37;-gencode;arch=compute_60,code=sm_60;-gencode;arch=compute_70,code=sm_70;-cudart=shared" \
         -DCUDA_USE_STATIC_CUDA_RUNTIME:BOOL=OFF && \
    make -j$(nproc) && make check && \
    chrpath -r '' bin/* && chrpath -r '' lib/* && \
    make install && source /usr/local/gromacs/bin/GMXRC
