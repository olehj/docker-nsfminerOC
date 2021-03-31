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
    nvidia-opencl-dev \
    nvidia-settings \
    nvidia-driver-460 \
    nvidia-utils-460 \
    xserver-xorg-video-nvidia-460 \
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
#ENV NV_DRV_V=""
#ENV NVIDIA_BUILD_OPTS="-a -N -q --install-libglvnd --ui=none --no-kernel-module"
#ENV DATA_DIR=/tmp

#COPY /fetch_nvidia_drivers.sh /tmp/
#RUN chmod +x /tmp/fetch_nvidia_drivers.sh

CMD bash -c "sleep 5 \
  && nvidia-smi -pm 1 \
  && nvidia-xconfig --cool-bits=31 --allow-empty-initial-configuration --use-display-device=None --virtual=1920x1080 --enable-all-gpus --separate-x-screens \
  && sleep 5 \
  && xinit \
  &  sleep 10 \
  && nvidia-smi -i $NSFMINER_GPU -pl $NSFMINER_GPUPOWERLIMIT \
  && nvidia-settings -a [gpu:$NSFMINER_GPU]/GPUPowerMizerMode=$NSFMINER_POWERMIZER \
  && nvidia-settings -a [gpu:$NSFMINER_GPU]/GPUGraphicsClockOffsetAllPerformanceLevels=$NSFMINER_GPUGFXCLOCKOFFSET \
  && nvidia-settings -a [gpu:$NSFMINER_GPU]/GPUMemoryTransferRateOffsetAllPerformanceLevels=$NSFMINER_GPUMEMCLOCKOFFSET \
  && nvidia-settings -a [gpu:$NSFMINER_GPU]/GPUFanControlState=$NSFMINER_GPUFANCONTROLL \
  && if [ $NSFMINER_GPUFANCONTROLL == 1 ]; then \
          nvidia-settings -a [fan:$NSFMINER_GPUFAN1]/GPUTargetFanSpeed=$NSFMINER_GPUFANSPEED1 \
       && nvidia-settings -a [fan:$NSFMINER_GPUFAN2]/GPUTargetFanSpeed=$NSFMINER_GPUFANSPEED2 ; fi \
  && /opt/nsfminer/nsfminer -R --nocolor -U --HWMON $NSFMINER_HWMON --devices $NSFMINER_GPU \
  -P $NSFMINER_TRANSPORT://$NSFMINER_ETHADDRESS.$NSFMINER_WORKERNAME@$NSFMINER_ADDRESS1:$NSFMINER_PORT1 \
  -P $NSFMINER_TRANSPORT://$NSFMINER_ETHADDRESS.$NSFMINER_WORKERNAME@$NSFMINER_ADDRESS2:$NSFMINER_PORT2"
