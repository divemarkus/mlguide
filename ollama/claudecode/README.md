
# 🍎 macOS Local AI Setup Guide — Ollama MLX + Claude Code + Qwen3.5 Coding Models

> A practical guide for running modern local LLM workflows on a MacBook Pro using Apple Silicon, Ollama MLX acceleration, and Claude Code.

---

![Image](https://images.openai.com/static-rsc-4/kPfLY2g2ldLfinTRkSxFMFAmxejg0promG22AUR3Tm5A4BdeIkfh9Sql5nsAdXDZTETM-Bq5nlC-eoQch6TikC_pcnhPF2dKvpLo7Uqz0k-5DWmhQobf_KhHJ1J_MFP9DAokbBn8ockIEwkbmgkAI9jOvi0FWYY1gZUURqyQUyuYQcrueGk1-iD3ewyWNz8n?purpose=fullsize)


## 🧠 What Changed Recently?

[Ollama MLX Blog Post](https://ollama.com/blog/mlx?utm_source=chatgpt.com)

Ollama now supports Apple’s **MLX framework** more deeply, which significantly improves:

* Apple Silicon GPU utilization
* Memory efficiency
* Battery life during inference
* Unified memory usage
* Local LLM responsiveness on macOS

This is a major step for:

* MacBook Pro users
* Local coding agents
* Portable AI workstations
* Privacy-first AI development

---

# 🚀 The Goal

Run this stack locally on macOS:

```text
Claude Code
     ↓
Ollama
     ↓
Qwen3.5 Coding Model (MLX accelerated)
     ↓
Apple Silicon GPU + Unified Memory
```

---

# 💻 Tested Hardware

## Your Experience

You tested:

| Hardware                                  | Result         |
| ----------------------------------------- | -------------- |
| Apple MacBook Pro (16-inch, 2021, M1 Pro) | ✅ Worked well |
| 32GB Unified Memory                       | ✅ Stable      |
| Ollama + Claude Code                      | ✅ Functional  |
| Qwen3.5 35B Coding Model                  | ✅ Usable      |

Your screenshot confirms:

```bash
ollama launch claude --model qwen3.5:35b-a3b-coding-nvfp4
```

…and Claude Code successfully used the local model for:

* repository analysis
* debugging
* code rewriting
* browser game generation

The workflow looked stable on an M1 Pro 32GB system.

---

# 🧠 Why Apple Silicon Works Surprisingly Well

Apple Silicon is uniquely good for local inference because of:

## Unified Memory

Instead of:

* VRAM
* system RAM

…being separate like NVIDIA laptops,

MacBooks use:

```text
CPU + GPU + Neural Engine
        ↓
Shared Unified Memory Pool
```

Meaning:

* large models spill gracefully into RAM
* memory management is efficient
* low power draw
* excellent thermals

---

# ⚡ Why MLX Matters

MLX is Apple’s machine learning framework.

Think of it as:

* Apple’s CUDA alternative
* optimized for Metal + Apple GPUs

Compared to older CPU-heavy inference:

| Runtime            | Mac Performance |
| ------------------ | --------------- |
| llama.cpp GGUF     | Good            |
| Ollama traditional | Better          |
| MLX accelerated    | Best            |

---

# 🧠 Recommended Models

## Coding Models

### Your tested model

```bash
ollama pull qwen3.5:35b-a3b-coding-nvfp4
```

Your screenshot shows:

* ~21GB model size
* running successfully via Claude Code

---

# 🧰 Install Ollama on macOS

## Official Site

[Ollama Official Website](https://ollama.com/?utm_source=chatgpt.com)

---

## Quick Install

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Or install with Homebrew:

```bash
brew install ollama
```

(Recommended since you already prefer Homebrew workflows.)

---

# ▶️ Start Ollama

```bash
ollama serve
```

Default API:

```text
http://localhost:11434
```

---

# 🧠 Pull Your Model

## Your tested model

```bash
ollama pull qwen3.5:35b-a3b-coding-nvfp4
```

---

# 🤖 Install Claude Code

## Official Site

[Claude Code by Anthropic](https://www.anthropic.com/claude-code?utm_source=chatgpt.com)

---

## Example Install

```bash
npm install -g @anthropic-ai/claude-code
```

---

# 🔌 Connect Claude Code to Ollama

Example workflow:

```bash
ollama launch claude --model qwen3.5:35b-a3b-coding-nvfp4
```

Screenshot demonstrates this exact workflow successfully.

---

# 🧠 What Claude Code Was Able To Do

From screenshot:

✅ Search repository
✅ Read HTML game files
✅ Detect syntax errors
✅ Rewrite broken code
✅ Explain logic issues
✅ Generate working replacement game

This aligns well with:

* coding agent workflows
* local repo analysis
* AI-assisted debugging

---

# 🔒 Why This Setup Is Powerful

## Advantages

| Feature             | macOS Apple Silicon |
| ------------------- | ------------------- |
| Battery life        | Excellent           |
| Noise               | Silent              |
| Heat                | Low                 |
| Portability         | Excellent           |
| Unified memory      | Huge advantage      |
| Local coding agents | Excellent           |

---

# ⚠️ Limitations

## Things Macs still struggle with

| Task                             | Status |
| -------------------------------- | ------ |
| CUDA training                    | ❌      |
| Large fine tuning                | ⚠️     |
| 70B+ heavy inference             | ⚠️     |
| Enterprise distributed inference | ❌      |

---

# 📊 Real-World MacBook Expectations

## M1 Pro 32GB (your system)

| Workload       | Result              |
| -------------- | ------------------- |
| 7B models      | Excellent           |
| 13B models     | Excellent           |
| 35B coding MoE | Surprisingly usable |
| LM Studio      | Smooth              |
| Claude Code    | Works well          |

---

# 🧠 Useful Ollama Commands

## List models

```bash
ollama list
```

---

## Run model

```bash
ollama run qwen3.6:latest
```

---

## Remove model

```bash
ollama rm modelname
```

---

# 🧩 Screenshot Findings

Screenshot is valuable because it demonstrates:

## Real-world confirmation that:

✅ M1 Pro 32GB is enough for meaningful local AI workflows
✅ Claude Code can operate against local models
✅ Qwen coding models work well locally (this model precisely)
✅ macOS is now a legitimate AI dev platform

---

# 🔥 Final Thoughts

Apple Silicon has evolved from:

> “not useful for AI”

to:

> “one of the best portable local AI development platforms available.”

Especially for:

* coding agents
* local inference
* RAG
* prompt engineering
* privacy-first AI workflows

Your M1 Pro 32GB result confirms:

* local coding agents are already practical
* MLX acceleration matters
* Ollama + Claude Code is a very viable setup

---
