# Docker container for Ethereum mining with CUDA (nsfminer) with Nvidia OC capabilities.

This Docker container was inspired by the [docker-nsfminer](https://github.com/pixelchrome/docker-nsfminer) which was inspired by [docker-ethminer](https://github.com/thipokch/docker-ethminer). It uses the [nsfminer](https://github.com/no-fee-ethereum-mining/nsfminer).

**NOTE:** Tested with *Unraid 6.9.1*

# Requirements

* NVIDIA drivers for your GPU installed.
 
# Usage

```sh
docker run \
-it --priveleged --restart unless-stopped --name=NsfminerOC --runtime=nvidia --gpus=all \
olehj/docker-nsfmineroc \
-e NSFMINER_GPU=0 \							# Set GPU ID
-e NSFMINER_GPUPOWERLIMIT=500 \						# Set power limit for GPU in Watt
-e NSFMINER_POWERMIZER=2 \						# Set PowerMizer performance level
-e NSFMINER_GPUGFXCLOCKOFFSET=0 \					# Set GPU graphics clock offset
-e NSFMINER_GPUMEMCLOCKOFFSET=0 \					# Set GPU memory clock offset
-e NSFMINER_HWMON=2 \							# Set Feedback level from nsfminer
-e NSFMINER_TRANSPORT=stratum1+ssl \					# Set transport for worker
-e NSFMINER_ETHADDRESS=0xC04d2fF8Ef057CbDc08360c65D9b1268BaFC5a6f \	# Set your worker ethereum address
-e NSFMINER_WORKERNAME=worker \						# Set a worker name
-e NSFMINER_ADDRESS1=eu1.ethermine.org \				# Set address 1 for worker, both must be set
-e NSFMINER_ADDRESS2=us1.ethermine.org \				# Set address 2 for worker, both must be set
-e NSFMINER_PORT1=5555 \						# Set port for address 1
-e NSFMINER_PORT2=5555 \						# Set port for address 2
-e NSFMINER_GPUFANCONTROLL=0 \						# Set GPU fan controll, 0 will run auto and other fan settings are ignored
-e NSFMINER_GPUFAN1=0 \							# Set the FAN ID 1 of GPU
-e NSFMINER_GPUFANSPEED1=100 \						# Set the speed in percent of FAN ID 1
-e NSFMINER_GPUFAN2=1 \							#   Same as above, skip and delete if there's no more fans available.
-e NSFMINER_GPUFANSPEED2=100						# 
```

**NOTE:** 
`-U [--cuda]` (Mine/Benchmark using CUDA only) is set by default and can't be changed.
`-R [--report-hashrates]` Report hashrates is set by default and can't be changed.
`--nocolor` No color is set by default and can't be changed.

## Show Logs

```sh
docker logs -f NsfminerOC
```

# Example

```sh
docker run \
-it --priveleged --restart unless-stopped --name=NsfminerOC --runtime=nvidia --gpus=all \
olehj/docker-nsfmineroc \
-e NSFMINER_GPU=1 \
-e NSFMINER_GPUPOWERLIMIT=230 \
-e NSFMINER_POWERMIZER=3 \
-e NSFMINER_GPUGFXCLOCKOFFSET=-200 \
-e NSFMINER_GPUMEMCLOCKOFFSET=1000 \
-e NSFMINER_HWMON=2 \
-e NSFMINER_TRANSPORT=stratum1+ssl \
-e NSFMINER_ETHADDRESS=0x516eaf4546BBeA271d05A3E883Bd2a11730Ef97b \
-e NSFMINER_WORKERNAME=worker1 \
-e NSFMINER_ADDRESS1=eu1.ethermine.org \
-e NSFMINER_ADDRESS2=us1.ethermine.org \
-e NSFMINER_PORT1=5555 \
-e NSFMINER_PORT2=5555 \
-e NSFMINER_GPUFANCONTROLL=1 \
-e NSFMINER_GPUFAN1=0 \
-e NSFMINER_GPUFANSPEED1=60 \
-e NSFMINER_GPUFAN2=1 \
-e NSFMINER_GPUFANSPEED2=60 \
```

# Build

To build the image locally

```sh
docker build -t olehj/docker-nsfmineroc .
```

# Support

Leave a tip here `0x516eaf4546BBeA271d05A3E883Bd2a11730Ef97b`
