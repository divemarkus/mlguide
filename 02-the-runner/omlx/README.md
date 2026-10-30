# oMLX on Apple Silicon: Architecture, Inference Serving, and Agent Workloads

> **Updated:** October 30, 2026  
> **Audience:** Mac mini / Mac Studio / MacBook Apple Silicon users, local-LLM operators, and agent developers  
> **Primary focus:** oMLX as an always-on, local inference server for Apple Silicon  
> **Deployment recommendation:** Native oMLX macOS application for everyday use; Homebrew and source installs remain valid alternatives.

---

## Table of Contents

1. [What oMLX Is](#1-what-omlx-is)
2. [MLX, MLX-LM, and oMLX: Understand the Layers](#2-mlx-mlx-lm-and-omlx-understand-the-layers)
3. [Why Apple Silicon Is Different](#3-why-apple-silicon-is-different)
4. [oMLX Deployment Options: Native App, Homebrew, and Source](#4-omlx-deployment-options-native-app-homebrew-and-source)
5. [The Native macOS App](#5-the-native-macos-app)
6. [oMLX Architecture and Serving Features](#6-omlx-architecture-and-serving-features)
7. [KV Cache: Hot Memory and SSD Tiering](#7-kv-cache-hot-memory-and-ssd-tiering)
8. [Continuous Batching and Concurrent Requests](#8-continuous-batching-and-concurrent-requests)
9. [Model Formats, Discovery, and Model Management](#9-model-formats-discovery-and-model-management)
10. [API Compatibility and Client Connections](#10-api-compatibility-and-client-connections)
11. [Using oMLX with Hermes Agent](#11-using-omlx-with-hermes-agent)
12. [Other Agent and Application Integrations](#12-other-agent-and-application-integrations)
13. [oMLX Compared with Ollama, LM Studio, MLX-LM, and llama.cpp](#13-omlx-compared-with-ollama-lm-studio-mlx-lm-and-llamacpp)
14. [Newer and Preview Features](#14-newer-and-preview-features)
15. [Multi-Mac and Distributed MLX](#15-multi-mac-and-distributed-mlx)
16. [Benchmarking oMLX Properly](#16-benchmarking-omlx-properly)
17. [Recommended Mac mini Deployment](#17-recommended-mac-mini-deployment)
18. [Troubleshooting and Operations](#18-troubleshooting-and-operations)
19. [Learning Curriculum](#19-learning-curriculum)
20. [References](#20-references)

---

## 1. What oMLX Is

oMLX is an inference-serving platform built around Apple's MLX ecosystem and optimized for Apple Silicon Macs. It turns a Mac into a local model-serving endpoint that can be used by chat clients, coding tools, agents, scripts, and other applications.

It is not simply another graphical model downloader. Its value is in the serving layer:

- Native Apple Silicon inference through MLX.
- OpenAI-compatible and Anthropic-compatible API endpoints.
- Continuous batching for concurrent inference requests.
- Tiered KV caching, with hot cache in memory and cold cache on SSD.
- Multiple model management, model loading and unloading controls.
- Memory-aware serving and model residency controls.
- A web administration interface and a native macOS menu-bar application.
- Local administration APIs for monitoring and automation.

A useful mental model:

> **MLX is the Apple Silicon machine-learning framework. MLX-LM provides language-model tooling. oMLX adds a managed inference-serving layer for persistent local workloads and agent clients.**

oMLX is particularly interesting when the Mac is expected to serve more than one application or agent over time.

Official project: [oMLX](https://omlx.ai/) · [GitHub repository](https://github.com/jundot/omlx)

## 2. MLX, MLX-LM, and oMLX: Understand the Layers

These technologies are related, but they are not interchangeable.

| Layer | What it is | Useful analogy |
|---|---|---|
| **MLX** | Apple's open-source array and machine-learning framework for Apple Silicon | PyTorch / CUDA ecosystem |
| **MLX-LM** | Language-model loading, generation, quantization, fine-tuning and related tooling built on MLX | LLM runtime and utilities |
| **oMLX** | An MLX-based inference server with model management, APIs, caching and concurrent serving | Local inference service |
| **Ollama** | Model acquisition, lifecycle management and local inference API | Local model appliance |
| **LM Studio** | Desktop model discovery, experimentation, chat and local API serving | Model laboratory |
| **llama.cpp** | Portable, highly optimized inference runtime supporting GGUF and many hardware backends | General-purpose inference engine |

### Conceptual architecture

```text
                 APPLICATIONS AND AGENTS
   ┌─────────────────────────────────────────────────────┐
   │ Hermes Agent │ OpenCode │ Codex │ MCP clients       │
   │ Home Assistant integrations │ Python │ Web apps     │
   └──────────────────────────┬──────────────────────────┘
                              │
                 OpenAI-compatible / Anthropic API
                              │
                    ┌─────────▼─────────┐
                    │       oMLX        │
                    │ Inference server  │
                    │ Model management  │
                    │ Cache / batching  │
                    └─────────┬─────────┘
                              │
                    ┌─────────▼─────────┐
                    │    MLX ecosystem  │
                    │ MLX / MLX-LM /    │
                    │ supported model   │
                    │ implementations   │
                    └─────────┬─────────┘
                              │
                    ┌─────────▼─────────┐
                    │  Apple Silicon    │
                    │ CPU + GPU +       │
                    │ Unified Memory    │
                    └───────────────────┘
```

This is a conceptual stack, not a claim that every model request passes through one fixed MLX-LM executable. oMLX integrates the MLX ecosystem and model-specific implementations within its own serving architecture.

Apple's MLX project: [github.com/ml-explore/mlx](https://github.com/ml-explore/mlx)

## 3. Why Apple Silicon Is Different

On a conventional PC with a discrete NVIDIA GPU, system RAM and GPU VRAM are separate pools connected over PCIe.

```text
Conventional PC

System RAM
    |
    | PCIe
    v
GPU VRAM
```

For example, a workstation might have 96 GB system RAM and an RTX GPU with 24 GB VRAM. The model and runtime must account for the separate memory pools and data movement between them.

Apple Silicon uses unified memory shared by the CPU and GPU:

```text
Apple Silicon SoC
┌───────────────────────────────────────┐
│            Unified Memory             │
│                                       │
│       CPU             GPU             │
│         \             /               │
│          \           /                │
│           MLX arrays                  │
│                                       │
└───────────────────────────────────────┘
```

This architecture avoids the conventional CPU-to-discrete-GPU memory-copy model for supported operations. It does **not** mean that all memory is free for models: macOS, applications, model weights, KV cache, temporary buffers and other services all share the same physical memory.

### Why this matters

- A larger unified-memory configuration can accommodate larger models or longer contexts.
- The GPU can operate on data in shared memory.
- Memory pressure affects the whole machine, not just the inference process.
- A Mac used as an always-on server needs headroom for the operating system and other services.

MLX primarily targets CPU and GPU execution. Do not assume that ordinary MLX inference is automatically using the Apple Neural Engine.

References: [Apple MLX](https://opensource.apple.com/projects/mlx/) · [MLX GitHub](https://github.com/ml-explore/mlx)

## 4. oMLX Deployment Options: Native App, Homebrew, and Source

oMLX now has a native macOS application in addition to command-line and source-based installation paths.

| Deployment | Best suited to | Characteristics |
|---|---|---|
| **Native macOS app (DMG)** | Most Mac users; always-on desktop/server appliance | Swift/SwiftUI menu-bar app, first-run setup, server controls, administration UI, app-managed updates |
| **Homebrew formula** | CLI-oriented and scripted deployments | Install and manage the server through Homebrew; useful for users who prefer package-manager lifecycle management |
| **Source install** | Developers, contributors and custom builds | Clone repository, install dependencies and run the server; more responsibility for Python/runtime dependencies and upgrades |

### Recommendation

For a dedicated Mac mini that runs oMLX continuously, use the **native macOS application** unless you have a specific reason to manage the service entirely through Homebrew or source.

The native app is the easiest way to manage the service, model directory, API settings and updates. Homebrew remains a valid alternative; it is not inherently obsolete.

Official installation and downloads: [oMLX website](https://omlx.ai/) · [GitHub Releases](https://github.com/jundot/omlx/releases)

### Homebrew and dotfiles

A Brewfile should contain tools that are actually installed and maintained through Homebrew. If using the native oMLX DMG, do not also install the Homebrew oMLX formula by default.

Example supporting Brewfile:

```ruby
# General CLI utilities
brew "git"
brew "gh"
brew "jq"
brew "yq"
brew "ripgrep"
brew "fd"
brew "httpie"

# Keep only tools you actually use.
```

For a native-app deployment, document oMLX as a separately installed macOS application rather than adding a guessed `cask "omlx"` entry. The official project publishes a DMG installation path and a Homebrew formula path; verify the current official instructions before automating either.

Keep app configuration templates and deployment notes in Git, but do not commit API keys, tokens, private model paths or personal settings files containing secrets.

## 5. The Native macOS App

The current native application is a Swift/SwiftUI menu-bar app, not an Electron wrapper. It provides a graphical control surface for the oMLX server.

The app's onboarding flow guides the user through the storage/model directory, API-key setup and starting the server. The app and web administration UI manage the same running oMLX service.

Typical responsibilities include:

- Start, stop and monitor the inference server.
- Configure the model directory and server settings.
- Manage model downloads and model availability.
- Open the administration interface.
- Review serving status and usage.
- Receive application updates; the app can download an update in the background and asks before installing it.

### App versus server

The graphical app is the management surface. The inference server is the service that accepts model requests. Keep this distinction in mind when designing an always-on deployment.

The server can also run headlessly in supported deployments. The administration API remains available when the server is run without the web UI, for example with `omlx serve --headless` or `OMLX_HEADLESS=1`.

### CLI

The native app provides a CLI shim under:

```text
~/.omlx/bin/omlx
```

Check the actual executable resolved by your shell:

```bash
which -a omlx
omlx --help
```

Do not assume that the native app always creates or maintains `/opt/homebrew/bin/omlx`. Recent release notes specifically describe a change to stop linking the app's CLI into that Homebrew path.

For a Homebrew-managed installation, use Homebrew's service commands. For the native app, use the app's own controls and the CLI it installs. Avoid running two oMLX servers against the same port and model directory.

## 6. oMLX Architecture and Serving Features

The major oMLX capabilities are designed around serving models to applications rather than only chatting with one model interactively.

### Key capabilities

- **Model management:** download, import, load, unload and configure models.
- **Multi-model serving:** make multiple models available and control their residency.
- **Memory management:** manage model admission, memory limits and model eviction.
- **Continuous batching:** combine work from concurrent requests for more efficient serving.
- **Tiered KV cache:** reuse cached prompt context from memory and SSD.
- **API compatibility:** expose endpoints for common OpenAI and Anthropic clients.
- **Administration:** web UI, app controls, CLI and admin API.
- **Usage visibility:** inspect activity, serving statistics and logs.

### Serving architecture

```text
Applications / Agents
        |
        v
OpenAI / Anthropic API
        |
        v
oMLX API server
        |
        +---- Request scheduling / batching
        |
        +---- Model manager
        |
        +---- Memory guard / model residency
        |
        +---- KV cache
        |       +-- Hot memory tier
        |       +-- SSD-backed tier
        |
        v
MLX model execution
        |
        v
Apple Silicon GPU / unified memory
```

The precise model implementation and optimizations vary by architecture and release. Check the release notes and model support documentation for the exact model you intend to serve.

## 7. KV Cache: Hot Memory and SSD Tiering

KV caching is one of oMLX's most important features for agentic and long-context workloads.

During transformer inference, the runtime calculates and retains key/value tensors for processed tokens. Reusing this state can avoid recomputing shared prompt prefixes.

Agent workflows often repeat large parts of a prompt:

```text
SYSTEM INSTRUCTIONS
       +
AGENT SKILLS / TOOL DEFINITIONS
       +
PROJECT OR HOME-LAB CONTEXT
       +
CONVERSATION HISTORY
       +
NEW USER REQUEST
```

A request may reuse much of the same prefix as an earlier request. Without effective prefix caching, the model may need to process that shared context again.

### oMLX tiered cache concept

```text
             Reusable prompt context
                       |
             ┌─────────┴─────────┐
             |                   |
          Hot cache           Cold cache
          Unified RAM          SSD storage
             |                   |
             └─────────┬─────────┘
                       |
                oMLX KV cache
                       |
                Model execution
```

The hot tier is intended for fast access in memory. The SSD tier allows cached blocks to persist beyond the in-memory working set and be restored when needed.

### Why agents benefit

Agent prompts may contain repeated system instructions, tool schemas, skill descriptions and conversation prefixes. Reusing these can improve subsequent-turn latency and reduce repeated prefill work.

This is particularly relevant to:

- Hermes Agent conversations.
- Coding agents that repeatedly inspect the same repository.
- Research agents that operate over a stable set of instructions.
- Multiple clients sharing a model server.

### Important qualifications

- Cache reuse depends on matching prefixes and the model/runtime implementation.
- A cache hit does not mean the entire request is free; new tokens still need processing.
- SSD cache is not a substitute for RAM or model memory.
- Cache capacity, eviction, model compatibility and settings affect actual benefit.
- Model/runtime upgrades can invalidate some previously stored cache blocks. Read release upgrade notes before assuming old cache data remains reusable.

The administration interface and API expose cache statistics and cache-clearing operations. Use them to observe actual behavior rather than assuming a workload benefits.

## 8. Continuous Batching and Concurrent Requests

A simple single-request server may process one request at a time:

```text
Request A ---> Model ---> Response A
Request B ---> Model ---> Response B
Request C ---> Model ---> Response C
```

Continuous batching allows active requests to be scheduled together:

```text
Request A ─┐
Request B ─┼──> Scheduler / Model ───> Responses
Request C ─┤
Request D ─┘
```

This can improve aggregate throughput when multiple clients use the same model server.

Potential clients on a Mac mini:

- Hermes Agent.
- A local chat interface.
- A Python automation script.
- A coding agent.
- A Home Assistant workflow.
- Another API-compatible application.

Batching is not a promise that every individual request becomes faster. Latency and throughput depend on model size, prompt length, context, concurrency, memory and sampling settings.

For a 32 GB always-on Mac mini, begin with modest concurrency and measure. More concurrent requests can increase memory pressure and queueing.

## 9. Model Formats, Discovery, and Model Management

oMLX is designed for the MLX model ecosystem and supported model implementations. It is not a generic GGUF server in the same sense as llama.cpp.

Common model artifacts and formats include:

```text
Model repositories
    |
    +-- Original Hugging Face checkpoints
    |
    +-- Safetensors
    |
    +-- MLX-converted weights
    |
    +-- GGUF (typically served by llama.cpp or compatible runtimes)
```

For oMLX, select a model repository/build that its current version supports. Do not assume that any arbitrary Hugging Face repository or GGUF file can be loaded directly.

### Existing model directories

The project states that oMLX can read the standard Hugging Face cache and an LM Studio model folder. This can avoid downloading another copy of compatible model files, but compatibility still depends on the model format and implementation.

### Model management practices

For an always-on Mac:

1. Keep one small, frequently used model readily available.
2. Load larger models only when needed.
3. Avoid pinning more models than unified memory can comfortably support.
4. Leave memory headroom for macOS and other services.
5. Set a realistic context window for the workload.
6. Monitor model residency, cache use and memory pressure.

Model weight size is not the total memory requirement. Runtime buffers, KV cache, context length, concurrency and macOS all consume additional memory.

## 10. API Compatibility and Client Connections

oMLX exposes APIs intended to make it usable by existing AI clients.

Common endpoints include:

| Endpoint | Purpose |
|---|---|
| `POST /v1/chat/completions` | OpenAI-style chat completions |
| `POST /v1/completions` | Text completions |
| `POST /v1/messages` | Anthropic Messages API |
| `POST /v1/embeddings` | Embedding generation |
| `POST /v1/rerank` | Document reranking |
| `GET /v1/models` | List available models |

The exact supported request parameters and model-specific behavior can vary. Consult the current API documentation and test the exact client/model combination.

Default local endpoint commonly used by the app:

```text
http://127.0.0.1:8000/v1
```

List models:

```bash
curl -s http://127.0.0.1:8000/v1/models | jq
```

### Authentication and network exposure

Do not assume that an API endpoint is safe to expose without authentication.

oMLX has API-key and authentication settings. The admin API uses the main API key; inference API sub-keys are intended for inference endpoints. If you bind the server to a LAN interface, configure authentication and firewall rules deliberately.

For a single-Mac local deployment, prefer loopback binding:

```text
127.0.0.1
```

For LAN access, use a controlled network interface, authentication, and firewall policy. Do not expose the admin interface directly to the public internet.

Admin API documentation: [docs/admin-api.md](https://github.com/jundot/omlx/blob/main/docs/admin-api.md)

## 11. Using oMLX with Hermes Agent

Hermes Agent is the agent platform; oMLX is the inference server. Hermes manages conversations, tools, skills, memory and actions. oMLX serves the model.

```text
                  Hermes Desktop
                        |
                 Hermes Agent Core
                        |
          Tools / Skills / Memory / Gateway
                        |
              OpenAI-compatible provider
                        |
                  oMLX API server
                        |
                   MLX model
                        |
                 Apple Silicon GPU
```

### Typical connection settings

In Hermes Desktop, configure a custom OpenAI-compatible provider:

| Setting | Example |
|---|---|
| Provider | Custom / OpenAI-compatible |
| Base URL | `http://127.0.0.1:8000/v1` |
| API key | The configured oMLX inference key, if authentication is enabled |
| Model | Exact model ID returned by `/v1/models` |
| Context | A value supported by both the model and the oMLX configuration |

Use the actual model ID returned by your server. Do not copy a guessed repository name if oMLX exposes a different ID.

Hermes also supports custom endpoints through its provider configuration. Confirm the current Hermes Desktop UI and provider documentation for the version installed.

### What the model does versus what Hermes does

| Responsibility | Component |
|---|---|
| Understand the user request | Model served by oMLX |
| Select and format tool calls | Model + Hermes agent runtime |
| Execute a Home Assistant action | Hermes tool/integration |
| Search the web | Hermes search tool and configured backend |
| Retrieve stock/crypto data | Finance skill or external data API |
| Maintain agent sessions and skills | Hermes |
| Run local model inference | oMLX |
| Manage model loading and cache | oMLX |

A local model does not automatically gain web access, Home Assistant access, market feeds or system permissions. Those capabilities come from Hermes tools and explicit integrations.

### Practical model-selection advice

For a 32 GB Mac mini that also runs background services, start with a compact instruction model that supports the tool-calling format required by Hermes. Test real tasks rather than selecting by parameter count alone.

Evaluate:

- Correct tool selection.
- Valid tool-call formatting.
- Ability to follow multi-step instructions.
- Reliability when tool results are incomplete.
- Context handling.
- Latency and memory consumption.

## 12. Other Agent and Application Integrations

Any client that supports a compatible OpenAI or Anthropic API may be a candidate, but compatibility should be verified per client and model.

Potential integrations:

| Client / platform | Example use |
|---|---|
| Hermes Agent | Persistent personal agent, tools, skills and Discord gateway |
| OpenCode | Terminal-based coding agent |
| Codex | Coding workflows using a configured model endpoint where supported |
| OpenClaw | Agent workflows using supported model providers |
| Custom Python | Automation, research and internal tools |
| Home Assistant | Local assistant workflows through an agent/integration layer |
| RAG applications | Retrieval-augmented question answering |
| MCP clients | Tool discovery and external service integration |

Do not confuse model serving with agent orchestration. oMLX provides inference; the client or agent is responsible for tools, workflow state, approvals and actions.

## 13. oMLX Compared with Ollama, LM Studio, MLX-LM, and llama.cpp

These products overlap, but they emphasize different workflows.

| Capability | oMLX | Ollama | LM Studio | MLX-LM | llama.cpp |
|---|---|---|---|---|---|
| Primary focus | Apple Silicon model serving | Simple local model lifecycle and serving | Desktop model lab and serving | MLX model tooling | Portable inference runtime |
| Apple Silicon | Native MLX focus | Supported backend/builds | Apple Silicon support | Native | Metal backend |
| NVIDIA | No | Yes | Yes | No | Yes |
| GUI | Native macOS app + web admin | Primarily CLI / ecosystem UI | Full desktop UI | No general-purpose desktop UI | No built-in desktop UI |
| Model management | Integrated | Integrated | Integrated | Tooling-based | File/runtime-oriented |
| OpenAI-compatible API | Yes | Yes | Yes | Via server tooling | Via server mode |
| Anthropic-compatible API | Yes | Not its primary API | Depends on current server support | Not its primary focus | Not its primary focus |
| Continuous batching | Yes | Implementation-dependent | Serving behavior varies | Available in supported serving paths | Server implementation-dependent |
| Tiered SSD KV cache | Core differentiator | Not equivalent to oMLX's design | Not equivalent to oMLX's design | Depends on tooling | Depends on configuration |
| Best fit | Persistent Apple Silicon serving | Simple cross-platform local inference | Interactive model experimentation | MLX development and experimentation | Flexible low-level inference |

### Which should you choose?

- **oMLX:** Strong choice for an always-on Apple Silicon inference service, especially when caching and concurrent agent requests matter.
- **Ollama:** Excellent for a consistent model workflow across Linux/NVIDIA and Mac machines.
- **LM Studio:** Excellent for model discovery, interactive testing, comparison and quick API serving.
- **MLX-LM:** Best when you want to work closer to Apple's MLX language-model tooling.
- **llama.cpp:** Excellent for GGUF, portability and broad hardware support.

These tools are complementary. You do not need to remove Ollama from an NVIDIA server just because you use oMLX on a Mac.

## 14. Newer and Preview Features

oMLX is actively developed. Separate stable releases from release candidates and development builds.

At the time of this update, the GitHub Releases page lists **0.7.2 as the stable release** and **0.7.3rc1 as a release candidate**. Use stable for a reliability-focused always-on service unless you intentionally want to test preview functionality.

### Features highlighted in the 0.7.3 release-candidate line

- **Ask AI:** A floating question bar that can invoke local models from other apps, with a keyboard shortcut and prompt presets.
- **GPU power limit:** A per-model control for limiting GPU power during generation, primarily useful for battery-powered Macs.
- **Lightning MTP:** Speculative decoding support for selected model families.
- **Model and runtime improvements:** Performance, model compatibility and quantization changes.
- **API improvements:** Additional response and token/log-probability support.
- **macOS app improvements:** Background update download with confirmation before installation, and clearer reporting when an update fails.

These are release-candidate notes, not a blanket guarantee that every feature is stable or supported on every Mac/model combination.

### Preview feature caution

Before upgrading an always-on agent host:

1. Read the release notes.
2. Check whether the release is stable, RC or development.
3. Back up important settings and configuration.
4. Confirm model compatibility.
5. Check whether cache data must be regenerated.
6. Test Hermes tool calling after the upgrade.

Release notes: [oMLX GitHub Releases](https://github.com/jundot/omlx/releases)

## 15. Multi-Mac and Distributed MLX

MLX has distributed-computing capabilities that can be used across multiple Apple Silicon systems. This opens the possibility of distributing some model-parallel or training workloads across Macs.

However, distinguish three separate things:

1. **MLX distributed capabilities:** The underlying framework's distributed execution support.
2. **oMLX cluster features:** Specific functionality implemented in the current oMLX release.
3. **A multi-Mac inference deployment:** A real operational system requiring compatible hardware, networking, model/runtime versions and coordination.

Do not assume that installing oMLX on several Macs automatically pools their unified memory into one large GPU.

For multi-Mac experiments, verify the current cluster documentation and release notes. Keep participating Macs on compatible oMLX/MLX versions; source-install upgrade instructions may require rebuilding kernels. Network topology and transport can affect performance.

Start with one Mac serving one model. Add distributed execution only after measuring a workload that benefits from it.

## 16. Benchmarking oMLX Properly

A useful oMLX learning project is a controlled benchmark rather than immediately deploying many agents.

Use the same model, quantization, context, prompt, sampling settings and hardware conditions when comparing runtimes.

```text
                   SAME MODEL
                       |
          ┌────────────┼────────────┐
          |            |            |
        Ollama      LM Studio      oMLX
          |            |            |
          └────────────┼────────────┘
                       |
                  SAME PROMPT
                       |
             Measure and compare
```

### Measurements

| Metric | What it tells you |
|---|---|
| Time to first token (TTFT) | How long before generation begins |
| Prompt processing speed | How quickly input context is processed |
| Decode tokens/sec | Output generation speed |
| Peak memory | Memory pressure during the workload |
| Cache hit / reuse | Whether repeated prefixes benefit |
| Second-turn latency | Practical benefit in a multi-turn session |
| Concurrent throughput | How the server behaves with multiple clients |
| Queue time | Delay caused by other requests |
| Thermal/power behavior | Sustained performance on an always-on Mac |

### Test agent-like workloads

A short chat prompt does not represent a coding or research agent. Test:

- Repeated long system prompts.
- Tool definitions and structured tool calls.
- Multi-turn conversations.
- Long context with a small new request.
- Two or more concurrent clients.
- A workload that reuses the same prompt prefix.
- A workload that switches between models.

For a 32 GB machine, watch macOS Memory Pressure as well as the server's model-memory statistics.

## 17. Recommended Mac mini Deployment

For a 32 GB Apple Silicon Mac mini that runs continuously, favor a compact primary model and reserve memory for the operating system and other services.

### Suggested architecture

```text
                  HOME LAN
                     |
        ┌────────────┴────────────┐
        |                         |
        v                         v
   Discord / User            Home Assistant
        |                         |
        v                         |
                Hermes Agent
             Desktop + Gateway
                     |
              Tools / Skills
                     |
              OpenAI API client
                     |
                     v
              oMLX macOS App
              Local API server
                     |
          ┌──────────┴──────────┐
          |                     |
     Primary model        On-demand model
     Small MLX model      Larger MLX model
          |                     |
          └──────────┬──────────┘
                     |
             Apple Silicon GPU
               Unified Memory
```

### Operating recommendations

- Use the native oMLX app for service management.
- Bind the inference server to loopback unless LAN access is explicitly required.
- Configure API authentication when appropriate.
- Keep one small primary model available.
- Load larger models only when needed.
- Avoid excessive concurrent requests.
- Keep context windows appropriate to the task.
- Monitor memory pressure, cache usage, logs and server uptime.
- Keep Hermes permissions separate from model serving.
- Require approval for sensitive Home Assistant and infrastructure actions.

### Dotfiles and GitHub

A sensible repository organization:

```text
endpoint-config/
├── Brewfile
├── Brewfile.ai
├── macos/
│   ├── apps.md
│   ├── install-apps.sh
│   └── defaults.sh
├── omlx/
│   ├── README.md
│   ├── settings-notes.md
│   └── model-inventory.example.md
└── hermes/
    ├── config.yaml.example
    └── README.md
```

Use GitHub for:

- Brewfiles and supporting CLI packages.
- Installation and update procedures.
- Non-secret configuration examples.
- Model inventory and benchmark notes.
- Hermes provider configuration templates.
- Recovery and troubleshooting documentation.

Do not commit:

- API keys or Discord bot tokens.
- Home Assistant long-lived access tokens.
- Personal `.env` files.
- Private conversation history or local agent memory.
- Unredacted logs containing sensitive data.

## 18. Troubleshooting and Operations

### Check the CLI

```bash
which -a omlx
omlx --help
```

If the native app's CLI is not found, check that `~/.omlx/bin` is on your shell `PATH`.

### Check the API

```bash
curl -s http://127.0.0.1:8000/v1/models | jq
```

If authentication is enabled, supply the configured inference API key:

```bash
curl -s http://127.0.0.1:8000/v1/models \
  -H "Authorization: Bearer $OMLX_API_KEY" | jq
```

### Inspect server administration

The admin API includes endpoints for:

- Server information and settings.
- Model status and activity.
- Usage statistics.
- Logs.
- Device information.
- Cache statistics and cache clearing.
- Model loading and other management operations.

The main admin API key is distinct from inference sub-keys. Use the official admin API documentation for the exact authentication requirements.

### Common operational issues

| Symptom | Checks |
|---|---|
| API is unreachable | Confirm server is running, host/port and firewall |
| Model not listed | Check model directory, model format and model discovery |
| Model load fails | Check available memory, model compatibility and logs |
| Hermes cannot connect | Verify base URL, API key, model ID and endpoint compatibility |
| Tool calls are malformed | Test another tool-capable model and confirm the expected chat template |
| Slow first response | Measure model loading and prompt prefill separately |
| Cache benefit is absent | Check prefix reuse, cache stats, model identity and cache settings |
| Memory pressure | Reduce context/concurrency, unload other models and review model residency |
| Update changes behavior | Review release notes and test model/API compatibility |

### Upgrade discipline

- Prefer stable releases for the always-on host.
- Keep a record of the installed version.
- Read migration notes before upgrades.
- For source installs, follow the release-specific dependency and kernel build instructions.
- Do not assume cached KV blocks are reusable across all runtime/model changes.
- Re-test the API and Hermes after upgrading.

## 19. Learning Curriculum

A useful learning path is to move from the framework to serving, then to agent integration.

### Level 1 — MLX Fundamentals

Learn:

- MLX arrays and operations.
- CPU and GPU devices.
- Unified memory.
- Lazy evaluation.
- Metal execution.
- MLX's relationship to PyTorch and other frameworks.

**Goal:** Understand the Apple Silicon ML framework.

### Level 2 — MLX-LM

Learn:

- Model loading.
- Generation.
- Quantization.
- Hugging Face model repositories.
- LoRA and fine-tuning.
- Supported architectures.

**Goal:** Run and inspect an LLM using MLX tooling.

### Level 3 — MLX Model Ecosystem

Learn:

- Safetensors.
- MLX conversions.
- Quantization levels.
- Model architecture and tokenizer files.
- Model cards and licenses.

**Goal:** Understand exactly what model artifacts you are downloading.

### Level 4 — Model Serving APIs

Learn:

- HTTP APIs.
- OpenAI-compatible request formats.
- Streaming.
- Authentication.
- Context and sampling parameters.

**Goal:** Connect a local model to an application.

### Level 5 — oMLX

Learn:

- Native app and server lifecycle.
- Model discovery and management.
- API configuration.
- KV cache and SSD cache.
- Continuous batching.
- Model residency and memory guard.
- Admin UI, CLI and admin API.

**Goal:** Operate a persistent local inference service.

### Level 6 — Agents

Connect oMLX to:

- Hermes Agent.
- Coding agents.
- MCP clients.
- Home Assistant workflows.
- Custom Python automation.

**Goal:** Understand the difference between model inference and agent orchestration.

### Level 7 — Multi-Mac

Study:

- MLX distributed execution.
- Model parallelism.
- Network topology.
- Communication overhead.
- Version compatibility.
- oMLX's own cluster support, where applicable.

**Goal:** Evaluate whether distributed execution solves a real workload problem.

### Level 8 — Benchmark and Document

Record:

- Model and quantization.
- oMLX version.
- macOS version and Mac hardware.
- Context length.
- TTFT and decode speed.
- Memory pressure.
- Cache reuse.
- Tool-call success rate.

**Goal:** Publish reproducible findings in your GitHub learning guide.

## 20. References

### Official oMLX

- [oMLX Website](https://omlx.ai/)
- [oMLX GitHub Repository](https://github.com/jundot/omlx)
- [oMLX Releases](https://github.com/jundot/omlx/releases)
- [oMLX Admin API](https://github.com/jundot/omlx/blob/main/docs/admin-api.md)
- [oMLX Documentation in the repository](https://github.com/jundot/omlx/tree/main/docs)

### Apple MLX

- [Apple MLX project](https://opensource.apple.com/projects/mlx/)
- [MLX GitHub](https://github.com/ml-explore/mlx)

### Related local inference tools

- [Ollama](https://ollama.com/)
- [LM Studio](https://lmstudio.ai/)
- [llama.cpp](https://github.com/ggml-org/llama.cpp)
- [MLX-LM](https://github.com/ml-explore/mlx-lm)

### Agent integration

- [Hermes Agent documentation](https://hermes-agent.nousresearch.com/docs/)
- [Model Context Protocol](https://modelcontextprotocol.io/)

---

## Final Perspective

Do not think of oMLX as a replacement for every local inference tool.

Think of it as adding a purpose-built Apple Silicon serving option to your toolkit:

- Use **Ollama** where its cross-platform model lifecycle and NVIDIA deployment fit.
- Use **LM Studio** when you want an interactive model laboratory.
- Use **MLX / MLX-LM** when you want to work directly with Apple's ML framework and model tooling.
- Use **oMLX** when you want a persistent, managed inference service on an Apple Silicon Mac.
- Use **Hermes Agent** or another agent runtime when you need tools, skills, workflows and actions.

The important architectural separation is:

> **The model generates. The inference server serves. The agent orchestrates. The integrations provide access to real systems and data.**

That separation makes it easier to build a reliable, private and maintainable local AI environment.
