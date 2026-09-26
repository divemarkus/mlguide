# Frigate NVR

[Current Frigate documentation](https://docs.frigate.video/plus/), I would make one important distinction up front:

> **Frigate is not an "LLM NVR." It is an AI NVR whose primary real-time detector is a dedicated object-detection model. Generative AI/VLMs such as Qwen3-VL sit on top of that detector as an enrichment layer.**

That distinction is actually one of the reasons Frigate fits your Jetson project.

And with your hardware, I would build it as **Jetson = NVR + real-time detector**, while your **RTX 3090 Ti = optional heavyweight local VLM/LLM server**. That gives you a much more capable architecture than trying to make the 8GB Jetson do everything.

---

# 1. What exactly is Frigate?

[Frigate official documentation](https://docs.frigate.video/)

Frigate is a **local-first NVR designed around IP cameras and real-time AI object detection**.

Its architecture is fundamentally different from a traditional NVR.

A traditional NVR is basically:

```text
Camera
   ↓
Record
   ↓
Hard Drive
   ↓
Playback
```

Frigate is closer to:

```text
                 IP Camera
                     │
              RTSP/H.264/H.265
                     │
                     ▼
               Video Decode
                     │
              Motion Detection
                     │
                     ▼
             Object Detection
                     │
          ┌──────────┼──────────┐
          │          │          │
        Person      Car       Package
          │          │          │
          └──────────┼──────────┘
                     │
                Object Tracker
                     │
        ┌────────────┼─────────────┐
        │            │             │
     Recording     Review        MQTT
        │            │             │
        │            │             ▼
        │            │       Home Assistant
        │            │
        │            ▼
        │       GenAI / VLM
        │            │
        │            ▼
        │       Description
        │       Summary
        │       Semantic Search
        │
        ▼
    Local Storage
```

Frigate is explicitly designed to minimize resource consumption by using inexpensive motion detection to determine when object detection needs to run, rather than running expensive inference against every frame continuously.

That architecture is **extremely appropriate for an edge computer such as your Orin Nano Super**.

---

# 2. Why we're choosing Frigate

There are several reasons I'm comfortable putting Frigate at the center of your system.

## 2.1 Local-first

Frigate's core functionality does **not require persistent Internet access**.

After models are downloaded, Frigate can operate completely offline unless you've deliberately enabled something that requires a cloud service.

That's exactly what you want for:

- cameras
- home security
- microphones
- doorbell
- recordings
- AI analysis

You don't need to send your home's video to somebody else's cloud.

---

# 3. It isn't just an NVR

This is probably the biggest reason everyone uses Frigate or for Home Lab.

Frigate is simultaneously:

### NVR

24/7 recording, event recording, retention, playback.

### Computer vision system

Person, vehicle, animal, package, etc.

### Event engine

Motion → object → zone → alert.

### MQTT producer

Events become messages that other systems can consume.

### Home Assistant sensor

Cameras and events become HA entities.

### AI enrichment platform

VLM/LLM descriptions, summaries and semantic search.

### Streaming gateway

go2rtc can restream camera feeds, reducing the number of direct connections to cameras.

Frigate explicitly provides RTSP restreaming for this purpose.

That's a **lot of functionality in one local system**.

---

# 4. The AI architecture is actually three different AI layers

This is extremely important.

## Layer 1 — Motion detection

Very cheap.

```text
"What changed?"
```

Frigate doesn't need a large neural network to answer this.

---

## Layer 2 — Object detection

This is the **real-time security AI**.

```text
"Is that a person?"
"Is that a car?"
"Is that a dog?"
"Is that a package?"
```

This is where:

**TensorRT / YOLO / ONNX / OpenVINO / Coral / Hailo**

etc. come into play.

Frigate recommends using a dedicated detector rather than CPU inference for production.

---

# 5. Layer 3 — Generative AI / VLM

This is where the LLM enters.

Instead of asking:

> "Is there a person?"

the VLM can answer:

> "A person wearing a dark jacket walks up the driveway carrying a cardboard package and places it beside the front door."

That's an entirely different problem.

Frigate calls this **Generative AI** and currently supports roles for:

- `descriptions`
- `chat`
- `embeddings`

A single provider can handle all three, or different providers can handle different roles.

---

# 6. So DON'T replace the object detector with an LLM

This is probably the most important technical takeaway from this entire discussion.

Don't build:

```text
Camera
  ↓
Qwen3-VL
  ↓
"person?"
```

as your primary detection loop.

Instead:

```text
Camera
  ↓
TensorRT
  ↓
PERSON DETECTED
  ↓
Tracking
  ↓
Interesting event
  ↓
Qwen3-VL
  ↓
"What is this person actually doing?"
```

That's much more efficient.

The dedicated detector can process the video continuously.

The VLM is called **only when useful**.

---

# 7. And Frigate has become much more interesting here

Current Frigate Generative AI can generate **review summaries**.

For example:

```text
ALERT

Front Door

Person detected

AI:
"An individual approached the front door carrying a
small package, placed it on the porch, rang the doorbell,
and walked away."

Threat:
Level 0
```

Frigate stores structured information including:

- title
- scene
- short summary
- confidence
- concerns
- potential threat level

and makes it available in the UI and notifications. :chatgpt-content-reference{index="6"}

That's substantially more useful than:

> PERSON DETECTED

---

# 8. Object descriptions

Frigate can also ask a VLM to describe individual tracked objects.

For example:

```text
Person

"Adult wearing a blue jacket and dark pants,
walking toward the front entrance."
```

These descriptions can be generated at the end of an object's lifecycle, or earlier when enough meaningful frames have changed. 

This is where your local VLM becomes really useful.

---

# 9. Semantic Search is where this gets REALLY interesting

This is one of the features I'd absolutely enable on your system.

Suppose you've got:

**30 days × 6 cameras × 24/7 recording.**

Instead of manually scrubbing through everything, you could search for concepts such as:

> "person carrying a package"

or:

> "red vehicle in driveway"

or:

> "person near backyard gate"

Frigate creates embeddings for tracked objects and uses those embeddings for image/text similarity search. The embeddings can remain entirely local.

The Explore interface then becomes something closer to:

```text
             FRIGATE EXPLORE

Search:
┌─────────────────────────────────────────┐
│ person carrying a package               │
└─────────────────────────────────────────┘

       ↓

[Front Door]     09:14
[Driveway]       09:16
[Front Door]     09:18
```

That's approaching **searchable video intelligence**, rather than just an NVR.

---

# 10. What model does semantic search use?

Frigate currently provides **Jina CLIP** models for semantic search.

V1 supports image ↔ text and image ↔ image similarity.

V2 adds multilingual support but requires substantially more RAM/GPU resources; Frigate currently recommends V1 for most users, particularly English-language installations. 

There is also an interesting newer option:

### Qwen3-VL embeddings

Frigate can use a GenAI provider for embeddings, and its documentation specifically supports multimodal embeddings through **llama.cpp**.

So eventually we can experiment with:

```text
Jina CLIP
      vs
Qwen3-VL embeddings
```

on your system.

---

# 11. Which LLM/VLM should we use?

For your system, I would start with:

## **Qwen3-VL**

Frigate's current documentation specifically recommends Qwen3-VL for local deployment.

It describes Qwen3-VL as having strong visual and situational understanding, including improved ability to identify smaller objects and interactions.

And the current Ollama distribution provides:

```text
qwen3-vl:2b
qwen3-vl:4b
qwen3-vl:8b
qwen3-vl:30b
qwen3-vl:32b
qwen3-vl:235b
```

with the local model sizes currently listed by Ollama. 

---

# 12. Which Qwen3-VL size?

I'd test these three:

### Qwen3-VL 4B

**First choice for Frigate experimentation**

Ollama currently lists the model around **3.3 GB**. 

Good:

- low latency
- relatively low VRAM
- inexpensive inference
- plenty capable for basic camera descriptions

---

### Qwen3-VL 8B

**My likely production choice**

Ollama currently lists it around **6.1 GB**.

This gives us substantially more reasoning/vision capacity without becoming ridiculous for a surveillance enrichment workload.

---

### Qwen3-VL 30B

**Experiment on the 3090 Ti**

Ollama currently lists approximately **20 GB** for the model.

Your 3090 Ti has 24 GB VRAM, so this becomes an interesting experiment, although I'd expect considerably less headroom for context, runtime overhead and concurrent workloads.

I would **not** put this on the Jetson.

---

# 13. Where do we get these models?

For your preferred local ecosystem, the primary places are:

### Ollama

[Ollama model library](https://ollama.com/library)

Example:

```bash
ollama pull qwen3-vl:4b
```

or:

```bash
ollama pull qwen3-vl:8b
```

Ollama is directly supported by Frigate's GenAI integration.

### Hugging Face

[Hugging Face](https://huggingface.co/)

Useful when we want:

- GGUF
- model files
- ONNX
- original model weights
- specialized variants

### llama.cpp

Useful when we want maximum control over local inference and multimodal embeddings.

Frigate supports OpenAI-compatible endpoints and specifically documents llama.cpp.

---

# 14. Your 3090 Ti becomes extremely useful

This is where your existing Home Lab hardware changes the architecture.

I would **not initially run the VLM on the Jetson**.

Instead:

```text
                   CAMERAS
                      │
                      ▼
             ┌─────────────────┐
             │ Jetson Orin     │
             │ Nano Super      │
             │                 │
             │ Frigate         │
             │ TensorRT        │
             │ Video Decode    │
             │ Recording       │
             └────────┬────────┘
                      │
                  GenAI API
                      │
                      ▼
             ┌─────────────────┐
             │ Ryzen 9900X3D   │
             │ RTX 3090 Ti     │
             │                 │
             │ Ollama          │
             │ Qwen3-VL 8B     │
             │ Qwen3-VL 30B    │
             └─────────────────┘
```

That's a **much better division of labor**.

---

# 15. Why?

The Jetson is exceptionally good at:

### Video

Dedicated hardware media engine.

### TensorRT

Real-time object detection.

### Low power

Excellent 24/7 edge appliance.

Frigate explicitly supports Jetson through TensorRT/ONNX and the Jetson media engine.

Your 3090 Ti is exceptionally good at:

### Large VLMs

### LLMs

### embeddings

### experimentation

### concurrent AI workloads

So:

> **Jetson = deterministic real-time security appliance**

while:

> **3090 Ti = AI reasoning/enrichment server**

That's a very clean architecture.

---

# 16. What about running Qwen3-VL directly on the Jetson?

Technically interesting.

But I wouldn't make that your primary architecture.

Your Orin Nano Super has only **8 GB unified memory**.

A Qwen3-VL 4B model can fit within that memory envelope, but you've got competing workloads:

```text
8 GB unified memory
│
├── Ubuntu
├── Docker
├── Frigate
├── FFmpeg
├── camera buffers
├── TensorRT
├── detector
├── database
├── semantic search
└── VLM
```

That's a lot.

Frigate itself recommends at least 8 GB available for 7B-class GenAI models, with larger models requiring substantially more memory.

So I'd consider Jetson-hosted VLM a **later experiment**, not the foundation.

---

# 17. Your Jetson's primary AI should be TensorRT

This is where your Orin Nano Super becomes particularly appropriate.

Current Frigate provides:

```text
ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6
```

for JetPack 6 Jetson systems.

Frigate's Jetson TensorRT detector can use the GPU and DLA, and its media engine handles hardware video decoding.

One caveat:

> **Orin Nano has no hardware video encoder.**

So Frigate can hardware-decode camera video, but encoding is done in software.

That's fine for your use case because we're primarily consuming camera streams rather than performing heavy transcoding.

---

# 18. Your final AI stack

I'd build this:

```text
                         CAMERA
                           │
                           │ RTSP
                           ▼
                 ┌──────────────────┐
                 │ JETSON ORIN NANO │
                 │     SUPER        │
                 │                  │
                 │ NVDEC            │
                 │ TensorRT         │
                 │ YOLO             │
                 │ Object Tracking  │
                 │ Frigate          │
                 └────────┬─────────┘
                          │
                  interesting event
                          │
                          ▼
                 ┌──────────────────┐
                 │  RTX 3090 Ti     │
                 │                  │
                 │ Ollama           │
                 │ Qwen3-VL 8B      │
                 │ Qwen3-VL 30B     │
                 └────────┬─────────┘
                          │
              ┌───────────┼────────────┐
              │           │            │
         Description   Summary     Conversation
              │           │            │
              └───────────┼────────────┘
                          │
                          ▼
                     FRIGATE
                          │
             ┌────────────┼─────────────┐
             │            │             │
          Review       Semantic       MQTT
                         Search         │
             │            │             ▼
             │            │        Home Assistant
             │            │             │
             └────────────┴─────────────┘
```

---

# 19. Home Assistant is the next piece

Frigate has an official Home Assistant integration.

Frigate requires MQTT for the HA integration, and the official integration exposes Frigate cameras/entities to Home Assistant.

Then you can build things like:

```text
Frigate:
Person at front door
       ↓
     MQTT
       ↓
Home Assistant
       ↓
Phone notification
       ↓
"Person at front door"
       ↓
Open camera
```

And with GenAI:

```text
"Person at front door"

↓ Qwen3-VL

"Delivery driver placed a package
beside the front door and walked away."

↓ Home Assistant

📱 Notification
```

That's a **huge difference** from a conventional NVR.

---

# 20. Frigate notifications are now native

Current Frigate has native WebPush notifications.

They use the WebPush/VAPID mechanism and work through supported browsers.

The current system supports:

- Chrome
- Firefox
- Safari

with some differences in notification content; for example, Chrome currently supports images in notifications while Safari/Firefox don't. 

And Frigate can generate the notification based on its review system.

---

# 21. Smartphone access

This is another area where Frigate has improved substantially.

There isn't a traditional "Frigate NVR iOS/Android native application" that you need to install.

Instead:

## Frigate PWA

Frigate can be installed as a **Progressive Web App** on:

- Android
- iOS
- desktop

It can behave much more like a native application, including deep links.

On iOS 16.4+ you can add it to the Home Screen.

On Android, Chrome/Firefox/Edge/etc. can install it.

So:

```text
Phone
  │
  ▼
Frigate PWA
  │
  ├── Live cameras
  ├── Review
  ├── History
  ├── Explore
  ├── Search
  ├── Clips
  └── AI summaries
```

That's likely what I'd use as your primary Frigate mobile interface.

---

# 22. Home Assistant Companion App

You can alternatively use:

**Home Assistant Companion App**

for:

- notifications
- camera dashboard
- automations
- doorbell events
- lights
- locks
- alarms
- presence
- other home automation

Then Frigate becomes the computer-vision engine underneath Home Assistant.

That's the architecture I'd eventually build.

---

# 23. Remote access

This is where I strongly recommend **VPN rather than exposing Frigate to the Internet**.

Your FortiGate is perfect for this.

I'd do:

```text
                 INTERNET
                    │
                    │
              VPN / IPsec
                    │
                    ▼
               FORTIGATE
                    │
                    ▼
              Home Network
                    │
                    ▼
                 Frigate
```

Then your phone gets:

```text
10.x.x.x
```

access to your home network through the VPN.

Your Frigate UI remains private.

No:

```text
Internet
   ↓
TCP 8971
   ↓
Frigate
```

No exposed RTSP.

No exposed camera.

No cloud relay required.

---

# 24. And this works particularly well with the PWA

Frigate's documentation explicitly says the PWA can be used:

- locally
- through VPN
- fully externally accessible

depending on how you expose Frigate. :chatgpt-content-reference{index="30"}

For **your** network, I'd choose:

> **VPN-only.**

Your FortiGate already gives you the infrastructure to do that properly.

---

# 25. Frigate's ports in your environment

Your architecture eventually looks roughly like:

| Port | Function |
|---:|---|
| **8971/TCP** | Authenticated Frigate UI/API |
| **5000/TCP** | Internal unauthenticated Frigate interface |
| **8554/TCP** | Frigate RTSP restream |
| **8555/TCP** | WebRTC |
| **8555/UDP** | WebRTC |
| **1883/8883** | MQTT, depending on broker configuration |
| **11434/TCP** | Ollama GenAI server |
| **554/TCP** | Camera RTSP |
| **8000/TCP** | Reolink ONVIF |
| **80/TCP** | Reolink HTTP/FLV |
| **1935/TCP** | Reolink RTMP/FLV |

Frigate's official Docker installation currently exposes 8971, 8554 and 8555 TCP/UDP for these functions. 

---

# 26. Storage is another reason I like Frigate

You don't necessarily need to record every camera at maximum quality forever.

Frigate can structure retention around:

```text
Continuous recording
        +
Motion
        +
Objects
        +
Alerts
```

Then:

```text
30 days
   │
   ├── Normal footage → shorter retention
   │
   ├── Motion → medium
   │
   └── Alerts/events → longer
```

And because the Jetson is the processing engine, you can put the actual recordings somewhere else.

For example:

```text
Jetson NVMe
   │
   ├── Frigate DB
   ├── config
   ├── cache
   └── active recordings
          │
          ▼
       NAS / unRAID
          │
          └── long-term retention
```

Frigate's documentation supports network storage architectures, including Home Assistant network-mounted storage. 

For your environment, I'd probably eventually use your **unRAID storage** for long-term video while keeping the Jetson NVMe as the high-performance working layer.

---

# 27. Where Frigate gets really powerful

Consider your eventual system.

### Camera

EmpireTech:

> "Something moved."

### Frigate detector

TensorRT:

> "Person."

### Tracker

> "Person remained in driveway for 38 seconds."

### Zone

> "Person entered driveway."

### GenAI

Qwen3-VL:

> "An adult wearing a dark jacket approached the garage carrying a small package."

### Home Assistant

> `front_driveway_person = true`

### Notification

**📱 Front driveway**

> "Person approached the garage carrying a package."

### You tap notification

↓

Frigate PWA

↓

Video

↓

AI description

↓

Full recording

↓

Everything stays inside your home network.

That's an **edge AI security platform**, not simply an NVR.

---

# 28. And the doorbell becomes particularly powerful

Our Reolink Doorbell WiFi fits this beautifully.

```text
               REOLINK DOORBELL
                      │
                 Wi-Fi VLAN
                      │
                      ▼
                  FortiGate
                      │
                 firewall rule
                      │
                      ▼
              Jetson / Frigate
                      │
               Person detected
                      │
                      ▼
                  Qwen3-VL
                      │
          ┌───────────┴───────────┐
          │                       │
       Summary                Notification
          │                       │
          ▼                       ▼
 "Delivery driver          📱 Your phone
  at front door"
```

And because the Reolink doorbell has the Frigate-supported two-way-talk path, we can eventually go:

**Notification → live video → talk to visitor.**

Frigate explicitly documents the Reolink Doorbell for this workflow.

---

# 29. What about Frigate+

There's another option worth understanding.

**Frigate+** provides specialized object-detection models trained on security-camera imagery.

The models include:

- MobileDet
- YOLO-NAS
- YOLOv9

and are designed specifically for surveillance imagery.

Importantly:

> **Frigate+ is not the same thing as GenAI.**

It's improving the **object detector**, not replacing it with an LLM.

And once the model is downloaded, detection remains local. Frigate says your video feeds aren't sent to the cloud for analysis; only images you explicitly submit to Frigate+ are uploaded. 

For your privacy-first setup, I'd initially **skip Frigate+** and establish how well the local TensorRT detector performs.

We can always test it later.

---

# 30. How I'd build your system in phases

This is where I think we can make this project much more interesting.

## Phase 1 — NVR

```text
Jetson
 ↓
Docker
 ↓
Frigate
 ↓
EmpireTech
 ↓
NVMe
```

Get:

- recording
- playback
- retention
- RTSP
- H.264/H.265
- hardware decoding

working first.

---

## Phase 2 — TensorRT

```text
Camera
 ↓
Jetson hardware decode
 ↓
TensorRT
 ↓
YOLO
 ↓
Person/car/package
```

Measure:

- detector FPS
- inference latency
- GPU utilization
- memory
- temperatures
- power

---

## Phase 3 — Reolink Doorbell

Add:

```text
Wi-Fi VLAN
 ↓
FortiGate
 ↓
Frigate
```

Then test:

- RTSP
- HTTP-FLV
- ONVIF
- go2rtc
- WebRTC
- two-way talk

---

## Phase 4 — MQTT

```text
Frigate
 ↓
MQTT
 ↓
Home Assistant
```

Now Frigate becomes an event engine.

---

## Phase 5 — Local VLM

Put:

```text
Ollama
 ↓
Qwen3-VL 4B
```

on your **3090 Ti**.

Then:

```text
Frigate
 ↓
Qwen3-VL
```

for:

- object descriptions
- review summaries
- contextual analysis

---

## Phase 6 — Semantic Search

Enable:

```text
Jina CLIP
```

and start searching historical detections.

Then we can experiment with:

```text
Qwen3-VL embeddings
```

through llama.cpp.

---

## Phase 7 — Home automation

Now things become fun.

Examples:

```text
Person enters driveway
        ↓
Turn porch light on
```

```text
Package detected
        ↓
Notify phone
```

```text
Known person at front door
        ↓
Different notification
```

```text
Unknown person at front door
        ↓
Record + notify + illuminate
```

```text
Garage door opens
+
Person detected
        ↓
Security event
```

---

# 31. Your eventual Home Lab topology

I'd envision this:

```text
                              INTERNET
                                  │
                                  │
                             FORTIGATE
                                  │
                    ┌─────────────┼──────────────┐
                    │             │              │
                    ▼             ▼              ▼
                CAMERAS       SERVERS          USERS
                    │              │              │
          ┌─────────┴──────┐       │              │
          │                │       │              │
       POE VLAN         Wi-Fi VLAN │              │
          │                │       │              │
    EmpireTech        Reolink      │              │
    Cameras           Doorbell     │              │
          │                │       │              │
          └────────┬───────┘       │              │
                   │               │              │
                   ▼               ▼              │
                ┌──────────────────────┐          │
                │  JETSON ORIN NANO    │          │
                │       SUPER          │          │
                │                      │          │
                │ Frigate              │          │
                │ TensorRT             │          │
                │ NVDEC                │          │
                │ go2rtc               │          │
                │ MQTT client          │          │
                └──────────┬───────────┘          │
                           │                      │
                           │ GenAI                │
                           ▼                      │
                 ┌──────────────────┐             │
                 │  RTX 3090 Ti     │             │
                 │                  │             │
                 │ Ollama           │             │
                 │ Qwen3-VL         │             │
                 │ Embeddings       │             │
                 └────────┬─────────┘             │
                          │                       │
                          ▼                       │
                 ┌──────────────────┐             │
                 │ Home Assistant   │◄────────────┘
                 │ MQTT             │
                 │ Automations      │
                 └────────┬─────────┘
                          │
                          ▼
                       PHONE
                 Frigate PWA / HA
```

---

# 32. One thing I particularly like about this architecture

**Each component has one job.**

| Component | Job |
|---|---|
| EmpireTech | Produce excellent video |
| Reolink | Doorbell + audio |
| FortiGate | Network segmentation/security |
| Jetson | Video decode + real-time CV |
| Frigate | NVR + tracking + event engine |
| TensorRT | Fast object detection |
| Ollama | Local model serving |
| Qwen3-VL | Visual reasoning/context |
| Jina/Qwen embeddings | Semantic search |
| MQTT | Event bus |
| Home Assistant | Automation/orchestration |
| unRAID | Long-term storage |
| Phone/PWA | User interface |

That's much more robust than buying one "smart NVR" that tries to do everything.

---

# 33. Does anything actually compare to Frigate?

I'd phrase it slightly differently than **"nothing compares."**

There are other capable NVR/VMS platforms — Blue Iris, Agent DVR, Shinobi, ZoneMinder, Scrypted, UniFi Protect, commercial VMS platforms, etc.

But **for the specific combination you're building**:

> **open IP cameras + local AI + TensorRT + Jetson + MQTT + Home Assistant + local VLMs + semantic search + Docker + no mandatory cloud + API access**

Frigate is an unusually strong fit.

And the **current GenAI additions make it substantially more interesting than the Frigate many people knew a few years ago.**

The important thing is that Frigate hasn't turned into an LLM toy. It maintains a sensible hierarchy:

```text
FAST / CHEAP
     │
     ▼
Motion detection
     │
     ▼
Object detection
     │
     ▼
Tracking / zones / events
     │
     ▼
     ├───────────────┐
     ▼               ▼
Recording          MQTT
     │               │
     ▼               ▼
  History       Home Assistant
     │
     ▼
   GenAI
     │
     ├── descriptions
     ├── summaries
     ├── semantic search
     └── conversational analysis
```

That is exactly how I'd want an edge-security AI system designed.

### And for **your** hardware, the key decision is now very clear:

**Jetson Orin Nano Super**
→ Frigate + TensorRT + hardware video decoding + NVR

**RTX 3090 Ti**
→ Ollama + Qwen3-VL + heavier local AI

**unRAID**
→ long-term recordings/storage

**FortiGate**
→ VLAN isolation + firewall + remote VPN

**Home Assistant**
→ automation + notifications

**Reolink Doorbell + EmpireTech**
→ cameras

That gives you a **fully local, segmented, AI-assisted home surveillance platform**, while retaining the ability to swap models, cameras, storage, and AI servers independently.

The next thing I'd do is build the **actual Jetson Frigate stack** rather than continuing at the conceptual level: **JetPack 6 → Ubuntu → Docker/NVIDIA runtime → `stable-tensorrt-jp6` → NVMe layout → TensorRT detector → go2rtc → MQTT → first EmpireTech camera → Reolink doorbell → Home Assistant → Qwen3-VL on the 3090 Ti.** That will let us validate each layer before adding the next.