# XREAL AURA

Yes. **This is where XREAL Aura gets much more interesting for you**, because the puck is not just a battery/adapter. It is effectively a **small Android XR computer**.

And the answer to your LLM question is:

> **Technically yes — the Snapdragon Reality Elite is explicitly designed to run LLMs locally. But XREAL has not yet published enough information to say which local LLMs you can install/run on Aura, or what model sizes will run well.**

That distinction is important.

## 1. What exactly is inside the Aura puck?

XREAL has now published substantially more detail.

![Image](https://images.openai.com/static-rsc-4/bYF8o723Qacxv3SEV7zWpN4tp6qi9SdBqPU_SmsYVNGv03T82XFvmvqruyzRysLMnOzxaXW9Kk2P6Yh9ksEBlsBayFEymTce2QJ4YAXMWr2ZNRPtQNxALvcCvde0GKOOXMP1-Yo7mgawWDBXR8LW0Jp_c8bzFYhVCan2ez94dAQvZUOG2P2tc95a6WT4wBMS?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/OELc-8yVwL7zrOFkVJ9bgVqwfXT-q1EBeMHDkWSycA8_M1eFGSySC3nnmpMZ2q6ZC2A23kIZf7oWixtpuWZMAoNM-KIGEd3waTZG8Gg5V5JdgtCOjRmYmj1pQdtL4pfHgZ1SsAxGsGKIjC_kzjq7YsE5PUfQfivphc2EeyndeimA95D4zTJ9efxI1nb8HVPI?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/np5jncdBPMu4_iRI7Ryn031Chw6KTtMrom9mNK8BJaWRInyULuNKhfhgYvloge6f59OIio96drF2aDvxl7NJQ0KC67FFPMcsiq2jWQbiIkeXgKC6qG5L0rwVbWmKoa1w7M52LQRik2d56tjjugBa-Tg-4oF-CDypPxHZp_f3mxWYZFQ3cNd6Zp1vf8upeOer?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/RiXSYmNIRuElUp4JfnUFr19rrItb8a9juiLl13loOUqPKdsG54lqIRU3MXH-QgxyNtwaDOzqFaR7EXiDXVNmQw4KzfWo7JafVF48oJRz4e1g8OkkGm7dYG40ZbkK1yhsLxT3zRWsMctKigdMEm0f8GeElQm_UC04_QtmX-Qj7LVOm0zhVyn7HhXJJraK5M2o?purpose=fullsize)

The puck has:

| Puck component          |                           XREAL Aura |
| ----------------------- | -----------------------------------: |
| **OS**                  |                           Android XR |
| **SoC**                 |    Qualcomm Snapdragon Reality Elite |
| **RAM**                 | **12GB / 256GB** or **16GB / 512GB** |
| **Battery**             |             **4,455 mAh / 34.84 Wh** |
| **USB-C**               |                              2 ports |
| Glasses connection      |                              USB 3.1 |
| PC/charging port        |         USB-C DP Alt Mode + charging |
| Charging                |                            Up to 65W |
| Wi-Fi                   |                       **Wi-Fi 6/6E** |
| Bluetooth               |                              **5.3** |
| ADB                     |                              **Yes** |
| External keyboard/mouse |                              **Yes** |
| Game controller         |                              **Yes** |
| Touchpad                |                      Built into puck |
| Fingerprint sensor      |                                  Yes |

([XREAL][1])

That **ADB support** is particularly interesting to me for you.

It means this isn't necessarily going to be a locked-down "XREAL appliance." There is at least a proper Android development/debugging path.

---

# 2. The LLM capability is real

This isn't speculation.

Qualcomm specifically says Snapdragon Reality Elite has:

**48 TOPS of AI processing**

and is designed to run:

> **large language models and large vision models directly on-device.**

Qualcomm specifically describes local LLM agents, vision models, real-time AI perception and generative-AI workloads. ([Qualcomm][2])

So:

**Aura → Snapdragon Reality Elite → local AI**

is absolutely part of the platform's intended architecture.

### But there's an important distinction:

**"The silicon can run LLMs" ≠ "Aura lets you install Ollama and Qwen."**

We don't yet have evidence that XREAL will ship:

```text
Ollama
llama.cpp
MLX
vLLM
Open WebUI
LM Studio
```

on Aura.

In fact, **MLX is Apple-specific**, so that's obviously not happening natively.

The interesting possibilities are instead:

```text
llama.cpp Android
MediaPipe / LiteRT
Qualcomm AI Runtime
ONNX Runtime
Android NNAPI / NPU
Gemini Nano-class models
custom Android LLM apps
```

The platform is powerful enough to make this technically plausible, but **software compatibility is the missing piece**.

---

# 3. 12GB vs 16GB becomes VERY important

Aura has two configurations:

### 12GB / 256GB

or

### **16GB / 512GB**

([XREAL][1])

If your interest includes local AI, **I would absolutely want the 16GB/512GB version**.

Why?

Because with local LLMs, RAM isn't just "system memory."

It's effectively:

> **model memory + KV cache + Android XR + application memory + vision models + spatial computing**

A rough illustration:

| Model | FP16 weights | 4-bit weights* |
| ----- | -----------: | -------------: |
| 3B    |         ~6GB |       ~1.5–2GB |
| 7B    |        ~14GB |           ~4GB |
| 8B    |        ~16GB |         ~4–5GB |
| 14B   |        ~28GB |         ~7–9GB |
| 32B   |        ~64GB |       ~18–22GB |

*Very rough real-world ranges; quantization format and runtime overhead matter.

So:

### 16GB Aura

could potentially be an excellent **small local-AI machine**.

But I would **not expect it to run your Qwen 35B models** like your desktop does.

Your 3090 Ti has **24GB VRAM**, and your workstation has **96GB system RAM**.

Aura is in a completely different performance class.

---

# 4. What Aura is actually designed to do with AI

This is where it gets really cool.

XREAL says Gemini on Aura can:

* understand what you're seeing
* understand what's on screen
* understand what's around you
* respond through voice
* open applications
* navigate the system
* provide contextual assistance

with user permission. ([XREAL][1])

So imagine:

You're looking at something through Aura.

You say:

> "What am I looking at?"

The system can combine:

**camera + microphones + spatial sensors + Gemini + Android XR**

to answer.

That's substantially different from your current AR glasses.

---

# 5. The cameras are actually functional sensors

This is another major difference from One Pro.

Aura has:

### 2× world-facing tracking cameras

Used for:

* 6DoF
* hand tracking
* spatial anchoring
* environment understanding

And:

### High-resolution RGB camera

with a **privacy LED**.

XREAL calls this the basis for **real-time AI perception**. ([XREAL][1])

So the AI architecture can theoretically look something like:

```text
                  ┌─────────────────┐
                  │  RGB Camera     │
                  └────────┬────────┘
                           │
                  ┌────────▼────────┐
                  │ Vision Model    │
                  │     (NPU)       │
                  └────────┬────────┘
                           │
Microphones ───────► AI / LLM ◄────── Sensors
                           │
                  ┌────────▼────────┐
                  │ Android XR      │
                  │ Spatial Agent   │
                  └────────┬────────┘
                           │
                       Aura Display
```

That is the **real vision** for Snapdragon Reality Elite.

---

# 6. And this is where local LLMs could become REALLY interesting

Imagine installing a local AI assistant that has access to:

**Vision**

```text
"What am I looking at?"
"Read this."
"Explain this network diagram."
"What does this error mean?"
```

**Spatial awareness**

```text
"Put my terminal over there."
"Keep this browser window attached to the wall."
"Show my dashboard beside me."
```

**Voice**

```text
"Open Firefox."
"Start my SSH session."
"Summarize this."
```

**Local knowledge**

Potentially:

```text
Qwen
Llama
Gemma
Phi
DeepSeek
etc.
```

The important word is **potentially**.

The hardware architecture is clearly moving in this direction, but **XREAL has not promised an unrestricted local-LLM ecosystem yet**.

---

# 7. Android XR changes everything

This is arguably more important than XREAL itself.

Aura isn't running some proprietary XREAL operating system.

It's:

> **Android XR**

Google's XR platform.

XREAL says Aura gets access to **millions of Google Play apps**, including:

* Chrome
* YouTube
* Google Maps
* Photos
* Gemini

plus more than 100 apps specifically designed for XR. ([XREAL][1])

That gives Aura a potentially enormous ecosystem.

Compare:

### One Pro

```text
XREAL OS-ish experience
       │
       └── display / spatial display
```

### Aura

```text
                 Android XR
                     │
       ┌─────────────┼──────────────┐
       │             │              │
    Google Play    XR Apps       Gemini
       │             │              │
    Chrome        WebXR          AI agents
    YouTube       Games          Vision
    Maps          3D apps       Voice
       │             │              │
       └─────────────┼──────────────┘
                     │
             Snapdragon Reality
                  Elite
```

That is a **much bigger ecosystem bet**.

---

# 8. WebXR is particularly interesting

XREAL specifically demonstrates Aura running WebXR applications.

They showed a **3D painting application created/vibe-coded with Gemini** and WebXR. ([XREAL][3])

That's significant because you don't necessarily need an Android APK for everything.

Potential ecosystem:

```text
Android Apps
       +
XR Apps
       +
WebXR
       +
Android XR
       +
XREAL SDK
```

The web becomes an XR application platform.

---

# 9. What about your existing local-AI stack?

This is where I'd be realistic.

You currently have things like:

**Ollama**

**OpenWebUI**

**Qwen**

**Docker**

**Qdrant**

**Postgres**

etc.

I would **not expect Aura to replace your existing local-AI server**.

Instead, I see Aura as an **AI client/interface** to your existing infrastructure.

For example:

```text
                 Your Home Lab
                      │
              ┌───────▼────────┐
              │ Ollama / LLM   │
              │ RTX 3090 Ti    │
              │ 96GB RAM       │
              └───────┬────────┘
                      │
                    LAN
                      │
               Wi-Fi 6/6E
                      │
              ┌───────▼────────┐
              │   Aura Puck    │
              │   Android XR   │
              └───────┬────────┘
                      │
                 USB-C
                      │
              ┌───────▼────────┐
              │ Aura Glasses   │
              │ 70° / 120Hz    │
              └────────────────┘
```

That could be **extremely powerful**.

Your RTX 3090 Ti remains the heavy AI engine.

Aura becomes the **spatial/voice/vision interface**.

---

# 10. But the puck itself could still run smaller models

This is where I think Aura could be useful even without your server.

For example:

### Local

```text
Speech recognition
       ↓
small LLM
       ↓
intent detection
       ↓
Android XR action
```

could potentially run entirely on the puck.

You don't need a 35B model to say:

> "Open Chrome."

or:

> "Move this window to my left."

That's exactly the type of AI workload the NPU is designed for.

Qualcomm says Reality Elite provides up to **48 TOPS** specifically for these on-device generative-AI workloads. ([Qualcomm][2])

---

# 11. Developer ecosystem

This is another area I'd watch closely.

XREAL already has an SDK and development ecosystem.

Their current SDK has moved toward:

**Unity XR Plugin**

and integrates with:

* Unity XR Interaction Toolkit
* AR Foundation
* hand tracking
* image tracking

([XREAL SDK][4])

However, there is an important wrinkle:

**XREAL's current SDK documentation says it does not currently support OpenXR.** ([Xreal Developer UAT][5])

That matters.

I would prefer Aura eventually to support:

**OpenXR**

because it makes the ecosystem much less proprietary.

Android XR itself is pushing toward broader XR standards, so this is something I'd watch as Aura approaches launch.

---

# 12. Hardware ecosystem

Aura isn't isolated.

The puck supports:

### Input

* hands
* voice
* touchpad
* Bluetooth keyboard
* Bluetooth mouse
* Bluetooth gamepad

([XREAL][1])

### Connectivity

**Wi-Fi 6/6E**

**Bluetooth 5.3**

### PC

USB-C **DisplayPort input**

So your desktop/laptop can feed Aura directly.

And XREAL demonstrated Aura connected to a laptop through DP-in while adding multimodal Gemini functionality to the laptop experience. ([XREAL][3])

That's a very interesting hybrid mode:

```text
           Windows PC
               │
          DisplayPort
               │
               ▼
          Aura Puck
               │
        Android XR + AI
               │
               ▼
        Aura Glasses
```

The PC supplies the traditional computing environment.

The puck adds spatial/AI capabilities.

---

# 13. Storage is surprisingly important

I'd choose:

### **16GB / 512GB**

if you are serious about experimenting.

Because 256GB disappears surprisingly quickly once you start installing:

* XR apps
* Android apps
* games
* movies
* local AI models
* vision models
* developer tools
* datasets

And Android XR itself will consume some of the storage.

The 512GB model gives you much more experimentation room.

---

# 14. The big unanswered question

There is one thing I would **not buy Aura on yet**:

### "Can I sideload llama.cpp and run Qwen locally?"

We don't have an official answer yet.

XREAL has exposed **ADB**, which is encouraging. ([XREAL][1])

Qualcomm explicitly supports local LLMs.

Android supports native ARM applications.

So the technical ingredients exist.

But we need to know:

1. **Bootloader restrictions**
2. Whether arbitrary APK sideloading is allowed
3. NPU access for third-party applications
4. Qualcomm AI Runtime availability
5. GPU compute APIs exposed to apps
6. Maximum model size recommended
7. Whether llama.cpp can access the NPU
8. Whether Android XR permits background AI services
9. Whether XREAL exposes camera frames to third-party applications
10. Whether Google restricts certain AI APIs

Those answers will determine whether Aura becomes a **developer-friendly local AI computer** or primarily a **Google/XREAL AI appliance**.

---

# My take for your Home Lab

This is where I think Aura could become **much more interesting to you than a normal AR glasses purchase**.

I'd think about it as:

### Tier 1 — standalone Aura

```text
Aura
 │
 ├── Android XR
 ├── Gemini
 ├── Google Play
 ├── WebXR
 └── local small AI
```

### Tier 2 — Aura + your home lab

```text
             Aura
               │
          Wi-Fi 6/6E
               │
       ┌───────▼────────┐
       │ Home Lab       │
       │                │
       │ Ollama         │
       │ Qwen           │
       │ OpenWebUI      │
       │ Qdrant         │
       │ PostgreSQL     │
       │ GPU 3090 Ti    │
       └────────────────┘
```

### Tier 3 — Aura + PC

```text
             Aura
               │
       ┌───────▼────────┐
       │ Windows 11     │
       │ RTX 3090 Ti    │
       │ Steam          │
       │ Local LLMs     │
       │ VR / gaming    │
       └────────────────┘
```

And **Tier 2 is the one I'd be most interested in for you**.

The puck doesn't need to beat your 3090 Ti at AI. **It doesn't need to.** Its value is becoming the **portable spatial/voice/vision terminal for your much more powerful home-lab AI infrastructure**.

### Bottom line

**Aura's puck is far more than a battery pack.**

It's a **16GB-class Android XR computer with a 48-TOPS AI-capable Snapdragon platform, 512GB storage option, Wi-Fi 6E, Bluetooth 5.3, ADB, DP input, and enough compute to run on-device AI.** Qualcomm explicitly designed Reality Elite to run LLMs and vision models locally. ([XREAL][1])

The remaining question isn't **"Can the hardware run local LLMs?"**

**Yes, it can.**

The question is:

> **"How much of that hardware will XREAL/Google actually expose to developers?"**

That's the part I'd monitor very closely before spending potentially $1,500.

I can also dig specifically into **Snapdragon Reality Elite's CPU/GPU/NPU architecture and estimate what models—Qwen 3, Gemma, Llama, Phi, etc.—could realistically run on the 12GB vs 16GB Aura puck**, including estimated tokens/sec.

[1]: https://www.xreal.com/aura "XREAL AURA | It Feels Like Tomorrow"
[2]: https://www.qualcomm.com/news/releases/2026/06/qualcomm-takes-spatial-computing-into-the-ai-era-with-snapdragon "Qualcomm Takes Spatial Computing into the AI Era with Snapdragon Reality Elite | Qualcomm"
[3]: https://www.xreal.com/uk/blog/project-aura-google-io-2026 "XREAL and Google Showcase Project Aura at Google I/O 2026"
[4]: https://docs.xreal.com/ "XREAL SDK Overview | XREAL SDK"
[5]: https://developer-uat.xreal.com/ "XREAL Developer"
