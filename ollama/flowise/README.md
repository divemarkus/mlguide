
# 🤖 Flowise

---

## 🤖 Flowise — Local LLM Workflows (Quick Start)

**Flowise** lets you build AI workflows (agents, RAG pipelines, automations) using a visual UI — fully compatible with **local LLMs via Ollama**.

---

### 🧠 How It Connects (Local-First)

Flowise talks to your local model server:

```text
Flowise → Ollama → Local LLM (llama3, mistral, etc.)
```

**Base URL (inside Docker):**

```text
http://ollama:11434
```

---

### ⚡ Basic Setup

1. Open Flowise:
   `http://localhost:3001`

2. Create a new **Chatflow**

3. Add nodes:

   * **LLM Node** → set provider to *Ollama*
   * **Base URL:** `http://ollama:11434`
   * **Model:** `llama3` (or any pulled model)

4. Connect nodes → Deploy

---

### 🧩 Common Local Workflows

#### 1. Simple Chatbot

* LLM Node → Chat Output
  👉 Local ChatGPT-style bot (no cloud)

---

#### 2. RAG (Document Q&A)

* Document Loader
* Text Splitter
* Embeddings
* Qdrant (vector DB)
* LLM

👉 Ask questions about your own files

---

#### 3. Tool / Agent Workflow

* LLM
* Tools (HTTP, scripts, APIs)
* Memory (Qdrant)

👉 Build automation agents (infra, coding, data tasks)

---

### 🔒 Privacy Benefits

* All inference runs through **Ollama locally**
* Documents stay in **Qdrant locally**
* No API keys required

---

### ⚠️ Tips

* Start with **7B–8B models** (best for your GPU)
* Keep flows simple at first (Flowise can get complex fast)
* Use Qdrant only when you need memory / search

---

### 🚀 When to Use Flowise

Use it when you want to:

* visually design AI workflows
* build agents without writing code
* connect LLMs + memory + tools quickly

---

> Flowise = glue layer between your local LLM and real-world workflows

---
