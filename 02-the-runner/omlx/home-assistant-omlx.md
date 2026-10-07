# Run a Local LLM with oMLX and Home Assistant

## Build a Private Local AI Voice Assistant on an Apple Silicon Mac Mini

Running a local LLM no longer requires a large GPU server or a complicated cluster.

For Apple Silicon, the **M6 Mac mini combined with MLX and oMLX** is now an especially attractive platform for an always-on local AI server.

A Mac mini can provide an excellent always-on platform for:

- Local LLM inference
- Home Assistant
- Voice control
- Speech-to-text
- Text-to-speech
- AI-powered home automation
- Local AI agents
- Open WebUI
- MCP and other AI tools

The basic architecture is:

```text
                    HOME NETWORK
                         │
                         ▼
              ┌─────────────────────┐
              │      MAC MINI       │
              │       M6 / 32 GB    │
              │                     │
              │   Home Assistant    │
              │         │           │
              │       oMLX          │
              │         │           │
              │     Local LLM       │
              │                     │
              │   Local STT / TTS   │
              │                     │
              └──────────┬──────────┘
                         │
                         │ LAN / Wi-Fi
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

This is particularly useful for LLM inference because the model can occupy a large portion of unified memory without being restricted by a comparatively small dedicated GPU VRAM pool.

Apple Silicon also provides excellent performance per watt, making the Mac mini attractive as an **always-on local AI server**.

---

# 2. Why the M6 Mac Mini Is Particularly Interesting for oMLX

The latest M6 Mac mini is an unusually good match for a local MLX/oMLX server.

The M6 Mac mini provides:

| Component | M6 Mac Mini |
|---|---|
| CPU | 12-core |
| GPU | 12-core |
| Neural Engine | Dual 16-core |
| Unified Memory | Up to 32 GB |
| Memory Bandwidth | Up to 170 GB/s |
| Networking | Ethernet + Wi-Fi |
| Form Factor | Very small |
| Power Consumption | Excellent for an always-on server |

Apple has also added **Neural Accelerators to each GPU core** in the M6 generation and reports up to 4× faster AI performance than the previous M4 Mac mini generation. Apple specifically reports up to 13.5× faster LLM prompt processing in LM Studio versus M1 Mac mini and up to 2.8× versus M4 in its published comparisons.

The important point for this project isn't simply that the M6 is faster.

It is that **oMLX is built specifically around Apple's MLX ecosystem**.

MLX is Apple's machine-learning framework optimized for Apple Silicon, while oMLX builds a persistent inference-server layer on top of that ecosystem.

That gives this architecture a particularly clean relationship:

```text
M6 Mac Mini
     │
     ▼
Apple Silicon
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

This is more Apple-native than treating the Mac as simply another machine running a generic inference backend.

---

# 3. Why oMLX Instead of Ollama on an Apple Silicon Mac?

Ollama remains an excellent local LLM runtime, and there is nothing inherently wrong with using it on a Mac.

However, this project is specifically targeting an **Apple Silicon local AI server**, which makes oMLX particularly interesting.

oMLX is built around Apple's MLX framework and is designed as an inference server optimized for Mac hardware. Its current architecture includes features particularly useful for persistent local AI and agentic workloads, including:

- MLX-native inference
- OpenAI-compatible API
- Anthropic-compatible API
- Multi-model serving
- Continuous batching
- Paged KV caching
- SSD-backed KV cache
- Model loading/unloading
- Model profiles
- Model aliases
- Model memory management
- Built-in administration dashboard
- Built-in chat
- Benchmarking
- MCP support
- macOS-native application/service support

One of oMLX's particularly interesting features is persistent KV caching.

Traditional local inference can repeatedly recompute large portions of a conversation or coding-agent context when the prompt prefix changes.

oMLX can persist KV-cache blocks between memory and SSD, allowing previously processed context to be reused.

This is particularly interesting for:

- coding agents
- long conversations
- tool calls
- MCP workflows
- OpenClaw
- OpenCode
- Codex
- other agentic applications

oMLX was specifically designed with these workloads in mind.

Therefore:

> **Ollama is an excellent general-purpose local LLM runtime. oMLX is particularly compelling when the Mac itself is the AI server and you want to exploit the Apple MLX ecosystem.**

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
- Open WebUI
- agents
- other local services

The M6 Mac mini is configurable up to 32 GB unified memory.

For a dedicated local AI server, I would choose **32 GB rather than 16 GB**.

---

# 5. Software Architecture

The modern stack looks like this:

```text
                         MAC MINI
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
       Home Assistant      oMLX       Open WebUI
             │              │              │
             │              ▼              │
             │          Local LLM          │
             │                             │
             ├── Assist                    │
             ├── Automations               │
             ├── Devices                   │
             ├── Scenes                    │
             └── Voice                     │
                                           │
                                           ▼
                                     Browser Chat
```

### Core components

| Component | Role |
|---|---|
| **Home Assistant** | Smart-home platform and voice orchestration |
| **oMLX** | Apple Silicon local LLM inference server |
| **Local LLM** | Reasoning/conversation |
| **Speech-to-Text** | Converts voice into text |
| **Text-to-Speech** | Converts responses into speech |
| **Voice Preview Edition** | Microphone + speaker + physical voice interface |
| **Open WebUI** | Optional ChatGPT-style local AI interface |

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

Unlike Ollama, which is a general-purpose local model runtime, oMLX is built specifically around Apple's MLX ecosystem.

The architecture is:

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

oMLX provides an OpenAI-compatible API, allowing applications that support OpenAI-compatible endpoints to communicate with the local models.

The API is typically exposed through:

```text
http://localhost:8000/v1
```

rather than Ollama's traditional:

```text
http://localhost:11434
```

oMLX also provides an administration interface and built-in chat interface.

The current macOS application includes a first-run setup flow for storage and API-key configuration before starting the server.

---

# 9. Connecting oMLX to Home Assistant

This is an important architectural change from the original Ollama version of this guide.

Home Assistant does not need a dedicated native "oMLX integration."

Instead, oMLX's **OpenAI-compatible API** can be used as the LLM backend.

The conceptual architecture is:

```text
Home Assistant
       │
       │ OpenAI-compatible API
       ▼
      oMLX
       │
       ▼
    MLX / Metal
       │
       ▼
   Local LLM
```

The exact Home Assistant configuration can change as Home Assistant's LLM/Conversation integrations evolve, so configure the LLM provider using its OpenAI-compatible/custom endpoint support rather than assuming an Ollama-specific integration.

The important values are:

```text
Base URL:
http://<MAC-MINI-IP>:8000/v1

API Key:
<oMLX API key>

Model:
<oMLX model name or alias>
```

If Home Assistant and oMLX are on the same Mac but Home Assistant is inside a VM, **do not assume `localhost` means the macOS host**.

Use the Mac Mini's LAN address when required.

For example:

```text
http://192.168.1.50:8000/v1
```

The exact address depends on your network.

---

# 10. oMLX API Authentication

Current oMLX versions use an API-key-based authentication model by default.

During initial setup, create the API key in the oMLX administration interface.

This key is then used by external applications communicating with the oMLX API.

Conceptually:

```text
Home Assistant
      │
      │ Authorization: Bearer <API KEY>
      ▼
     oMLX
```

The key should be treated like a password.

Do not place it in public GitHub repositories, screenshots, configuration examples, or publicly accessible automation files.

oMLX stores its configuration under:

```text
~/.omlx/
```

The current oMLX documentation also supports explicitly enabling unauthenticated inference, but that should be treated as an exception rather than the normal configuration.

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

Home Assistant controls which entities and tools are exposed to the AI.

This is an important security boundary.

Therefore:

> **Start with a small, carefully selected set of Home Assistant entities.**

---

# 12. Use Different Models for Different Jobs

One of the advantages of running oMLX as a model server is that there is no reason to use one LLM for everything.

For example:

```text
                      oMLX
                       │
              ┌────────┼────────┐
              │        │        │
              ▼        ▼        ▼
           Fast AI  General AI  Reasoning AI
              │        │        │
              ▼        ▼        ▼
           Voice   Conversation  Complex Tasks
```

### Fast voice model

Use a small model for:

- Lights
- Temperature
- Timers
- Simple questions
- Home Assistant tools

### General model

Use a medium model for:

- Conversation
- Planning
- Explanations
- General questions

### Large reasoning model

Use a larger model for:

- Complex reasoning
- Coding
- Research
- Long-context tasks

The M6/32 GB configuration makes this multi-model approach particularly interesting because oMLX can manage models rather than requiring the entire system to revolve around a single resident model.

---

# 13. oMLX Model Management

oMLX is more than a process that launches one model.

Its administration interface allows you to manage the local model pool.

Useful capabilities include:

- Download models
- Load models
- Unload models
- Pin models
- Configure model aliases
- Configure model profiles
- Set idle behavior
- Benchmark models
- Monitor inference
- Manage multiple models

This allows the Mac Mini to behave more like a small **local inference server** than a simple chatbot computer.

For example:

```text
                   oMLX
                    │
       ┌────────────┼────────────┐
       │            │            │
       ▼            ▼            ▼
   Voice Model   General       Coding
       │            │            │
       ▼            ▼            ▼
   Fast Tasks   Conversation  Agents
```

---

# 14. Why oMLX's KV Cache Matters

One of oMLX's most interesting features for this project is its persistent KV-cache architecture.

Traditional inference can repeatedly recompute context when the prompt changes.

This becomes particularly painful with coding agents and tool-heavy workflows.

For example:

```text
User
  │
  ▼
Agent
  │
  ├── Tool call
  │
  ├── Tool result
  │
  ├── New request
  │
  ├── Another tool call
  │
  └── New request
```

The context may become extremely large.

oMLX can maintain KV-cache data across a hot RAM tier and a cold SSD tier.

Conceptually:

```text
             Context
                │
                ▼
           KV Cache
                │
       ┌────────┴────────┐
       │                 │
       ▼                 ▼
   Unified RAM          SSD
     HOT                COLD
```

This can be particularly valuable for:

- OpenClaw
- OpenCode
- Codex
- Claude Code-style workflows
- MCP
- long conversations
- tool-heavy agents

This is one of the strongest reasons to consider oMLX for an always-on Apple Silicon AI server rather than simply treating the Mac as a desktop chatbot.

---

# 15. Home Assistant Voice Preview Edition

Rather than building a custom microphone/speaker system, use the official:

**Home Assistant Voice Preview Edition**

It is designed specifically as a dedicated Home Assistant voice endpoint.

It includes:

- Dual microphones
- XMOS XU316 audio processor
- Echo cancellation
- Noise removal
- Automatic gain control
- Built-in speaker
- Physical microphone mute
- Rotary volume control
- Multipurpose button
- LED status ring
- 3.5 mm stereo audio output
- ESP32-S3
- Wi-Fi
- Bluetooth

The Voice Preview Edition is therefore a **voice satellite**, not the LLM server.

The Mac Mini performs the computationally intensive AI work.

---

# 16. Why Voice Preview Edition?

The Voice Preview Edition gives the system a proper physical interface.

```text
          VOICE PREVIEW EDITION

             🎤 🎤
          Microphones
               │
               ▼
          Voice command
               │
               ▼
             Network
               │
               ▼
            Mac Mini
               │
        ┌──────┴──────┐
        │             │
   Home Assistant   oMLX
        │             │
        └──────┬──────┘
               │
               ▼
              TTS
               │
               ▼
        Voice Preview
               │
               ▼
              🔊
```

---

# 17. Hardware Privacy

One of my favorite features of the Voice Preview Edition for a privacy-first installation is the physical microphone switch.

The switch physically cuts power to the microphones.

```text
             MUTE
              │
              ▼
       ┌────────────────┐
       │ Microphones OFF│
       └────────────────┘
```

This is much better than relying solely on a software mute indicator.

---

# 18. Speech-to-Text

There are two broad local approaches.

### Focused local voice

Home Assistant's **Speech-to-Phrase** system is designed for a limited set of home-control commands.

It is extremely lightweight but isn't a general-purpose speech recognition system.

For example:

```text
"Turn on the kitchen lights."
```

works well.

But:

```text
"Explain the current geopolitical situation."
```

is obviously outside its purpose.

### Full local speech recognition

For general speech, Home Assistant supports fully local STT such as **Whisper** through the Wyoming ecosystem.

The Mac Mini is much better suited to this than a low-power voice satellite.

```text
Voice PE
   │
   ▼
Audio
   │
   ▼
Whisper
   │
   ▼
Text
```

---

# 19. Text-to-Speech

The reverse process is:

```text
Local LLM
    │
    ▼
Text
    │
    ▼
Local TTS
    │
    ▼
Audio
    │
    ▼
Voice Preview Edition
    │
    ▼
   🔊
```

A local TTS engine such as **Piper** can be used when you want the entire voice pipeline to remain local.

This means:

```text
🎤
 │
 ▼
Local STT
 │
 ▼
Home Assistant
 │
 ▼
oMLX
 │
 ▼
Local LLM
 │
 ▼
Local TTS
 │
 ▼
🔊
```

No cloud AI service is required for the core pipeline.

---

# 20. Fully Local vs Cloud

Home Assistant Voice supports several processing models.

### Fully local

```text
Voice PE
   │
   ▼
Mac Mini
   │
   ├── STT
   ├── Home Assistant
   ├── oMLX
   └── TTS
   │
   ▼
Voice PE
```

### Hybrid

```text
Voice PE
   │
   ▼
Home Assistant
   │
   ├── Local Home Automation
   ├── Local STT
   └── Local oMLX
```

with selected cloud services available when desired.

### Cloud

Home Assistant Cloud can provide speech processing for users who don't want to run the heavier local STT/TTS stack.

For this project, the recommended philosophy is:

> **Local by default. Cloud only when deliberately enabled.**

---

# 21. Wake Words

The Voice Preview Edition has an on-device wake-word engine.

Current default wake words include:

- **Okay Nabu**
- **Hey Jarvis**
- **Hey Mycroft**

The wake-word detection happens on the device using microWakeWord.

The resulting interaction becomes:

```text
"Hey Jarvis"
      │
      ▼
Voice PE wakes
      │
      ▼
"You..."
      │
      ▼
Speech-to-Text
      │
      ▼
Home Assistant / oMLX
      │
      ▼
TTS
      │
      ▼
Voice PE speaks
```

---

# 22. Open WebUI

Open WebUI is optional.

It provides a browser-based ChatGPT-style interface for your local models.

```text
Browser
   │
   ▼
Open WebUI
   │
   ▼
oMLX
   │
   ▼
Local LLM
```

It is useful for:

- Testing models
- Comparing models
- Normal text conversations
- Uploading documents
- Experimenting with prompts
- Managing local AI outside Home Assistant

Keep the roles separate:

```text
VOICE

Voice PE → Home Assistant → oMLX


CHAT

Browser → Open WebUI → oMLX
```

Both ultimately use the same local AI backend.

---

# 23. Caching and Pre-Computed Information

Don't make an LLM perform expensive work every time someone asks a common question.

For example, instead of asking a large model to analyze weather information every time:

```text
User
 │
 ▼
Large LLM
 │
 ▼
Weather analysis
```

you can periodically generate a summary:

```text
Weather data
     │
     ▼
Large LLM
     │
     ▼
Cached summary
     │
     ▼
Fast voice model
```

Then a voice query such as:

> "What's the weather?"

can be answered almost immediately.

This concept remains highly relevant with oMLX because its persistent server architecture allows you to keep different models available for different workloads.

---

# 24. Recommended Model Strategy

For an M6 Mac Mini with 32 GB unified memory, use this strategy:

| Workload | Model Type | Priority |
|---|---|---|
| Home Assistant commands | Small/fast | **Very high** |
| Voice conversation | Small/medium | **High** |
| General assistant | Medium | High |
| Complex reasoning | Larger | Medium |
| Vision | Multimodal | Optional |
| Coding | Coding model | Optional |
| Agents/tools | Tool-capable | **High** |

Don't hard-code one model into the architecture.

Instead:

```text
                    oMLX
                     │
          ┌──────────┼──────────┐
          │          │          │
          ▼          ▼          ▼
       Voice      General     Coding
       Model       Model       Model
          │          │          │
          ▼          ▼          ▼
       HA Voice    Chat      Agents
```

This lets the M6 Mac Mini act as a **local model server** rather than merely a machine running one chatbot.

---

# 25. Security: Don't Expose oMLX to the Internet

oMLX should remain on the trusted LAN unless you have deliberately designed a secure remote-access architecture.

Recommended:

```text
Home LAN
   │
   ├── Mac Mini
   │      │
   │      └── oMLX :8000
   │
   ├── Voice PE
   │
   └── Home Assistant
```

Avoid:

```text
Internet
   │
   ▼
oMLX :8000
```

If remote access is required, use a VPN or another properly authenticated access layer rather than exposing the inference server directly.

This is particularly important because Home Assistant can give an LLM access to real devices.

---

# 26. Entity Exposure Is a Security Boundary

Don't expose every Home Assistant entity to the LLM.

Start with a small set:

```text
LLM
 │
 ├── Kitchen lights
 ├── Living room lights
 ├── Thermostat
 ├── Bedroom fan
 └── Office lights
```

Then expand gradually.

This reduces:

- Prompt size
- Model confusion
- Latency
- Tool-call errors
- Unintended device control

The principle is simple:

> **Give the AI only the tools and devices it actually needs.**

---

# 27. Final Architecture

The modern version of this project should look like this:

```text
                         HOME NETWORK
                              │
                              │
                    ┌─────────▼─────────┐
                    │     MAC MINI      │
                    │       M6          │
                    │      32 GB        │
                    │                   │
                    │       macOS       │
                    │         │         │
                    │  ┌──────▼───────┐ │
                    │  │Home Assistant│ │
                    │  │     OS VM    │ │
                    │  └──────┬───────┘ │
                    │         │         │
                    │       Assist      │
                    │         │         │
                    │         ▼         │
                    │       oMLX        │
                    │         │         │
                    │         ▼         │
                    │     Local LLM     │
                    │                   │
                    │  Whisper / STT    │
                    │  Piper / TTS      │
                    │                   │
                    │  Open WebUI       │
                    │  MCP / Agents     │
                    └─────────┬─────────┘
                              │
                         LAN / Wi-Fi
                              │
                    ┌─────────▼─────────┐
                    │ HOME ASSISTANT    │
                    │ VOICE PE          │
                    │                   │
                    │ 🎤 Dual Mics      │
                    │ 🔊 Speaker        │
                    │ 🔇 Hardware Mute  │
                    │ 🔘 Action Button  │
                    │ 🎛 Volume          │
                    └───────────────────┘
```

---

# 28. The Complete Voice Conversation

A typical interaction now looks like:

```text
User:

"Hey Jarvis, what's the temperature
in the living room?"

             │
             ▼

       Voice Preview Edition
             │
             ▼
       Local Speech-to-Text
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
        Home Assistant
             │
             ▼
        Text-to-Speech
             │
             ▼
       Voice Preview Edition
             │
             ▼
            🔊

"The living room is 71 degrees."
```

The entire exchange can remain inside your home.

---

# 29. Optional AI Expansion

Once the basic system works, the Mac Mini can become a much broader local AI platform.

```text
                    MAC MINI
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
   Home Assistant     oMLX       Open WebUI
          │            │            │
          │            │            │
          ▼            ▼            ▼
   Smart Home      Local LLMs      Chat
                       │
                       ├── MCP
                       ├── Agents
                       ├── Coding
                       └── RAG
```

Later, the same infrastructure could integrate with:

- Frigate
- Home Assistant automations
- MCP servers
- OpenClaw
- Hermes
- Codex
- Local RAG
- Local knowledge bases
- Calendar
- Weather
- Notifications
- Security events

The important thing is to add those **after the basic voice pipeline is stable**.

---

# 30. Recommended Build Order

Don't install everything simultaneously.

### Phase 1 — Mac Mini

```text
Mac Mini M6
    ↓
macOS
    ↓
oMLX
```

Verify local LLM inference.

### Phase 2 — Home Assistant

```text
Mac Mini
    ↓
Home Assistant OS VM
```

Verify Home Assistant independently.

### Phase 3 — oMLX + Home Assistant

```text
Home Assistant
      ↓
    oMLX
      ↓
   Local LLM
```

Verify text-based conversation first.

### Phase 4 — Voice Preview Edition

```text
Voice PE
    ↓
Home Assistant
```

Verify:

- Microphone
- Speaker
- Wake word
- Button
- Volume
- Hardware mute

### Phase 5 — Local STT/TTS

```text
Voice PE
    ↓
Local STT
    ↓
Home Assistant
    ↓
oMLX
    ↓
Local TTS
    ↓
Voice PE
```

At this point you have a **fully local voice AI assistant**.

### Phase 6 — Smart Home Control

Expose a small number of Home Assistant entities.

```text
Voice
 ↓
LLM
 ↓
Home Assistant tools
 ↓
Devices
```

### Phase 7 — Advanced AI

Add:

```text
MCP
Agents
RAG
Frigate
Vision
OpenClaw
Hermes
Codex
```

Only as needed.

---

# 31. The End Result

The goal is no longer simply:

> "Run an LLM on a Mac Mini."

The goal is:

> **Build a private local AI server that also happens to run your home's voice interface.**

The resulting system has four primary layers:

| Layer | Technology | Purpose |
|---|---|---|
| **Voice hardware** | Home Assistant Voice Preview Edition | Ears + mouth |
| **Automation** | Home Assistant | Home control + Assist |
| **AI runtime** | **oMLX / MLX** | Local Apple Silicon inference |
| **AI models** | Qwen / Gemma / other MLX models | Reasoning + conversation |

And optionally:

| Layer | Technology | Purpose |
|---|---|---|
| Chat UI | Open WebUI | Browser-based AI |
| STT | Whisper | General speech recognition |
| TTS | Piper | Local speech synthesis |
| Agents | MCP / OpenClaw / Hermes | Tool use and automation |
| Vision | Qwen-VL etc. | Image/video understanding |
| RAG | Qdrant/etc. | Local knowledge |

The important architectural change is that **oMLX is no longer just being substituted for Ollama**.

The Mac Mini becomes an **Apple-native local AI server**:

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
       ┌──────────┼──────────┐
       │          │          │
       ▼          ▼          ▼
   Home        Open WebUI   Agents
 Assistant        │          │
       │          │          │
       └──────────┼──────────┘
                  │
                  ▼
             Local LLMs
                  │
                  ▼
          Local AI Services
                  │
                  ▼
       Home Assistant Voice
```

**The M6 Mac Mini becomes the permanent local AI server. The Voice Preview Edition becomes the human interface. Home Assistant is the orchestration and smart-home layer. MLX provides the Apple-native ML foundation. And oMLX becomes the persistent local inference server sitting between the applications and the models.**
