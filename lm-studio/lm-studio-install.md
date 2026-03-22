# LM Studio Install

Basic notes for installing LM Studio locally. Keep platform-specific steps here for quick reference.

## Table of Contents
1. [Download](#download)  
2. [Platform Install](#platform-install)

---

## ⬇️ Download
1. Download LM Studio from the official site or vendor.

## 🛠️ Platform Install
2. Follow platform-specific install instructions (Windows .exe, macOS dmg, Linux tar/installer).

Expand this file with exact commands for each platform when ready.

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
