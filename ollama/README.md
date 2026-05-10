# Ollama

Guides and example configuration for running models with Ollama.

## Files

- [Quick start notes](ollama-setup.md) 
- [Full Ollama Stack v1](docker-compose.yml)

<details>
- [Docker Deployment](../Docker/containers/OLLAMA-STACKv1.md)
</details>

---

## 💡 Introduction

Ollama is a lightweight local model serving tool and workflow that makes it easy to run, evaluate, and serve large language models on your own hardware or private infrastructure. It focuses on simple deployment, reproducible model runs, and convenient developer tooling (CLI + API) so teams can prototype and ship inference services without heavy orchestration.

## ⚙️ Installation

For detailed platform-specific instructions see `ollama-setup.md`. Typical installation options:

- Download the official installer from the project website and follow platform instructions.  
- Use the provided Docker images (see `docker-compose.yml`) for containerized deployments.

After installation, verify the CLI is available and the service can list models:

```bash
docker exec it ollama --help
docker exec it ollama models
```

---

## 🚀 Deployment Scenario

Common deployment patterns:

- **Local development:** run Ollama on a developer workstation for fast iteration and testing.  
- **Single-node production:** host the Ollama process on a VM or dedicated server, optionally fronted by an API gateway.  
- **Containerized deployment:** run `docker-compose.yml` or a Docker image for reproducible environments.
- [**Containerized deployment:**](../Docker/containers/OLLAMA-STACKv1.md)

---


# [Ollama](https://ollama.com/?utm_source=chatgpt.com) — What It Is

Ollama is a lightweight local AI runtime that lets you:

* Run LLMs locally on:

  * Windows
  * macOS
  * Linux
  * Docker
* Serve models as an API server
* Download/manage models with a simple CLI
* Use GPU acceleration
* Connect tools like:

  * [Open WebUI](https://openwebui.com/?utm_source=chatgpt.com)
  * [Flowise](https://flowiseai.com/?utm_source=chatgpt.com)
  * [AnythingLLM](https://anythingllm.com/?utm_source=chatgpt.com)
  * [OpenCode](https://opencode.ai/?utm_source=chatgpt.com)
  * [LM Studio](https://lmstudio.ai/?utm_source=chatgpt.com)
  * VS Code AI extensions
  * Coding agents

It acts like a local “AI engine” with:

* CLI
* REST API
* Model management
* GPU scheduling
* Local inference

Your own notes describe it well as:

> “Own your models. Own your data. Own your intelligence.” 

---

# 🧠 Background & Why It Became Popular

Ollama exploded in popularity because it simplified local AI dramatically.

Before Ollama:

* Running local LLMs often required:

  * Python environments
  * CUDA setup
  * llama.cpp compilation
  * Hugging Face configs
  * manual quantization handling

Ollama changed this with:

```bash
ollama run llama3
```

That single command:

* downloads model
* configures runtime
* launches inference
* opens chat session

This made local AI accessible to:

* developers
* homelab users
* privacy-focused users
* AI researchers
* coding-agent workflows

Project notes also emphasize its privacy-first architecture and local-first deployment philosophy.

---

# ⚡ Key Features (Latest Important Features)

## 1. MLX Backend Support (Huge for Apple Silicon)

Ollama now supports MLX acceleration on Apple Silicon Macs.

This is one of the biggest recent improvements because:

* dramatically improves M-series performance
* better unified memory utilization
* lower latency
* better power efficiency

Especially important for:

* M3/M4 Macs
* large MoE models
* Qwen 3.5/3.6
* DeepSeek
* coding agents

---

## 2. OpenAI-Compatible API Server

Ollama can behave like an OpenAI API endpoint:

```bash
http://localhost:11434/v1/chat/completions
```

This is massive because tools expecting OpenAI APIs can use Ollama locally.

Examples:

* Open WebUI
* Continue.dev
* Flowise
* LangChain
* LiteLLM
* OpenCode
* AI coding agents

---

## 3. Model Serving / Hosting

Ollama is no longer just “run a model locally.”

It is now commonly used as:

* homelab AI server
* shared LAN inference server
* coding-agent backend
* RAG backend
* local API gateway

Uploaded Docker stack reflects this architecture:

```text
OpenWebUI → Ollama → Qdrant → Flowise
```

---

## 4. Modelfiles (Custom AI Personalities)

You can build custom models using:

```Dockerfile
FROM llama3
SYSTEM "You are a cybersecurity assistant."
```

Then:

```bash
ollama create mymodel -f Modelfile
```

Useful for:

* homelab assistants
* coding agents
* RAG workflows
* infra automation

---

## 5. Streaming & Tool Calling

Modern Ollama models support:

* streaming responses
* structured JSON
* tool calling
* agent frameworks

Important for:

* coding agents
* AI IDEs
* automation pipelines

---

## 6. Multi-Platform GPU Support

Supports:

* NVIDIA CUDA
* Apple MLX
* CPU fallback
* AMD support improving via ROCm

---

# 🖥️ Desktop Install

## Windows

### Official Installer

Download:
[Ollama Windows Download](https://ollama.com/download/windows?utm_source=chatgpt.com)

Install normally:

```powershell
OllamaSetup.exe
```

Verify:

```powershell
ollama --version
```

Run:

```powershell
ollama run llama3
```

---

## macOS

### Official Installer

Download:
[Ollama macOS Download](https://ollama.com/download/mac?utm_source=chatgpt.com)

Supports:

* Intel Macs
* Apple Silicon
* MLX acceleration

Verify:

```bash
ollama --version
```

---

## Ubuntu/Linux Native Install

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Then:

```bash
ollama serve
```

---

# 🐳 Docker Install (Ubuntu)

## NVIDIA GPU Version

Install:

* Docker
* NVIDIA Container Toolkit

Stack documentation recommends Ubuntu + Docker Compose v2.

---

## Example Docker Compose

Uploaded compose stack already provides a strong privacy-first architecture.

Core Ollama service:

```yaml
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    gpus: all
    volumes:
      - ollama_data:/root/.ollama
    ports:
      - "11434:11434"
    restart: unless-stopped
```

Run:

```bash
docker compose up -d
```

Pull model:

```bash
docker exec -it ollama ollama pull llama3
```

Run model:

```bash
docker exec -it ollama ollama run llama3
```

---

# 🌐 Ollama as API Server

Start server:

```bash
ollama serve
```

Default endpoint:

```text
http://localhost:11434
```

Example:

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt": "Explain Docker networking"
}'
```

OpenAI-compatible endpoint:

```text
/v1/chat/completions
```

---

# 🔥 Top 10 CLI Commands

| Command                              | Purpose                    |
| ------------------------------------ | -------------------------- |
| `ollama run llama3`                  | Run/chat with a model      |
| `ollama pull mistral`                | Download model             |
| `ollama list`                        | List installed models      |
| `ollama ps`                          | Show loaded/running models |
| `ollama stop llama3`                 | Stop loaded model          |
| `ollama rm llama3`                   | Remove model               |
| `ollama show llama3`                 | Show model info            |
| `ollama create mymodel -f Modelfile` | Build custom model         |
| `ollama serve`                       | Start API server           |
| `ollama cp llama3 myclone`           | Clone model locally        |

---

# 🧠 Recommended Models (2026)

| Use Case         | Model            |
| ---------------- | ---------------- |
| General AI       | Llama 4          |
| Coding           | Qwen3-Coder-Next |
| Small Fast Model | Gemma 3          |
| Reasoning        | DeepSeek-R1      |
| Agents           | Qwen3.5          |
| Lightweight CPU  | Phi-4            |

Your own tests with Qwen3-Coder-Next showed extremely strong coding output but very heavy RAM usage.

---

# 🧩 Best Ecosystem Pairings

## Homelab / Self-Hosted

* [Open WebUI](https://openwebui.com/?utm_source=chatgpt.com)
* [Flowise](https://flowiseai.com/?utm_source=chatgpt.com)
* [Qdrant](https://qdrant.tech/?utm_source=chatgpt.com)
* [LiteLLM](https://litellm.ai/?utm_source=chatgpt.com)

## Coding

* [OpenCode](https://opencode.ai/?utm_source=chatgpt.com)
* VS Code Continue
* Cline
* Roo Code

## Privacy-First AI

Ollama is one of the best tools available today for:

* offline AI
* self-hosted agents
* private RAG
* local coding assistants

Uploaded stack architecture is already aligned with this philosophy.

---

# ⚠️ Important Hardware Notes

## Apple Silicon

Excellent:

* M3 Max
* M4 Max
* 36GB+
* MLX acceleration

## NVIDIA

Best experience:

* CUDA
* 16GB+ VRAM
* RTX 4090 / 5090
* RTX A-series

## RAM Reality

Large coding models can consume:

* 32GB
* 64GB
* 128GB+

Your Qwen3-Coder-Next testing confirms this in real-world usage.

---
