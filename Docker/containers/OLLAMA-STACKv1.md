
# Ollama Stack v1

Verified running stack (deployed on RTX 3070 Ti). Deployed using Portainer — compose file below.

## Table of Contents
1. [Overview](#overview)  
2. [Compose Snippet](#compose-snippet)  
3. [Version](#version)

---

## 🔎 Overview
Services included: Ollama (model runner), Open-WebUI, Opencode (dev), Frigate (NVR), Jellyfin (media), Netdata (monitoring).

---

## 🧩 Compose Snippet
```yaml
version: "3.9"

services:

  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./ollama:/root/.ollama
    ports:
      - "11434:11434"
    restart: unless-stopped

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    network_mode: host
    environment:
      - OLLAMA_BASE_URL=http://127.0.0.1:11434
    volumes:
      - ./open-webui:/app/backend/data
    restart: unless-stopped

  opencode:
    image: node:20
    container_name: opencode
    stdin_open: true
    tty: true
    working_dir: /workspace
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    volumes:
      - ./opencode:/workspace
    restart: unless-stopped
    command: >
      bash -c "
      npm install -g opencode-ai &&
      sleep infinity
      "

  frigate:
    container_name: frigate
    image: ghcr.io/blakeblackshear/frigate:stable
    privileged: true
    shm_size: "1gb"
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./frigate/config:/config
      - ./frigate/media:/media/frigate
      - type: tmpfs
        target: /tmp/cache
    ports:
      - "5000:5000"
      - "8554:8554"
    restart: unless-stopped

  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./jellyfin/config:/config
      - ./jellyfin/cache:/cache
      - /mnt:/media
    ports:
      - "8096:8096"
    restart: unless-stopped

  netdata:
    image: netdata/netdata:latest
    container_name: netdata
    network_mode: host
    cap_add:
      - SYS_PTRACE
    security_opt:
      - apparmor:unconfined
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=all
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    volumes:
      - ./netdata:/etc/netdata
      - /var/run/docker.sock:/var/run/docker.sock:ro
    restart: unless-stopped
```

---

## 🏷️ Version
#### Version 03052026-1338
