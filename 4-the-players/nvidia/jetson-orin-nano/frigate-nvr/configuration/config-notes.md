# Configuration

I built the first **real Frigate configuration for your Jetson + EmpireTech + Reolink + FortiGate architecture** rather than a generic example.

### Files

- :chatgpt-content-reference{index="17"}[Download the complete Frigate configuration ZIP](sandbox:/mnt/data/jetson-frigate-config.zip)
- :chatgpt-content-reference{index="18"}[Download `docker-compose.yml`](sandbox:/mnt/data/jetson-frigate/docker-compose.yml)
- :chatgpt-content-reference{index="19"}[Download `config.yml`](sandbox:/mnt/data/jetson-frigate/config.yml)
- :chatgpt-content-reference{index="20"}[Download `.env.example`](sandbox:/mnt/data/jetson-frigate/.env.example)
- :chatgpt-content-reference{index="21"}[Download README.md](sandbox:/mnt/data/jetson-frigate/README.md)

### Architecture implemented

```text
                 CAMERA VLAN
                     │
          ┌──────────┴──────────┐
          │                     │
     EmpireTech             Reolink
       RTSP                Doorbell WiFi
          │                     │
          └──────────┬──────────┘
                     │
                FORTIGATE
                     │
                SERVER VLAN
                     │
          ┌──────────▼──────────┐
          │ Jetson Orin Nano    │
          │      Super          │
          │                     │
          │      Frigate        │
          │       │ │ │         │
          │       │ │ └─ MQTT ──────► existing broker
          │       │ │           │
          │       │ └── TensorRT│
          │       │             │
          │       └──── go2rtc  │
          │                     │
          │       NVMe          │
          └─────────────────────┘
```

### Key design decisions

**EmpireTech**

The configuration uses the Dahua-compatible RTSP structure:

```text
/cam/realmonitor?channel=1&subtype=0
```

for the main stream and:

```text
/cam/realmonitor?channel=1&subtype=1
```

for the substream. Frigate's current camera documentation supports this pattern for Dahua/Amcrest-family cameras. :chatgpt-content-reference{index="0"}

The intended pipeline is:

```text
EmpireTech main  → recording
EmpireTech sub   → detection
```

That avoids feeding 4K frames into the detector unnecessarily.

**Reolink Doorbell**

I'm deliberately using the current Reolink-specific architecture:

```text
HTTP-FLV main stream
        │
        ├── recording
        └── audio

secondary RTSP
        │
        └── WebRTC / two-way audio
```

Frigate's current documentation recommends HTTP-FLV for many Reolink cameras and specifically documents the additional RTSP stream pattern for two-way audio. :chatgpt-content-reference{index="1"}

### Jetson acceleration

The Compose file uses:

```yaml
image: ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6
runtime: nvidia
```

and the configuration uses:

```yaml
hwaccel_args: preset-jetson-h264
```

for the initial H.264 camera streams.

That is consistent with current Frigate Jetson guidance: JetPack 6 uses the `stable-tensorrt-jp6` image, the NVIDIA runtime, and Jetson-specific H.264/H.265 decode presets. The Orin Nano has hardware video decoding but no hardware video encoder, so Frigate uses software encoding when encoding is required. :chatgpt-content-reference{index="2"}

### TensorRT

I've started with:

```text
YOLOv7-320
```

and:

```yaml
detectors:
  tensorrt:
    type: tensorrt
    device: 0
```

The container has:

```yaml
YOLO_MODELS: yolov7-320
```

so Frigate generates the TensorRT engine **on the Jetson itself** and stores it under:

```text
/srv/frigate/config/model_cache/
```

That's important: the TensorRT engine should not be generated on your RTX 3090 Ti and copied to the Jetson. Frigate's current TensorRT documentation specifically says the model must be processed on the same hardware platform where it will run. :chatgpt-content-reference{index="3"}

### Recording strategy

I started you with:

```text
Continuous:        1 day
Motion:            7 days
Alerts/detections: 30 days
```

This gives us a useful baseline without immediately consuming the entire NVMe. Frigate's current recording system supports separate continuous, motion, alert, and detection retention policies. :chatgpt-content-reference{index="4"}

Once we know the actual EmpireTech bitrate and Doorbell bitrate, we can calculate the NVMe requirement precisely.

---

## Before starting it

There are **four things you must change**.

### 1. Camera IPs

In `config.yml`:

```yaml
192.168.60.20
```

→ EmpireTech camera IP

and:

```yaml
192.168.60.30
```

→ Reolink Doorbell IP.

### 2. Jetson Server VLAN IP

Change:

```yaml
192.168.50.10:8555
```

to the Jetson's actual Server VLAN address.

That's the WebRTC candidate.

### 3. MQTT broker

In `.env`:

```bash
FRIGATE_MQTT_HOST=CHANGE_ME
```

put the IP/DNS name of your existing MQTT broker.

I intentionally **didn't deploy Mosquitto on the Jetson**. Your architecture is better served by a shared home-lab broker, assuming you already have one.

Frigate supports environment-variable substitution for MQTT credentials and camera credentials, keeping them out of `config.yml`. :chatgpt-content-reference{index="5"}

### 4. Credentials

Set:

```bash
FRIGATE_EMPIRETECH_USER=frigate
FRIGATE_EMPIRETECH_PASSWORD=...
FRIGATE_REOLINK_USER=frigate
FRIGATE_REOLINK_PASSWORD=...
```

I'd recommend creating **dedicated camera/Frigate accounts**, rather than putting the camera administrator account into Frigate.

---

## Start sequence

After editing:

```bash
cd /srv/frigate/config
```

First validate the Compose file:

```bash
docker compose config
```

Then:

```bash
docker compose pull
```

Then:

```bash
docker compose up -d
```

Immediately watch:

```bash
docker logs -f frigate
```

The first startup will take longer because the Jetson needs to generate the TensorRT model.

Then:

```bash
docker compose ps
```

and:

```bash
docker stats frigate
```

The Frigate UI will be:

```text
https://<JETSON-SERVER-VLAN-IP>:8971
```

Port `8971` is the current authenticated Frigate UI/API port; `8554` is the go2rtc RTSP port and `8555` is WebRTC TCP/UDP. :chatgpt-content-reference{index="6"}

**Don't open any of these ports through the FortiGate WAN.** Remote access should eventually be through your VPN.

---

## One thing I intentionally left for our next step

I did **not** try to guess the exact EmpireTech camera resolution/codec configuration.

Once the first EmpireTech camera is physically installed, we'll determine:

```text
Main:
  resolution
  FPS
  codec
  bitrate
  I-frame interval

Sub:
  resolution
  FPS
  codec
  bitrate
```

Then we'll tune:

```text
NVDEC
   ↓
substream
   ↓
TensorRT YOLOv7-320
   ↓
5 FPS detection
```

and benchmark the Jetson.

After that we can test **YOLOv7-416 vs 320**, potentially test the Orin's DLA, and then add the Reolink Doorbell.

### References

- [Frigate — Installation](https://docs.frigate.video/frigate/installation/?utm_source=chatgpt.com)
- [Frigate — Jetson Hardware Acceleration](https://docs.frigate.video/configuration/hardware_acceleration_video/?utm_source=chatgpt.com)
- [Frigate — Object Detectors / TensorRT](https://docs.frigate.video/configuration/object_detectors/?utm_source=chatgpt.com)
- [Frigate — Camera Configuration](https://docs.frigate.video/configuration/cameras/?utm_source=chatgpt.com)
- [Frigate — Reolink Camera Configuration](https://docs.frigate.video/configuration/camera_specific/?utm_source=chatgpt.com)
- [Frigate — Recording](https://docs.frigate.video/configuration/record/?utm_source=chatgpt.com)
- [NVIDIA JetPack 6.2.3](https://developer.nvidia.com/embedded/jetpack-sdk-623?utm_source=chatgpt.com)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html?utm_source=chatgpt.com)
- [Seeed Studio — Deploy Frigate on Jetson](https://wiki.seeedstudio.com/deploy_frigate_on_jetson/?utm_source=chatgpt.com)

**Next, I recommend we bring up exactly one camera — the first EmpireTech — and validate NVDEC + TensorRT + recording before touching the Reolink Doorbell.** That gives us a clean baseline for the entire NVR.