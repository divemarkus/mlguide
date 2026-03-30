
# 🧠 Architecture (What you’re building)

Below is a **production-ready Frigate NVR + local AI setup** built specifically for the **NVIDIA Jetson Orin Nano Super Dev Kit (8GB)**. It follows the Seeed guide, but adds **best-practice containerization, TensorRT usage, and optional local LLM integration**.

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

# ⚙️ 3. docker-compose.yml (Jetson Optimized)

```yaml
version: "3.9"

services:
  frigate:
    container_name: frigate
    restart: unless-stopped
    image: ghcr.io/blakeblackshear/frigate:stable
    runtime: nvidia

    shm_size: "512mb"

    devices:
      - /dev/video0:/dev/video0
      - /dev/nvhost-ctrl
      - /dev/nvhost-ctrl-gpu
      - /dev/nvhost-prof-gpu
      - /dev/nvmap
      - /dev/nvhost-gpu

    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=compute,video,utility

    volumes:
      - ./config:/config
      - ./media:/media/frigate
      - ./db:/db

    ports:
      - "5000:5000"
      - "8554:8554"   # RTSP restream
      - "8555:8555/tcp"
      - "8555:8555/udp"

    depends_on:
      - mqtt

  mqtt:
    container_name: mqtt
    image: eclipse-mosquitto:latest
    restart: unless-stopped
    ports:
      - "1883:1883"
    volumes:
      - ./mosquitto:/mosquitto
```

---

# 🎥 4. Frigate config.yml (TensorRT + RTSP Cameras)

```yaml
mqtt:
  host: mqtt

detectors:
  tensorrt:
    type: tensorrt
    device: 0

ffmpeg:
  hwaccel_args:
    - -hwaccel
    - cuda
    - -hwaccel_output_format
    - cuda

cameras:
  front_yard:
    ffmpeg:
      inputs:
        - path: rtsp://USER:PASSWORD@CAMERA_IP:554/cam/realmonitor?channel=1&subtype=0
          roles:
            - detect
            - record
    detect:
      width: 1920
      height: 1080
      fps: 5

    objects:
      track:
        - person
        - car
        - dog

    record:
      enabled: true
      retain:
        days: 7

    snapshots:
      enabled: true
      timestamp: true
```

---

# 🧠 5. TensorRT Model Setup (IMPORTANT)

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

# 📡 6. RTSP Camera (Dahua / EmpireTech)

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

# ⚡ 7. Performance Tuning (CRITICAL)

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

# 🧠 8. Local LLM Integration (Optional but Powerful)

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
