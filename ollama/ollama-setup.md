
# Ollama Stack v1
- [Use this update docker-compose.yml file](docker-compose.yml)

---

# 🧠 Local AI Stack (Privacy-First)

A fully self-hosted AI platform using Docker.
Runs **local LLMs, agents, vector memory, and dev tooling** — with **zero cloud dependency by default**.

---

## 🚀 Stack Overview

This system is designed around a simple principle:

> **All inference happens locally unless explicitly configured otherwise.**

### Architecture

```
OpenWebUI  →  Ollama (default local inference)
              ↓
        Qdrant (memory)
              ↓
        Flowise (agents)

+ OpenCode (AI dev workspace)
+ LiteLLM (optional routing layer)
+ Netdata (monitoring)
```

---

# 📦 Containers & Usage

## 🧠 Ollama — Local LLM Engine (Core)

**Role:** Runs local language models
**Port:** `11434`

### What it does

* Hosts LLMs locally (Llama3, Mistral, CodeLlama)
* Provides API for inference
* Keeps all data on your machine

### Usage

```bash
docker exec -it ollama ollama pull llama3
docker exec -it ollama ollama run llama3
```

### Why it matters

* 🔒 Full privacy (no API calls)
* ⚡ Fast local inference
* 🧠 Foundation of the entire stack

---

## 🌐 OpenWebUI — Chat Interface

**Role:** Web UI for interacting with local models
**URL:** [http://localhost:3000](http://localhost:3000)

### What it does

* ChatGPT-like interface
* Connects directly to Ollama (default)
* Supports file uploads, chat history, tools

### Key Config

```yaml
OLLAMA_BASE_URL=http://ollama:11434
```

### Why it matters

* 🧑‍💻 Primary user interface
* 🔒 No cloud dependency
* 🧠 Direct access to local models

---

## 🧑‍💻 OpenCode — AI Coding Workspace

**Role:** Dev container for AI-assisted coding

### What it does

* CLI-based AI coding assistant
* Runs against local Ollama models
* Can automate scripts, pipelines, workflows

### Usage

```bash
docker exec -it opencode bash
```

Inside:

```bash
opencode
```

### Why it matters

* ⚙️ Automate development tasks
* 🧠 Build agents and tooling
* 🔒 Fully local coding assistant

---

## 🧠 Qdrant — Vector Database (Memory)

**Role:** Stores embeddings for RAG / memory
**URL:** [http://localhost:6333](http://localhost:6333)

### What it does

* Stores semantic vectors
* Enables:

  * long-term memory
  * document search
  * RAG pipelines

### Why it matters

* 🧠 Adds memory to LLMs
* 📚 Enables document-based AI
* 🔒 Local data storage

---

## 🤖 Flowise — Agent Builder (UI)

**Role:** No-code / low-code agent builder
**URL:** [http://localhost:3001](http://localhost:3001)

### What it does

* Build AI workflows visually
* Connect:

  * Ollama
  * Qdrant
  * APIs
* Create autonomous agents

### Why it matters

* 🧩 Build pipelines without coding
* 🤖 Rapid prototyping of agents
* 🔒 Can run fully local

---

## ⚡ LiteLLM — Optional Router Layer

**Role:** Unified API / model router
**Port:** `4000`

### What it does

* Routes requests between:

  * Ollama (local)
  * vLLM (future)
  * Cloud APIs (optional)

### Important

> ❗ Not used by default (privacy-first)

### Why it matters

* 🔀 Multi-model orchestration
* 🧠 Benchmarking models
* 🌐 Optional cloud fallback

---

## 📊 Netdata — Monitoring

**Role:** System + container monitoring
**URL:** [http://localhost:19999](http://localhost:19999)

### What it does

* CPU / RAM / Disk
* Docker container metrics
* GPU stats (if configured)

### Why it matters

* 📈 Observe AI workloads
* ⚠️ Prevent overload
* 🔍 Debug performance

---

# 🔐 Privacy Model

This stack is designed so that:

✅ All LLM inference runs locally
✅ No data leaves your machine
✅ No API keys required
✅ No telemetry required

### Optional (opt-in only)

* LiteLLM → cloud routing
* external APIs in Flowise

---

# ⚙️ Common Workflows

## 🧠 Chat with Local LLM

1. Open [http://localhost:3000](http://localhost:3000)
2. Select model (e.g., `llama3`)
3. Start chatting

---

## 📚 Add Memory (RAG)

1. Store documents in Qdrant
2. Connect Flowise → Qdrant
3. Build retrieval pipeline

---

## 🤖 Build Agents

1. Open Flowise
2. Create new flow
3. Connect:

   * Ollama (LLM)
   * Qdrant (memory)

---

## 🧑‍💻 AI Coding

```bash
docker exec -it opencode bash
opencode
```

Use for:

* script generation
* infra automation
* code refactoring

---

# 🧠 Recommended Models (3070Ti)

```bash
ollama pull llama3
ollama pull mistral
ollama pull codellama
```

### Notes

* 7B–8B models → optimal
* 13B → possible but tight
* Mixtral → not recommended on 8GB VRAM

---

# 📦 Data Persistence

| Service   | Storage          |
| --------- | ---------------- |
| Ollama    | `ollama_data`    |
| OpenWebUI | `openwebui_data` |
| Qdrant    | `qdrant_data`    |
| Flowise   | `flowise_data`   |

---

# 🧠 Future Enhancements

* 🔐 Traefik (HTTPS + auth)
* ⚡ vLLM (high-performance inference)
* 🧠 LangGraph (advanced agents)
* 📊 Prometheus + Grafana (GPU metrics)
* 🗂️ NAS-backed model storage

---

# ⚠️ Notes

* Requires NVIDIA Container Toolkit
* GPU strongly recommended
* Ubuntu 24 + Docker Compose v2 tested

---

# 🔥 Philosophy

> Own your models.
> Own your data.
> Own your intelligence.

