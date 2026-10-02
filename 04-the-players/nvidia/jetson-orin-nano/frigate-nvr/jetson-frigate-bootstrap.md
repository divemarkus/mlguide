# Jetson Frigate Bootstrap

I’d use the bootstrap as **Phase 1**. It deliberately stops before creating `docker-compose.yml` or `config.yml`, so we can build those around your actual hardware/camera design afterward.

> See 'jetson-frigate-bootstrap.sh' file

### What the script does

1. Verifies **Ubuntu 22.04 / ARM64 / JetPack 6**
2. Displays Jetson/L4T information
3. Checks the NVMe mount
4. **Never formats or partitions anything**
5. Installs Docker Engine from Docker’s official repository if necessary
6. Installs Docker Compose v2
7. Installs NVIDIA Container Toolkit
8. Configures Docker's NVIDIA runtime with `nvidia-ctk`
9. Tests NVIDIA device visibility inside a container
10. Creates:

```text
/srv/frigate/
├── config/
├── media/
├── database/
├── models/
└── system/
```

11. Pulls:

```text
ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6
```

12. Performs a Frigate container smoke test
13. **Does not start Frigate yet**

This follows NVIDIA's current Docker/NVIDIA Container Toolkit procedure and Frigate's current Jetson guidance. 
- https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

Docker officially supports Ubuntu 22.04 on ARM64, and the current Docker installation method uses the Docker apt repository plus the Compose plugin.
- https://docs.docker.com/engine/install/ubuntu

### Download the bootstrap script

> See 'jetson-frigate-bootstrap.sh' file

Copy it onto the Jetson, then:

```bash
chmod +x jetson-frigate-bootstrap.sh
sudo ./jetson-frigate-bootstrap.sh
```

Since you're already working as root, simply:

```bash
chmod +x jetson-frigate-bootstrap.sh
./jetson-frigate-bootstrap.sh
```

### Important NVMe behavior

The script expects the final Frigate storage location to be:

```text
/srv/frigate
```

It will **not** automatically execute something dangerous like:

```bash
mkfs.ext4 /dev/nvme0n1
```

If `/srv/frigate` isn't backed by the NVMe, it stops and gives you the exact commands to identify and mount the correct partition.

That is intentional because the Jetson's NVMe device name/partition layout must be confirmed before anything destructive.

### One thing I intentionally did differently from Seeed

The older Seeed guide uses the JetPack 5-era:

```text
stable-tensorrt-jp5
docker-compose
```

For this build we're using the current JetPack 6 path:

```text
stable-tensorrt-jp6
Docker Compose v2
nvidia-ctk
```

Frigate explicitly documents `stable-tensorrt-jp6` for JetPack 6+, with `runtime: nvidia`. 
- https://docs.frigate.video/configuration/hardware_acceleration_video/

JetPack 6.2.3 is currently NVIDIA's latest production JetPack 6 release, based on Jetson Linux 36.5.2 / Ubuntu 22.04. 
- https://developer.nvidia.com/embedded/jetpack-sdk-623

### After it finishes

**Don't start configuring cameras yet.** Paste the final output from the script here.

Then we'll do **Phase 2**:

```text
Jetson
  │
  ├── Docker
  ├── NVIDIA Container Runtime
  ├── NVMe
  │
  └── Frigate JP6 container
         │
         ├── Jetson NVDEC
         ├── TensorRT
         ├── go2rtc
         └── recording
```

We'll then create the actual `docker-compose.yml` and `config.yml` specifically for your **EmpireTech + Reolink + FortiGate VLAN** architecture rather than using a generic Frigate configuration. Frigate's current installation guidance also recommends Docker Compose and port `8971` for authenticated UI/API access. 
- https://docs.frigate.video/frigate/installation/
