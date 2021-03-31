#!/bin/bash

if [ -z "${NV_DRV_V}" ]; then
echo "---Trying to get Nvidia driver version---"
export NV_DRV_V="$(nvidia-smi | grep NVIDIA-SMI | cut -d ' ' -f3)"
	if [ -z "${NV_DRV_V}" ]; then
		echo "---Something went wrong, can't get driver version, putting server into sleep mode---"
		sleep infinity
	else
		echo "---Successfully got driver version: ${NV_DRV_V}---"
	fi
fi

echo "---Checking Xwrapper.config---"
if grep -rq 'allowed_users=anybody' /etc/X11/Xwrapper.config; then
	echo "---Xwrapper.config properly configured---"
else
	echo "---Configuring Xwrapper.config---"
	sed -i '/allowed_users=/c\allowed_users=anybody' /etc/X11/Xwrapper.config
fi

INSTALL_V="$(find ${DATA_DIR} -name NVIDIA_*\.run | cut -d '_' -f 2 | cut -d '.' -f 1,2)"

if [ ! -z "$INSTALL_V" ]; then
	if [ "$INSTALL_V" != "${NV_DRV_V}" ]; then
		echo "---Version missmatch, deleting local Nvidia Driver v$INSTALL_V---"
		rm ${DATA_DIR}/NVIDIA_$INSTALL_V.run
	fi
fi

if [ ! -f /usr/bin/nvidia-settings ]; then
	if [ -f ${DATA_DIR}/NVIDIA_${NV_DRV_V}.run ]; then
		echo "---Found NVIDIA Driver v${NV_DRV_V} localy, installing...---"
		${DATA_DIR}/NVIDIA_${NV_DRV_V}.run ${NVIDIA_BUILD_OPTS} > /dev/null 2>&1
	else
		echo "---Downloading and installing Nvidia Driver v${NV_DRV_V}---"
		wget -q --show-progress --progress=bar:force:noscroll -O /tmp/NVIDIA.run http://download.nvidia.com/XFree86/Linux-x86_64/${NV_DRV_V}/NVIDIA-Linux-x86_64-${NV_DRV_V}.run && \
		chmod +x /tmp/NVIDIA.run && \
		/tmp/NVIDIA.run ${NVIDIA_BUILD_OPTS} > /dev/null 2>&1 && \
		mv /tmp/NVIDIA.run ${DATA_DIR}/NVIDIA_${NV_DRV_V}.run
	fi
else
	CUR_NV_DRV_V="$(/usr/bin/nvidia-settings --version | grep version | cut -d ' ' -f 4)"
	if [ "$NV_DRV_V" != "$CUR_NV_DRV_V" ]; then
		echo "---Driver version missmatch, currently installed: v$CUR_NV_DRV_V, driver on Host: v$NV_DRV_V---"
		if [ -f ${DATA_DIR}/NVIDIA_${NV_DRV_V}.run ]; then
			echo "---Found NVIDIA Driver v${NV_DRV_V} localy, installing...---"
			${DATA_DIR}/NVIDIA_${NV_DRV_V}.run ${NVIDIA_BUILD_OPTS} > /dev/null 2>&1
		else
			echo "---Downloading and installing Nvidia Driver v${NV_DRV_V}---"
			wget -q --show-progress --progress=bar:force:noscroll -O /tmp/NVIDIA.run http://download.nvidia.com/XFree86/Linux-x86_64/${NV_DRV_V}/NVIDIA-Linux-x86_64-${NV_DRV_V}.run && \
			chmod +x /tmp/NVIDIA.run && \
			/tmp/NVIDIA.run ${NVIDIA_BUILD_OPTS} > /dev/null 2>&1 && \
			mv /tmp/NVIDIA.run ${DATA_DIR}/NVIDIA_${NV_DRV_V}.run
		fi
	else
		echo "---Nvidia Driver v$CUR_NV_DRV_V Up-To-Date---"
	fi
fi
