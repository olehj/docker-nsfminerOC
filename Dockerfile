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
    xserver-xorg \
  && add-apt-repository -y ppa:graphics-drivers \
  && apt install -y \
    nvidia-driver-460 \
    nvidia-utils-460 \
    xserver-xorg-video-nvidia-460 \
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
  && rm -rf /var/lib/apt/lists/*

ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100
ENV DISPLAY=:0

CMD bash -c "sleep 3 \
  && nvidia-xconfig --cool-bits=31 --allow-empty-initial-configuration --use-display-device=None --virtual=1920x1080 --enable-all-gpus --separate-x-screens \
  && xinit \
  &  sleep 5 \
  && nvidia-smi -i $NSFMINER_GPU -pl $NSFMINER_GPUPOWERLIMIT \
  && nvidia-settings -a [gpu:$NSFMINER_GPU]/GPUPowerMizerMode=$NSFMINER_POWERMIZER \
  && nvidia-settings -a [gpu:$NSFMINER_GPU]/GPUGraphicsClockOffsetAllPerformanceLevels=$NSFMINER_GPUGFXCLOCKOFFSET \
  && nvidia-settings -a [gpu:$NSFMINER_GPU]/GPUMemoryTransferRateOffsetAllPerformanceLevels=$NSFMINER_GPUMEMCLOCKOFFSET \
  && nvidia-settings -a [gpu:$NSFMINER_GPU]/GPUFanControlState=$NSFMINER_GPUFANCONTROLL \
  && nvidia-settings -a [fan:$NSFMINER_GPUFAN1]/GPUTargetFanSpeed=$NSFMINER_GPUFANSPEED1 \
  && nvidia-settings -a [fan:$NSFMINER_GPUFAN2]/GPUTargetFanSpeed=$NSFMINER_GPUFANSPEED2 \
  && nvidia-settings -a [fan:$NSFMINER_GPUFAN3]/GPUTargetFanSpeed=$NSFMINER_GPUFANSPEED3 \
  && /opt/nsfminer/nsfminer --nocolor -R -U --HWMON $NSFMINER_HWMON --devices $NSFMINER_GPU \ 
  -P $NSFMINER_TRANSPORT://$NSFMINER_ETHADDRESS.$NSFMINER_WORKERNAME@$NSFMINER_ADDRESS1:$NSFMINER_PORT1 \
  -P $NSFMINER_TRANSPORT://$NSFMINER_ETHADDRESS.$NSFMINER_WORKERNAME@$NSFMINER_ADDRESS2:$NSFMINER_PORT2"
