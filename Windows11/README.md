
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
5. [AnythingLLM](#anythingllm--workspace-manager)  
6. [Monitoring & Optimization](#monitoring--troubleshooting)  
7. [Bonus Tools & Integrations](#bonus-tools--integrations)

---

## 🔌 Prerequisites
*I am running on AMD Ryzen laptop with 128GB shared RAM, split between GPU=64GB*

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

> ⚠️ **Note**: As of 2024, **AMD GPU support in ML tooling is still maturing**. ROCm 6.x works with select Linux kernels & Windows 11 (via WSL2 or experimental native). See [GPU Setup](#gpu-setup-amd-rocm). Proceed with your own research.

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
# Launch → Login/Sign Up (free)
```

### 🚀 Essential Setup Steps
1. **Download Models**  
   - Use the built-in *Model Hub* or import `.gguf` files manually  
   - Recommended starting models for AMD GPUs:  
     • `Mistral-7B-Instruct-v0.3.Q4_K_M.gguf` (~5GB VRAM)  
     • `Llama-3-8B-Instruct.Q4_K_M.gguf`  

2. **Configure System Prompt** *(for consistent behavior)*
```prompt
You are a precise Technical Assistant. Provide concise, factual answers.
If you do not know an answer, state that you don't know rather than guessing.
```
→ Click ⋮ next to model → *Presets* → *Copy Preset Identifier*  
→ Paste into chat or save as default in *Settings > Prompts*

### 🧰 Plugins & Enhancements
| Plugin | Purpose |
|--------|---------|
| **DuckDuckGo Search** ([@danielsig](https://lmstudio.ai/danielsig/duckduckgo)) | Adds real-time web search to context — great for factual accuracy over static knowledge cutoffs. Enable in *Settings > Plugins*. |
| **PDF/Markdown Parser** | Drag & drop documents → LM Studio will extract & index content for RAG-style QA. |

### 🔌 Turn LM Studio into a Local API Server
```bash
# Start server via UI: Top bar → ⚙️ (⚙️) → "Start Server"  
# Or via CLI:
lmstudio server --port 1234
```
> 🧪 Now use tools like `curl`, Python's `requests`, or **AnythingLLM** to query your model!

---

## 💡 AnythingLLM – Your AI Workspace Orchestrator

Runs on top of LM Studio/Ollama/vLLM to build knowledge bases, chat apps, and deployable agents.

### Docker Deployment (Recommended for Windows)
1. Clone & configure:
```bash
git clone https://github.com/Mintplex-Labs/anything-llm.git
cd anything-llm
cp .env.example .env
# Edit .env: set `LLM_PROVIDER=lmstudio`, `LMSTUDIO_BASE_URL=http://host.docker.internal:1234`
```

2. Deploy with Docker Compose:
```yaml
version: '3.8'
services:
  anything-llm:
    image: mintplexlabs/anything-llm:latest
    ports:
      - "3001:3001"
    environment:
      - LLM_PROVIDER=lmstudio
      - LMSTUDIO_BASE_URL=http://host.docker.internal:1234  # ← Critical!
      - VECTOR_DB=chroma
      - EMBEDDING_ENGINE=openai   # or `local` (uses sentence-transformers)
    volumes:
      - ./data:/app/server/storage
```

### Key Features You’ll Love 🎯
- 📁 Upload PDFs, docs, web pages → auto-chunk & embed  
- 💬 Chat with multiple sources + context window tuning  
- 🌐 Deploy as a self-hosted internal AI portal  

---

## 🔍 Monitoring & Troubleshooting

### 🖥️ System Resource Monitor
| Tool | Use Case |
|------|----------|
| **Task Manager** (Ctrl+Shift+Esc) | Quick RAM/VRAM % usage check |
| **MSI Afterburner + GPU-Z** | Real-time VRAM clock, temp, utilization |
| **`rocm-smi` in WSL2 terminal** | Confirm GPU memory use & health |

### Common AMD Windows Issues & Fixes
| Symptom | Fix |
|---------|-----|
| `out of memory (OOM)` during model load | Reduce quantization level: `Q5_K_M` → `Q4_K_M`, or use smaller model (`Phi-3-mini-3.8B`) |
| GPU not detected in LM Studio | Ensure WSL2 backend has access to GPU + ROCm installed in distro |
| Slow inference on AMD | Enable [ROCm memory pool](https://rocmdocs.amd.com/en/docs-6.0/memory_management.html) via `export HIP_VISIBLE_DEVICES=0` (WSL2) |

> 💡 **Pro Tip**: Run `lmstudio server --max-context-length 4096` to cap context and preserve VRAM.

---

## 🎁 Bonus Tools & Integrations

| Tool | Why Add It? |
|------|-------------|
| **Ollama CLI** (`ollama run llama3:8b-instruct-q4_K_M`) | Scriptable model pulls + parallel requests (`OLLAMA_MAX_PARALLEL=2`) |
| **vLLM + Docker** | Enterprise-grade serving with PagedAttention (faster decoding) |
| **LangChain/Gradio UI** | Build custom apps on top of your local LLMs |
| **Hugging Face Transformers** + `bitsandbytes` | Fine-tuning & quantization control (via WSL2) |

---

> ✨ **Made with ❤️ from your local AI community**  
> *Last updated: Oct 2024 — ROCm 6.2 / LM Studio v0.2.55* <-check for updates

---
