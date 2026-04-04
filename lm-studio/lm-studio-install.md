# LM Studio Install

Basic notes for installing LM Studio locally. Keep platform-specific steps here for quick reference.

## Table of Contents
1. [Download](#download)  
2. [Platform Install](#platform-install)

---

## ⬇️ Download
1. Download [LM Studio](https://lmstudio.ai/) from the official site or vendor.

## 🛠️ Platform Install
2. Follow platform-specific install instructions (Windows .exe, macOS dmg, Linux tar/installer).

### 🚀 Essential Setup Steps
1. **Download Models**  
   - Use the built-in *Model Hub* or import `.gguf` files manually  
   - Recommended starting models for GPUs:  
     • `Mistral-7B-Instruct-v0.3.Q4_K_M.gguf` (~5GB VRAM)  
     • `Llama-3-8B-Instruct.Q4_K_M.gguf`  (~8GB VRAM)

2. **Configure System Prompt** *(for consistent behavior)*
```prompt
You are a precise Technical Assistant. Provide concise, factual answers.
If you do not know an answer, state that you don't know rather than guessing.
```
→ Click ⋮ next to model → *Presets* → *Copy Preset Identifier*  
→ Paste into chat or save as default in *Settings > Prompts*

3. [Basic Chat](https://github.com/lmstudio-ai/docs/blob/main/0_app/1_basics/chat.md)

---

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

- [AnythingLLM is open-source](https://github.com/Mintplex-Labs/anything-llm) 
- Runs on top of LM Studio/Ollama/vLLM to build knowledge bases, chat apps, and deployable agents.
- **Proceed with caution from installing AI Orchestrator** 

---

### Docker Deployment (Recommended for Windows)
1. Clone & configure:
```bash
git clone https://github.com/Mintplex-Labs/anything-llm.git
cd anything-llm
cp .env.example .env
# Edit .env: set `LLM_PROVIDER=lmstudio`, `LMSTUDIO_BASE_URL=http://host.docker.internal:1234`
```

2. Deploy with [Docker Compose](anythingllm-docker-compose.yml):


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

> 💡 **Tip**: Run `lmstudio server --max-context-length 4096` to cap context and preserve VRAM.

---

