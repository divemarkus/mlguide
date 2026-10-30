# Hermes Agent Knowledge Base

**Created:** October 30, 2026  
**Last Updated:** October 30, 2026  
**Version:** 1.0  
**Owner:** CEO  
**Status:** Active  

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Model Support](#model-support)
4. [Desktop App](#desktop-app)
5. [Local Models & llama.cpp](#local-models--llamacpp)
6. [Capabilities](#capabilities)
7. [Use Cases](#use-cases)
8. [Installation & Configuration](#installation--configuration)
9. [Best Practices](#best-practices)
10. [Appendix: Command Reference](#appendix-command-reference)

---

## Overview

Hermes is a general-purpose AI agent framework built by Nous Research, designed to bridge natural language inputs to executable actions across the machine. It operates as a desktop application on macOS, leveraging local LLM backends (llama.cpp) for privacy-first, offline-capable intelligence.

### Core Identity

- **Base Model:** Qwen3.5-4B (4-bit quantized via MLX)
- **Quantization:** MLX-4bit quantization (Apple Silicon optimized)
- **Backend:** llama.cpp / MLX runtime
- **Provider:** "custom" (self-hosted/local)
- **Platform:** macOS 14+ (Apple Silicon M1/M2/M3/M4)
- **Optimization:** 4-bit quantization, MLX acceleration

### Purpose

Hermes acts as an **orchestration layer** between natural language (your queries) and tool execution (browsing, code, data). It's not just a chatbot — it's a **productivity agent** that executes workflows across your local machine.

### Key Differentiators

| **Feature** | **Description** |
|-------------|-----------------|
| **Local-First** | All model inference runs locally (no API calls) |
| **Privacy** | No data leaves your machine; zero remote transmission |
| **Apple Silicon** | Native MLX support on M-series chips |
| **Tool-Rich** | 18+ categories of executable tools |
| **Persistent** | Memory and skills survive sessions |

---

## Architecture

### High-Level Flow

```
[User Input] → [Model Inference] → [Tool Descriptor] → [Tool Execution] → [Output]
    ↓            ↓                  ↓                  ↓               ↓
  Natural        Qwen3.5-4B         JSON Schema        CLI/API         Markdown/File
  Language                                            (hermes_tools)    MEDIA:/
```

### Components

#### 1. **Model Layer**
- **Qwen3.5-4B-MLX-4bit**: Main inference engine
- **llama.cpp / MLX**: Runtime for 4-bit quantized models
- **Optimization:** 4-bit quantization reduces VRAM usage while maintaining quality
- **Apple Silicon:** Native support via MLX hardware acceleration

#### 2. **Tool Layer (`hermes_tools`)**
- **18+ Tool Categories:** Browser, dev, productivity, creative, etc.
- **Schema Validation:** Pre-loaded JSON schemas define parameters
- **Batch Execution:** Multiple tools can run in parallel
- **Fallbacks:** `blocked-page-recovery`, `blocked-page-recovery`

#### 3. **Memory & Skills**
- **Persistent Memory:** Session-surviving facts (`/Users/ceo/.hermes/memories/`)
- **Procedural Memory (Skills):** Loadable task-specific procedures (`/Users/ceo/.hermes/skills/`)
- **Skills System:** `skill_view()` loads skills before execution

#### 4. **Desktop UI**
- **Preview Panes:** Real-time application viewing
- **Notifications:** System alerts for long jobs, deadlines
- **Terminal Access:** Direct CLI integration
- **Desktop Integration:** Full system access (file system, services)

---

## Model Support

### Supported Models

| **Model** | **Quantization** | **VRAM Required** | **Performance** |
|-----------|------------------|-------------------|-----------------|
| Qwen3.5-4B-MLX-4bit | 4-bit (MLX) | ~4GB (base) | ⚡ MLX native acceleration |
| Qwen3.5-8B-MLX-4bit | 4-bit | ~8GB | Good balance |
| Llama-3-8B-4-bit | 4-bit (llama.cpp) | ~8GB | Good quality |
| Mistral-7B-4-bit | 4-bit | ~8GB | Fast inference |

### Apple Silicon Support

**M1/M2/M3/M4 chips:**
- **MLX Runtime:** Native metal/metal2/metal3 support
- **4-bit Quantization:** Enables 4GB+ VRAM to run 4-8B models
- **Int4/Q4_K_M:** Recommended quantization levels

### Model Loading Patterns

```python
from hermes_tools import web_search, terminal, skill_view

# Load skill before use
skill_view(name='codebase-inspection')

# Initialize tools
web_search(query="...", limit=3)
```

---

## Desktop App

### Features

- **Visual Preview Pane:** Real-time application viewing (IDE, browser, terminal)
- **System Notifications:** Alerts for long jobs, deadlines, security events
- **Terminal Access:** Direct CLI command execution
- **File System:** Full read/write access (USER root)
- **Connectors:** Integrated app accounts (Gmail, Notion, Linear)

### Required macOS Version

- **Minimum:** macOS 14 (Sonoma)
- **Recommended:** macOS 15 (Sequoia) 26.x

### Installation

```bash
# Install Hermes
brew install hermes

# Or via CLI
hermes install

# Configure profile
hermes profile create --name "ceo"
```

### Active Profile

- **Default Profile:** `/Users/ceo/.hermes/profiles/default`
- **Custom Profiles:** `/Users/ceo/.hermes/profiles/{name}/`

---

## Local Models & llama.cpp

### llama.cpp Integration

Hermes leverages **llama.cpp** for high-quality, open-model support:

- **Direct Model Loading:** No API keys required
- **Offline Capable:** All inference local
- **Format Support:** GGUF, Quantized GGUF
- **Tool Call Templates:** Built-in support for structured tool calls

### Typical Local Setup (Apple Silicon)

1. **Ensure MLX is installed** (bundled with Hermes)
2. **Load 4-bit model**: Qwen3.5-4B-MLX-4bit or llama.cpp model
3. **Set environment variables:**
   ```bash
   export HERMES_MODEL="Qwen3.5-MLX"
   export HERMES_QUANTIZATION="4-bit"
   ```

### Model Sizes (Approximate)

| **Model** | **4-bit (KB)** | **VRAM Used** |
|-----------|---------------|---------------|
| Qwen3.5-4B | ~4GB | ~4.2GB |
| Llama-3-8B | ~8GB | ~8.5GB |
| Mistral-7B | ~7GB | ~7.8GB |

### Acceleration

- **MLX Runtime:** Native metal acceleration on Apple Silicon
- **CPU Fallback:** Graceful degradation on non-Apple Silicon
- **Batch Processing:** Parallel tool calls leverage multi-core

---

## Capabilities

### Tool Categories (18+)

| **Category** | **Tools** | **Primary Use** |
|--------------|-----------|----------------|
| **Browser** | `web_search`, `web_extract`, `blocked-page-recovery`, `browser_vault` | Research, content fetch, 429 recovery |
| **Terminal** | `terminal`, `python-debugpy`, `node-inspect-debugger`, `manage_connections` | CLI, debug, manage |
| **Code** | `codebase-inspection`, `requesting-code-review`, `simplify-code` | Inspect, review, clean |
| **Productivity** | `xlsx`, `powerpoint`, `docx`, `google-workspace`, `meeting-action-items` | Reports, docs, calendar |
| **Email** | `email-inbox-triage`, `himalaya`, `xurl` | Inbox, terminal email, social |
| **Research** | `arxiv`, `grounded-citations`, `competitor-news-monitor` | Papers, citations, news |
| **Social Media** | `xurl`, `gif-search`, `songsee` | Posts, media, audio |
| **Creative** | `architecture-diagram`, `popular-web-designs`, `manim-video`, `p5js` | Visuals, design, animation |
| **Media** | `youtube-content`, `songwriting-and-ai-music`, `gifs` | YouTube, audio, GIFs |
| **Note Taking** | `obsidian`, `note-taking`, `session_search` | Knowledge base, search |
| **Multi-Agent** | `autonomous-ai-agents`, `claude-code`, `opencode` | Multi-agent work, code gen |
| **Desktop** | `desktop_project`, `focus_pane`, `gui_tour`, `manif` | UI, dev environment |
| **Education** | `weekly-review-planning`, `todo_list`, `skill_manage` | Planning, tasks |
| **Block Recovery** | `blocked-page-recovery` | 429, 403, rate limits |
| **Assistant** | `manage_connections`, `chat` | Connectors, chat |

### Key Tool Patterns

**Web + Tool Pattern:**
```python
# Search then extract
results = web_search(query="home assistant 2026", limit=3)
urls = [r['url'] for r in results['data']['web']]
content = web_extract(urls=urls)
```

**Code Pattern:**
```python
# Inspect codebase
skill_view(name='codebase-inspection')
inspection = codebase_inspection(repo_path="/path/to/repo")
```

**Local Model Pattern:**
```python
# Use local model via hermes_tools
from hermes_tools import web_search, terminal

# All inference local (via MLX/llama.cpp)
results = web_search(query="my research topic")
```

---

## Use Cases

### 1. Home Automation (Home Assistant)

| **Use Case** | **Tools** |
|--------------|-----------|
| Integrate HA components | `codebase-inspection`, `python-debugpy`, `terminal` |
| Debug integrations | `requesting-code-review`, `simplify-code`, `python-debugpy` |
| System monitoring | `weekly-review-planning`, `todo_list`, `product-price-monitor` |
| Documentation | `docx`, `xlsx`, `meeting-action-items`, `powerpoint` |

### 2. Trading (Stocks & Crypto)

| **Use Case** | **Tools** |
|--------------|-----------|
| Market research | `web_search`, `web_extract`, `blocked-page-recovery` |
| Price monitoring | `product-price-monitor`, `competitor-news-monitor` |
| Data export | `xlsx`, `google-workspace` |
| Trading analysis | `powerpoint`, `meeting-action-items` |

### 3. Code Development

| **Use Case** | **Tools** |
|--------------|-----------|
| Inspect code | `codebase-inspection` |
| Debug | `python-debugpy`, `node-inspect-debugger`, `systematic-debugging` |
| Code review | `requesting-code-review` |
| Clean code | `simplify-code` |
| Documentation | `docx`, `meeting-action-items` |

### 4. Knowledge Management

| **Use Case** | **Tools** |
|--------------|-----------|
| Personal notes | `obsidian`, `note-taking` |
| Session history | `session_search` |
| Task tracking | `todo_list`, `weekly-review-planning` |
| Skills library | `skill_manage` |

### 5. Creative/Design

| **Use Case** | **Tools** |
|--------------|-----------|
| Architecture diagrams | `architecture-diagram` |
| Web design | `popular-web-designs` |
| Video animation | `manim-video` |
| Interactive art | `p5js`, `ascii-video` |

---

## Installation & Configuration

### Prerequisites

- **macOS 14+ (Sonoma or later)**
- **Apple Silicon (M1/M2/M3/M4)** — preferred for MLX acceleration
- **Disk space:** ~4-10GB for 4-bit models
- **VRAM:** 8GB+ for 8B models (4B can run on 4GB+ with swapping)

### Installation Steps

```bash
# 1. Install Hermes CLI
brew install hermes  # or via Xcode

# 2. Configure model
hermes model set "Qwen3.5-MLX-4bit"

# 3. Create profile
hermes profile create --name "ceo"

# 4. Verify installation
hermes status
```

### Configuration Files

- **Main Config:** `~/.hermes/config.yaml`
- **Profiles:** `~/.hermes/profiles/`
- **Skills:** `~/.hermes/skills/`
- **Memories:** `~/.hermes/memories/`
- **Scratch:** `~/.hermes/cache/scratch/`

### Example Configuration

```yaml
# ~/.hermes/config.yaml

model:
  name: "Qwen3.5-MLX-4bit"
  quantization: "4-bit"
  path: "/Users/ceo/.hermes/models/Qwen3.5-MLX-4bit.gguf"

output:
  format: "markdown"
  console: true

tools:
  web_search_limit: 5
  web_extract_max_urls: 5
  blocked_page_retries: 3

notifications:
  enable: true
  on_schedule: true
```

---

## Best Practices

### 1. **Skill-First Approach**
Always load relevant skills before using tools:
```python
skill_view(name='codebase-inspection')
```

### 2. **Memory Discipline**
- Store only **high-signal facts** (e.g., "CEO owns domain x.com", "HA uses MQTT port 4567")
- Memory has a **character limit** (~50k chars) — consolidate stale entries
- Don't store full conversations, just persistent facts

### 3. **Parallel Tool Calls**
Batch independent calls:
```python
web_search(query1)
web_search(query2)
```

### 4. **Error Recovery**
Use `blocked-page-recovery` when `web_search`/`web_extract` fails with 429/403.

### 5. **Local-First**
Always prioritize local inference (LLM/API) — no remote API calls unless needed.

### 6. **Profile-Specific Setup**
Create custom profiles for different use cases:
- **`ceo`** profile: production, custom notifications
- **`dev`** profile: dev-focused tools (debug, inspect)

### 7. **Notifications**
Enable notifications for:
- Long-running jobs (compilation, building)
- Scheduled tasks (weekly review)
- Security events
- Deadline warnings

### 8. **Privacy**
- **All inference local** — no API calls
- **Memory sealed** — doesn't leave your machine
- **Tool outputs** — execute in sandboxed context

---

## Appendix: Command Reference

### Common Commands

| **Command** | **Description** |
|-------------|-----------------|
| `hermes status` | List connectors and profile status |
| `hermes model set` | Set active model |
| `hermes profile create` | Create new profile |
| `hermes skill view` | Load skill schema |
| `hermes memory add` | Add fact to memory |
| `hermes connect` | Connect connector account |
| `hermes tools list` | List available tools |

### Example CLI Flow

```bash
# Search
hermes --session mysession "search for HA zwave 2026"

# Extract
hermes --session mysession "extract web content"

# Debug
hermes --session mysession "debug my script"

# Code review
hermes --session mysession "review my PR"

# Notebook
hermes --session mysession "create knowledge base"
```

---

## Version History

| **Version** | **Date** | **Changelog** |
|-------------|----------|--------------|
| 1.0 | Oct 30, 2026 | Initial knowledge base |

---

**Status:** ✅ Active  
**Owner:** CEO  
**Last Reviewed:** October 30, 2026  
**Next Review:** Weekly (or as needed)
