# Docker container for Ethereum mining with CUDA (nsfminer) under Unraid and with OC capabilities.

This Docker container was inspired by the [docker-nsfminer](https://github.com/pixelchrome/docker-nsfminer) which was inspired by [docker-ethminer](https://github.com/thipokch/docker-ethminer). It uses the [nsfminer](https://github.com/no-fee-ethereum-mining/nsfminer).

**NOTE:** Tested with *Unraid 6.9.1*

# Requirements

* NVIDIA drivers for your GPU installed
 
# Usage

```sh
docker run \
-it --gpus all \
olehj/docker-nsfminer \
-P <scheme://[user[.workername][:password]@]hostname:port[/...]>
```

**NOTE:** 
`-U [--cuda]` (Mine/Benchmark using CUDA only) is set by default.
`-R [--report-hashrate]` (Hashrate report) is activated by default.
`-HWMON 2` (Hardware monitoring, level 2) is activated by default.

## Show Logs

```sh
docker logs -f nsfminer
```

# Example

```sh
docker run \
-it -d \
--restart unless-stopped \
--name=nsfminer \
--gpus all \
olehj/docker-nsfminer \
-P stratum1+ssl://0x00000000000000.worker@eu1.ethermine.org:5555
```

# Build

To build the image locally

```sh
docker build -t olehj/docker-nsfminer .
```

# Support

Leave a tip here `0x0`
