# 🧠 Getting Started with Local AI & Local LLMs (2026 Edition)

## Why Run AI Locally?

Running AI locally means the model runs directly on **your phone, laptop, desktop, NAS, or homelab server** instead of sending every prompt to cloud services.

### Benefits

| Feature        | Local LLMs                | Cloud AI                    |
| -------------- | ------------------------- | --------------------------- |
| Privacy        | ✅ High                    | ❌ Data leaves device        |
| Offline Use    | ✅ Yes                     | ❌ Usually No                |
| Monthly Fees   | ✅ Optional                | ❌ Usually Required          |
| Custom Models  | ✅ Yes                     | ⚠️ Limited                  |
| Speed          | ✅ Instant (good hardware) | Depends on internet         |
| Data Ownership | ✅ You own it              | ❌ Provider stores some data |

A good way to think about it:

* **The Model = The Brain**
* **Ollama / LM Studio = The Body**
* **Flowise / Agents = The Nervous System**

This is similar to the architecture echoed in this repo. 

---

# 🚀 Step 1: Start With What You Already Own

Many people think they need a $3,000 AI workstation.

You don't.

Start with your existing device and learn first.

---

# 📱 iPhone, Samsung & Google Pixel

## Easiest Path: Google AI Edge Gallery

[Google AI Edge Gallery](https://ai.google.dev/edge)

Google's Edge AI initiative allows modern smartphones to run smaller AI models directly on-device.

### What You Need

| Device                    | Recommendation |
| ------------------------- | -------------- |
| iPhone 15 Pro / 16 Series | Excellent      |
| Samsung S24/S25           | Excellent      |
| Pixel 8 / 9 Series        | Excellent      |
| Older Phones              | Limited        |

### What You Can Do

* Chat with AI offline
* Summarize documents
* Translation
* Coding assistance
* Image understanding
* Privacy-first AI
* [More use-cases](./google/edge-ai-gallery/edge-ai-use-cases.md)

### Good Starter Models

* Best to follow recommended as it changes quiet often!
* Gemma-4-e2b-it (~2.6GB)
* Gemma 3

### Reality Check

Phones are amazing for:

✅ Learning AI

✅ Daily assistant tasks

✅ Privacy

But:

❌ Large coding models

❌ 70B+ models

❌ Heavy agents

---

# 🍎 Mac Users (Recommended Beginner Platform)

If somebody asks me:

> "What's the easiest computer for local AI?"

The answer is usually a modern Apple Silicon Mac.

---

## Recommended Hardware

| Mac      | Recommendation |
| -------- | -------------- |
| M1 16GB  | Good           |
| M2 16GB  | Good           |
| M3 24GB+ | Excellent      |
| M4 32GB+ | Outstanding    |

Unified memory is extremely valuable for AI workloads.

---

## Install Ollama

[Ollama](https://ollama.com)

Ollama is the easiest way to run local models. It serves models locally and exposes a simple API.

### Install

```bash
brew install ollama
```

or use the macOS installer.

### Pull Your First Model

```bash
ollama run llama3
```

---

## Install LM Studio

[LM Studio](https://lmstudio.ai)

LM Studio provides a GUI for downloading, testing, and serving models locally.

Why beginners love it:

* Visual model browser
* One-click downloads
* Chat interface
* Local API server
* No terminal required

---

## Install Draw Things

[Draw Things](https://drawthings.ai)

Best beginner image-generation application for Mac.

Use it for:

* Stable Diffusion
* Flux
* Image generation
* AI image editing

---

## Recommended First Models (Below might be outdated)

| Use Case       | Model        |
| -------------- | ------------ |
| General Chat   | Gemma 3 12B  |
| Coding         | Qwen3-Coder  |
| Fast Assistant | Llama 3.1 8B |
| Research       | DeepSeek R1  |

---

# 🪟 Windows Users

## First Question: Do You Have a Dedicated GPU?

### Check

Press:

```text
Ctrl + Shift + Esc
```

Task Manager → Performance

Look for:

* NVIDIA RTX
* AMD Radeon
* Intel Arc

---

## Recommended Minimum Specs

| Hardware | Recommendation       |
| -------- | -------------------- |
| RAM      | 16GB+                |
| Storage  | 100GB Free           |
| GPU VRAM | 8GB+                 |
| CPU      | Modern Ryzen / Intel |
| OS       | Windows 11           |

---

## GPU Capability Guide

| GPU           | Local AI    |
| ------------- | ----------- |
| GTX 1080 Ti   | Good        |
| RTX 3060 12GB | Excellent   |
| RTX 3070      | Excellent   |
| RTX 4070      | Excellent   |
| RTX 4080      | Outstanding |
| RTX 4090      | Elite       |
| RTX 5080      | Elite       |
| RTX 5090      | Extreme     |

Even the legendary NVIDIA GeForce GTX 1080 Ti can still run many modern quantized models surprisingly well.

---

## Install LM Studio First

For Windows beginners:

### Download

[LM Studio Download](https://lmstudio.ai/download)

### Then

1. Install
2. Open Model Hub
3. Download a model
4. Click Chat
5. Start using AI

The LM Studio guide recommends lightweight starter models such as Mistral 7B and Llama 3 8B quantizations for typical desktop GPUs.

---

## Recommended Windows Models

### 8GB VRAM

* Mistral 7B
* Gemma 3 4B
* Llama 3.1 8B

### 12GB VRAM

* Gemma 3 12B
* Qwen 3 14B
* DeepSeek distilled models

### 16GB–24GB VRAM

* Qwen 3 32B
* DeepSeek R1 Distill
* Large coding models

---

# 🔥 Best Beginner Setup by Device

| Device                     | Best Starting Tool               |
| -------------------------- | -------------------------------- |
| iPhone                     | Google AI Edge Gallery           |
| Samsung Galaxy             | Google AI Edge Gallery           |
| Google Pixel               | Google AI Edge Gallery           |
| MacBook Air M-Series       | Ollama + LM Studio               |
| MacBook Pro M-Series       | Ollama + LM Studio + Draw Things |
| Windows Laptop w/ RTX GPU  | LM Studio                        |
| Windows Desktop w/ RTX GPU | LM Studio + Ollama               |
| Homelab Server             | Ollama + Open WebUI + Flowise    |
| Jetson Orin Nano           | Ollama + Open WebUI              |

---

# Final Advice

Don't start by chasing the biggest model.

Start by running **any model locally today** on the hardware you already own.

The fastest way to learn AI is:

1. Install one tool.
2. Download one model.
3. Use it every day.
4. Gradually build your local AI stack.

Most people are surprised that a phone, MacBook, or mid-range RTX PC can already run useful AI completely offline.
