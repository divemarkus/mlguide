#!/usr/bin/env bash
#
# Jetson Orin Nano Super + Frigate bootstrap
# Target: Ubuntu 22.04 / JetPack 6.x / arm64
#
# PURPOSE
#   - Validate JetPack 6 / Jetson environment
#   - Install Docker Engine + Compose v2 if Docker is not already installed
#   - Install NVIDIA Container Toolkit
#   - Configure Docker for the NVIDIA runtime
#   - Validate NVIDIA container device access
#   - Verify that Frigate storage is really on the NVMe mount
#   - Create the initial Frigate directory layout
#   - Pull the current JetPack 6 Frigate image
#
# INTENTIONALLY NOT INCLUDED
#   - Partitioning/formatting NVMe
#   - Frigate docker-compose.yml
#   - Frigate config.yml
#   - Camera credentials/configuration
#   - MQTT configuration
#   - Ollama/Qwen3-VL
#
# Run as root:
#   chmod +x jetson-frigate-bootstrap.sh
#   ./jetson-frigate-bootstrap.sh
#
# Optional:
#   FRIGATE_STORAGE=/srv/frigate ./jetson-frigate-bootstrap.sh
#   ALLOW_ROOT_STORAGE=1 ./jetson-frigate-bootstrap.sh
#

set -Eeuo pipefail

trap 'echo; echo "[ERROR] Bootstrap failed at line $LINENO."; echo "        Review the message above, fix the issue, then rerun the script."; exit 1' ERR

# -----------------------------
# Configuration
# -----------------------------

FRIGATE_STORAGE="${FRIGATE_STORAGE:-/srv/frigate}"
FRIGATE_IMAGE="${FRIGATE_IMAGE:-ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6}"
ALLOW_ROOT_STORAGE="${ALLOW_ROOT_STORAGE:-0}"

DOCKER_SOURCE="/etc/apt/sources.list.d/docker.sources"
DOCKER_KEYRING="/etc/apt/keyrings/docker.asc"
NVIDIA_KEYRING="/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg"
NVIDIA_SOURCE="/etc/apt/sources.list.d/nvidia-container-toolkit.list"

# -----------------------------
# Helpers
# -----------------------------

log()  { echo -e "\n[+] $*"; }
warn() { echo -e "\n[!] $*" >&2; }
die()  { echo -e "\n[ERROR] $*" >&2; exit 1; }

run() {
    echo "+ $*"
    "$@"
}

# -----------------------------
# Basic host validation
# -----------------------------

[[ "${EUID}" -eq 0 ]] || die "Run this script as root."

source /etc/os-release

[[ "${ID}" == "ubuntu" ]] || die "This script expects Ubuntu. Detected: ${ID:-unknown}"
[[ "${VERSION_ID}" == "22.04" ]] || die "This build targets Ubuntu 22.04. Detected: ${VERSION_ID:-unknown}"

ARCH="$(dpkg --print-architecture)"
[[ "${ARCH}" == "arm64" ]] || die "Expected arm64/aarch64. Detected: ${ARCH}"

log "Host"
echo "Hostname : $(hostname)"
echo "Ubuntu   : ${PRETTY_NAME}"
echo "Arch     : ${ARCH}"
echo "Kernel   : $(uname -r)"
echo "Machine  : $(uname -m)"

# -----------------------------
# JetPack validation
# -----------------------------

log "JetPack / Jetson validation"

if [[ -r /etc/nv_tegra_release ]]; then
    cat /etc/nv_tegra_release
else
    die "/etc/nv_tegra_release not found. This does not look like a normal Jetson Linux installation."
fi

if command -v dpkg-query >/dev/null 2>&1 && dpkg-query -W -f='${Status}\n' nvidia-jetpack 2>/dev/null | grep -q "install ok installed"; then
    echo "nvidia-jetpack package: installed"
    dpkg-query -W nvidia-jetpack || true
else
    warn "nvidia-jetpack meta-package is not installed."
    warn "Continuing because Jetson Linux / L4T may still be installed correctly."
fi

grep -q "R36\." /etc/nv_tegra_release || die "Jetson Linux R36.x / JetPack 6 was not detected."

# -----------------------------
# NVMe / storage preflight
# -----------------------------

log "Storage preflight"

echo "Block devices:"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MODEL,MOUNTPOINTS

echo
echo "Current mounts relevant to ${FRIGATE_STORAGE}:"
findmnt -T "${FRIGATE_STORAGE}" -o SOURCE,FSTYPE,SIZE,USED,AVAIL,TARGET 2>/dev/null || true

mkdir -p "${FRIGATE_STORAGE}"

# Find the actual filesystem backing the target.
STORAGE_SOURCE="$(findmnt -T "${FRIGATE_STORAGE}" -n -o SOURCE 2>/dev/null || true)"
STORAGE_FSTYPE="$(findmnt -T "${FRIGATE_STORAGE}" -n -o FSTYPE 2>/dev/null || true)"
STORAGE_TARGET="$(findmnt -T "${FRIGATE_STORAGE}" -n -o TARGET 2>/dev/null || true)"

echo
echo "Storage source : ${STORAGE_SOURCE:-<none>}"
echo "Filesystem     : ${STORAGE_FSTYPE:-<none>}"
echo "Mount target   : ${STORAGE_TARGET:-<none>}"

if [[ -z "${STORAGE_SOURCE}" || "${STORAGE_SOURCE}" == "/dev/root" || "${STORAGE_TARGET}" == "/" ]]; then
    if [[ "${ALLOW_ROOT_STORAGE}" == "1" ]]; then
        warn "NVMe is NOT mounted at ${FRIGATE_STORAGE}; using the root filesystem because ALLOW_ROOT_STORAGE=1."
        warn "This is for bootstrap/testing only. Do not use this as the final NVR recording location."
    else
        cat >&2 <<EOF

[ERROR] ${FRIGATE_STORAGE} is not backed by a separate filesystem/NVMe mount.

The script will NOT format or partition anything.

First identify the NVMe device:
    lsblk -o NAME,SIZE,TYPE,FSTYPE,MODEL,MOUNTPOINTS

Example, ONLY after confirming the correct device/partition:
    sudo mkfs.ext4 /dev/nvme0n1p1
    sudo mkdir -p ${FRIGATE_STORAGE}
    sudo blkid /dev/nvme0n1p1

Then add its UUID to /etc/fstab:
    UUID=<UUID_FROM_BLKID>  ${FRIGATE_STORAGE}  ext4  defaults,noatime  0  2

Mount it:
    sudo mount -a

Verify:
    findmnt ${FRIGATE_STORAGE}

Then rerun this script.

IMPORTANT: Do NOT blindly use /dev/nvme0n1p1. Confirm the device with lsblk first.
EOF
        exit 2
    fi
fi

# -----------------------------
# Required host packages
# -----------------------------

log "Installing base packages"

apt-get update

apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    jq \
    nvme-cli \
    smartmontools \
    util-linux

# -----------------------------
# Docker Engine
# -----------------------------

log "Docker installation / validation"

if command -v docker >/dev/null 2>&1; then
    echo "Docker already installed:"
    docker --version
else
    log "Installing Docker Engine from Docker's official apt repository"

    # Docker's official repository supports Ubuntu arm64.
    install -m 0755 -d /etc/apt/keyrings

    if [[ ! -f "${DOCKER_KEYRING}" ]]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
            -o "${DOCKER_KEYRING}"
        chmod a+r "${DOCKER_KEYRING}"
    fi

    cat > "${DOCKER_SOURCE}" <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_CODENAME:-${VERSION_CODENAME}}
Components: stable
Architectures: ${ARCH}
Signed-By: ${DOCKER_KEYRING}
EOF

    apt-get update

    # If an older Ubuntu-packaged docker.io is installed, Docker CE may conflict.
    # Do not remove an existing installation automatically; handle it manually.
    if dpkg-query -W -f='${Status}\n' docker.io 2>/dev/null | grep -q "install ok installed"; then
        die "docker.io is already installed but 'docker' was not detected. Remove/repair docker.io manually, then rerun."
    fi

    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
fi

systemctl enable --now docker

echo
docker --version
docker compose version

# -----------------------------
# NVIDIA Container Toolkit
# -----------------------------

log "NVIDIA Container Toolkit installation"

if command -v nvidia-ctk >/dev/null 2>&1; then
    echo "nvidia-ctk already installed:"
    nvidia-ctk --version || true
else
    log "Adding NVIDIA Container Toolkit repository"

    install -m 0755 -d /usr/share/keyrings

    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
        | gpg --dearmor -o "${NVIDIA_KEYRING}"

    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
        | sed 's#deb https://#deb [signed-by='"${NVIDIA_KEYRING}"'] https://#g' \
        > "${NVIDIA_SOURCE}"

    apt-get update
    apt-get install -y nvidia-container-toolkit
fi

# -----------------------------
# Configure Docker for NVIDIA
# -----------------------------

log "Configuring Docker NVIDIA runtime"

nvidia-ctk runtime configure --runtime=docker

systemctl restart docker

echo
echo "Docker runtime configuration:"
docker info 2>/dev/null | sed -n '/Runtimes:/,/Default Runtime:/p' || true

# -----------------------------
# NVIDIA container validation
# -----------------------------

log "Testing NVIDIA container access"

echo "Host NVIDIA devices:"
ls -l /dev/nvhost-gpu /dev/nvhost-nvdec /dev/nvmap 2>/dev/null || true

if command -v nvidia-container-cli >/dev/null 2>&1; then
    echo
    echo "nvidia-container-cli info:"
    nvidia-container-cli info || true
fi

echo
echo "Running a minimal NVIDIA-runtime container test..."

docker run --rm \
    --runtime=nvidia \
    -e NVIDIA_VISIBLE_DEVICES=all \
    --entrypoint /bin/sh \
    ubuntu:22.04 \
    -c 'echo "Container started"; echo "NVIDIA device nodes visible:"; ls -l /dev/nvhost-* /dev/nvmap 2>/dev/null || true'

# -----------------------------
# Frigate storage layout
# -----------------------------

log "Creating Frigate storage layout"

mkdir -p \
    "${FRIGATE_STORAGE}/config" \
    "${FRIGATE_STORAGE}/media" \
    "${FRIGATE_STORAGE}/database" \
    "${FRIGATE_STORAGE}/models" \
    "${FRIGATE_STORAGE}/system"

chmod 0755 "${FRIGATE_STORAGE}"
chmod 0755 \
    "${FRIGATE_STORAGE}/config" \
    "${FRIGATE_STORAGE}/media" \
    "${FRIGATE_STORAGE}/database" \
    "${FRIGATE_STORAGE}/models" \
    "${FRIGATE_STORAGE}/system"

touch "${FRIGATE_STORAGE}/system/.write-test"
rm -f "${FRIGATE_STORAGE}/system/.write-test"

echo
echo "Frigate storage:"
findmnt -T "${FRIGATE_STORAGE}" -o SOURCE,FSTYPE,SIZE,USED,AVAIL,TARGET
du -sh "${FRIGATE_STORAGE}"/* 2>/dev/null || true

# -----------------------------
# Pull Frigate Jetson image
# -----------------------------

log "Pulling Frigate JetPack 6 image"

docker pull "${FRIGATE_IMAGE}"

echo
echo "Frigate image:"
docker image inspect "${FRIGATE_IMAGE}" \
    --format 'Repository={{index .RepoTags 0}} | Architecture={{.Architecture}} | OS={{.Os}} | Created={{.Created}}'

# -----------------------------
# Frigate container smoke test
# -----------------------------

log "Frigate image smoke test"

docker run --rm \
    --runtime=nvidia \
    -e NVIDIA_VISIBLE_DEVICES=all \
    --entrypoint /bin/sh \
    "${FRIGATE_IMAGE}" \
    -c '
        echo "Frigate container started successfully."
        echo
        echo "Architecture:"
        uname -m
        echo
        echo "Jetson device nodes:"
        ls -l /dev/nvhost-gpu /dev/nvhost-nvdec /dev/nvmap 2>/dev/null || true
        echo
        echo "FFmpeg:"
        ffmpeg -version | head -n 1 || true
    '

# -----------------------------
# Final report
# -----------------------------

log "Bootstrap complete"

cat <<EOF

============================================================
JETSON + FRIGATE BOOTSTRAP COMPLETE
============================================================

Host
  Ubuntu          : ${PRETTY_NAME}
  Architecture    : ${ARCH}
  Kernel          : $(uname -r)

JetPack
  L4T             : $(head -n 1 /etc/nv_tegra_release)

Docker
  Engine          : $(docker --version)
  Compose         : $(docker compose version)

NVIDIA
  Toolkit         : $(nvidia-ctk --version 2>/dev/null || echo installed)
  Runtime         : configured for Docker

Frigate
  Image           : ${FRIGATE_IMAGE}
  Storage         : ${FRIGATE_STORAGE}

Directories
  Config          : ${FRIGATE_STORAGE}/config
  Media           : ${FRIGATE_STORAGE}/media
  Database        : ${FRIGATE_STORAGE}/database
  Models          : ${FRIGATE_STORAGE}/models
  System          : ${FRIGATE_STORAGE}/system

NEXT PHASE
  1. Create docker-compose.yml
  2. Create initial Frigate config.yml
  3. Configure Jetson hardware decode
  4. Build/test TensorRT detector
  5. Add first EmpireTech camera
  6. Add go2rtc
  7. Add MQTT
  8. Add Reolink doorbell
  9. Add Home Assistant integration
 10. Add Ollama + Qwen3-VL 4B
 11. Benchmark power/performance modes

NO CAMERA OR FRIGATE CONTAINER HAS BEEN STARTED YET.
============================================================
EOF
