# HPL 
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/hpl/build
ENV topdir $topdir

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    cpio \
    openmpi-bin libopenmpi-dev

WORKDIR /install/hpl

# mkl
RUN cd /tmp && \
    wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15275/l_mkl_2019.3.199.tgz && \
    tar -xzf l_mkl_2019.3.199.tgz && \
    cd l_mkl_2019.3.199 && \
    sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' silent.cfg && \
    sed -i 's/ARCH_SELECTED=ALL/ARCH_SELECTED=INTEL64/g' silent.cfg && \
    sed -i 's/COMPONENTS=DEFAULTS/COMPONENTS=;intel-comp-l-all-vars__noarch;intel-comp-nomcu-vars__noarch;intel-openmp__x86_64;intel-tbb-libs__x86_64;intel-mkl-common__noarch;intel-mkl-installer-license__noarch;intel-mkl-core__x86_64;intel-mkl-core-rt__x86_64;intel-mkl-doc__noarch;intel-mkl-doc-ps__noarch;intel-mkl-gnu__x86_64;intel-mkl-gnu-rt__x86_64;intel-mkl-common-ps__noarch;intel-mkl-core-ps__x86_64;intel-mkl-common-c__noarch;intel-mkl-core-c__x86_64;intel-mkl-common-c-ps__noarch;intel-mkl-tbb__x86_64;intel-mkl-tbb-rt__x86_64;intel-mkl-gnu-c__x86_64;intel-mkl-common-f__noarch;intel-mkl-core-f__x86_64;intel-mkl-gnu-f-rt__x86_64;intel-mkl-gnu-f__x86_64;intel-mkl-f95-common__noarch;intel-mkl-f__x86_64;intel-mkl-psxe__noarch;intel-psxe-common__noarch;intel-psxe-common-doc__noarch;intel-compxe-pset/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    cd .. && \
    rm -rf * && \
    rm -rf /opt/intel/.*.log /opt/intel/compilers_and_libraries_2019.3.199/licensing && \
    echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/intel.conf && \
    ldconfig && \
    echo "source /opt/intel/mkl/bin/mklvars.sh intel64" >> /etc/bash.bashrc

# hpl
COPY apps/hpl/hpl-2.0_FERMI_v15.tgz .
RUN tar xzf hpl-2.0_FERMI_v15.tgz && \
    cd hpl-2.0_FERMI_v15/ && \
    sed -i -e "104c TOPdir = /install/hpl/hpl-2.0_FERMI_v15"  \
        -e "/#MPdir/c\MPdir = /usr/lib/x86_64-linux-gnu/openmpi" \
        -e "/#MPinc/c\MPinc = -I\$(MPdir)/include" \
        -e "/#MPlib/c\MPlib = -L\$(MPdir)/lib -lmpi -libverbs" \
        -e "/LAdir        =/c\LAdir = /opt/intel/lib/intel64 -L/opt/intel/lib/intel64 -L/opt/intel/mkl/lib/intel64" \
        Make.CUDA && \
    make arch=CUDA && \
    mkdir -p $topdir/bin && \
    mkdir -p $topdir/lib && \
    cp -a bin/CUDA/ $topdir/bin && \
    cp src/cuda/libdgemm* $topdir/lib

# Clean space
RUN rm -rf hpl-2.0_FERMI_v15/ hpl-2.0_FERMI_v15.tgz