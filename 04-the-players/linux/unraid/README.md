# Unraid — Where It Came From and Where It's Going

## 1. What exactly is Unraid?

[Unraid](https://unraid.net/) is an operating system developed by **Lime Technology, Inc.**

It is fundamentally a **Linux-based server OS** designed to combine:

- NAS/storage
- Docker containers
- Virtual machines
- GPU passthrough
- Networking
- Home-lab applications
- Media servers
- AI/ML workloads
- Backup
- ZFS
- SMB/NFS file services

The thing that originally made Unraid different was its storage architecture.

Instead of requiring a conventional RAID array where all disks generally need to match, Unraid allows something like:

```text
12 TB + 12 TB + 8 TB + 8 TB + 4 TB + 4 TB
```

and combines them into a parity-protected array.

Each data disk retains its own filesystem, so if you pull a disk out, you can generally still access the data on that disk independently.

That philosophy — **use the hardware you already have** — remains central to the product today. [Unraid](https://unraid.net/about/)

---

# 2. How Unraid Started

Unraid goes back to **2005**.

The founder is:

### Tom Mortensen

Tom came from an enterprise-storage background and originally created Unraid because he had a pile of inexpensive drives containing his digitized DVD collection.

The problem was familiar:

> Cheap disks fail.

He wanted redundancy without rebuilding everything into a conventional RAID system.

His solution was to modify the Linux MD driver and create the parity-protected architecture that eventually became Unraid. [Unraid](https://unraid.net/blog/unraid-8-announced)

Interestingly, Unraid wasn't originally envisioned as a giant commercial product.

Tom has described the original project essentially as a side project/"beer money" endeavor.

Twenty years later, Lime Technology has roughly **30 people** working on it. [Unraid](https://unraid.net/blog/unraid-8-announced)

---

# 3. Who Owns/Controls Unraid?

The company is:

**Lime Technology, Inc.**

Headquarters:

**San Diego, California**

The company remains **independent**.

Current leadership includes:

| Person | Role |
|---|---|
| **Tom Mortensen** | Founder / Senior Software Architect |
| **Tiffany Jones** | CEO |
| **Eli** | Product Director |

Tiffany is Tom's daughter and joined the company in 2019 as Co-CEO before becoming CEO. [Unraid](https://unraid.net/about/)

That independence is actually significant.

Unraid isn't being driven by a VMware/Broadcom, Synology, QNAP, Dell, or other large corporate roadmap.

Their stated philosophy remains essentially:

> Your hardware, your data, your choice.

---

# 4. The Evolution Is Pretty Interesting

The progression looks roughly like this:

```text
2005
 │
 ├── Unraid begins
 │
 │   Storage / parity
 │
 ▼
Unraid 5
 │
 ├── PHP
 ├── Plugins
 └── Community-driven development
 │
 ▼
Unraid 6
 │
 ├── 64-bit
 ├── Docker
 ├── VMs
 └── Community Applications
 │
 ▼
Unraid 7
 │
 ├── ZFS
 ├── ZFS boot mirror
 ├── Better virtualization
 └── More advanced networking
 │
 ▼
Unraid 7.3 / 7.4
 │
 ├── Modern kernels
 ├── Better networking
 ├── Better virtualization
 └── Multi-network Docker
 │
 ▼
Unraid 8
 │
 ├── Fedora/uCore
 ├── Docker Compose
 ├── Integrated backup
 ├── Better hardware support
 ├── Plugin permission system
 └── More separation between OS and Unraid
```

The community has played a surprisingly large role.

For example, the Dynamix WebGUI originated with a community developer, and **Andrew Zawadzki ("Squid")** remains heavily involved with Community Applications. [Unraid](https://unraid.net/blog/unraid-8-announced)

---

# 5. And This Answers Your Linux-Kernel Question

## Unraid 8 is a major architectural change.

Unraid **is not staying on its current Slackware-derived base forever.**

The Unraid 8 announcement in August 2026 explicitly says:

> Unraid 8 is moving to **Fedora**, built on **Universal Blue's uCore**. [Unraid](https://unraid.net/blog/unraid-8-announced)

That's a fairly substantial change.

### Current Unraid

The current 7.x generation is still based on the traditional Unraid architecture.

For example, current development releases are already using modern Linux kernels — the 7.3.3 RC2 release uses:

```text
Linux 6.18.52-Unraid
``` :chatgpt-content-reference{index="8"}


### Unraid 8

The new architecture becomes:

```text
                 Unraid 8

              Unraid UI/API
                    │
             Unraid Services
                    │
        ┌───────────┴───────────┐
        │                       │
     Docker                  VMs
        │                       │
        └───────────┬───────────┘
                    │
             Fedora / uCore
                    │
              Linux Kernel
                    │
                 Hardware
```

This is **not** simply "Unraid changes its Linux kernel."

It's more fundamental:

**Unraid is changing the underlying Linux distribution.**

---

# 6. Why Fedora/uCore?

This is actually one of the parts of the Unraid roadmap I like most.

The reasons Lime Technology gives include:

### Faster security updates

Fedora provides a much larger upstream ecosystem.

Instead of Lime Technology having to maintain/patch as much of the underlying distribution themselves, they can inherit more from Fedora.

### Better hardware support

This should become particularly interesting for:

- newer CPUs
- newer GPUs
- newer NICs
- newer storage controllers
- newer Wi-Fi hardware
- newer virtualization hardware

### Cleaner OS separation

The Unraid-specific software becomes more independent from the Linux base.

### Kernel flexibility

One particularly interesting statement from Lime Technology is that Unraid 8 is intended to allow:

> the option to run the latest kernel for brand-new hardware while everyone else stays on a stable long-term kernel. [Unraid](https://unraid.net/blog/unraid-8-announced)

For a home-lab user who likes bleeding-edge hardware, **that's potentially a big deal.**

---

# 7. Is Unraid Becoming an "Immutable Linux"?

Sort of — but this is where terminology gets interesting.

Unraid has behaved like an immutable appliance for years.

The OS itself is largely loaded from the USB boot device into RAM.

So:

```text
USB
 │
 └── Unraid OS
        │
        ├── kernel
        ├── drivers
        └── OS
               ↓
              RAM
               ↓
          running system
```

Your persistent data lives elsewhere:

```text
/mnt/user/
     │
     ├── appdata
     ├── domains
     ├── system
     ├── media
     ├── documents
     └── ...
```

This is one of the reasons you can screw up the running environment and reboot back into a clean OS image.

Unraid 8 is taking that concept further using Fedora/uCore. [Unraid](https://unraid.net/blog/unraid-8-announced)

---

# 8. Unraid + Local AI

This is where I think Unraid becomes particularly interesting **for your lab**.

Unraid's current Community Applications catalog contains thousands of applications. [Unraid](https://unraid.net/community/apps)

And Unraid now explicitly promotes local AI as a major use case.

Their own AI category includes:

```text
Generative AI
    Ollama
    Open WebUI
    ComfyUI
    voice
    music
    image generation

Predictive AI
    Frigate
    Whisper
    photo recognition
    object detection
```


---

# 9. Your Potential Local-AI Stack

I'd think about it as several layers.

```text
                         USER
                           │
              ┌────────────┴────────────┐
              │                         │
         Open WebUI                 Home Assistant
              │                         │
              │                         │
         ┌────┴────┐              ┌─────┴─────┐
         │         │              │           │
      Ollama    llama.cpp       Frigate    Automations
         │         │              │
         └────┬────┘              │
              │                    │
          LLM Models           Cameras
              │                    │
              └────────┬───────────┘
                       │
                    NVIDIA GPU
                       │
                ┌──────┴──────┐
                │             │
             CUDA           NVDEC
                │             │
             AI/ML       Video Decode
```

That is a **very powerful home-lab architecture**.

---

# 10. LLM Engines You Can Run

## Ollama

Probably the easiest starting point.

```text
Unraid
 └── Docker
      └── Ollama
           ├── Qwen
           ├── Llama
           ├── Gemma
           ├── DeepSeek
           └── other GGUF/compatible models
```

Then:

```text
Open WebUI
      │
      ▼
    Ollama
      │
      ▼
    GPU
```

This fits extremely well with your existing Ollama/Open WebUI experience.

---

# 11. llama.cpp

This is particularly interesting because it gives you a second inference engine.

Unraid's catalog now includes a current llama.cpp container supporting:

- LLM inference
- VLM inference
- GGUF
- quantization
- OpenAI-compatible API
- NVIDIA GPU acceleration

and the Unraid template explicitly supports NVIDIA GPUs. [Unraid Community Apps](https://ca.unraid.net/apps/llama-cpp-0v2s4d30qmhgbv)

That means you can build:

```text
Open WebUI
      │
      ├── Ollama
      │
      └── llama.cpp
```

and compare the two.

---

# 12. vLLM

This is the more serious **LLM-serving** option.

Unraid currently has a vLLM Community Apps container.

It uses NVIDIA CUDA and exposes an OpenAI-compatible endpoint. [Unraid Community Apps](https://ca.unraid.net/apps/vllm-17eh90i0w140wm)

Conceptually:

```text
Applications
      │
      ▼
 OpenAI-compatible API
      │
      ▼
     vLLM
      │
      ▼
    NVIDIA
      │
      ▼
      LLM
```

I'd use:

**Ollama → experimentation**

**llama.cpp → efficient local inference**

**vLLM → serious model serving / API workloads**

---

# 13. Open WebUI

This becomes your **AI control plane**.

It can sit above:

- Ollama
- OpenAI-compatible APIs
- vLLM
- llama.cpp
- remote models

and provide:

- Chat
- RAG
- documents
- multimodal models
- image generation
- model switching
- multi-model conversations
- API connections
- vector databases

The current Unraid package has also evolved considerably beyond simply being "Ollama WebUI." [Unraid Community Apps](https://ca.unraid.net/apps/open-webui-0z497h31ntbiab)

---

# 14. Qdrant

This is where your local AI infrastructure starts becoming a **knowledge system**.

Qdrant is available in Community Apps and provides vector search for RAG and semantic applications. [Unraid Community Apps](https://ca.unraid.net/apps/qdrant-01envx20t62syy)

You could build:

```text
                   Open WebUI
                       │
                       ▼
                     Ollama
                       │
              ┌────────┴────────┐
              │                 │
           LLM            Embedding model
                                │
                                ▼
                             Qdrant
                                │
                    ┌───────────┼───────────┐
                    │           │           │
                  Docs       Manuals      Configs
                    │           │           │
                  Network     Home Lab    Projects
```

For your lab, this could eventually become:

### "Ask my Home Lab"

> "What VLAN is the Frigate camera network on?"

> "What ports did we allow between Frigate and Home Assistant?"

> "Show me the FortiGate rule for the Reolink cameras."

> "What is the IP of the Wazuh server?"

That's a much more interesting application than simply running a chatbot.

---

# 15. AI Coding Agents

Unraid can also become a **local AI development server**.

One particularly interesting current container is OpenHands.

The Unraid package supports connecting it to local Ollama and can create isolated execution containers. [Unraid Community Apps](https://ca.unraid.net/apps/openhands-11lx1wx1yjp30t)

Architecture:

```text
              You
               │
               ▼
          OpenHands
               │
          ┌────┴────┐
          │         │
       Ollama    Sandbox
          │         │
          ▼         ▼
        Qwen       Docker
       Coder       tools
```

That is essentially a **self-hosted coding agent server**.

---

# 16. ComfyUI

This is where GPU acceleration becomes much more important.

Unraid has a current NVIDIA-enabled ComfyUI container supporting CUDA and GPU workloads. [Unraid Community Apps](https://ca.unraid.net/apps/comfyui-nvidia-docker-0pc9cef1g9rsd7)

You could run:

```text
ComfyUI
   │
   ├── Stable Diffusion
   ├── Flux
   ├── image workflows
   ├── image enhancement
   ├── video workflows
   └── custom nodes
```

This is considerably more GPU hungry than basic LLM inference.

---

# 17. Frigate

This is especially relevant to **your existing project**.

Unraid has a Frigate container with NVIDIA support for:

- video decoding
- object detection
- multiple cameras
- AI inference [Unraid Community Apps](https://ca.unraid.net/apps/frigate-1pz914f0swytzn?maintainer=yayitazale%27s+Repository\)


Your current architecture could eventually become:

```text
             EmpireTech PTZ
                    │
             Reolink Doorbell
                    │
                    ▼
                 VLAN
                    │
                    ▼
                 Frigate
                    │
             ┌──────┴──────┐
             │             │
          NVDEC          CUDA
             │             │
        Video decode   Detection
             │             │
             └──────┬──────┘
                    ▼
             Home Assistant
```

This raises an interesting question:

**Do you still need the Jetson?**

Potentially yes — but Unraid + NVIDIA could consolidate some of the workload.

---

# 18. Speech / Voice AI

You can also run Whisper locally.

Unraid has Whisper ASR containers supporting multiple model sizes, including:

```text
tiny
base
small
medium
large
```

and multilingual transcription/translation. [Unraid Community Apps](https://ca.unraid.net/apps/whisper-asr-webservice-1vy2sky10pahdq)

That opens up:

```text
Microphone
    │
    ▼
 Whisper
    │
    ▼
 Text
    │
    ▼
 LLM
    │
    ▼
 Home Assistant
```

Which gives you a completely local voice assistant.

---

# 19. Home Assistant

You already know where I'm going here.

Home Assistant can run directly as a container, or you can run **Home Assistant OS as an Unraid VM**.

There is currently even a community "Home Assistant inabox" application that automates creation of the HAOS VM. [Unraid Community Apps](https://ca.unraid.net/apps/homeassistant-0z830pg0kwl1e0)

For your environment I'd actually favor:

```text
Unraid
   │
   ├── Docker
   │     ├── Frigate
   │     ├── Ollama
   │     ├── Open WebUI
   │     ├── Qdrant
   │     ├── n8n
   │     └── other services
   │
   └── VM
         └── Home Assistant OS
```

That gives HA its own OS boundary.

---

# 20. Automation / Agent Infrastructure

You can also run n8n.

Current Unraid Community Apps includes n8n. [Unraid Community Apps](https://ca.unraid.net/apps/n8n-0rqjcrx1wbo7hd?q=n8n\)

That gives you:

```text
                  n8n
                   │
        ┌──────────┼──────────┐
        │          │          │
       HA        Ollama     Frigate
        │          │          │
     devices      AI       cameras
        │          │          │
        └──────────┼──────────┘
                   │
                  n8n
                   │
             automation
```

Imagine:

> Frigate detects a person at the front door.

→ n8n receives event

→ local vision model analyzes snapshot

→ Ollama interprets it

→ Home Assistant announces:

> "Someone is at the front door."

All locally.

---

# 21. VM Capabilities

Unraid isn't limited to containers.

Its virtualization stack is:

```text
KVM
 +
QEMU
 +
libvirt
 +
VFIO/IOMMU
```

and supports PCIe passthrough. [Unraid Docs](https://docs.unraid.net/unraid-os/using-unraid-to/create-virtual-machines/overview-and-system-prep/)

You could therefore run:

### Linux VMs

- Ubuntu
- Debian
- Fedora
- Kali
- security appliances
- development environments

### Windows

- Windows 10/11
- GPU accelerated workstation
- gaming VM

### Home Assistant OS

Excellent candidate for a VM.

### Lab infrastructure

```text
Unraid
│
├── Ubuntu Security VM
├── Windows 11 VM
├── Home Assistant VM
├── Dev VM
└── containers
```

---

# 22. Should You Put a GPU in the Unraid Server?

## For your use case:

### **Yes.**

But I would **not** put a giant GPU in it.

Your Ryzen/3090 Ti workstation is already the machine for serious local AI.

Your Unraid GPU should instead be:

> **low-power, always-on acceleration.**

That is a very different design philosophy.

---

# 23. The GPU I'd Look At First

## NVIDIA RTX A2000 12GB

This is probably the most interesting option for your particular project.

PNY RTX A2000 12GB GDDR6$672.71·newegg.com

The key characteristics are:

| Feature | RTX A2000 |
|---|---:|
| Architecture | Ampere |
| VRAM | **12 GB** |
| Memory | GDDR6 ECC |
| Bus | 192-bit |
| PCIe | 4.0 x16 |
| Power | **~70 W** |
| External power | **No** |
| Form factor | Low profile |
| CUDA | Yes |
| Tensor cores | Yes |
| RT cores | Yes |
| NVENC/NVDEC | Yes |
| Good for 24/7 server | **Excellent** |

The critical part:

### It gets its power entirely from the PCIe slot.

No 6-pin.

No 8-pin.

No special PSU cable.

That's exactly what you're asking for.

---

# 24. Why I Like the A2000 for Unraid

It's not because it's a monster AI GPU.

It isn't.

The point is the combination:

```text
             RTX A2000 12GB

                 70 W
                   │
                   ▼
             ┌───────────┐
             │  Ampere   │
             │           │
             │ 12GB VRAM │
             │           │
             │ CUDA      │
             │ Tensor    │
             │ NVENC     │
             │ NVDEC     │
             └───────────┘
```

It gives you a surprisingly broad set of capabilities without turning your NAS into a 300–500 W AI server.

---

# 25. Cheaper / Lower-Power Alternative

## NVIDIA T600 4GB

The T600 is much smaller and only consumes about **40 W**. NVIDIA's own datasheet specifies PCIe 3.0 x16 and 40 W maximum power. [NVIDIA](https://www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/productspage/quadro/quadro-desktop/proviz-print-nvidia-T600-datasheet-us-nvidia-1670029-r5-web.pdf)

NVIDIA T600 4GB$299.00 · newegg.com

But there is a major tradeoff:

```text
T600
  │
  └── 4 GB VRAM
```

For AI:

**4 GB is restrictive.**

It's excellent for:

- video decoding
- transcoding
- display
- lightweight CUDA workloads
- Frigate
- small models

but I'd hesitate to buy one specifically for your **LLM ambitions**.

---

# 26. Another Interesting Option — T1000

The T1000 family is also interesting because of its low power envelope and workstation/server-friendly form factor.

But I'd still favor:

### A2000 12GB

because the additional VRAM dramatically increases its usefulness for AI.

---

# 27. The Weird Sleeper: Tesla P4

There's another interesting possibility:

**Tesla P4 — 24 GB**

It is a very low-power PCIe accelerator at roughly the 75 W slot-power class.

And:

```text
24 GB VRAM
```

is extremely attractive for LLM workloads.

But there's a catch.

It's an older Pascal-generation accelerator and is:

- passive cooled
- datacenter oriented
- no display outputs
- older CUDA capability
- dependent on good chassis airflow
- considerably less attractive for modern AI than Ampere

For a purpose-built server with strong airflow, it can be interesting.

For your Unraid box:

### I wouldn't choose it.

---

# 28. My GPU Ranking for Your Unraid

| GPU | VRAM | Power | External power | AI | Frigate | My rating |
|---|---:|---:|---|---|---|---|
| **RTX A2000 12GB** | **12GB** | ~70W | No | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | **Best** |
| RTX A2000 6GB | 6GB | ~70W | No | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Very good |
| T1000 8GB | 8GB | ~50W | No | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Good |
| T600 4GB | 4GB | **40W** | No | ⭐⭐ | ⭐⭐⭐⭐⭐ | Good budget |
| T400 4GB | 4GB | ~30W | No | ⭐⭐ | ⭐⭐⭐⭐ | Lightweight |
| Tesla P4 | 24GB | ~75W | No | ⭐⭐⭐ | ⭐⭐⭐⭐ | Interesting but old |
| RTX 3090 Ti | 24GB | ~450W | Yes | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | **Overkill** |

For your Unraid server, I would **not** move the 3090 Ti into it.

Keep that GPU in your Ryzen 9900X3D workstation.

---

# 29. The Architecture I'd Build for You

Considering the rest of your lab, I'd eventually make Unraid the **always-on infrastructure/AI hub**:

```text
                         HOME LAB
                            │
                    ┌───────┴───────┐
                    │               │
                 Unraid          Ryzen Workstation
                 Server              │
                    │             RTX 3090 Ti
                    │                 │
          ┌─────────┼─────────┐       │
          │         │         │       │
        Docker     VMs       GPU      │
          │         │         │       │
          │         │      A2000      │
          │         │         │       │
          │         │         ├── Frigate
          │         │         ├── Ollama
          │         │         ├── llama.cpp
          │         │         └── Whisper
          │         │
          │       Home Assistant
          │
          ├── Open WebUI
          ├── Qdrant
          ├── n8n
          ├── Immich
          ├── Paperless
          ├── OpenHands
          ├── Frigate
          └── monitoring
```

Then the **3090 Ti becomes the heavy AI engine**:

```text
3090 Ti
 ├── large LLMs
 ├── Qwen
 ├── vision models
 ├── ComfyUI
 ├── Flux
 ├── serious agent workloads
 └── model experimentation
```

while the **A2000 becomes the always-on utility GPU**:

```text
A2000
 ├── Frigate
 ├── video decode
 ├── lightweight LLM
 ├── Whisper
 ├── embeddings
 ├── small vision models
 └── occasional AI workloads
```

That division makes a lot of sense.

---

# 30. And There Is an Even Better Trick

You don't necessarily need to run **all** AI on the Unraid GPU.

You can make Unraid the **AI orchestration server**.

For example:

```text
                         Open WebUI
                              │
                   ┌──────────┴──────────┐
                   │                     │
              Unraid GPU            3090 Ti
                   │                     │
             small models            large models
                   │                     │
                   └──────────┬──────────┘
                              │
                         OpenAI API
                              │
                         optional
```

So Open WebUI can decide whether a workload goes to:

```text
A2000
   │
   └── fast/light/local

3090 Ti
   │
   └── large/heavy/local

Cloud API
   │
   └── only when you explicitly permit it
```

That is much more powerful than treating the Unraid GPU as simply "the GPU for Ollama."

---

# 31. Cool Things You Could Build

Here are some of the things I'd actually consider worthwhile in **your** lab.

### 🏠 1. Local AI Home Assistant

```text
Home Assistant
      │
      ▼
  local LLM
      │
      ▼
 device control
```

No cloud AI required.

---

### 📷 2. AI Security System

```text
EmpireTech
Reolink
   │
   ▼
Frigate
   │
   ▼
A2000
   │
   ▼
Object detection
   │
   ▼
Home Assistant
   │
   ▼
Notification
```

---

### 🧠 3. "Ask My Home Lab"

Qdrant + embeddings + LLM.

Ask:

> "Why is Frigate not seeing my camera?"

The AI searches your:

- configs
- documentation
- network diagrams
- notes
- logs

and answers.

---

### 💻 4. Local Coding Agent

```text
OpenHands
    │
    ▼
Qwen Coder
    │
    ▼
Docker sandbox
    │
    ├── Git
    ├── Python
    ├── Linux
    └── your repositories
```

This is particularly aligned with your engineering background.

---

### 📄 5. AI Document Server

```text
Paperless
    │
    ▼
Paperless-AI
    │
    ▼
Ollama
    │
    ▼
Qdrant
```

Search your documents semantically.

---

### 🎨 6. Local Image/Video Lab

```text
ComfyUI
   │
   ▼
A2000 / 3090 Ti
   │
   ├── Flux
   ├── Stable Diffusion
   ├── image enhancement
   └── video workflows
```

---

### 🎙️ 7. Local Voice Assistant

```text
Microphone
   │
   ▼
Whisper
   │
   ▼
LLM
   │
   ▼
Home Assistant
```

---

### 🔄 8. Autonomous Home-Lab Automation

This could get really fun:

```text
                  n8n
                   │
       ┌───────────┼────────────┐
       │           │            │
    Frigate       HA          Wazuh
       │           │            │
       └───────────┼────────────┘
                   │
                 LLM
                   │
              decision
                   │
               action
```

For example:

> Wazuh detects suspicious activity → local LLM summarizes → n8n evaluates → Home Assistant sends notification.

---

# 32. My Recommendation

If you were building this **today**, I would not overhaul your existing Unraid server yet.

I'd approach it like this:

### Phase 1 — Unraid infrastructure

```text
Unraid 7.x
│
├── Storage
├── Docker
├── VMs
├── Home Assistant
└── existing services
```

### Phase 2 — Add GPU

**RTX A2000 12GB**

No external power.

Low-profile.

~70 W class.

12 GB VRAM.

CUDA/Tensor/NVENC/NVDEC.

### Phase 3 — AI stack

```text
A2000
 │
 ├── Ollama
 ├── llama.cpp
 ├── Frigate
 ├── Whisper
 └── embeddings
```

Then:

```text
Open WebUI
Qdrant
n8n
OpenHands
```

### Phase 4 — 3090 Ti integration

Don't move it.

Instead expose the 3090 Ti workstation as a **second local inference endpoint**.

```text
              Open WebUI
                   │
        ┌──────────┴──────────┐
        │                     │
    Unraid/A2000         Ryzen/3090 Ti
        │                     │
   small/fast AI          heavy AI
```

---

# 33. And Unraid 8 Makes This More Interesting

The Unraid 8 announcement is probably the most important thing to know if you're considering expanding your Unraid investment.

The roadmap isn't:

> "We're going to keep maintaining the old NAS OS."

It's closer to:

> **"We're turning Unraid into a modern self-hosted server platform."**

The move to Fedora/uCore, native Docker Compose, integrated backups, improved hardware support, plugin permissions, and cleaner OS/application separation all point in that direction. [Unraid](https://unraid.net/blog/unraid-8-announced)

And importantly, **Unraid isn't abandoning the advanced stuff**. Lime explicitly says VLANs, bridging, advanced networking, virtualization, and other power-user capabilities are staying. [Unraid](https://unraid.net/blog/unraid-8-announced)

For someone with your networking, Linux, Docker, security, Home Assistant, Frigate and local-LLM interests, **that's a much more compelling direction than Unraid simply remaining a NAS appliance.**

### My overall assessment

| Area | Unraid today | Unraid 8 direction |
|---|---|---|
| NAS | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Docker | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐+ |
| VMs | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐+ |
| ZFS | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Networking | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Local AI | ⭐⭐⭐⭐ | **⭐⭐⭐⭐⭐** |
| GPU support | ⭐⭐⭐⭐ | **⭐⭐⭐⭐⭐** |
| Security/update model | ⭐⭐⭐⭐ | **⭐⭐⭐⭐⭐** |
| Hardware support | ⭐⭐⭐⭐ | **⭐⭐⭐⭐⭐** |
| Docker Compose | Community/third-party | **Native** |
| Backups | Existing solutions | **Built-in direction** |
| Linux foundation | Slackware-derived | **Fedora/uCore** |

**Bottom line:** I would absolutely keep Unraid in your Home Lab architecture. And if we are designing an AI-capable Unraid server rather than just a NAS, **the RTX A2000 12GB is the sweet spot I'd investigate first**, while keeping your 3090 Ti as the heavy AI engine.

One important caveat: **Unraid 8 is announced but not released as stable yet**; as of September 2026, the 7.4 branch is still beta and 7.3.x is the current development/stable family. [Unraid](https://unraid.net/blog/)