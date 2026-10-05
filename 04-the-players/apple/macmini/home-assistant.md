# Run a Local LLM with Ollama and Home Assistant

## Build a Private Local AI Voice Assistant on an Apple Silicon Mac Mini

Running a local LLM no longer requires a large GPU server or a complicated cluster.

An Apple Silicon Mac Mini can provide an excellent always-on platform for:

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
              │                     │
              │   Home Assistant    │
              │         │           │
              │       Ollama        │
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

This is particularly useful for LLM inference because the model can occupy a large portion of unified memory without being restricted by a small dedicated GPU VRAM pool.

Apple Silicon also provides good performance per watt, making a Mac Mini attractive as an **always-on local AI server**.

The same architectural concept applies to newer Apple Silicon Mac Minis; model selection should simply be matched to the amount of unified memory available.

---

# 2. Recommended Mac Mini

For an AI + Home Assistant server, I would prioritize memory over storage.

| Component | Recommendation |
|---|---|
| Apple Silicon | Required |
| Memory | **32 GB minimum / preferred** |
| Storage | **1 TB recommended** |
| Networking | **Ethernet preferred** |
| Wi-Fi | Supported |
| Monitor | Required only for initial setup |
| Keyboard/mouse | Required only for initial setup |
| Always-on | **Yes** |
| UPS | Recommended |

For this project, **32 GB unified memory is a very good starting point**.

More memory gives you more flexibility to run larger local models while Home Assistant and other services remain active.

---

# 3. Software Architecture

The modern stack looks like this:

```text
                         MAC MINI
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
       Home Assistant     Ollama       Open WebUI
             │              │
             │              ▼
             │          Local LLM
             │
             ├── Assist
             ├── Automations
             ├── Devices
             ├── Scenes
             └── Voice
                            │
                            ▼
                  Voice Preview Edition
```

### Core components

| Component | Role |
|---|---|
| **Home Assistant** | Smart-home platform and voice orchestration |
| **Ollama** | Local LLM runtime |
| **Local LLM** | Reasoning/conversation |
| **Speech-to-Text** | Converts voice into text |
| **Text-to-Speech** | Converts responses into speech |
| **Voice Preview Edition** | Microphone + speaker + physical voice interface |
| **Open WebUI** | Optional ChatGPT-style local AI interface |

---

# 4. Home Assistant

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

> **Home Assistant controls the home. Ollama provides the general-purpose AI intelligence.**

---

# 5. Home Assistant on the Mac Mini

Home Assistant can run on an Apple Silicon Mac through a virtual machine using **Home Assistant OS**. [Link here to VM](https://www.home-assistant.io/installation/macos/)

Home Assistant's current macOS installation documentation supports running the Home Assistant OS image in a VM on Apple Silicon Macs.

The architecture becomes:

```text
                MAC MINI
                   │
                macOS
                   │
          ┌────────▼────────┐
          │  Home Assistant │
          │       OS        │
          │       VM        │
          └─────────────────┘
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
   └── Ollama
```

I would **not** put Ollama inside the Home Assistant VM.

Keep the AI runtime on macOS and let Home Assistant communicate with it over the network.

That creates a clean separation:

```text
Home Assistant OS
        │
        │ HTTP/API
        ▼
Ollama on macOS
        │
        ▼
Local LLM
```

---

# 6. Ollama

Ollama is the local model runtime.

It downloads and manages models and provides an API that other applications can use.

For example:

```bash
ollama run qwen3.5:9b
```

or another model appropriate for the Mac Mini's available memory.

Ollama exposes its local API on:

```text
http://localhost:11434
```

Other applications can communicate with Ollama through that API.

---

# 7. Connecting Ollama to Home Assistant

This is one area where the original article can be modernized significantly.

Home Assistant now has an **official Ollama integration**.

Go to:

```text
Settings
   ↓
Devices & services
   ↓
Add Integration
   ↓
Ollama
```

Then provide the address of the Ollama server.

If Ollama and Home Assistant are running on the same Mac but Home Assistant is inside a VM, use the Mac Mini's LAN address rather than assuming `localhost` refers to the macOS host.

For example:

```text
http://192.168.1.50:11434
```

The exact address will depend on your network.

The official integration supports selecting an Ollama model and configuring the conversation agent. It can also give the model access to exposed Home Assistant entities.

---

# 8. Give the LLM Access to Home Assistant

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
Ollama
  │
  ▼
Local LLM
  │
  ▼
Home Assistant Assist API
  │
  ▼
Smart-home device
```

The LLM does not directly control every device.

Home Assistant controls which entities are exposed to the AI.

This is an important security boundary.

Home Assistant's current Ollama integration recommends exposing fewer than 25 entities initially, and only models with tool support can control Home Assistant. Smaller models are more likely to make mistakes.

Therefore:

> **Start with a small, carefully selected set of entities.**

---

# 9. Use Different Models for Different Jobs

One of the biggest improvements over the original architecture is that there is no reason to use one LLM for everything.

For example:

```text
                    Ollama
                       │
             ┌─────────┼─────────┐
             │         │         │
             ▼         ▼         ▼
          Fast AI   General AI  Reasoning AI
             │         │         │
             ▼         ▼         ▼
          Voice     Conversation Complex Tasks
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

Home Assistant allows multiple Ollama conversation agents, making this multi-model approach practical.

---

# 10. Home Assistant Voice Preview Edition

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

The current recommended MSRP is **$69 USD**, before applicable taxes.
[Link here to Product](https://www.home-assistant.io/voice-pe/)

---

# 11. Why Voice Preview Edition?

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
   Home Assistant   Ollama
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

The Voice Preview Edition is therefore a **voice satellite**, not the LLM server.

---

# 12. Hardware Privacy

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

# 13. Speech-to-Text

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
"Explain the current geopolitical situation in the Middle East."
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

Home Assistant notes that fully local Whisper requires considerably more compute than focused Speech-to-Phrase processing.

---

# 14. Text-to-Speech

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
Ollama
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

# 15. Fully Local vs Cloud

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
   ├── Ollama
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
   └── Local Ollama
```

with selected cloud services available when desired.

### Cloud

Home Assistant Cloud can provide speech processing for users who don't want to run the heavier local STT/TTS stack.

Home Assistant explicitly states that Home Assistant Cloud is **not required** for Voice Preview Edition.

For this project, the recommended philosophy is:

> **Local by default. Cloud only when deliberately enabled.**

---

# 16. Wake Words

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
Home Assistant / Ollama
      │
      ▼
TTS
      │
      ▼
Voice PE speaks
```

---

# 17. Open WebUI

Open WebUI is optional.

It provides a browser-based ChatGPT-style interface for your local models.

```text
Browser
   │
   ▼
Open WebUI
   │
   ▼
Ollama
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

I would **not** make Open WebUI part of the voice pipeline, yet.

Keep the roles separate:

```text
VOICE
Voice PE → Home Assistant → Ollama

CHAT
Browser → Open WebUI → Ollama
```

Both ultimately use the same local AI backend.

---

# 18. Caching and Pre-Computed Information

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

This concept remains highly relevant.

---

# 19. Recommended Model Strategy

For Mac Mini, I'd modernize the model strategy substantially.

Use this strategy:

| Workload | Model Type | Priority |
|---|---|---|
| Home Assistant commands | Small/fast | **Very high** |
| Voice conversation | Small/medium | **High** |
| General assistant | Medium | High |
| Complex reasoning | Large | Medium |
| Vision | Multimodal | Optional |
| Coding | Coding model | Optional |
| Agents/tools | Tool-capable | **High** |

For example, a small **Spark-X2.5** model could be an interesting candidate for fast tool-oriented voice interactions, while larger Qwen/Gemma-class models can remain available for heavier tasks.

The model should be selected based on the Mac Mini's actual memory configuration and current model availability rather than hard-coding a model into the architecture.

---

# 20. Security: Don't Expose Ollama to the Internet

Ollama should remain on the trusted LAN.

Recommended:

```text
Home LAN
   │
   ├── Mac Mini
   │      │
   │      └── Ollama :11434
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
Ollama :11434
```

If remote access is required, use a VPN rather than exposing the Ollama API directly.

This is particularly important because Home Assistant can give an LLM access to real devices.

---

# 21. Entity Exposure Is a Security Boundary

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

Home Assistant specifically recommends exposing fewer than 25 entities when experimenting with Ollama control.

This reduces:

- Prompt size
- Model confusion
- Latency
- Tool-call errors
- Unintended device control

---

# 22. Final Architecture

The modern version of this project should look like this:

```text
                         HOME NETWORK
                              │
                              │
                  ┌───────────▼───────────┐
                  │       MAC MINI        │
                  │       32 GB+          │
                  │                       │
                  │        macOS          │
                  │          │            │
                  │  ┌───────▼────────┐   │
                  │  │ Home Assistant │   │
                  │  │      OS VM     │   │
                  │  └───────┬────────┘   │
                  │          │            │
                  │       Assist          │
                  │          │            │
                  │          ▼            │
                  │       Ollama          │
                  │          │            │
                  │          ▼            │
                  │      Local LLM        │
                  │                       │
                  │  Whisper / STT        │
                  │  Piper / TTS          │
                  │                       │
                  │  Open WebUI           │
                  │  MCP / Agents         │
                  └───────────┬───────────┘
                              │
                         LAN / Wi-Fi
                              │
                ┌─────────────▼─────────────┐
                │ HOME ASSISTANT VOICE PE   │
                │                           │
                │ 🎤 Dual Microphones       │
                │ 🔊 Speaker                │
                │ 🔇 Hardware Mute          │
                │ 🔘 Action Button          │
                │ 🎛 Volume Control         │
                └───────────────────────────┘
```

---

# 23. The Complete Voice Conversation

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
           Ollama
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

# 24. Optional AI Expansion

Once the basic system works, the Mac Mini can become a much broader local AI platform.

```text
                    MAC MINI
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
 Home Assistant     Ollama       Open WebUI
        │              │              │
        │              │              │
        ▼              ▼              ▼
 Smart Home       Local LLMs       Chat
        │              │
        │              ├── MCP
        │              ├── Agents
        │              ├── Coding
        │              └── RAG
        │
        ▼
 Voice PE
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

# 25. Recommended Build Order

Don't install everything simultaneously.

### Phase 1 — Mac Mini

```text
Mac Mini
    ↓
macOS
    ↓
Ollama
```

Verify local LLM inference.

### Phase 2 — Home Assistant

```text
Mac Mini
    ↓
Home Assistant OS VM
```

Verify Home Assistant independently.

### Phase 3 — Ollama + Home Assistant

```text
Home Assistant
      ↓
    Ollama
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
Ollama
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

# 26. The End Result

The goal is no longer simply:

> "Run an LLM on a Mac Mini."

The goal is:

> **Build a private local AI server that also happens to run your home's voice interface.**

The resulting system has four distinct layers:

| Layer | Technology | Purpose |
|---|---|---|
| **Voice hardware** | Home Assistant Voice Preview Edition | Ears + mouth |
| **Automation** | Home Assistant | Home control + Assist |
| **AI runtime** | Ollama | Local model execution |
| **AI models** | Qwen / Gemma / Spark / etc. | Reasoning + conversation |

And optionally:

| Layer | Technology | Purpose |
|---|---|---|
| Chat UI | Open WebUI | Browser-based AI |
| STT | Whisper | General speech recognition |
| TTS | Piper | Local speech synthesis |
| Agents | MCP / OpenClaw / Hermes | Tool use and automation |
| Vision | Qwen-VL etc. | Image/video understanding |
| RAG | Qdrant/etc. | Local knowledge |

This is a much more future-proof architecture than tying the project to one particular model or one particular voice engine.

**The Mac Mini becomes the permanent local AI server. The Voice Preview Edition becomes the human interface. Home Assistant is the orchestration and smart-home layer. Ollama is the model runtime.**
