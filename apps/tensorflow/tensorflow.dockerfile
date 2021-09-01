# Tensorflow
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG jobs=1
ARG topdir=/install/tensorflow/build
ENV topdir $topdir

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y \
    build-essential \
    wget \
    vim \
    nano \
    gdb \
    openssh-client \
    screen \
    git \
    python3-dev \
    python3-pip \
    python3-venv 
    # bazel
    # zip \
    # unzip \
    # openjdk-8-jdk

WORKDIR /install/tensorflow

# bazel
# RUN mkdir -p bazel/bin && cd bazel && \ 
#     wget https://github.com/bazelbuild/bazel/releases/download/0.26.1/bazel-0.26.1-dist.zip && \
#     unzip bazel-0.26.1-dist.zip && \
#     ./compile.sh && \
#     cp -a output/bazel ../bin

RUN wget https://releases.bazel.build/0.26.1/release/bazel-0.26.1-linux-x86_64 && \
    mv ./bazel-0.26.1-linux-x86_64 /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel

# Python avoid bazel error compilation
RUN ln -s /usr/bin/python3 /usr/bin/python

# TF
WORKDIR $topdir
RUN mkdir $topdir && \
    python3 -m $topdir --system-site-packages ./$topdir && \
    /bin/bash -c 'source ./venv/bin/activate' && \
    pip3 install -U pip && \
    pip3 install -U numpy==1.18.5 wheel && \
    pip3 install -U keras_preprocessing --no-deps

RUN wget https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.0.0.tar.gz && \
    tar zxf v2.0.0.tar.gz && \
    cd tensorflow-2.0.0 && \
    TF_CUDA_CLANG=0; TF_DOWNLOAD_CLANG=0; TF_NEED_CUDA=1; \
    TF_CUDA_COMPUTE_CAPABILITIES="3.0,3.5,3.7,6.0,7.0"; \
    TF_ENABLE_XLA=1; TF_NEED_ROCM=0; TF_SET_ANDROID_WORKSPACE=0; \
    TF_CONFIGURE_IOS=0; TF_NEED_NCCL=1; TF_NEED_OPENCL=0; TF_NEED_MPI=1; \
    CC_OPT_FLAGS="--copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-msse4.2 --copt=-mfpmath=both --config=cuda"; \
    TEST_TMPDIR=/install/tensorflow/tmp && \
    /bin/bash -c '/bin/echo -e "\n\n\n\n\ny\n\n\n\n\n\n\n\n" | ./configure' && \
    bazel build --jobs $jobs --config=cuda --config=v2 --linkopt=-lcudart //tensorflow/tools/pip_package:build_pip_package && \
    ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && \
    pip3 install /tmp/tensorflow_pkg/tensorflow-2.0.0-cp37-cp37m-linux_x86_64.whl

# Clean space
RUN rm -rf bazel/ /tmp/bazel* tmp/ /tmp/tensorflow_pkg tensorflow-2.0.0 v2.0.0.tar.gz