# LM Studio

Local-first environment for experimenting with, fine-tuning, and serving large language models (LLMs). Provides a GUI + CLI to manage models, run inference, test prompts, and prototype apps on your hardware or private cloud.

## Installation Notes
- [LM Studio Install Notes](lm-studio-install.md)

<details>
## Table of Contents
1. [Basic Facts](#basic-facts)  
2. [Key Features](#key-features)  
3. [Common Use-Cases](#common-use-cases)  
4. [Quick Installation (Overview)](#quick-installation-overview)  
5. [Configuration](#configuration)  
6. [Deployment Scenarios](#deployment-scenarios)  
7. [Security & Privacy](#security--privacy)  
8. [Examples / Quickstart](#examples--quickstart)  
9. [Troubleshooting](#troubleshooting)  
10. [FAQ / Notes](#faq--notes)  
11. [References & Links](#references--links)
</details>
---

## ✅ Basic Facts
| Item | Details |
|------|---------|
| Purpose | Local development, evaluation, and small-scale serving of LLMs. |
| Scope | Single-machine or small-cluster usage (not full enterprise MLOps). |
| Interfaces | Web UI, REST/gRPC APIs, and CLI. |
| Models | Open models (quantized or full precision) depending on runtime (CPU/GPU/Ollama). |
| License | Varies by component/model — check individual licenses before production use. |

---

## ✨ Key Features
- **Model management:** download, version, and switch models easily.  
- **Prompt studio:** interactive prompt building, testing, and comparison.  
- **Experiment tracking:** save sessions, inputs, outputs, and metrics.  
- **Local deployment:** run model servers locally or expose via secure tunnels.  
- **Extensibility:** plugin hooks for custom preprocessing/postprocessing/connectors.

---

## 🔍 Common Use-Cases
- Prompt engineering and rapid prototyping.  
- Small-scale inference for demos or internal tools.  
- Offline model evaluation and comparison.  
- Education and exploration without cloud costs.

---

## ⚙️ Quick Installation (Overview)

1. Prerequisites:
	- OS: Linux, macOS, or Windows (WSL recommended on Windows).  
	- Python 3.10+ (if using Python components) or Docker.  
	- Optional: GPU drivers and CUDA for acceleration.

2. Install options:
	- Docker: Use the provided container image for isolation.  
	- Native: Clone and install Python deps (see `requirements.txt`).

3. Example (Docker):
	- Build/pull image and run container exposing the UI port.

4. Example (native):
	- Create a venv, install, and run the server:
```bash
python -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
python -m lm_studio.server
```

> ⚠️ Adjust commands for Windows/WSL as needed.

---

## 🛠 Configuration
- Config file format/location: YAML/JSON/env (describe exact file once finalized).  
- Common settings: model cache path, default model, UI port, auth, resource limits (CPU/GPU/memory).  
- Env vars to consider: `MODEL_PATH`, `LM_STUDIO_PORT`, `AUTH_TOKEN`.

---

## ☁️ Deployment Scenarios
- **Local dev:** single host running UI + model.  
- **Team share:** host on LAN with auth and firewall rules.  
- **Cloud:** containerize to VM or Kubernetes (use GPU nodes for heavy models).  
- **Edge:** quantized models on Jetson/NVidia — optimize models and reduce batch sizes.

---

## 🔒 Security & Privacy
- Models and data stay local by default.  
- Recommend token-based auth or reverse proxy with TLS when exposing network access.  
- Sanitize logs; avoid storing sensitive prompts/outputs.  
- Verify model licenses before commercial use.

---

## ▶️ Examples / Quickstart
- Basic inference (curl):
```bash
curl -X POST http://localhost:1234/api/v1/generate \
  -H "Content-Type: application/json" \
  -d '{"model":"ggml-small","prompt":"Hello"}'
```
- UI: open http://localhost:1234 after starting the server.

---

## 🧰 Troubleshooting
- Common issues: model download failures, insufficient GPU memory, port conflicts.  
- Quick tips:
  - Check service logs.  
  - Increase swap for large CPU-model runs.  
  - Verify GPU drivers and CUDA versions.

---

## ❓ FAQ / Notes
- Recommended models for small GPUs / CPU-only: list quantized and lightweight models.  
- Adding new models: document model formats and registry steps.  
- Performance tuning: batch sizes, sequence length, CPU affinity, quantization options.

---

## 📚 References & Links
- Model sources and license links.  
- Related tooling: Ollama, LMflow, etc.

---

Files:

- `lm-studio-install.md`: Install notes  
- `sample-workspace.yml`: Example workspace configuration
