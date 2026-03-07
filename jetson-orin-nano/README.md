# Nvidia Jetson Orin Nano Super Dev Kit: Getting Started with Machine Learning

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

## Introduction

The Nvidia Jetson Orin Nano Super Dev Kit is a powerful platform designed for machine learning and AI applications. This guide provides detailed instructions to help you set up and get started with your Jetson Orin Nano, focusing on machine learning tasks.

---

## Where to Buy

Here are the links to purchase the necessary components:

- **Jetson Orin Nano Super Dev Kit**:  
  [Amazon Link](https://www.amazon.com/dp/B0BZJTQ5YP?th=1)

- **Storage (NVMe Gen4)**:  
  [Amazon Link](https://www.amazon.com/dp/B0B217LZBG?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1)

- **Female Jumper for pins# 9 & 10 on the Jetson**:  
  [Amazon Link](https://www.amazon.com/dp/B0DSZWFS1V?ref=ppx_yo2ov_dt_b_fed_asin_title)

---

## SDK Manager Setup Using Ubuntu Host

### Prerequisites
- **Ubuntu 22.04 or later** installed on your host machine.
- Internet connection for downloading necessary software.
- USB Ubuntu host to USB-C Jetson.

### Installation Steps
Follow the comprehensive guide provided by Jetson AI Lab:
[SDK Manager Setup Guide](https://www.jetson-ai-lab.com/tutorials/initial-setup-jetson-orin-nano/)

This process typically takes over an hour, depending on your selections and system speed.

---

## Docker Configuration

For optimal performance and ease of use with your Jetson Orin Nano, follow these steps:

1. **Docker Installation**:  
   Refer to the official Docker documentation or use the following commands:
   ```bash
   sudo apt-get update && sudo apt-get install docker.io
   ```

2. **Docker Configuration**:  
   Ensure Docker is properly configured and running on your system.

3. **GPU Acceleration in Docker**:  
   Follow the guide provided by Jetson AI Lab for enabling GPU acceleration:
   [Docker Setup Guide](https://www.jetson-ai-lab.com/tutorials/ssd-docker-setup/)

4. **Example Compose file**:  
  See the included example `docker-compose.yml` for a pre-built service stack ([docker-compose.yml](docker-compose.yml)).

---

## Getting Started with Models

The Jetson Orin Nano supports a wide range of machine learning models. Here are some popular options:

### Pre-trained Models
- **TensorRT Optimized Models**:  
  TensorRT is NVIDIA's high-performance deep learning inference library. Models optimized for TensorRT offer significant performance improvements.
  - [TensorRT Models](https://www.jetson-ai-lab.com/models/)

- **CUDA-Based Models**:  
  CUDA provides the foundational GPU acceleration libraries for deep learning.
  - [CUDA Models](https://developer.nvidia.com/cuda/)

### Model Hosting Platforms
- **OpenRouter AI**:  
  Offers a variety of popular models optimized for edge devices.
  - [OpenRouter AI Models](https://openrouter.ai/models?order=most-popular)

- **ClawHub**:  
  A community-driven platform for sharing and downloading machine learning models.
  - [ClawHub AI](https://clawhub.ai/)

---

## Ollama Installation and Usage

### Overview
Ollama is a lightweight framework designed for running large language models locally on edge devices. It's particularly well-suited for the Jetson Orin Nano due to its efficiency and compatibility with NVIDIA GPUs.

### Installation Steps

1. **Install Ollama**:
   ```bash
   curl -fsSL https://ollama.com/install.sh | sh
   ```

2. **Pull a Pre-trained Model**:
   - For optimal performance on edge devices, consider using smaller models like Llama 3.2 (1B or 3B parameters).
     ```bash
     ollama pull gemma3:4b
     ```

3. **Run Ollama Locally**:
   - Start the Ollama server by typing `ollama` in your terminal.
   - For detailed command-line options, refer to the [Ollama CLI Reference](https://docs.ollama.com/cli).

### Web Interface

1. **Launch the WebUI as a Docker Container**:
   ```bash
   docker run -it --rm --network=host -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui ghcr.io/open-webui/open-webui:main
   ```

2. **Access the WebUI**:
   - Open your web browser and navigate to `http://x.x.x.x:8080` (replace x.x.x.x with your device's IP address).

3. **Credentials**:
   - The default credentials are `Username: admin`, `Password: admin`.

### Performance Tips
- **Swapfile Configuration**:  
  If you encounter memory errors, create a swapfile to improve performance.
  ```bash
  sudo dd if=/dev/zero of=/swapfile bs=1M count=16384 && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile' >> /etc/fstab
  ```

---

## Frigate NVR Setup

### Overview
Frigate is a popular open-source AI-powered security camera that integrates seamlessly with the Jetson Orin Nano.

### Installation Guide
Follow the official deployment guide provided by Seeed Studio:
[Deploying Frigate on Jetson](https://wiki.seeedstudio.com/deploy_frigate_on_jetson/)

This setup allows you to leverage the power of AI for real-time object detection and tracking in security applications.

---

## Additional Resources

- **Jetson AI Lab Tutorials**:  
  [Jetson AI Lab](https://www.jetson-ai-lab.com/tutorials/)  
  A comprehensive collection of tutorials covering various aspects of Jetson Orin Nano setup and usage.

- **NVIDIA Developer Forums**:  
  [Nvidia Forums](https://forums.developer.nvidia.com/)  
  Join the community to ask questions, share experiences, and get support.

- **GitHub Repositories**:  
  Explore repositories dedicated to Jetson Orin Nano projects on GitHub.
  [Jetson Orin Nano Projects](https://github.com/topics/jetson-orin-nano)

---

## Conclusion

The Nvidia Jetson Orin Nano Super Dev Kit is an excellent choice for machine learning enthusiasts mostly looking for low power draws and small models.

