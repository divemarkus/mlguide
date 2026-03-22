
# 🧠 Windows Setup Guide for Machine Learning  
*Optimized for AMD GPUs | Local LLMs | Privacy-First Workflows*

> **💡 Tip**: This guide is designed for *on-premise, offline-capable AI workflows* — ideal for developers, researchers, and privacy-conscious users who want to run large language models (LLMs) locally on Windows 11 without cloud dependencies.

## Files

- `install-windows.ps1`: PowerShell helper for common installations.
- `sample-config.yml`: Example config for Windows-specific tooling.

---

[![Windows 11](https://img.shields.io/badge/OS-Windows_11-blue?logo=windows)](https://www.microsoft.com/windows)
[![AMD ROCm](https://img.shields.io/badge/GPU-AMD_ROCM-orange?logo=amd)](https://rocm.docs.amd.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📚 Table of Contents
1. [Prerequisites](#prerequisites)  
2. [System Preparation](#system-preparation)  
3. [GPU Setup (AMD ROCm)](#gpu-setup-amd-rocm) *(New!)*  
4. [LM Studio](#lm-studio--local-llm-workstation) 

---

## 🔌 Prerequisites
*I am running on AMD machine with 128GB shared memory. [See system specs](system-specs.md), on how running local LLMs utilizes each device*

Ensure your system meets baseline requirements:

| Component | Minimum | Recommended |
|---------|----------|-------------|
| RAM     | 16 GB    | 32+ GB (DDR4/5) |
| VRAM    | 8 GB     | 12–24 GB (AMD RX 6000/7000 series or MI series) |
| Storage | 50 GB free SSD/NVMe | 1+ TB NVMe for large model repos |

### ✅ Core Tools Overview
| Tool | Purpose | Parallelism? | Notes |
|------|---------|--------------|-------|
| **LM Studio** 📦 | Desktop UI to run & chat with local models (GGUF format) | ✅ (multi-model support via server) | Best for beginners & quick prototyping |
| **Ollama** 🐋 | CLI-first model runner (`ollama run llama3`) | ✅ (via `OLLAMA_MAX_PARALLEL` env var) | Great scripting support; cross-platform |
| **Docker + vLLM** 🚢 | Production-grade inference server | ✅ (with proper config) | Ideal for APIs, multi-tenant servers |
| **Docker Model Runner** 🏗️ | Deploy models as containers on WSL2 or native Windows Docker Desktop | ✅ | Requires WSL2 backend |

> ⚠️ **Note**: **AMD GPU support in ML tooling is still maturing**. ROCm 6.x works with select Linux kernels & Windows 11 (via WSL2 or experimental native). [Proceed with your own research](https://www.amd.com/en/developer/resources/ml-radeon.html). We will use Vulkan for now. Skip anything related to ROCm on this write-up.

---

## 🛠️ System Preparation

### 1️⃣ Windows Housekeeping
```powershell
# Run these in PowerShell as Admin:
winget install --id Microsoft.WindowsTerminal --silent
winget install --id Git.Git -e --source winget
```
✅ **Update Everything**  
- Go to *Settings > Windows Update* → Install all pending updates (especially optional driver/security updates).  
- Check *Device Manager* for outdated GPU drivers. Use [AMD Adrenalin Software](https://www.amd.com/en/support) for latest ROCm-compatible drivers.

### 2️⃣ Power Optimization (Critical for Local Inference!)
> 🔋 Laptop users: **Always use AC power** during model loading/inference.  
> 💻 Enable *High Performance* mode:
```powershell
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
```
- Windows 11 often hides these traditional power plans in the Settings app in favor of its own "Power Mode" toggle (Best Power Efficiency, Balanced, Best Performance). Running this command is a popular way to "force" the classic High Performance behavior if you feel the system is being too aggressive with power saving.

### 3️⃣ GPU Setup (AMD ROCm)  
⚠️ **Windows Native Support is Experimental** — **WSL2 + Ubuntu is recommended for stability.** 

- Skip this part as we will use Vulkan.

| Option | Steps |
|--------|-------|
| 🔹 **Recommended: WSL2 + ROCm** | 1. Enable WSL & GPU acceleration:<br> `wsl --install -d Ubuntu`<br> `wsl --set-default-version 2`<br>2. Install [ROCm for WSL](https://rocmdocs.amd.com/en/docs-6.0/deploy/linux/rapid_start.html#wsl2-guide)<br>3. Use `rocm-smi` to verify GPU visibility |
| 🔸 **Native Windows (Beta)** | 1. Follow [ROCm on Windows guide](https://rocm.docs.amd.com/projects/install-on-windows/en/latest/how-to/native_windows.html)<br>2. Reboot after install<br>3. Test with `rocminfo` |

> 🌐 Check GPU compatibility:  
> 🔍 Supported GPUs: [AMD ROCm 6.x supported devices](https://rocmdocs.amd.com/en/docs-6.0/deploy/linux/rapid_start.html#supported-devices)

---

## 🧩 LM Studio – Local LLM Workstation

LM Studio is a **beautiful, drag-and-drop UI** for loading & interacting with quantized models (GGUF format) — perfect for Windows.

### Install & First Run
```bash
# Download from https://lmstudio.ai → install .exe
# Launch → configure environment
```

### 🚀 Essential Setup Steps
- [LM Studio Write-up](lm-studio\README.md)
- [LM Studio Install and Configure](lm-studio\lm-studio-install.md)

