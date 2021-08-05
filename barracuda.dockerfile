FROM python:3.6-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y build-essential libibverbs-dev make libopencv-dev git-all gcc g++ wget vim gdb openssh-client screen

COPY rCUDAv20.10beta-CUDA9.0-cuDNN7.2.1-linux64 /rCUDA

ENV RCUDA_DEVICE_COUNT=4
ENV RCUDA_DEVICE_0=192.168.4.3:0
ENV RCUDA_DEVICE_1=192.168.4.3:1
ENV RCUDA_DEVICE_2=192.168.4.4:0
ENV RCUDA_DEVICE_3=192.168.4.4:1


####### Set cudnn

#RUN mkdir -p /usr/local/cuda/include
#RUN mkdir -p /usr/local/cuda/lib64
#COPY cudnn-9.0-linux-x64-v7/cuda/include/cudnn.h /usr/local/cuda/include/
#COPY cudnn-9.0-linux-x64-v7/cuda/lib64/libcudnn* /usr/local/cuda/lib64/
#RUN chmod a+r /usr/local/cuda/lib64/libcudnn* 


####### Set library path

#ENV LD_LIBRARY_PATH /rCUDA/lib:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH /rCUDA/lib:$LD_LIBRARY_PATH


####### Install library

RUN pip install pipenv
ENV TOOL_DIR /home/gpuuser/a-GPUBench_public/
COPY ./a-GPUBench_public/ $TOOL_DIR
COPY ./simpletraining.py /home/gpuuser

WORKDIR $TOOL_DIR

RUN pipenv lock
RUN pipenv install --system


####### Create keys

RUN yes '/root/.ssh/id_rsa' | /usr/bin/ssh-keygen -N ''
RUN cp /root/.ssh/id_rsa keys
RUN cp /root/.ssh/id_rsa.pub keys

ENTRYPOINT ["/bin/bash"]

