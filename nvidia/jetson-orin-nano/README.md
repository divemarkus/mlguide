# Nvidia Jetson Orin Nano Super Dev Kit
Getting Started with Machine Learning

## Files

- `jetson_setup.sh`: Example commands to install CUDA/L4T components.  
- `docker-compose.yml`: Example Compose file for services (Ollama, Open-WebUI, Netdata, Portainer).

---

## Table of Contents
1. [Introduction](#introduction)  
2. [Where to Buy](#where-to-buy)  
3. [SDK Setup Using Ubuntu Host](#sdk-setup-using-ubuntu-host)  
4. [Docker Configuration](#docker-configuration)  
5. [Getting Started with Models](#getting-started-with-models)  
6. [Ollama Installation and Usage](#ollama-installation-and-usage)  
7. [Frigate NVR Setup](#frigate-nvr-setup)  
8. [Additional Resources](#additional-resources)

---

## 🧭 Introduction

The Nvidia Jetson Orin Nano Super Dev Kit is a powerful platform for machine learning and AI applications. This guide helps you set up and get started, focusing on ML tasks.

---

## 🛒 Where to Buy

Helpful purchase links for common components:

- **Jetson Orin Nano Super Dev Kit**:  
  https://www.amazon.com/dp/B0BZJTQ5YP?th=1

- **Storage (NVMe Gen4)**:  
  https://www.amazon.com/dp/B0B217LZBG?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1

- **Female Jumper for pins# 9 & 10 on the Jetson**:  
  https://www.amazon.com/dp/B0DSZWFS1V?ref=ppx_yo2ov_dt_b_fed_asin_title

---

## 🛠 SDK Manager Setup Using Ubuntu Host

### Prerequisites
- **Ubuntu 22.04 or later** installed on your host machine.  
- Internet connection for downloads.  
- USB Ubuntu host to USB-C Jetson.

### Installation Steps
Follow the Jetson AI Lab SDK Manager setup guide:
https://www.jetson-ai-lab.com/tutorials/initial-setup-jetson-orin-nano/

This process typically takes over an hour depending on options selected.

---

## 🐳 Docker Configuration

1. **Docker Installation**

```bash
sudo apt-get update && sudo apt-get install docker.io
```

2. **Docker Configuration**

Ensure Docker is configured and running.

3. **GPU Acceleration in Docker**

Follow the Jetson AI Lab guide for enabling GPU acceleration:
https://www.jetson-ai-lab.com/tutorials/ssd-docker-setup/

4. **Example Compose file**

See the included `docker-compose.yml` for a pre-built service stack.

---

## 🔎 Getting Started with Models

### Pre-trained Models
- **TensorRT Optimized Models** — high-performance inference: https://www.jetson-ai-lab.com/models/  
- **CUDA-Based Models** — foundational GPU acceleration: https://developer.nvidia.com/cuda/

### Model Hosting Platforms
- **OpenRouter AI** — edge-optimized models: https://openrouter.ai/models?order=most-popular  
- **ClawHub** — community model sharing: https://clawhub.ai/

---

## 🧩 Ollama Installation and Usage

### Overview
Ollama is a lightweight framework for running LLMs locally on edge devices. It's well-suited to the Jetson platform.

### Installation Steps
1. **Install Ollama**:
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

2. **Pull a Pre-trained Model**:
```bash
ollama pull gemma3:4b
```

3. **Run Ollama Locally**
Start the Ollama server via the CLI; see the Ollama CLI Reference: https://docs.ollama.com/cli

### Web Interface
```bash
docker run -it --rm --network=host -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui ghcr.io/open-webui/open-webui:main
```

Access the WebUI at `http://<device-ip>:8080`.

Default credentials: Username: admin / Password: admin

### Performance Tips
- **Swapfile Configuration** — create swapfile if you encounter memory errors:
```bash
sudo dd if=/dev/zero of=/swapfile bs=1M count=16384 && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile' >> /etc/fstab
```

---

## 📡 Frigate NVR Setup

Frigate integrates AI-powered camera processing on Jetson. Follow Seeed Studio's deployment guide:
https://wiki.seeedstudio.com/deploy_frigate_on_jetson/

---

## 📚 Additional Resources
- Jetson AI Lab Tutorials: https://www.jetson-ai-lab.com/tutorials/  
- NVIDIA Developer Forums: https://forums.developer.nvidia.com/  
- Jetson Orin Nano projects on GitHub: https://github.com/topics/jetson-orin-nano

---

## ✅ Conclusion
The Nvidia Jetson Orin Nano Super Dev Kit is a solid option for ML enthusiasts seeking low power and edge-capable models.

