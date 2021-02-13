# Docker container for Ethereum mining with CUDA (nsfminer)

This Docker container was inspired by the [docker-etheminer](https://github.com/thipokch/docker-ethminer). It uses the [nsfminer](https://github.com/no-fee-ethereum-mining/nsfminer).

**NOTE:** Tested with *Ubuntu 18.04.5 LTS*

# Requirements

* NVIDIA drivers for your GPU installed
* NVIDIA-docker installed

See the [Installation Guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) for more details.
 
# Usage

```sh
docker run \
-it --gpus all \
pixelchrome/docker-nsfminer \
-P <scheme://[user[.workername][:password]@]hostname:port[/...]>
```

**NOTE:** `-U [--cuda]` (Mine/Benchmark using CUDA only) is set by default.

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
pixelchrome/docker-nsfminer \
-P stratum1+ssl://0xe01A5deB05749d816176DB35499c5B50B1759449.gh@eu1.ethermine.org:5555
```

# Support

Leave a tip here `0xe01A5deB05749d816176DB35499c5B50B1759449`