# Text-to-Spech | Voice Commands

I would structure the guide around **two independent setups**, with the MacBook designed to remain fully functional when you leave home.

# Local Voice AI / TTS on Mac

The basic requirement is simple:

**Voice command → Speech-to-Text (STT) → LLM → Text-to-Speech (TTS) → Speaker**

There are two ways to implement it:

1. **Mac Mini as an always-on voice/AI server**
2. **MacBook as a completely self-contained portable voice AI**

If you own both, the best architecture is **both**: the Mini handles the heavy/always-on services at home, while the MacBook can operate independently when traveling.

---

# 1. Mac Mini — Always-On Voice AI Server

The Mac Mini doesn't need a microphone or speakers if you're going to interact with it through your MacBook, phone, Home Assistant, etc.

### Mac Mini role

```text
                 HOME NETWORK
                      │
                      ▼
              ┌─────────────────┐
              │    MAC MINI     │
              │   Always On     │
              │                 │
              │  Whisper / STT  │
              │       ↓         │
              │      Ollama     │
              │       ↓         │
              │     Piper/TTS   │
              │                 │
              │ Home Assistant  │
              │ Wyoming         │
              │ MCP / Agents    │
              └────────┬────────┘
                       │
                 LAN / Wi-Fi
                       │
                       ▼
              ┌─────────────────┐
              │    MACBOOK      │
              │                 │
              │  Microphone     │
              │       ↑         │
              │     Voice       │
              │       ↓         │
              │    Speaker      │
              └─────────────────┘
```

### What the Mini needs

| Component | Recommendation |
|---|---|
| Mac Mini | Apple Silicon |
| RAM | **32 GB ideal** |
| Storage | **1 TB preferred** |
| Network | Ethernet preferred |
| Monitor | Not required after setup |
| Keyboard/mouse | Not required |
| Microphone | Not required |
| Speakers | Not required |
| UPS | Highly recommended |
| Ollama | Yes |
| Whisper / whisper.cpp | Yes |
| Piper TTS | Yes |
| Wyoming | Recommended |
| Home Assistant | Optional |
| OpenWakeWord | Optional |

Your upcoming **32 GB Mac Mini** is therefore a very good candidate for this role.

---

## Mac Mini software stack

I would build the Mini around:

```text
                 MAC MINI
                    │
       ┌────────────┴────────────┐
       │                         │
   Speech-to-Text             LLM
   Whisper / whisper.cpp       Ollama
       │                         │
       └────────────┬────────────┘
                    │
                  TTS
                  Piper
                    │
               Wyoming API
                    │
        ┌───────────┴───────────┐
        │                       │
    MacBook                  Home Assistant
    Voice UI                  Smart Home
```

### STT

**Whisper** converts:

> "What's the weather tomorrow?"

into text.

For the Mini, you can use:

- `whisper.cpp`
- Whisper models
- Wyoming-compatible Whisper services

### LLM

**Ollama** becomes the brain:

```text
Voice
  ↓
Whisper
  ↓
Ollama
  ↓
Qwen / Gemma / Spark / other model
  ↓
Piper
  ↓
Voice
```

For a lightweight always-on assistant, your **Spark-X2.5-4B** work is particularly relevant.

You could have:

```text
Fast voice assistant
        ↓
Spark-X2.5-4B
```

while using a larger Qwen/Gemma model for more complicated tasks.

### TTS

**Piper** is an excellent local TTS option because it is:

- Local
- Fast
- Lightweight
- Open source
- Suitable for always-on operation
- Doesn't require an Internet service

The Mini generates the speech audio and sends it back to the client.

---

# 2. MacBook — Completely Self-Contained Voice AI

This is the important part for travel.

**Do not make the MacBook dependent on the Mini.**

When you're at home:

```text
MacBook
   ↓
Mac Mini
   ↓
AI processing
   ↓
MacBook speakers
```

When traveling:

```text
MacBook
   ↓
Local Whisper
   ↓
Local Ollama
   ↓
Local LLM
   ↓
Local Piper
   ↓
MacBook speakers
```

No Mini required.

---

# MacBook hardware advantage

The MacBook already has everything necessary:

| Requirement | MacBook |
|---|---|
| Microphone | ✅ Built in |
| Speakers | ✅ Built in |
| CPU | ✅ |
| GPU | ✅ Apple Silicon |
| Unified memory | ✅ |
| Network | ✅ |
| Battery | ✅ |
| Display | ✅ |

So the MacBook can be a **complete portable voice-AI computer**.

Your **M4 Max / 36 GB** MacBook is particularly well suited to this.

---

# MacBook local architecture

```text
             MACBOOK
       ┌─────────────────────┐
       │                     │
       │   🎤 Microphone     │
       │         │           │
       │         ▼           │
       │      Whisper        │
       │         │           │
       │         ▼           │
       │       Ollama        │
       │         │           │
       │         ▼           │
       │    Local LLM        │
       │         │           │
       │         ▼           │
       │       Piper         │
       │         │           │
       │         ▼           │
       │    🔊 Speakers      │
       │                     │
       └─────────────────────┘
```

Nothing external is required.

---

# Recommended MacBook software

I'd install:

### 1. Ollama

Your local LLM runtime.

For example:

```bash
ollama run SparkLLM/Spark-X2.5-4B
```

or a larger local model appropriate for the MacBook's memory.

### 2. Whisper

For speech recognition:

```text
Microphone
     ↓
Whisper
     ↓
Text
```

### 3. Piper

For speech generation:

```text
Text
 ↓
Piper
 ↓
WAV/audio
 ↓
MacBook speakers
```

### 4. Optional: OpenWakeWord

This adds:

> "Hey Assistant..."

so you don't have to manually activate the voice interface.

### 5. Optional: Wyoming

Wyoming gives you a useful standardized voice-assistant protocol and becomes particularly valuable if you eventually integrate Home Assistant.

---

# The important difference between the two Macs

I would **not** configure them identically.

| Function | Mac Mini | MacBook |
|---|---:|---:|
| Always running | **Yes** | No |
| Voice server | **Primary** | Secondary |
| STT | **Yes** | **Yes** |
| Ollama | **Yes** | **Yes** |
| TTS | **Yes** | **Yes** |
| Microphone | Optional | **Built-in** |
| Speakers | Optional | **Built-in** |
| Home Assistant | **Yes** | Optional |
| MCP servers | **Yes** | Yes |
| Agents | **Yes** | Yes |
| Internet required | No | No |
| Portable | No | **Yes** |
| Works without Mini | N/A | **Yes** |

That gives you **redundancy** rather than creating a dependency.

---

# When Both Macs Are Together

At home, I would use the Mini as the primary AI server.

```text
                 HOME

        🎤 MacBook microphone
                 │
                 │
                 ▼
        ┌─────────────────┐
        │    MAC MINI     │
        │                 │
        │    Whisper      │
        │       ↓         │
        │     Ollama      │
        │       ↓         │
        │     Piper       │
        └────────┬────────┘
                 │
                 ▼
        🔊 MacBook speakers
```

This lets the MacBook act almost like a **thin voice terminal** when you're home.

The heavy work can remain on the Mini.

---

# When You Travel

The MacBook automatically becomes the entire system:

```text
              TRAVEL

       🎤 MacBook microphone
                │
                ▼
          Local Whisper
                │
                ▼
          Local Ollama
                │
                ▼
          Local LLM
                │
                ▼
            Local Piper
                │
                ▼
        🔊 MacBook speakers
```

No:

- Mac Mini
- Home network
- VPN
- Cloud API
- Internet connection

is necessary.

That's the architecture I'd recommend for your privacy-first setup.

---

# Optional: Remote Access to the Mini

When traveling, there's a third mode.

```text
                   INTERNET
                      │
                      │ VPN
                      ▼
             ┌─────────────────┐
             │    MAC MINI     │
             │     HOME        │
             │                 │
             │ Ollama          │
             │ Whisper         │
             │ Piper           │
             │ Agents          │
             └────────┬────────┘
                      │
                      │
                   MacBook
                   TRAVEL
```

You could use a VPN such as **Tailscale/WireGuard**, but this should be **optional**, not a requirement.

For example:

### Local travel mode

```text
MacBook → local Ollama
```

### Remote powerful mode

```text
MacBook → VPN → Mac Mini → Ollama
```

This gives you a nice choice:

**No Internet:** use MacBook locally.

**Internet available:** optionally use the more powerful Mini.

---

# My Recommended Final Architecture

For your particular setup, I'd build it as a **two-tier local AI system**:

```text
                    YOUR AI SYSTEM
                         │
             ┌───────────┴───────────┐
             │                       │
          HOME                    TRAVEL
             │                       │
             ▼                       ▼
       ┌──────────┐            ┌──────────┐
       │ Mac Mini │            │ MacBook  │
       │ 32 GB    │            │ M4 Max   │
       └────┬─────┘            │ 36 GB    │
            │                  └────┬─────┘
            │                       │
       ┌────┴─────┐            ┌────┴─────┐
       │  Whisper │            │  Whisper │
       │  Ollama  │            │  Ollama  │
       │  Piper   │            │  Piper   │
       │ Wyoming  │            │  Wyoming │
       │ Agents   │            │ Agents   │
       └────┬─────┘            └────┬─────┘
            │                       │
            ▼                       ▼
       MacBook                  MacBook
       speakers                 speakers
```

### The key principle

**The Mac Mini is your permanent AI infrastructure.**

**The MacBook is your portable, self-contained AI computer.**

That means you're never stranded without your voice assistant simply because you left the house.

---

## Recommended implementation order

I would build this in stages rather than installing everything simultaneously:

**Stage 1 — MacBook**

```text
Ollama
   +
Whisper
   +
Piper
   ↓
Local voice assistant
```

Get voice input → LLM → spoken response working completely locally.

**Stage 2 — Mac Mini**

Move the same components to the Mini and make it the always-on server.

**Stage 3 — Networking**

Make the MacBook automatically use the Mini when you're home.

**Stage 4 — Wake word**

Add OpenWakeWord.

**Stage 5 — Wyoming/Home Assistant**

Turn the system into a proper distributed voice-assistant platform.

**Stage 6 — Agents**

Connect your local AI to MCP, OpenClaw/Hermes, Codex, Home Assistant, Frigate, etc.

That last stage is where this becomes considerably more interesting than simply having a local Siri replacement.

---

# Mac Mini Only — Standalone Voice AI

The simplest architecture becomes:

```text
              ┌──────────────────────────┐
              │        MAC MINI          │
              │                          │
              │      🎤 Microphone       │
              │           ↓              │
              │        Whisper           │
              │           ↓              │
              │         Ollama           │
              │           ↓              │
              │         Piper            │
              │           ↓              │
              │      🔊 Speakers         │
              │                          │
              └──────────────────────────┘
```

The Mac Mini itself doesn't have a built-in microphone or speakers suitable for this, so you add them.

---

# What Does the Mac Mini Need?

| Component | Required? | Recommendation |
|---|---:|---|
| Mac Mini | ✅ | Apple Silicon |
| Monitor | ✅ Initially | Any HDMI/USB-C display |
| Keyboard | ✅ Initially | Any USB/Bluetooth |
| Mouse/trackpad | ✅ Initially | Any USB/Bluetooth |
| Microphone | **✅** | USB microphone |
| Speakers | **✅** | USB/3.5mm/Bluetooth speakers |
| Ollama | **✅** | Local LLM |
| Whisper | **✅** | Local STT |
| Piper | **✅** | Local TTS |
| Internet | ❌ | Only needed for downloads/updates |
| Cloud AI | ❌ | Not required |
| Home Assistant | Optional | For smart-home integration |
| Wake word | Optional | OpenWakeWord |

Once everything is configured, the monitor/keyboard/mouse can potentially be removed if you want the Mini to operate headlessly.

---

# Option 1 — USB Microphone + Speakers

This is probably the **best simple setup**.

```text
       USB Microphone
             │
             ▼
       ┌───────────┐
       │ MAC MINI  │
       │           │
       │  Whisper  │
       │     ↓     │
       │  Ollama   │
       │     ↓     │
       │   Piper   │
       └─────┬─────┘
             │
             ▼
          Speakers
```

For example:

**Microphone**

- USB desktop microphone
- USB conference microphone
- USB microphone array

**Speakers**

- Powered desktop speakers
- USB speakers
- 3.5-mm powered speakers
- Bluetooth speakers

This gives you a completely independent local voice assistant.

---

# Option 2 — USB Conference Speakerphone

For someone who wants a **single device**, this can be even better.

A conference speakerphone combines:

```text
        ┌──────────────────┐
        │ USB Speakerphone │
        │                  │
        │ 🎤 Microphones   │
        │        +         │
        │ 🔊 Speaker       │
        └────────┬─────────┘
                 │ USB
                 ▼
             Mac Mini
```

This is particularly attractive if the Mini is sitting on a desk or in a living room.

You don't need separate microphone and speaker hardware.

---

# Option 3 — Mac Mini + Home Assistant

This is where the architecture becomes much more interesting.

You could have the Mac Mini running:

```text
Mac Mini
│
├── Ollama
├── Whisper
├── Piper
├── Wyoming
├── Home Assistant
├── OpenWakeWord
└── MCP / AI Agents
```

Then put inexpensive voice satellites around the house.

For example:

```text
                    MAC MINI
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
       Kitchen      Bedroom       Office
       🎤🔊          🎤🔊          🎤🔊
       Voice        Voice         Voice
       Satellite    Satellite     Satellite
```

The satellites don't necessarily need to run the LLM.

They simply provide:

**Microphone → Mini → AI → Speaker**

This is a much better architecture if the goal is whole-home voice AI.

---

# Option 4 — Mac Mini + iPhone/iPad

Someone who doesn't own a laptop may still own an iPhone or iPad.

Then you don't necessarily need a dedicated microphone/speaker system.

For example:

```text
             iPhone
          🎤       🔊
           │       ▲
           │       │
           ▼       │
        Wi-Fi / LAN
              │
              ▼
          Mac Mini
              │
         ┌────┴────┐
         │         │
      Whisper    Ollama
                   │
                 Piper
                   │
                   └──────► iPhone
```

The phone becomes the **voice terminal**, while the Mini remains the AI brain.

This is especially useful because the person already has:

- microphone
- speaker
- display
- network connection
- battery

in the phone.

---

# What About Someone With Literally Only a Mac Mini?

Then I'd recommend:

### Minimum

```text
Mac Mini
   +
USB microphone
   +
Powered speakers
```

That's all they fundamentally need.

They can then run:

```text
🎤
 ↓
Whisper
 ↓
Ollama
 ↓
Piper
 ↓
🔊
```

**100% locally.**

No MacBook.

No iPhone.

No cloud.

No subscription.

No Internet after the software/models have been downloaded.

---

# Add a Wake Word

The next improvement would be:

```text
          🎤
           │
           ▼
    OpenWakeWord
           │
       "Hey AI"
           │
           ▼
        Whisper
           │
           ▼
        Ollama
           │
           ▼
         Piper
           │
           ▼
          🔊
```

Now the person can simply say something like:

> "Hey Assistant, what's the weather today?"

and receive a spoken answer.

---

# One Important Distinction

There are actually **three different Mac configurations** worth documenting in your AI Guide:

| Configuration | Voice Input | AI Processing | Voice Output | Portable |
|---|---|---|---|---|
| **Mac Mini only** | USB mic / satellite | Mac Mini | Speakers | ❌ |
| **MacBook only** | Built-in mic | MacBook | Built-in speakers | ✅ |
| **Mac Mini + MacBook** | MacBook / satellites | Mini + MacBook | MacBook / satellites | **✅** |

And I'd add a fourth:

| Configuration | Voice Input | AI Processing | Voice Output |
|---|---|---|---|
| **Mac Mini + iPhone/iPad** | iPhone/iPad | Mac Mini | iPhone/iPad |

So the fundamental lesson for the guide should be:

> **Any Mac can become a voice AI system. The difference is simply where the microphone, speakers, STT, LLM, and TTS components live.**
