# oMLX on macOS — Getting Started

oMLX is particularly interesting on Apple Silicon because it gives you a **native MLX-based inference server with a web administration interface**, rather than just another command-line model runner.

The current oMLX project provides a macOS/Homebrew service, an `/admin` dashboard, built-in chat, model downloading, model management, benchmarking, and per-model configuration. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

---

## 1. Installation with Homebrew

Since you already use a Brewfile, the installation can be kept very simple.

Your Brewfile can contain:

```ruby
tap "jundot/omlx", "https://github.com/jundot/omlx"

brew "jundot/omlx/omlx"
```

Then:

```bash
brew bundle
```

Or, if installing directly:

```bash
brew tap jundot/omlx https://github.com/jundot/omlx
brew install jundot/omlx/omlx
```

Verify:

```bash
omlx --help
```

And check the installed version:

```bash
omlx --version
```

For an existing installation, upgrading is simply:

```bash
brew update
brew upgrade omlx
```

The current project recommends Homebrew for a CLI/service-oriented installation and provides `omlx start`, `stop`, and `restart` commands. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

---

# 2. Start oMLX

This is the command I would teach first:

```bash
omlx start
```

This starts oMLX as a **background macOS service**.

You don't need to leave a Terminal window open.

Check the Homebrew service:

```bash
brew services info omlx
```

You can also use:

```bash
brew services list
```

You should see oMLX running.

### Stop

```bash
omlx stop
```

### Restart

```bash
omlx restart
```

Or equivalently:

```bash
brew services restart omlx
```

The oMLX service uses a default model directory of:

```text
~/.omlx/models
```

and listens on:

```text
localhost:8000
```

unless you've customized the configuration. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

---

# 3. Open the Admin Dashboard

Once oMLX is running, open your browser. If you see API Key creation, proceed to create API key & keep the password safe.

```text
http://localhost:8000/admin
```

This is the **oMLX control center**.

You can also go directly to the built-in chat:

```text
http://localhost:8000/admin/chat
```

The project documents `/admin` as the main web UI for:

- real-time monitoring
- model management
- model downloading
- chat
- benchmarking
- per-model configuration
- integrations [GitHub](https://github.com/jundot/omlx/blob/main/README.md)


---

# 4. Understanding the Admin Dashboard

Think of the dashboard as the equivalent of the **control plane** for your local LLM server.

Instead of doing everything with:

```bash
ollama pull ...
ollama run ...
```

you're managing the MLX inference environment from a browser.

The major areas you'll want to learn are:

| Area | Purpose |
|---|---|
| **Dashboard** | Server health, activity and resource information |
| **Models** | Discover, download, load/unload and manage models |
| **Chat** | Directly interact with models |
| **Benchmark** | Test model performance |
| **Settings** | Server/system configuration |
| **Per-model settings** | Sampling, aliases, TTL, profiles, etc. |
| **Integrations** | Connect tools such as OpenClaw, OpenCode, Codex, Hermes Agent, etc. |

The exact UI evolves fairly rapidly, so think of these as **functional areas rather than fixed button names**.

---

# 5. First Stop: Models

The **Models** section is probably where you'll spend most of your initial time.

The current dashboard has several model-management functions, including:

- **Manager**
- **Downloader**
- **Quantizer**
- **Uploader**

The Manager displays models that oMLX can find locally, while the Downloader lets you find MLX models from Hugging Face directly from the dashboard. [GitHub](https://github.com/jundot/omlx/blob/main/omlx/admin/templates/dashboard/_models.html)

### Model Manager

This is where you'll see your installed models.

For each model you can see things such as:

- model name
- model type
- model size
- loaded/unloaded state
- settings
- model alias

The dashboard also provides controls for loading and unloading models.

---

# 6. Download Your First Model

This is probably the **best first-time oMLX experience**.

Go to:

**Models → Downloader**

Rather than manually finding an MLX model, copying it somewhere and configuring paths, use the built-in downloader.

oMLX can search Hugging Face for MLX models and download them directly from the administration interface. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

For your first experiment, I'd deliberately choose something **small enough that you can experiment rapidly** rather than immediately loading a giant model.

For example:

```text
Qwen
Llama
Mistral
Gemma
```

with an MLX-compatible quantization appropriate for your Mac.

The important thing at this stage isn't finding the "best" model.

It's learning the workflow:

```text
Hugging Face
      ↓
oMLX Downloader
      ↓
MLX model
      ↓
Model Manager
      ↓
Load
      ↓
Chat
```

That's the oMLX workflow you want to internalize.

---

# 7. Load the Model

After downloading, go back to:

**Models → Manager**

You should see the model.

Load it.

Once loaded, oMLX keeps the model available to serve inference requests.

One of the useful differences from the simple `ollama run` mental model is that oMLX is designed as a **multi-model server**.

It can manage:

- multiple LLMs
- VLMs
- OCR models
- embedding models
- rerankers

and can automatically evict models when memory pressure requires it. You can also manually load/unload models, pin models, and configure per-model idle TTLs. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

---

# 8. Your First Chat

Now go to:

```text
http://localhost:8000/admin/chat
```

Select your model and start chatting.

For your first experiment, don't try to benchmark it yet.

Give it a practical prompt such as:

```text
Explain how Apple Silicon unified memory changes the way
local LLM inference works compared with an NVIDIA GPU.
```

Then try a coding prompt:

```text
Write a Python script that monitors CPU, GPU,
memory usage and temperature on macOS.
Explain how the script works.
```

Then try a reasoning prompt:

```text
I have several local LLMs available on my Mac.

Design a strategy for deciding which model should handle:
1. general chat
2. coding
3. reasoning
4. large-context documents
5. agentic tasks

Explain your reasoning.
```

The point is to get familiar with **model switching and behavior**, not just token speed.

---

# 9. Per-Model Settings

This is one of the areas I recommend you spend time exploring.

oMLX lets you configure settings **per model** directly from the dashboard. Changes can be applied without restarting the server. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

Depending on the model, you'll encounter things such as:

### Sampling

Examples include:

```text
temperature
top_p
top_k
```

These influence how deterministic or exploratory generation is.

### Model Alias

You can give a model a friendlier API name.

For example:

```text
Qwen3-Coder-Next-8bit
```

could have an API alias such as:

```text
coding
```

Then your clients can reference the alias.

### TTL

TTL controls how long an idle model remains loaded.

This becomes particularly useful when you have several models competing for unified memory.

### Model Type

You can override automatic model-type detection when necessary.

### Profiles

This is a particularly interesting feature.

You can create named configurations such as:

```text
qwen-coder
qwen-coder-thinking
qwen-coder-fast
```

without creating separate copies of the model.

The profile overlays different settings on the same underlying model. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

---

# 10. Model Memory Management

This is another feature worth experimenting with early.

Imagine your Mac has:

```text
Model A
Model B
Model C
```

You don't necessarily want all three consuming unified memory simultaneously.

oMLX supports:

**Automatic LRU eviction**

Least-recently-used models can be unloaded when memory becomes constrained.

**Manual load/unload**

You can explicitly control which models are resident.

**Pinning**

Frequently used models can be pinned so they remain loaded.

**TTL**

A model can automatically unload after being idle for a configured period.

This is where oMLX starts feeling less like:

> "a program that runs an LLM"

and more like:

> **"an inference server managing a local model pool."** [GitHub](https://github.com/jundot/omlx/blob/main/README.md)


---

# 11. Built-in Benchmark

Once you've become comfortable chatting with a model, try the **Benchmark** functionality.

This is where I'd start your actual oMLX learning.

Instead of asking:

> "Which model feels faster?"

you can begin measuring:

```text
prompt processing
generation speed
latency
throughput
memory behavior
```

Then eventually compare:

```text
              Same Model
                  │
        ┌─────────┼─────────┐
        ↓         ↓         ↓
      Ollama   LM Studio   oMLX
```

on the **same Mac**.

That will give you a much more meaningful understanding of what MLX/oMLX is actually doing.

---

# 12. The Dashboard's Most Important Concept

Don't think of the oMLX dashboard as merely a **chat interface**.

That's probably the least interesting part.

Think of it as:

```text
                 oMLX
                   │
       ┌───────────┼───────────┐
       │           │           │
    Models      Runtime      Clients
       │           │           │
       ↓           ↓           ↓
   Download     Memory      Chat
   Load         Cache       OpenAI API
   Unload       Batching    Agents
   Pin          Metrics     Coding tools
   Profiles
```

The browser chat is simply the easiest way to prove that the inference server is working.

---

# 13. First-Time Learning Path

For your first oMLX session, I'd do exactly this:

### Step 1

Start:

```bash
omlx start
```

### Step 2

Open:

```text
http://localhost:8000/admin
```

### Step 3

Go to:

**Models → Downloader**

Download one modest MLX model.

### Step 4

Go to:

**Models → Manager**

Load the model.

### Step 5

Open:

```text
http://localhost:8000/admin/chat
```

Chat with it.

### Step 6

Return to the model settings.

Experiment with:

```text
temperature
context
TTL
alias
profiles
```

### Step 7

Load a second model.

Experiment with:

```text
Model A → unload
Model B → load
Model A → load
```

Observe how oMLX manages memory.

### Step 8

Run the benchmark.

Now you're actually learning the **server**, rather than simply learning how to chat with an LLM.

---

# 14. Useful macOS Commands

Keep this little cheat sheet in your oMLX notes:

```bash
# Start
omlx start

# Stop
omlx stop

# Restart
omlx restart

# Check Homebrew service
brew services info omlx

# See all Homebrew services
brew services list

# Upgrade
brew update
brew upgrade omlx
```

Useful locations:

```text
~/.omlx/
```

Default models:

```text
~/.omlx/models/
```

Server log:

```text
~/.omlx/logs/server.log
```

Homebrew service log:

```text
$(brew --prefix)/var/log/omlx.log
```

The project documents these locations and the managed-service behavior. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

---

# 15. Two URLs to Remember

### Administration

```text
http://localhost:8000/admin
```

### Chat

```text
http://localhost:8000/admin/chat
```

And later, when you start connecting applications:

```text
http://localhost:8000/v1
```

is the OpenAI-compatible API endpoint. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

---

## What I would consider your "Day 1" oMLX goal

Don't start with agents, distributed inference, API integrations, or complicated configurations.

Get to this point first:

```text
                  macOS
                    │
                    ▼
                  oMLX
                    │
          ┌─────────┴─────────┐
          │                   │
       Dashboard             API
          │                   │
      ┌───┴────┐              │
      │        │              │
   Models     Chat       Future clients
      │
      ├── Download
      ├── Load
      ├── Unload
      ├── Settings
      ├── Profiles
      └── Benchmark
```

Once that feels natural, **then** the really interesting part begins: using oMLX as the persistent inference backend for things like OpenClaw, OpenCode, Codex, and Hermes Agent. The current oMLX dashboard even exposes integration setup for several of these tools. [GitHub](https://github.com/jundot/omlx/blob/main/README.md)

