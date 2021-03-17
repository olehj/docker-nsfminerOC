FROM nvidia/cuda:11.2.1-base-ubuntu18.04

RUN set -ex \
  && apt update \
  && apt upgrade -y \
  && apt update \
  && apt install -y \
    bzip2 \
    software-properties-common \
    tzdata \
    wget \
    xinit \
  && add-apt-repository -y ppa:graphics-drivers \
  && apt install -y \
    nvidia-opencl-dev \
    nvidia-settings \
  && mkdir /opt/nsfminer \
  && wget https://github.com/no-fee-ethereum-mining/nsfminer/releases/download/v1.3.8/nsfminer_1.3.8-ubuntu_18.04-cuda_11.2-opencl.tgz -O /tmp/nsfminer.tar.gz \
  && tar -xvzf /tmp/nsfminer.tar.gz -C /opt/nsfminer/ \
  && rm -rf /tmp/nsfminer.tar.gz \
  && ls -l /opt/nsfminer \
  && apt remove -y software-properties-common \
  && apt autoremove -y \
  && apt clean autoclean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /etc/X \
  && wget https://raw.githubusercontent.com/olehj/docker-nsfminer/main/xorg.conf -O /etc/X/xorg.conf

ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100

CMD ["xinit", "&"]

ENTRYPOINT ["/opt/nsfminer/nsfminer", "--nocolor -R -U --HWMON 2"]
