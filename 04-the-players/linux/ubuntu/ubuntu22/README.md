
# Ubuntu 22.04 Setup Guide for Machine Learning

This guide provides instructions to set up an Ubuntu 22.04 system optimized for machine learning tasks with NVIDIA GPU support.

## Files

- `setup.sh`: Script to install drivers and common packages.
- `docker-compose.yml`: Example compose file for development.

## Table of Contents
1. [Prerequisites](#prerequisites)  
2. [System Preparation](#system-preparation)  
3. [NVIDIA Drivers and CUDA Setup](#nvidia-drivers-and-cuda-setup)  
4. [Docker Installation](#docker-installation)  
5. [NVIDIA Container Toolkit](#nvidia-container-toolkit)  
6. [LLM Runner Setup (Ollama)](#llm-runner-setup-ollama)  
7. [Model Deployment](#model-deployment)  
8. [Monitoring Resources](#monitoring-resources)

---

## ✅ Prerequisites
Run your application alongside your AI/model platform:
1. Ollama — supports parallelism by default.  
2. Docker — ensure compose flags/switches support parallelism: https://docs.vllm.ai/en/stable/deployment/docker/  
3. Docker Model Runner: https://docs.docker.com/ai/model-runner/  
4. LMStudio — handy UI with one-click install: https://lmstudio.ai/docs/app/advanced/parallel-requests

### Remote Access Configuration
Enable SSH access to your system for remote management.

1. Update your system packages:
```bash
sudo apt update && sudo apt upgrade
```

2. Install and enable the OpenSSH server:
```bash
sudo apt install openssh-server -y
sudo systemctl start ssh
sudo systemctl enable ssh
sudo systemctl status ssh
```

---

## ⚙️ System Preparation

### Basic Software Installation
Install essential tools for system monitoring and development:
```bash
sudo apt install curl git zsh wget btop nvtop htop neofetch konsole -y
```

---

## 🔧 NVIDIA Drivers and CUDA Setup
Some GPUs require the proprietary drivers to utilize VRAM effectively.

### Install NVIDIA Drivers
```bash
# Install recommended drivers
sudo ubuntu-drivers install
# Verify installation after reboot
nvidia-smi
```

### Install TensorRT (Optional)
For high-performance deep learning inference:
```bash
sudo apt install tensorrt
# Reboot
```

---

## 🐳 Docker Installation
Install Docker and necessary dependencies:
```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Add your user to the Docker group:
```bash
sudo usermod -aG docker $USER
```

## 🔗 NVIDIA Container Toolkit
This is the bridge that allows Docker containers to access your GPU.

Install the NVIDIA Container Toolkit to leverage GPU resources in Docker:
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Test GPU functionality in Docker:
```bash
docker run --rm --gpus all nvidia/cuda:12.3.2-runtime-ubuntu22.04 nvidia-smi
```

---

## 🧩 LLM Runner Setup (Ollama)
Install Ollama from their official website:
- [See Docker Guide](../Docker/containers/OLLAMA-STACKv1.md)

Run models locally using Docker:
- Example for a smaller model (safe for most enthusiast GPUs):
```bash
docker exec -it ollama ollama run llama3.2
```
- Example for a larger model (check requirements first):
```bash
docker exec -it ollama ollama run deepseek-r1:8b
```
- Larger models (ensure you meet system requirements):
```bash
docker exec -it ollama ollama run deepseek-r1:14b
```

---

## 🚀 Model Deployment

### Docker Deployment
Create a project directory and start your services:
```bash
mkdir -p ~/docker-stack && cd ~/docker-stack
```

Run the provided compose file:
```bash
docker compose up -d
```

Access points (examples):
- Open Web UI: `http://open-webui:8080`  
- Frigate: `http://frigate:5000`  
- Portainer: `http://portainer:9443`  
- Netdata: `http://netdata:19999`  
- Jellyfin: `http://jellyfin:8096`

---

## 📈 Monitoring Resources
Useful commands to monitor system resources:
```bash
nvidia-smi
watch -n 1 free -m
watch -n 1 nvidia-smi
htop
btop
nvtop
```

### Additional Tools
- Netdata container provides a Web portal for monitoring.  
- Access Netdata and navigate to Hardware > NVIDIA (GPU).

