# Frigate Build — NVIDIA Jetson Orin Nano Super

## Project Goal

Build a **local, privacy-first Frigate NVR** around the NVIDIA Jetson Orin Nano Super, using:

- JetPack 6
- Ubuntu 22.04
- Docker / Docker Compose
- NVIDIA Container Toolkit
- Frigate's Jetson TensorRT image
- TensorRT object detection
- Jetson hardware video decoding
- NVMe storage
- go2rtc
- MQTT
- EmpireTech IP cameras
- Reolink Video Doorbell WiFi
- Home Assistant
- Local Qwen3-VL
- Optional NVIDIA RTX 3090 Ti VLM server when home

The key design requirement is:

> **The Jetson must remain a fully functional standalone security/NVR/AI system even when the RTX 3090 Ti is powered off while away from home.**

The 3090 Ti will therefore be an **optional AI accelerator**, not a dependency.

---

# 1. Target Architecture

```text
                         INTERNET
                            │
                            ▼
                       FORTIGATE
                            │
             ┌──────────────┴──────────────┐
             │                             │
        CAMERA VLAN                    SERVER VLAN
             │                             │
      ┌──────┴──────┐                      │
      │             │                      │
 EmpireTech     Reolink Doorbell           │
   Cameras          WiFi                   │
      │             │                      │
      └──────┬──────┘                      │
             │ RTSP / HTTP-FLV             │
             │                             │
             └────────────────────────────►│
                                           │
                              ┌────────────▼─────────────┐
                              │     JETSON ORIN NANO     │
                              │          SUPER           │
                              │                          │
                              │ Ubuntu / JetPack 6       │
                              │ Docker                   │
                              │ NVIDIA Container Toolkit │
                              │                          │
                              │ Frigate                  │
                              │ TensorRT                 │
                              │ NVDEC                    │
                              │ go2rtc                   │
                              │ WebRTC                   │
                              │ Recording                │
                              │ MQTT                     │
                              │                          │
                              │ Ollama                   │
                              │ Qwen3-VL 4B              │
                              └────────────┬─────────────┘
                                           │
                       ┌───────────────────┼──────────────────┐
                       │                   │                  │
                       ▼                   ▼                  ▼
                     MQTT             Home Assistant        NVMe
                       │                   │                  │
                       │                   │             Recordings
                       │                   │             Database
                       │                   │             Models
                       │                   │
                       └───────────────────┘

                    OPTIONAL WHEN HOME

                              ┌──────────────────────┐
                              │ Ryzen 9 9900X3D      │
                              │ RTX 3090 Ti          │
                              │                      │
                              │ Ollama               │
                              │ Qwen3-VL 8B/30B      │
                              └──────────┬───────────┘
                                         │
                                         ▼
                                      Frigate
```

---

# 2. Why JetPack 6.2.3

## Recommended baseline

Use:

**JetPack 6.2.3**

NVIDIA identifies JetPack 6.2.3 as the latest production release of JetPack 6. It provides:

- Jetson Linux 36.5.2
- Linux kernel 5.15
- Ubuntu 22.04
- CUDA 12.6
- TensorRT 10.3
- cuDNN 9.3
- DLA 3.1

Source:

[NVIDIA JetPack SDK 6.2.3](https://developer.nvidia.com/embedded/jetpack-sdk-623)

This is the version we should target for this project.

---

# 3. Why Not JetPack 7?

JetPack 7 is newer, but our goal is not simply to use the newest JetPack.

Our goal is:

> **Maximum compatibility with Frigate + TensorRT + Jetson hardware acceleration.**

Current Frigate documentation specifically states:

> For Jetson systems running JetPack 6.0+, use the `stable-tensorrt-jp6` image.

Source:

[Frigate — Hardware-Accelerated Video Decoding](https://docs.frigate.video/configuration/hardware_acceleration_video/)

Therefore our initial platform is:

```text
Jetson Orin Nano Super
        │
        ▼
JetPack 6.2.3
        │
        ▼
Jetson Linux 36.5.2
        │
        ▼
Frigate stable-tensorrt-jp6
```

We can revisit JetPack 7 later when Frigate's Jetson support catches up.

---

# 4. Seeed Studio Guide — What We Keep and What We Change

Seeed has a useful guide:

[Seeed Studio — Deploy Frigate on Jetson](https://wiki.seeedstudio.com/deploy_frigate_on_jetson/)

The overall workflow is useful:

```text
Jetson
  ↓
JetPack
  ↓
Docker
  ↓
NVIDIA Container Toolkit
  ↓
Frigate TensorRT image
  ↓
IP camera
```

However, the guide is based on:

```text
JetPack 5.1.3
stable-tensorrt-jp5
docker-compose
```

rather than our JetPack 6 architecture.

Therefore:

### We will NOT copy these parts directly

```text
stable-tensorrt-jp5
docker-compose
port 5000 as primary UI
```

Instead:

```text
stable-tensorrt-jp6
docker compose
port 8971 authenticated UI
```

The current Frigate documentation is our authoritative source for the actual deployment.

---

# 5. Software Stack

| Component | Choice |
|---|---|
| Hardware | NVIDIA Jetson Orin Nano Super 8GB |
| OS | Ubuntu 22.04 |
| JetPack | **6.2.3** |
| Jetson Linux | **36.5.2** |
| CUDA | 12.6 |
| TensorRT | 10.3 |
| Docker | Current Docker Engine |
| Compose | Docker Compose v2 |
| NVIDIA runtime | NVIDIA Container Toolkit |
| Frigate | Current stable |
| Frigate image | **`stable-tensorrt-jp6`** |
| Video decoding | Jetson NVDEC |
| Detection | TensorRT |
| Initial detector | YOLOv7-320 baseline |
| Restream | go2rtc |
| Messaging | MQTT |
| VLM | Qwen3-VL 4B |
| VLM server | Ollama |
| Primary storage | NVMe |
| Long-term storage | Potentially unRAID |
| Home automation | Home Assistant |

---

# 6. Physical Hardware

Our Jetson should have:

```text
Jetson Orin Nano Super
        │
        ├── NVMe Gen4 SSD
        │
        ├── Active cooling
        │
        ├── Ethernet
        │
        └── Recovery jumper
```

Your female jumper for the Jetson pins will be used when recovery/firmware flashing is required.

Do **not** flash or format anything yet.

First determine exactly what software state the Jetson is currently in.

---

# 7. First Diagnostic Check

Connect:

- HDMI
- Keyboard
- Mouse
- Ethernet
- Power

Then run:

```bash
cat /etc/nv_tegra_release
```

```bash
dpkg-query -W nvidia-jetpack
```

```bash
uname -a
```

```bash
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS,MODEL
```

```bash
df -h
```

```bash
sudo nvpmodel -q
```

```bash
sudo jetson_clocks --show
```

Do not make changes yet.

These tell us:

1. JetPack/L4T version
2. NVIDIA package state
3. Kernel version
4. NVMe device and partitions
5. Current filesystem usage
6. Current power profile
7. Clock configuration

---

# 8. NVMe Strategy

Frigate recordings should **not** live on the microSD card.

The NVMe will become the Jetson's primary working storage.

Proposed layout:

```text
NVMe
│
├── /srv/frigate/
│   │
│   ├── config/
│   │
│   ├── media/
│   │
│   └── database/
│
├── /srv/ollama/
│
└── /srv/system/
```

Initially:

```text
Jetson NVMe
    │
    ├── Frigate configuration
    ├── Frigate database
    ├── recordings
    └── AI models
```

Eventually:

```text
Jetson NVMe
    │
    ├── active recordings
    ├── database
    └── models
           │
           ▼
         unRAID
           │
           └── long-term storage
```

Frigate supports local storage as well as network-storage architectures.

Source:

[Frigate — Installation](https://docs.frigate.video/frigate/installation/)

---

# 9. Filesystem

Once we have positively identified the NVMe device, I recommend:

```text
ext4
```

For example:

```text
/dev/nvme0n1
       │
       └── /srv/frigate
```

Create the mount point:

```bash
sudo mkdir -p /srv/frigate
```

Then configure `/etc/fstab` using the NVMe UUID.

### Important

We will **not** run:

```bash
mkfs
```

until the actual NVMe device has been positively identified.

This prevents accidentally formatting the wrong disk.

---

# 10. Jetson Performance Mode

The Orin Nano Super provides several power profiles.

We'll initially benchmark:

```text
15W
25W
MAXN SUPER
```

For the first installation and performance testing, use the maximum-performance configuration.

The eventual goal is different:

> Find the lowest-power mode that can comfortably handle the final camera count.

For example, if six cameras perform identically at 25W and MAXN SUPER, there is little reason to operate continuously at MAXN SUPER.

---

# 11. Docker

Install current Docker Engine and use:

```bash
docker compose
```

rather than the obsolete Python-based:

```bash
docker-compose
```

The resulting architecture is:

```text
Docker
   │
   └── Docker Compose
          │
          └── Frigate
```

Seeed's older guide installs the Python `docker-compose` package; we're deliberately avoiding that approach.

---

# 12. NVIDIA Container Toolkit

The NVIDIA Container Toolkit exposes the Jetson GPU to Docker.

Current NVIDIA documentation uses:

```bash
sudo nvidia-ctk runtime configure --runtime=docker
```

followed by:

```bash
sudo systemctl restart docker
```

Official documentation:

[NVIDIA Container Toolkit — Docker Configuration](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

Then verify Docker:

```bash
docker info | grep -i runtime
```

and:

```bash
docker info | grep -i nvidia
```

---

# 13. Validate GPU Access Before Installing Frigate

We want to prove:

```text
Jetson
   ↓
NVIDIA driver
   ↓
NVIDIA Container Toolkit
   ↓
Docker
   ↓
GPU-enabled container
```

before adding Frigate.

Also install Jetson monitoring tools:

```bash
sudo apt install python3-pip
```

```bash
sudo pip3 install -U jetson-stats
```

Then:

```bash
jtop
```

and:

```bash
sudo tegrastats
```

`jtop` will eventually be particularly useful for verifying NVDEC activity.

---

# 14. Frigate Docker Image

The image we want is:

```yaml
image: ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6
```

This is the current Frigate Jetson image for JetPack 6.

Source:

[Frigate — Hardware-Accelerated Video Decoding](https://docs.frigate.video/configuration/hardware_acceleration_video/)

The container uses:

```yaml
runtime: nvidia
```

---

# 15. Initial Docker Compose

Our first deployment should intentionally be small.

```yaml
services:
  frigate:
    container_name: frigate
    restart: unless-stopped
    stop_grace_period: 30s

    image: ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6

    runtime: nvidia

    shm_size: "256mb"

    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /srv/frigate/config:/config
      - /srv/frigate/media:/media/frigate

      # RAM cache reduces SSD writes
      - type: tmpfs
        target: /tmp/cache
        tmpfs:
          size: 1000000000

    ports:
      - "8971:8971"
      - "8554:8554"
      - "8555:8555/tcp"
      - "8555:8555/udp"

    environment:
      TZ: America/Los_Angeles
```

Notice:

**No port 5000.**

Current Frigate uses:

```text
8971 = authenticated UI/API
5000 = unauthenticated internal interface
```

Source:

[Frigate — Installation](https://docs.frigate.video/frigate/installation/)

For our network, 8971 will be the normal management interface.

---

# 16. Shared Memory

Docker's default shared-memory allocation is relatively small.

Frigate uses shared memory for frame processing.

For our first camera:

```text
256 MB
```

is a reasonable starting point.

Once we reach several cameras, we'll measure memory requirements rather than arbitrarily increasing it.

---

# 17. TensorRT Detector

Our initial detection architecture:

```text
Camera
   │
   ▼
Jetson NVDEC
   │
   ▼
Frigate
   │
   ▼
TensorRT
   │
   ▼
Object Detection
```

TensorRT engines should be generated for the actual Jetson hardware.

Therefore:

```text
3090 Ti
   │
   └── NOT used to build Jetson TRT engine
```

Instead:

```text
Jetson
   │
   ▼
TensorRT
   │
   ▼
Jetson-specific engine
```

This gives us a reproducible Jetson-local detector.

Source:

[Frigate — Object Detectors](https://docs.frigate.video/configuration/object_detectors/)

---

# 18. Initial Detector: YOLOv7-320

For our first benchmark:

```text
yolov7-320
```

We'll use it as the known-good baseline.

The environment variable is:

```yaml
environment:
  YOLO_MODELS: yolov7-320
```

Frigate will generate/cache the TensorRT model under:

```text
/config/model_cache/tensorrt/
```

which maps to:

```text
/srv/frigate/config/model_cache/tensorrt/
```

---

# 19. Later Detector Benchmark

Once the basic system is working, we'll compare the baseline with newer ONNX/TensorRT models.

Frigate's current object-detector documentation also discusses YOLOv9 ONNX models.

Source:

[Frigate — Object Detectors](https://docs.frigate.video/configuration/object_detectors/)

We'll measure:

| Metric | YOLOv7-320 | Newer model |
|---|---:|---:|
| Detection FPS | Measure | Measure |
| Latency | Measure | Measure |
| GPU utilization | Measure | Measure |
| RAM | Measure | Measure |
| Accuracy | Measure | Measure |
| False positives | Measure | Measure |
| Maximum cameras | Measure | Measure |

We will choose based on actual Jetson performance rather than assuming a newer model is automatically better.

---

# 20. Hardware Video Decoding

This is critical.

For H.264:

```yaml
ffmpeg:
  hwaccel_args: preset-jetson-h264
```

For H.265/HEVC:

```yaml
ffmpeg:
  hwaccel_args: preset-jetson-h265
```

Frigate provides these Jetson-specific presets.

Source:

[Frigate — Hardware-Accelerated Video Decoding](https://docs.frigate.video/configuration/hardware_acceleration_video/)

We want:

```text
EmpireTech
    │
    │ H.264/H.265
    ▼
Jetson NVDEC
    │
    ▼
Frigate
```

rather than CPU-based decoding.

---

# 21. Orin Nano Video Encoder Limitation

The Orin Nano does **not** have a hardware video encoder.

However, it does provide hardware video decoding and TensorRT acceleration.

Frigate therefore uses:

```text
Hardware decode
+
TensorRT detection
+
Software encode where required
```

This is another reason to avoid unnecessary transcoding.

Source:

[Frigate — Hardware-Accelerated Video Decoding](https://docs.frigate.video/configuration/hardware_acceleration_video/)

---

# 22. Initial Frigate Configuration

We'll start with one camera.

Conceptually:

```yaml
mqtt:
  enabled: false

detectors:
  tensorrt:
    type: tensorrt
    device: 0

detect:
  fps: 5

objects:
  track:
    - person
    - car
    - dog
    - cat

birdseye:
  enabled: true
  mode: objects
```

The exact detector/model configuration will be finalized against the version of Frigate actually installed.

We should **not blindly copy a model path or label map** from an older configuration.

---

# 23. Detection FPS vs Camera FPS

This is an important concept.

The camera may produce:

```text
20 FPS
```

while Frigate initially performs object detection at:

```text
5 FPS
```

Those are not the same thing.

The camera can continue recording at high frame rate while the AI detector examines a smaller number of frames.

Initial target:

```text
Camera:
20 FPS

Detection:
5 FPS
```

Then we'll benchmark from there.

---

# 24. Camera Stream Architecture

For the EmpireTech cameras:

```text
MAIN STREAM
     │
     ├── High-quality recording
     │
     └── Full-resolution playback

SUBSTREAM
     │
     └── Object detection
```

For example:

```text
EmpireTech
    │
    ├── Main
    │     3840×2160
    │     H.264/H.265
    │
    └── Sub
          640×360 / similar
          H.264
```

Then:

```text
Main stream ─────► Recording
Substream ───────► Detection
```

This is considerably more efficient than performing object detection against 4K frames.

---

# 25. go2rtc

Frigate includes go2rtc.

We'll use it for:

- RTSP restreaming
- reducing camera connections
- WebRTC
- mobile live viewing
- Home Assistant
- Reolink camera integration
- future two-way audio requirements

Architecture:

```text
Camera
   │
   ▼
go2rtc
   │
   ├── Frigate
   ├── WebRTC
   ├── Home Assistant
   └── Mobile clients
```

Instead of:

```text
Camera
 ├── Frigate
 ├── Home Assistant
 ├── Mobile
 └── Other client
```

all independently connecting to the camera.

---

# 26. MQTT

Eventually:

```text
Frigate
   │
   ▼
MQTT Broker
   │
   ├── Home Assistant
   ├── Node-RED
   └── Other automation
```

I do **not** necessarily want the MQTT broker running on the Jetson.

A shared home-lab MQTT broker is more useful.

Possible locations:

- Home Assistant
- Dedicated Mosquitto container
- Another home-lab VM/server

Frigate's Home Assistant integration requires MQTT.

Source:

[Frigate — Home Assistant Integration](https://docs.frigate.video/integrations/home-assistant/)

---

# 27. Qwen3-VL Comes After the NVR

Do not initially install:

```text
Frigate
+
MQTT
+
Home Assistant
+
Ollama
+
Qwen
+
Reolink
+
multiple cameras
```

at the same time.

Instead:

### Stage 1

```text
Camera
   ↓
Frigate
   ↓
TensorRT
```

### Stage 2

```text
Camera
   ↓
Frigate
   ↓
TensorRT
   ↓
Recording
```

### Stage 3

```text
Frigate
   ↓
go2rtc
```

### Stage 4

```text
Frigate
   ↓
MQTT
   ↓
Home Assistant
```

### Stage 5

```text
Frigate
   ↓
Ollama
   ↓
Qwen3-VL
```

This gives us a clean troubleshooting path.

---

# 28. Qwen3-VL on the Jetson

This is where the project gets particularly interesting.

Current Frigate documentation recommends Qwen3-VL for local vision descriptions/chat and provides an Ollama configuration using:

```yaml
model: qwen3-vl:4b
```

Source:

[Frigate — Generative AI Configuration](https://docs.frigate.video/configuration/genai/genai_config/)

The first Jetson model will therefore be:

```text
Qwen3-VL 4B
```

not 8B.

---

# 29. Why Qwen3-VL 4B First?

The Orin Nano Super has:

```text
8 GB unified memory
```

That memory is shared by:

- Linux
- Docker
- Frigate
- FFmpeg
- TensorRT
- video buffers
- go2rtc
- database
- Ollama
- Qwen3-VL

A larger VLM leaves progressively less headroom for the NVR itself.

Therefore:

```text
Jetson:
Qwen3-VL 4B
```

is our starting point.

Current Frigate documentation also recommends GPU/dedicated hardware for practical local GenAI inference and specifically documents Qwen3-VL/Ollama as a local option.

Source:

[Frigate — Generative AI Configuration](https://docs.frigate.video/configuration/genai/genai_config/)

---

# 30. Event-Driven VLM

We absolutely do **not** want:

```text
5 FPS × 6 cameras × Qwen3-VL
```

That would be an inefficient architecture.

Instead:

```text
Camera
   │
   ▼
Motion
   │
   ▼
TensorRT
   │
   ▼
Person detected
   │
   ▼
Object tracking
   │
   ▼
Interesting event
   │
   ▼
Qwen3-VL
   │
   ▼
Description
```

For example:

> "A person approached the front door carrying a small package."

rather than merely:

> "Person detected."

Frigate's GenAI functionality is designed to enrich detected/tracked objects rather than replace the real-time detector.

Source:

[Frigate — Generative AI Configuration](https://docs.frigate.video/configuration/genai/genai_config/)

---

# 31. 3090 Ti as Optional VLM Server

When the 3090 Ti is powered on:

```text
Frigate
   │
   ▼
RTX 3090 Ti
   │
   ▼
Ollama
   │
   ├── Qwen3-VL 8B
   └── Qwen3-VL 30B
```

When you're away:

```text
Frigate
   │
   ▼
Jetson
   │
   ▼
Ollama
   │
   ▼
Qwen3-VL 4B
```

This is the key architectural advantage.

The NVR itself never depends on the 3090 Ti.

Frigate's GenAI provider configuration allows the Ollama server to be specified by its URL, making this architecture practical.

Source:

[Frigate — Generative AI Configuration](https://docs.frigate.video/configuration/genai/genai_config/)

Eventually we can implement:

```text
3090 Ti available?
       │
   ┌───┴───┐
  YES      NO
   │        │
   ▼        ▼
3090 Ti   Jetson
   │        │
8B/30B     4B
```

without changing the camera/NVR layer.

---

# 32. Semantic Search

Do not enable this on day one.

First establish:

```text
Detection
Recording
GenAI descriptions
```

Then add:

```text
Semantic Search
```

Frigate supports local embedding models and current documentation discusses Qwen3-VL embeddings through llama.cpp.

Source:

[Frigate — Semantic Search](https://docs.frigate.video/configuration/semantic_search/)

Eventually we want:

```text
Search:

"person carrying a package"

        ↓

Frigate

        ↓

Historical matching events
```

That will be Phase 2.

---

# 33. Home Assistant

Once Frigate is stable:

```text
Frigate
   │
   ▼
MQTT
   │
   ▼
Home Assistant
```

Then Home Assistant can become the automation layer:

```text
Person at front door
       ↓
Home Assistant
       ↓
Phone notification
```

or:

```text
Package detected
       ↓
Home Assistant
       ↓
Porch light
```

or:

```text
Person enters driveway
       ↓
Home Assistant
       ↓
Security automation
```

Official integration:

[Frigate — Home Assistant Integration](https://docs.frigate.video/integrations/home-assistant/)

---

# 34. Remote Access

Do **not** expose Frigate directly to the Internet.

Use the FortiGate VPN.

```text
Phone
   │
   ▼
FortiGate VPN
   │
   ▼
Home Network
   │
   ▼
Jetson
   │
   ▼
Frigate :8971
```

This gives you remote access while keeping:

- cameras private
- RTSP private
- Frigate private
- MQTT private
- AI services private

The Frigate web application can be used as a PWA on mobile devices.

---

# 35. Mobile Access

The primary mobile architecture will be:

```text
                     PHONE
                       │
          ┌────────────┴────────────┐
          │                         │
          ▼                         ▼
    Frigate PWA              Home Assistant App
          │                         │
     Live video                Notifications
     Recordings                Automations
     Events                    Sensors
     Review                    Controls
     Search
```

Remote access:

```text
Phone
  ↓
VPN
  ↓
FortiGate
  ↓
Home network
  ↓
Jetson
```

No cloud NVR is required.

---

# 36. First Milestone

The first milestone should be intentionally simple:

```text
Jetson Orin Nano Super
        │
        ├── JetPack 6.2.3
        │
        ├── Docker
        │
        ├── NVIDIA Container Toolkit
        │
        └── Frigate
              │
              └── TensorRT
                    │
                    └── YOLOv7-320
                          │
                          └── ONE EmpireTech camera
```

Nothing else initially.

No:

- MQTT
- Home Assistant
- Ollama
- Qwen
- semantic search
- Reolink
- multiple cameras

---

# 37. First-Milestone Success Criteria

We want all of these working:

```text
✓ JetPack 6.2.3
✓ Ubuntu 22.04
✓ MAXN SUPER available
✓ NVMe mounted
✓ Docker working
✓ NVIDIA Container Toolkit working
✓ Docker GPU access
✓ Frigate container starts
✓ TensorRT initializes
✓ TensorRT model generated
✓ NVDEC active
✓ EmpireTech RTSP stream works
✓ Person detection works
✓ Recording works
✓ Frigate authenticated UI works
```

Only after all of these work do we add the next layer.

---

# 38. Our Build Roadmap

## Phase 0 — Hardware

```text
Jetson
NVMe
Cooling
Ethernet
```

## Phase 1 — JetPack

```text
JetPack 6.2.3
Ubuntu 22.04
MAXN SUPER
```

## Phase 2 — Docker

```text
Docker Engine
Docker Compose v2
NVIDIA Container Toolkit
```

## Phase 3 — Frigate

```text
stable-tensorrt-jp6
TensorRT
YOLOv7-320
```

## Phase 4 — Camera

```text
EmpireTech
RTSP
Main stream
Substream
NVDEC
```

## Phase 5 — go2rtc

```text
RTSP
Restream
WebRTC
```

## Phase 6 — MQTT

```text
Frigate
   ↓
MQTT
```

## Phase 7 — Home Assistant

```text
MQTT
   ↓
Home Assistant
```

## Phase 8 — Reolink Doorbell

```text
Wi-Fi VLAN
   ↓
FortiGate
   ↓
Frigate
```

## Phase 9 — Local VLM

```text
Jetson
   ↓
Ollama
   ↓
Qwen3-VL 4B
```

## Phase 10 — Semantic Search

```text
Embeddings
   ↓
Frigate
   ↓
Natural-language video search
```

## Phase 11 — 3090 Ti

```text
Frigate
   ↓
3090 Ti Ollama
   ↓
Qwen3-VL 8B / 30B
```

---

# 39. Our First Diagnostic Checkpoint

Before flashing, installing Docker, formatting the NVMe, or changing anything:

Run these commands on the Jetson:

```bash
cat /etc/nv_tegra_release
```

```bash
dpkg-query -W nvidia-jetpack
```

```bash
uname -a
```

```bash
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS,MODEL
```

```bash
df -h
```

```bash
sudo nvpmodel -q
```

```bash
sudo jetson_clocks --show
```

Paste the complete output here.

That will establish whether we're starting from:

```text
A. Factory / JetPack 5
B. JetPack 6.x
C. Already configured JetPack 6.x / Super mode
```

and, importantly, what the NVMe currently looks like.

From that point we can proceed with the **exact commands for your actual Jetson**, rather than blindly applying a generic installation script.

---

# Reference Documentation

### NVIDIA

- [NVIDIA JetPack SDK 6.2.3](https://developer.nvidia.com/embedded/jetpack-sdk-623)
- [NVIDIA Jetson Developer Documentation](https://docs.nvidia.com/jetson/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/)

### Frigate

- [Frigate Documentation](https://docs.frigate.video/)
- [Frigate Installation](https://docs.frigate.video/frigate/installation/)
- [Frigate Hardware-Accelerated Video Decoding](https://docs.frigate.video/configuration/hardware_acceleration_video/)
- [Frigate Object Detectors](https://docs.frigate.video/configuration/object_detectors/)
- [Frigate Generative AI](https://docs.frigate.video/configuration/genai/genai_config/)
- [Frigate Semantic Search](https://docs.frigate.video/configuration/semantic_search/)
- [Frigate Home Assistant Integration](https://docs.frigate.video/integrations/home-assistant/)

### Seeed Studio

- [Seeed Studio — Deploy Frigate on Jetson](https://wiki.seeedstudio.com/deploy_frigate_on_jetson/)

### Ollama

- [Ollama](https://ollama.com/)
- [Ollama Model Library](https://ollama.com/library)

---

# Build from old summary
- The information below has been updated. Take notes.

# 🧠 Architecture (What you’re building)

Below is a **production-ready Frigate NVR + local AI setup** built specifically for the **NVIDIA Jetson Orin Nano Super Dev Kit (8GB)**. It follows the [Seeed guide](https://wiki.seeedstudio.com/deploy_frigate_on_jetson/), but adds **best-practice containerization, TensorRT usage, and optional local LLM integration**.

```text
RTSP PoE Cameras (Dahua / EmpireTech)
        ↓
Frigate (Docker, TensorRT detector)
        ↓
Jetson GPU (CUDA + TensorRT)
        ↓
MQTT (events + automation)
        ↓
(Optional) Local LLM (alerts, summaries)
```

---

# 🧰 1. Prerequisites (Jetson Setup)

## Flash + OS

* Use **JetPack 6.x (Ubuntu 22.04/24.04 based)**
* Ensure:

  * CUDA ✅
  * TensorRT ✅
  * Docker ✅ (with NVIDIA runtime)

---

## Install Docker + NVIDIA runtime

```bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER
newgrp docker
```

---

## Verify GPU inside container

```bash
docker run --rm --runtime nvidia nvcr.io/nvidia/l4t-base:r36.2.0 nvidia-smi
```

👉 On Jetson you may not get full `nvidia-smi`, but no errors = OK

---

# 📦 2. Directory Layout

```bash
mkdir -p ~/frigate/{config,media,db,models}
cd ~/frigate
```

---

# 🧠 3. TensorRT Model Setup (IMPORTANT)

Jetson performs best with TensorRT-optimized models.

---

## Download Frigate TensorRT model:

```bash
cd ~/frigate/models
wget https://github.com/blakeblackshear/frigate/releases/download/v0.13.0/frigate-tensorrt-models.tar.gz
tar -xvf frigate-tensorrt-models.tar.gz
```

---

## Update config:

```yaml
model:
  path: /models/tensorrt/efficientdet_lite0.trt
```

---

# 📡 4. RTSP Camera (Dahua / EmpireTech)

Typical RTSP:

```text
rtsp://user:password@192.168.1.100:554/cam/realmonitor?channel=1&subtype=0
```

---

## Best Practices:

* Use **main stream for recording**
* Use **substream (lower res) for detection**

Example:

```yaml
inputs:
  - path: rtsp://...subtype=1   # detection (low res)
    roles: [detect]
  - path: rtsp://...subtype=0   # record (high res)
    roles: [record]
```

---

# ⚡ 5. Performance Tuning (CRITICAL)

## On Orin Nano 8GB:

| Setting    | Recommendation     |
| ---------- | ------------------ |
| Cameras    | 2–4 max            |
| Resolution | 720p–1080p         |
| FPS detect | 5–10               |
| Model      | efficientdet-lite0 |
| Storage    | NVMe SSD           |

---

## Enable max performance mode:

```bash
sudo nvpmodel -m 0
sudo jetson_clocks
```

---

# 🧠 6. Local LLM Integration (Optional but Powerful)

## Use case:

* “Person detected at front door at 3:12 PM”
* Summarize events
* Alert classification

---

## Lightweight approach (Jetson-friendly):

Run small models via:

* llama.cpp (CPU + GPU offload)
* or remote Ollama (recommended)

---

## Example flow:

```text
Frigate → MQTT → Python script → LLM → Notification
```

---

## Example Python hook:

```python
import paho.mqtt.client as mqtt

def on_message(client, userdata, msg):
    event = msg.payload.decode()
    # send to local LLM or remote Ollama
    print("Event:", event)

client = mqtt.Client()
client.connect("localhost", 1883, 60)
client.subscribe("frigate/events")
client.on_message = on_message
client.loop_forever()
```

---

# 🧠 9. What This Setup Does Well

## 🟢 Strengths

* Real-time object detection
* Very low power (~15–25W)
* Fully local (no cloud)
* Works great with 2–4 cameras

---

## 🔴 Limitations

* Not for large LLMs
* Limited camera scaling
* TensorRT setup required

---

# 🔥 Final Verdict

> 🧠 The **Jetson Orin Nano Super** is one of the BEST platforms for:

* Frigate NVR
* Edge AI
* Low-power surveillance
