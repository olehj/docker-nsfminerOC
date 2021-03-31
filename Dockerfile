FROM nvidia/cuda:11.2.2-base-ubuntu18.04

RUN set -ex \
  && apt update \
  && apt upgrade -y \
  && apt update \
  && apt install -y \
    bzip2 \
    software-properties-common \
    tzdata \
    wget \
    xterm \
    xinit \
  && add-apt-repository -y ppa:graphics-drivers \
  && apt install -y \
    nvidia-driver-460 \
    nvidia-utils-460 \
    xserver-xorg-video-nvidia-460 \
    nvidia-opencl-dev \
    nvidia-settings \
  && mkdir /opt/nsfminer \
  && wget https://github.com/no-fee-ethereum-mining/nsfminer/releases/download/v1.3.12/nsfminer_1.3.12-ubuntu_18.04-cuda_11.2-opencl.tgz -O /tmp/nsfminer.tar.gz \
  && tar -xvzf /tmp/nsfminer.tar.gz -C /opt/nsfminer/ \
  && rm -rf /tmp/nsfminer.tar.gz \
  && ls -l /opt/nsfminer \
  && apt remove -y software-properties-common \
  && apt autoremove -y \
  && apt clean autoclean \
  && rm -rf /var/lib/apt/lists/*

ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV DISPLAY=:0
ENV DATA_DIR=/tmp/
ENV NV_DRV_V=""
ENV NVIDIA_BUILD_OPTS="-a -n -q -X --install-libglvnd --ui=none --no-kernel-module"

COPY /worker.sh /tmp/
RUN chmod +x /tmp/worker.sh

ENTRYPOINT ["/tmp/worker.sh"]
