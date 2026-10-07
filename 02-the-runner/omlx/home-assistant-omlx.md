
# Run a Local LLM with oMLX and Home Assistant

## Build a Private Local AI Voice Assistant on an Apple Silicon Mac Mini

Running a local LLM no longer requires a large GPU server or a complicated cluster.

For an Apple Silicon system, the latest **M6 Mac mini combined with Apple's MLX framework and oMLX** provides an especially attractive platform for an always-on local AI server.

A properly configured Mac mini can provide an excellent always-on platform for:

- Local LLM inference
- Home Assistant
- Voice control
- Speech-to-text
- Text-to-speech
- AI-powered home automation
- Local AI agents
- MCP and other AI tools
- Local model serving

The basic architecture is:

```text
                         HOME NETWORK
                              │
                              ▼
                   ┌─────────────────────┐
                   │      MAC MINI       │
                   │       M6 / 32 GB    │
                   │                     │
                   │       macOS         │
                   │         │           │
                   │   Home Assistant    │
                   │         │           │
                   │        oMLX         │
                   │         │           │
                   │     Local LLM       │
                   │                     │
                   │   Local STT / TTS   │
                   │                     │
                   └──────────┬──────────┘
                              │
                         LAN / Wi-Fi
                              │
                              ▼
                   ┌─────────────────────┐
                   │ HOME ASSISTANT      │
                   │ VOICE PREVIEW       │
                   │ EDITION             │
                   │                     │
                   │ 🎤 Microphones      │
                   │ 🔊 Speaker          │
                   │ 🔇 Hardware Mute    │
                   └─────────────────────┘
```

The **Mac Mini is the AI server**.

The **Home Assistant Voice Preview Edition is the voice interface**.

This separation is important: the Voice Preview Edition provides the microphones, speaker, controls, and voice endpoint, while the Mac Mini supplies the computing power for Home Assistant and local AI.

---

# 1. Why a Mac Mini?

Apple Silicon is particularly interesting for local AI because the CPU and GPU share a large pool of unified memory.

Instead of having:

```text
CPU → System RAM

GPU → Dedicated VRAM
```

Apple Silicon uses:

```text
             Unified Memory
                  │
          ┌───────┴───────┐
          │               │
         CPU             GPU
```

The same memory pool can therefore be used by the CPU and GPU.

This is particularly useful for LLM inference because model weights, KV cache, and other working data can occupy unified memory without being restricted by a separate dedicated GPU VRAM pool.

Apple Silicon also provides excellent performance per watt, making a Mac Mini attractive as an **always-on local AI server**.

---

# 2. Why the M6 Mac Mini Is Particularly Good for oMLX

The latest M6 Mac mini is an unusually good match for a local MLX/oMLX server.

The M6 provides:

| Component | M6 Mac Mini |
|---|---|
| CPU | 12-core |
| GPU | 12-core |
| GPU AI hardware | Neural Accelerators |
| Neural Engine | Dual 16-core |
| Unified Memory | Up to 32 GB |
| Memory Bandwidth | Up to 170 GB/s |
| Networking | 2.5Gb Ethernet, Wi-Fi 7 |
| Form Factor | Very small |
| Power efficiency | Excellent for always-on use |

Apple specifically positions the M6 Mac mini as an **AI powerhouse**. The M6 GPU introduces Neural Accelerators in each GPU core, while the system has a dual 16-core Neural Engine and up to 170 GB/s of memory bandwidth. Apple reports up to 4× faster AI performance than the M4 Mac mini.

That hardware is particularly interesting when paired with MLX.

The architecture becomes:

```text
                 M6 Mac Mini
                      │
              Unified Memory
                      │
                      ▼
                     MLX
                      │
                      ▼
                    oMLX
                      │
                      ▼
                 Local LLM
```

MLX is Apple's machine-learning framework designed for Apple Silicon.

oMLX uses that MLX ecosystem to provide a persistent local inference server.

That makes oMLX more than simply another application that happens to run an LLM on a Mac.

It gives the M6 a **native Apple Silicon AI serving stack**.

---

# 3. Why oMLX Instead of Ollama?

Ollama remains an excellent general-purpose local LLM runtime.

However, this project is specifically designed around an Apple Silicon Mac acting as a **permanent local AI server**.

That makes oMLX particularly compelling.

oMLX is built around Apple's MLX ecosystem and provides:

- Apple Silicon optimized inference
- OpenAI-compatible API
- Anthropic-compatible API
- Multi-model serving
- Continuous batching
- Persistent KV caching
- SSD-backed KV caching
- Model loading/unloading
- Model profiles
- Model aliases
- Model memory management
- Built-in administration dashboard
- Built-in Chat
- Benchmarking
- MCP and agent integrations
- macOS-native service/application support

The current oMLX project also provides direct dashboard setup for tools such as OpenClaw, OpenCode, Codex, Hermes Agent, Copilot, and other clients.

This gives the system a clean separation:

```text
Applications
     │
     ▼
    oMLX
     │
     ▼
    MLX
     │
     ▼
Apple Silicon
```

Rather than:

```text
Application
     │
     ▼
Generic runtime
     │
     ▼
Apple Silicon
```

### The important distinction

> **Ollama is a general-purpose local LLM runtime. oMLX is particularly attractive when Apple Silicon is the primary inference platform and you want an MLX-native local inference server.**

For this project, **oMLX is the preferred runtime**.

---

# 4. Recommended Mac Mini

For an AI + Home Assistant server, prioritize memory over storage.

| Component | Recommendation |
|---|---|
| Apple Silicon | **M6 preferred** |
| Memory | **32 GB preferred** |
| Storage | **1 TB recommended** |
| Networking | **Ethernet preferred** |
| Wi-Fi | Supported |
| Monitor | Required only for initial setup |
| Keyboard/mouse | Required only for initial setup |
| Always-on | **Yes** |
| UPS | Recommended |

### Recommended configuration

**Mac mini M6 / 32 GB / 1 TB**

The 32 GB configuration is particularly attractive because unified memory is shared by:

- macOS
- Home Assistant
- oMLX
- LLM weights
- KV cache
- STT
- TTS
- agents
- other local services

The M6 Mac mini is configurable to 32 GB unified memory.

For this project, I would choose **32 GB rather than 16 GB**.

---

# 5. Software Architecture

The modern stack looks like this:

```text
                         MAC MINI
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
       Home Assistant      oMLX       Local STT/TTS
             │              │
             │              ▼
             │          Local LLM
             │
             ├── Assist
             ├── Automations
             ├── Devices
             ├── Scenes
             └── Voice
```

There is deliberately **no Open WebUI in this architecture**.

oMLX already provides a built-in Chat interface through its administration dashboard. Current oMLX documentation lists:

```text
http://localhost:8000/admin/chat
```

as its built-in Chat interface. It supports conversation history, model switching, reasoning output, dark mode, and image uploads for supported VLM/OCR models.

### Core components

| Component | Role |
|---|---|
| **Home Assistant** | Smart-home platform and voice orchestration |
| **oMLX** | Apple Silicon local LLM inference server |
| **Local LLM** | Reasoning/conversation |
| **Speech-to-Text** | Converts voice into text |
| **Text-to-Speech** | Converts responses into speech |
| **Voice Preview Edition** | Microphone + speaker + physical voice interface |

### oMLX also provides

- Model management
- Built-in Chat
- Benchmarking
- API serving
- Model profiles
- Model aliases
- Agent integrations

Therefore, an additional chat frontend is **not required**.

---

# 6. Home Assistant

Home Assistant provides the automation and voice-control layer.

It understands commands such as:

```text
"Turn on the kitchen lights."

"Set the bedroom temperature to 68 degrees."

"Turn off everything downstairs."

"What's the temperature outside?"
```

Home Assistant's Conversation/Assist system handles these interactions and can expose selected entities to an LLM.

The important architectural distinction is:

> **Home Assistant controls the home. oMLX provides the general-purpose AI intelligence.**

---

# 7. Home Assistant on the Mac Mini

Home Assistant can run on an Apple Silicon Mac through a virtual machine using **Home Assistant OS**.

The architecture becomes:

```text
                MAC MINI
                   │
                 macOS
                   │
           ┌───────▼────────┐
           │  Home Assistant│
           │       OS       │
           │       VM       │
           └────────────────┘
```

This gives Home Assistant its normal OS environment, Supervisor functionality, and Home Assistant apps/add-ons without requiring Home Assistant to replace macOS on the Mac Mini.

### Recommended approach

For this project:

```text
Mac Mini
   │
   ├── macOS
   │
   ├── Home Assistant OS VM
   │
   └── oMLX
```

I would **not** put oMLX inside the Home Assistant VM.

Keep the AI runtime on macOS and let Home Assistant communicate with it over the network.

That creates a clean separation:

```text
Home Assistant OS
        │
        │ HTTP/API
        ▼
     oMLX on macOS
        │
        ▼
     Local LLM
```

---

# 8. oMLX

oMLX is the local LLM inference server in this architecture.

It sits between applications and the MLX models running on the Apple Silicon hardware.

```text
                  macOS
                    │
                    ▼
                   MLX
                    │
                    ▼
                  oMLX
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
       Local LLM          API Clients
```

oMLX provides an OpenAI-compatible API.

The standard endpoint is:

```text
http://localhost:8000/v1
```

Current oMLX also supports Anthropic-compatible endpoints and other inference APIs.

---

# 9. First-Time oMLX Setup

The current oMLX macOS/Homebrew workflow includes an initial setup process.

After installation:

```bash
omlx start
```

Then open:

```text
http://localhost:8000/admin
```

The current version requires configuring authentication during initial setup, including an API key.

Save the API key securely.

oMLX stores its configuration under:

```text
~/.omlx/
```

If necessary, the current API key can be recovered locally from:

```bash
cat ~/.omlx/settings.json | grep api
```

The oMLX maintainer confirms that the API key is intentionally available in the local settings file so it can be used with external applications.

### Built-in Chat

Once the dashboard is available:

```text
http://localhost:8000/admin/chat
```

provides the built-in Chat interface.

This means you do **not** need Open WebUI simply to test or interact with your models.

---

# 10. Connecting oMLX to Home Assistant

This is an important architectural difference from the original Ollama version of this guide.

Do not think of this as:

```text
Home Assistant
      │
      ▼
"Ollama integration"
```

Instead, think of it as:

```text
Home Assistant
      │
      │ OpenAI-compatible API
      ▼
     oMLX
      │
      ▼
   Local LLM
```

oMLX exposes standard OpenAI-compatible endpoints, including:

```text
POST /v1/chat/completions
GET  /v1/models
POST /v1/embeddings
POST /v1/rerank
```

and other compatible endpoints.

Configure Home Assistant using its appropriate OpenAI-compatible/custom LLM provider mechanism.

Typical values will be conceptually:

```text
Base URL:
http://<MAC-MINI-IP>:8000/v1

API Key:
<oMLX API key>

Model:
<oMLX model name or alias>
```

If Home Assistant is running inside a VM on the Mac Mini, do not assume that:

```text
localhost
```

means the macOS host.

Use the Mac Mini's LAN address when necessary.

For example:

```text
http://192.168.1.50:8000/v1
```

The exact address depends on your network.

---

# 11. Give the LLM Access to Home Assistant

This is where the system becomes much more interesting.

Instead of simply asking:

```text
"What is the weather?"
```

you can ask:

```text
"Turn off the downstairs lights."
```

The architecture becomes:

```text
Voice
  │
  ▼
Home Assistant
  │
  ▼
Conversation Agent
  │
  ▼
oMLX
  │
  ▼
Local LLM
  │
  ▼
Home Assistant tools
  │
  ▼
Smart-home device
```

The LLM does not directly control every device.

Home Assistant controls which entities are exposed to the AI.

This is an important security boundary.

Therefore:

> **Start with a small, carefully selected set of entities.**

---

# 12. Use Different Models for Different Jobs

One of the advantages of running oMLX as a model server is that there is no reason to use one LLM for everything.
