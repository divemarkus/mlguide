# Hermes-Agent on Apple Silicon macOS

**Local LLM • Autonomous Agents • Always-On AI Server**

> Run Hermes-Agent continuously on an Apple Silicon Mac mini using local LLM inference, Metal acceleration, persistent memory, scheduled automation, and macOS `launchd`.

---

## Table of Contents

1. [Overview](#overview)
2. [Background](#background)
3. [What Hermes-Agent Actually Is](#what-hermes-agent-actually-is)
4. [Technical Architecture](#technical-architecture)
5. [Why Apple Silicon](#why-apple-silicon)
6. [Local LLM Options](#local-llm-options)
7. [Recommended Mac mini Architecture](#recommended-mac-mini-architecture)
8. [24/7 Operation](#247-operation)
9. [Always-On Services](#always-on-services)
10. [Use Cases](#use-cases)
11. [Deployment Scenarios](#deployment-scenarios)
12. [Security Model](#security-model)
13. [Resource Planning](#resource-planning)
14. [Recommended Configuration](#recommended-configuration)
15. [Quick Start](#quick-start)
16. [Operational Model](#operational-model)
17. [Future Expansion](#future-expansion)
18. [Summary](#summary)

---

# Overview

Hermes-Agent is an autonomous AI agent created by **Nous Research**.

It is designed to operate beyond a traditional chatbot interaction. Hermes can:

- reason through multi-step tasks
- use tools
- execute commands
- work with files
- browse the web
- interact with APIs
- maintain memory
- create and use skills
- delegate work to subagents
- run scheduled jobs
- operate through messaging platforms
- interact with computers
- run continuously through its Gateway

A particularly important characteristic is that Hermes is designed to **continue becoming useful after the initial conversation**.

The current project describes Hermes as a self-improving agent with a built-in learning loop: it can create skills from experience, improve those skills, persist knowledge, and build a deeper model of the user over time.

For a local-AI environment, this makes Hermes interesting as an **always-on autonomous worker**, rather than simply another interface for talking to an LLM.

---

# Background

Hermes-Agent is developed by **Nous Research**, the organization behind the Hermes family of AI models and other open AI research projects.

The project has evolved considerably beyond its earlier CLI-oriented agent implementation.

The current architecture includes:

- CLI
- Desktop application
- Gateway
- local model support
- scheduled automation
- messaging integrations
- skills
- MCP
- computer use
- subagents
- persistent sessions
- memory
- tool execution
- remote gateways
- local and cloud model providers

Hermes is therefore better understood as an **agent runtime/platform** than simply a Python AI assistant.

---

# Current Version

As of **October 2026**, the latest tagged release is:

**Hermes Agent v0.21.3 — September 14, 2026**

The project is moving very quickly, with frequent releases and substantial changes between versions.

For a self-hosted deployment, pinning the version used in production is recommended rather than blindly tracking `latest`.

---

# What Hermes-Agent Actually Is

A useful mental model is:

```text
                   ┌──────────────────────┐
                   │       USER           │
                   └──────────┬───────────┘
                              │
                              ▼
                   ┌──────────────────────┐
                   │    HERMES AGENT      │
                   │                      │
                   │ Reasoning            │
                   │ Planning             │
                   │ Memory               │
                   │ Tool Selection       │
                   │ Skill System         │
                   │ Delegation           │
                   └──────────┬───────────┘
                              │
              ┌───────────────┼────────────────┐
              │               │                │
              ▼               ▼                ▼
          Local LLM         Tools           Memory
          Metal/MLX        Shell/API       ~/.hermes
              │               │                │
              └───────────────┼────────────────┘
                              ▼
                         ACTION / RESULT
```

The LLM is the **reasoning engine**.

Hermes is the **agent system surrounding the model**.

That distinction is important.

---

# Technical Architecture

The current Hermes architecture can be thought of as several layers.

## 1. Agent Core

Responsible for:

- conversation
- planning
- reasoning
- tool selection
- execution
- context management
- memory
- delegation
- session management

---

## 2. Model Provider

Hermes is not locked to one model provider.

It can communicate with:

- local `llama.cpp`
- Ollama
- OpenAI-compatible endpoints
- OpenRouter
- Nous Portal
- other supported providers

For this deployment, the preferred architecture is:

```text
Hermes
   │
   ▼
Local Model Server
   │
   ▼
Apple Metal
   │
   ▼
Apple Silicon GPU
```

---

# 3. Tool System

Hermes can interact with external systems through tools.

Examples include:

```text
Shell
Filesystem
Code execution
HTTP/API
Git
Browser
Computer Use
MCP
Docker
Custom tools
```

This is what transforms Hermes from:

```text
Question → Answer
```

into:

```text
Goal
  ↓
Reason
  ↓
Choose Tool
  ↓
Execute
  ↓
Observe
  ↓
Reason Again
  ↓
Continue
```

---

# 4. Skills

Hermes has an extensible skill system.

Skills allow reusable workflows to be packaged and invoked by the agent.

For example:

```text
Skill: Docker Health

1. Check Docker
2. List containers
3. Identify unhealthy services
4. Inspect logs
5. Determine likely cause
6. Report findings
7. Optionally restart approved service
```

This becomes particularly useful on an always-on Mac mini.

---

# 5. Memory

Hermes maintains local state under:

```text
~/.hermes/
```

This includes things such as:

```text
~/.hermes/
├── config.yaml
├── .env
├── sessions/
├── cron/
├── logs/
├── pairing/
└── ...
```

The important concept is that the agent can maintain state between interactions rather than treating every conversation as completely independent.

---

# Apple Silicon

Apple Silicon is particularly attractive for local Hermes deployments because CPU, GPU, and memory are tightly integrated through the unified-memory architecture.

Instead of:

```text
CPU RAM
   │
PCIe
   │
GPU VRAM
```

Apple Silicon provides:

```text
             Unified Memory
          ┌──────────────────┐
          │                  │
          │  CPU      GPU    │
          │   │        │     │
          │   └────────┘     │
          │                  │
          └──────────────────┘
```

This is extremely useful for local LLM inference.

Large models don't have to fit inside a traditional discrete GPU's VRAM boundary.

The trade-off is that CPU, GPU, operating system, applications, and model inference all compete for the same unified-memory pool.

Therefore:

> **More unified memory is usually more valuable than raw CPU performance for an always-on local LLM Mac.**

---

# Why the Mac mini Makes Sense

A Mac mini is particularly interesting as an AI server because it combines:

- very low idle power
- silent operation
- small physical footprint
- Apple Silicon GPU
- large unified-memory configurations
- fast internal storage
- wired Ethernet
- macOS Metal
- excellent standby/idle characteristics
- no discrete GPU power supply
- macOS `launchd`
- always-on operation

This makes it an excellent **AI appliance**.

Instead of turning on a workstation every time an agent needs to run:

```text
Mac mini
   │
   ├── Hermes Gateway
   ├── Local LLM
   ├── Scheduled Jobs
   ├── Memory
   ├── Skills
   └── Messaging
```

can remain available continuously.

---

# Local LLM Options

Hermes currently has a very good local-model story on Apple Silicon.

There are three particularly interesting approaches.

---

## Option A — Hermes Managed llama.cpp

This is the simplest approach.

```text
Hermes
   │
   ▼
Managed llama.cpp
   │
   ▼
GGUF Model
   │
   ▼
Metal
   │
   ▼
Apple Silicon
```

Hermes can download and manage the local inference runtime and model.

It can also automatically evaluate the model against available memory and choose an appropriate build/quantization.

This is the **recommended starting point**.

---

# Option B — llama.cpp

Run `llama-server` yourself.

Example architecture:

```text
Hermes
   │
   │ OpenAI-compatible API
   ▼
llama-server
   │
   ▼
GGUF
   │
   ▼
Metal
```

This provides more control over:

- model
- quantization
- context
- KV cache
- parallelism
- networking
- startup parameters

Example:

```bash
brew install llama.cpp
```

Then:

```bash
llama-server \
  -m ~/models/model.gguf \
  -ngl 99 \
  -c 131072 \
  --host 127.0.0.1
```

Hermes can connect to the resulting OpenAI-compatible endpoint.

---

# Option C — MLX / omlx

Apple's MLX ecosystem is particularly interesting for Apple Silicon.

Architecture:

```text
Hermes
   │
   ▼
OpenAI-compatible API
   │
   ▼
omlx
   │
   ▼
MLX
   │
   ▼
Apple Silicon
```

The Hermes documentation currently identifies:

**llama.cpp**

as particularly good for:

- fast time-to-first-token
- GGUF
- quantized KV cache
- memory-constrained systems

while **omlx/MLX** is particularly attractive for:

- native Apple Silicon optimization
- high token-generation throughput
- MLX/Safetensors models

---

# Model Selection

For smaller Apple Silicon systems, Hermes currently recommends **Qwen3.5-9B** as a starting point.

The official example shows approximately:

```text
Qwen3.5-9B Q4
≈ 5.3 GB model
≈ 10 GB RAM at 128K context
```

with quantized KV cache.

For larger models:

```text
27B
35B
```

the documentation recommends **32 GB+ unified memory**.

For an always-on Mac mini, therefore:

| Unified Memory | Hermes Local AI Role |
|---:|---|
| 16 GB | Small local agents |
| 24 GB | Good local-agent machine |
| 32 GB | Strong general-purpose agent |
| 48 GB | Excellent local-agent server |
| 64 GB+ | Large models / larger contexts / multiple workloads |

---

# Recommended Mac mini Architecture

For your environment, I would build the Mac mini around this model:

```text
                         LAN
                          │
                    ┌─────┴─────┐
                    │ Mac mini  │
                    │  macOS    │
                    └─────┬─────┘
                          │
                  ┌───────▼────────┐
                  │ Hermes Gateway │
                  └───────┬────────┘
                          │
              ┌───────────┴───────────┐
              │                       │
              ▼                       ▼
       Local LLM Server           Tool System
       llama.cpp / MLX             │
              │                    ├─ Shell
              ▼                    ├─ Files
         Metal GPU                 ├─ Git
              │                    ├─ APIs
              ▼                    ├─ MCP
       Apple Silicon               └─ Computer Use
              │
              ▼
       Unified Memory
```

---

# 24/7 Operation

This is where Hermes becomes especially interesting.

The key component is the **Hermes Gateway**.

The Gateway provides the persistent runtime for:

- messaging
- scheduled jobs
- automation
- bot operation
- background tasks

The scheduler runs inside the Gateway and checks for due jobs approximately every 60 seconds.

---

# macOS launchd

Hermes provides native macOS integration through `launchd`.

Install the Gateway:

```bash
hermes gateway install
```

Start it:

```bash
hermes gateway start
```

Check it:

```bash
hermes gateway status
```

Logs:

```bash
tail -f ~/.hermes/logs/gateway.log
```

The generated service is:

```text
~/Library/LaunchAgents/ai.hermes.gateway.plist
```

This is much better than leaving a terminal window running:

```bash
hermes gateway
```

because `launchd` manages the persistent background process.

---

# Always-On Architecture

The resulting Mac mini becomes:

```text
                 ┌──────────────────────┐
                 │       macOS          │
                 │                      │
                 │      launchd         │
                 │         │            │
                 │         ▼            │
                 │  Hermes Gateway      │
                 │         │            │
                 │    ┌────┴─────┐      │
                 │    │          │      │
                 │    ▼          ▼      │
                 │  Cron       Bots     │
                 │    │          │      │
                 │    └────┬─────┘      │
                 │         ▼            │
                 │    Local LLM         │
                 │         │            │
                 │       Metal          │
                 │         │            │
                 │    Apple Silicon     │
                 └──────────────────────┘
```

---

# Important 24/7 Consideration

The Mac mini should be configured as a server rather than as a conventional desktop.

Recommended:

```text
System Settings
   ↓
Energy
   ↓
Prevent automatic sleeping
```

Also:

- keep Ethernet connected
- configure automatic restart after power failure where supported
- keep macOS updated deliberately rather than automatically rebooting at unpredictable times
- keep sufficient free SSD space
- monitor memory pressure
- monitor model-server health
- monitor Hermes Gateway logs

The objective is:

```text
Power ON
   ↓
macOS
   ↓
launchd
   ↓
Hermes Gateway
   ↓
Local LLM
   ↓
Ready 24/7
```

---

# What the Mac Mini Can Do While You're Away

This is where an always-on Hermes deployment becomes substantially more interesting.

You could tell Hermes:

```text
Every morning at 07:00:

Check my GitHub repositories.

Look for:
- new issues
- pull requests
- failed CI jobs
- security-related changes

Summarize anything important.
```

Hermes can execute the scheduled task without you being present.

---

# Example: Homelab Monitoring

```text
Every 6 hours:

Check:
- Docker containers
- disk utilization
- system memory
- network availability
- selected services

If something is abnormal:
1. Investigate
2. Collect logs
3. Determine likely cause
4. Send me a report
```

This is an excellent use of the Mac mini.

---

# Example: AI Research Assistant

Schedule:

```text
Every morning:

Search for significant developments
in local LLMs, AI agents and inference.

Prioritize:
- new models
- Apple Silicon developments
- local inference
- agent frameworks
- major GitHub projects

Produce a concise briefing.
```

---

# Example: GitHub Assistant

Hermes can periodically inspect repositories and report:

```text
Repository Health

✓ CI passing
✓ No critical issues
⚠ 3 stale pull requests
⚠ Dependency update available
⚠ 1 security advisory

Recommended action:
...
```

---

# Example: Docker Assistant

The Mac mini can become an AI operations assistant:

```text
Hermes
  │
  ├── docker ps
  ├── docker stats
  ├── docker logs
  ├── inspect services
  └── report anomalies
```

For destructive operations, require explicit approval.

---

# Example: Home Assistant

Hermes can become an AI interface around a home-automation environment.

Architecture:

```text
Home Assistant
       ▲
       │
      MCP
       │
       ▼
Hermes-Agent
       │
       ▼
Local LLM
```

Potential tasks:

- summarize house status
- explain sensor anomalies
- create automations
- investigate device failures
- execute approved automations
- provide natural-language control

---

# Example: Personal AI Assistant

The Mac mini can remain available as:

```text
Telegram
Discord
Slack
Home Assistant
CLI
Web UI
API
       │
       ▼
Hermes Gateway
       │
       ▼
Local LLM
```

You don't necessarily have to sit at the Mac mini to interact with it.

---

# Deployment Scenarios

## Scenario 1 — Simplest

### Hermes + Managed Local Model

```text
macOS
 └── Hermes Desktop
      └── Managed llama.cpp
           └── Local GGUF
```

### Best for

- experimenting
- personal assistant
- minimal administration

---

# Scenario 2 — Always-On AI Server

### Hermes Gateway + llama.cpp

```text
macOS
 ├── launchd
 ├── Hermes Gateway
 ├── llama-server
 └── Local Models
```

### Best for

**Your intended Mac mini deployment.**

---

# Scenario 3 — Hermes + MLX

```text
macOS
 ├── Hermes
 ├── MLX / omlx
 └── Apple Silicon
```

### Best for

Maximum Apple Silicon inference efficiency and experimentation with MLX models.

---

# Scenario 4 — Mac Mini + RTX Workstation

This is the architecture I would find most interesting for your environment.

```text
                         LAN
                          │
             ┌────────────┴────────────┐
             │                         │
             ▼                         ▼
        Mac mini                  RTX Workstation
        macOS                     Ubuntu
             │                         │
        Hermes Gateway            Ollama / vLLM
             │                         │
        Small/Medium              Large Models
        Local Models              Heavy Compute
             │                         │
             └───────────┬─────────────┘
                         │
                       LAN
```

The Mac mini becomes the **always-on control/agent layer**.

The RTX workstation becomes the **heavy inference layer** when a task needs a larger model.

---

# Hybrid Local Architecture

For example:

```text
                    Hermes
                       │
            ┌──────────┴──────────┐
            │                     │
            ▼                     ▼
      Local Mac Model        Remote Local Model
            │                     │
       Apple Metal             RTX GPU
            │                     │
        Qwen 9B                Qwen 27B+
```

This gives you the best of both architectures.

Small tasks stay on the Mac.

Large tasks can be sent to the RTX workstation.

Both remain inside your LAN.

---

# Security Model

An autonomous agent should be treated differently from a normal chatbot.

Hermes may have access to:

- filesystem
- shell
- Git
- Docker
- network
- APIs
- credentials
- messaging systems

Therefore:

> **The agent's permissions should be smaller than the permissions of the human administrator.**

Recommended architecture:

```text
Hermes
   │
   ▼
Restricted Tool Environment
   │
   ├── Read-only where possible
   ├── Limited filesystem paths
   ├── Restricted network access
   ├── No unnecessary credentials
   └── Approval for destructive actions
```

Hermes itself supports Docker as a terminal backend specifically to isolate agent command execution.

---

# Docker Sandbox

For higher-risk operations:

```text
Hermes
   │
   ▼
Docker Terminal Backend
   │
   ▼
Sandbox Container
   │
   ├── CPU limit
   ├── RAM limit
   ├── Restricted filesystem
   └── Restricted network
```

This is preferable to allowing an autonomous agent unrestricted access to the macOS host.

---

# Local Privacy

A completely local deployment can look like:

```text
                    INTERNET
                       X
                       │
                    optional
                       │
                       X
                  ┌───────────┐
                  │ Hermes    │
                  └─────┬─────┘
                        │
                  Local Model
                        │
                     Metal
                        │
                  Apple Silicon
```

No cloud model API is required for local inference.

Hermes also states that it does not collect telemetry, usage analytics, or similar usage data; conversations, memory, and skills are stored locally.

---

# Resource Planning

The most important Mac mini specification for this workload is:

## Unified Memory

For local Hermes agents, prioritize:

```text
RAM > GPU size > CPU cores
```

because the unified memory pool is shared by:

- macOS
- Hermes
- model weights
- KV cache
- inference runtime
- other applications

---

# Practical Configuration

### Entry-Level

```text
Apple Silicon
16 GB unified memory
512 GB SSD
```

Use:

- 7B–9B models
- modest context
- single-user workloads
- scheduled lightweight agents

---

### Recommended

```text
Apple Silicon
32 GB unified memory
1 TB SSD
10 Gb Ethernet if available
```

Excellent for:

- Hermes
- 9B–14B class models
- automation
- RAG
- Home Assistant
- GitHub
- scheduled agents

---

### High-End

```text
Apple Silicon
48–64 GB+ unified memory
1–2 TB+ SSD
10 Gb Ethernet
```

Best for:

- larger local models
- long context
- multiple concurrent workloads
- multiple agents
- larger RAG workloads
- heavier computer-use tasks

---

# Storage

Use the internal NVMe SSD for:

```text
~/models
~/.hermes
model cache
logs
agent state
```

Large model collections can quickly consume storage.

For larger libraries:

```text
Mac mini
   │
   ├── Internal SSD
   │     └── Active models
   │
   └── External Thunderbolt / USB4 storage
         └── Model archive
```

Keep actively used models on fast storage.

---

# Recommended Architecture for Your Mac Mini

I would deploy your Mac mini as:

```text
┌───────────────────────────────────────────────┐
│                MAC MINI                       │
│              Apple Silicon                    │
│                                               │
│  macOS                                        │
│    │                                          │
│    ├── launchd                                │
│    │     │                                    │
│    │     └── Hermes Gateway                   │
│    │                                          │
│    ├── Local LLM                              │
│    │     ├── llama.cpp                        │
│    │     └── OR MLX/omlx                      │
│    │                                          │
│    ├── ~/.hermes                              │
│    │     ├── memory                           │
│    │     ├── sessions                         │
│    │     ├── skills                           │
│    │     └── cron                             │
│    │                                          │
│    └── Optional Docker                        │
│          └── sandboxed tools                  │
│                                               │
└──────────────────────┬────────────────────────┘
                       │
                       │ LAN
                       ▼
              ┌──────────────────┐
              │ RTX WORKSTATION  │
              │                  │
              │ Ubuntu           │
              │ Ollama/vLLM      │
              │ Large Models     │
              └──────────────────┘
```

---

# Quick Start

## 1. Install Hermes

For Apple Silicon:

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

Alternatively, use the Hermes Desktop application.

---

## 2. Verify

```bash
hermes --help
```

---

## 3. Configure the Model

```bash
hermes model
```

For the simplest local deployment, select the local-model path.

---

## 4. Start with a Small Model

Use a model that comfortably fits your Mac's unified memory.

A good starting point is:

```text
Qwen3.5-9B
```

Then move upward as your memory capacity allows.

---

# 5. Install the Gateway

```bash
hermes gateway install
```

Start it:

```bash
hermes gateway start
```

Check:

```bash
hermes gateway status
```

---

# 6. Verify Logs

```bash
tail -f ~/.hermes/logs/gateway.log
```

---

# 7. Create a Scheduled Task

Once the base agent is working:

```bash
hermes cron list
```

and create scheduled tasks through Hermes.

The scheduler is handled by the Gateway.

---

# Operational Model

The final system behaves less like:

```text
Mac mini
=
computer I occasionally use
```

and more like:

```text
Mac mini
=
AI server
```

The conceptual transformation is:

```text
             Traditional Computer

                    USER
                     │
                     ▼
                   MAC
                     │
                  APPS
                     ↓


                AI SERVER

                    USER
                     │
                     ▼
                 HERMES
                     │
          ┌──────────┼───────────┐
          │          │           │
        MODEL       TOOLS      MEMORY
          │          │           │
          └──────────┼───────────┘
                     │
                  ACTION
                     │
                  RESULT
```

---

# Recommended Use Cases

For your environment, the strongest applications are:

| Use Case | Suitability |
|---|---:|
| Personal AI assistant | ★★★★★ |
| Scheduled AI research | ★★★★★ |
| GitHub monitoring | ★★★★★ |
| Homelab monitoring | ★★★★★ |
| Docker management | ★★★★★ |
| Home Assistant | ★★★★★ |
| Local RAG | ★★★★☆ |
| Autonomous coding | ★★★★☆ |
| Computer automation | ★★★★☆ |
| Large-model reasoning | ★★★☆☆ |
| Heavy model inference | RTX workstation |

The last distinction is important.

The Mac mini does **not** need to be your most powerful inference machine.

It can instead be the **always-available AI control plane**.

---

# Recommended Long-Term Architecture

The most compelling architecture for your setup is therefore:

```text
                      YOUR LAN
                         │
             ┌───────────┴───────────┐
             │                       │
             ▼                       ▼
       ┌───────────┐          ┌───────────────┐
       │  MAC MINI │          │RTX WORKSTATION│
       │           │          │               │
       │  macOS    │          │ Ubuntu        │
       │  Hermes   │◄────────►│ Ollama/vLLM   │
       │  Gateway  │   LAN    │ Large Models  │
       │           │          │               │
       │ Local LLM │          │ 24GB–48GB+    │
       └─────┬─────┘          └───────────────┘
             │
     ┌───────┼────────┐
     │       │        │
     ▼       ▼        ▼
   GitHub  Home     Homelab
           Assistant Services
     │       │        │
     └───────┼────────┘
             ▼
       Autonomous AI
```

The Mac mini stays powered on.

Hermes stays available.

Scheduled jobs continue running.

Small models execute locally.

Large jobs can be delegated to the RTX machine.

The result is effectively a **private AI appliance for your LAN**.

---

# Final Recommendation

For an always-on Apple Silicon Hermes deployment, I would use:

| Component | Recommendation |
|---|---|
| Hardware | Apple Silicon Mac mini |
| Memory | **32 GB minimum; 48/64 GB preferred** |
| Storage | **1 TB minimum** |
| Network | Ethernet; 10 GbE if available |
| OS | Current supported macOS |
| Agent | Hermes-Agent |
| Persistent service | `launchd` |
| Gateway | Hermes Gateway |
| Local inference | Managed llama.cpp initially |
| Alternative inference | MLX/omlx |
| Starting model | Qwen3.5-9B |
| Larger models | 27B / 35B with 32 GB+ |
| Sandbox | Docker terminal backend |
| Large-model backend | RTX Ubuntu workstation |
| Automation | Hermes Cron |
| Remote interaction | Telegram / Discord / Slack / etc. |
| Long-term role | **Always-on AI control plane** |

## The key idea

Don't think of the Mac mini as merely **another computer capable of running an LLM**.

For Hermes, it can become:

> **A continuously running autonomous AI server that happens to be powered by Apple Silicon.**

The Mac mini handles the **agent, automation, scheduling, memory, tools and lightweight local inference**, while your RTX workstation remains the **heavy-compute engine**.

That division of labor is arguably the most powerful way to use the two machines together.