
# 🧠 VS Code + AI Coding Agent Setup (ML/AI Focus)

## 🧰 Core Stack Overview

You want 3 layers working together:

1. **Editor (VS Code)** → your command center
2. **AI Agent(s)** → coding + reasoning + refactoring
3. **Version Control (GitHub)** → memory + collaboration + CI/CD

---

## ⚙️ 1. Install VS Code + Core Extensions

### 🔹 Must-Have Extensions

* **Python** (by Microsoft)
* **Pylance** → fast type checking / IntelliSense
* **Jupyter** → notebook support inside VS Code
* **GitHub Pull Requests & Issues**
* **Docker** (if doing ML infra or containers)

---

### 🤖 AI Coding Agents (Choose 1–2 max)

#### 🥇 Top Tier (Agent-style, not just autocomplete)

* **Cursor**

  * Full AI-native IDE (VS Code fork)
  * Best for deep codebase reasoning
  * Can refactor across files, explain systems

* **GitHub Copilot**

  * Strong inline + chat + PR review
  * Best balance of stability + power

* **Continue**

  * Open-source agent framework
  * Supports multiple models (local + API)

---

### 🧠 Optional (Advanced / Power Users)

* **Ollama**
  → run local models (privacy + offline)

* **LangChain**
  → build your own agents

---

## 🔐 2. API Key Setup (Critical Step)

Depending on your AI tool:

### 🔑 OpenAI (or compatible providers)

1. Go to provider dashboard (OpenAI, etc.)
2. Generate API key
3. Store securely:

#### Option A — Environment Variable (recommended)

```bash
# Windows PowerShell
setx OPENAI_API_KEY "your_api_key_here"

# Mac/Linux
export OPENAI_API_KEY="your_api_key_here"
```

#### Option B — `.env` file (project-level)

```bash
OPENAI_API_KEY=your_api_key_here
```

Then load it in Python:

```python
from dotenv import load_dotenv
import os

load_dotenv()
api_key = os.getenv("OPENAI_API_KEY")
```

---

### 🔐 VS Code Integration

For **Continue**:

```json
// ~/.continue/config.json
{
  "models": [
    {
      "title": "GPT",
      "provider": "openai",
      "model": "gpt-4.1",
      "apiKey": "YOUR_KEY"
    }
  ]
}
```

---

## 🧠 3. Recommended Project Structure (ML/AI)

```bash
project/
│
├── src/                 # core logic
├── notebooks/           # experiments
├── data/                # datasets
├── models/              # saved models
├── tests/               # unit tests
├── .env                 # secrets
├── requirements.txt
└── README.md
```

---

## 🔁 4. GitHub Integration (Non-Optional IMO)

Use GitHub as:

* Version control
* Prompt memory (via commits)
* Experiment tracking (lightweight)

### Setup

```bash
git init
git add .
git commit -m "initial ML setup"
git branch -M main
git remote add origin https://github.com/your/repo.git
git push -u origin main
```

---

### 🔥 Power Move: AI + GitHub Workflow

* Use Copilot or Cursor to:

  * Generate PR summaries
  * Review diffs
  * Suggest refactors

---

## 🧪 5. Real Use Cases (Where AI Actually Shines)

### ⚡ Use Case 1 — Rapid Model Prototyping

Prompt:

> “Build a PyTorch model for time-series anomaly detection with training loop and evaluation metrics.”

AI will:

* Scaffold model
* Add training loop
* Suggest loss functions

---

### ⚡ Use Case 2 — Codebase Refactor

Prompt:

> “Refactor this pipeline into modular components with dependency injection.”

Agent can:

* Split files
* Rename functions
* Improve structure

---

### ⚡ Use Case 3 — Debugging at Scale

Paste error:

```python
RuntimeError: CUDA out of memory
```

Prompt:

> “Optimize memory usage for this training loop.”

AI suggests:

* Batch size tuning
* Gradient accumulation
* Mixed precision

---

### ⚡ Use Case 4 — Data Engineering

Prompt:

> “Build a pipeline to ingest CSV → clean → feature engineer → store in parquet.”

---

### ⚡ Use Case 5 — Infra + Automation

Prompt:

> “Create Dockerfile for this ML app with GPU support.”

---

## 🧠 6. Advanced Setup (Agent-Level Workflow)

### Combine:

* VS Code + Continue
* OpenAI API
* Local embeddings / vector DB

You get:

👉 A **context-aware coding agent** that:

* Knows your repo
* Searches files
* Writes multi-file changes

---

## 🧩 Example: Continue + Codebase Awareness

Prompt:

> “Find where model training happens and add logging + checkpointing.”

Agent will:

* Search repo
* Modify relevant files
* Maintain consistency

---

## ⚠️ Pitfalls (From Real Usage)

* ❌ Too many extensions → conflicts
* ❌ Blind trust in generated code
* ❌ No version control checkpoints
* ❌ API keys hardcoded (security risk)

---

## 🧭 Recommended Setup: 

For local models, make sure you can connect to network:

👉 Go with:

* **VS Code**
* **Continue (multi-model flexibility)**
* **Copilot (fallback + PR integration)**
* Optional: **Ollama for local models**
