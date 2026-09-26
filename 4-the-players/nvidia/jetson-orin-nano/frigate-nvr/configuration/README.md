# Jetson Orin Nano Super — Frigate Configuration

## Files

- `docker-compose.yml` — JetPack 6 Frigate container
- `config.yml` — Frigate/NVDEC/TensorRT/go2rtc/camera configuration
- `.env.example` — credentials and MQTT variables

## Install

On the Jetson:

```bash
sudo mkdir -p /srv/frigate/config
sudo mkdir -p /srv/frigate/media
sudo mkdir -p /srv/frigate/database
sudo mkdir -p /srv/frigate/models
sudo mkdir -p /srv/frigate/system
```

Copy the files into `/srv/frigate/config` or another compose directory.

Example:

```bash
cd /srv/frigate/config
cp .env.example .env
chmod 600 .env
```

Edit:

```bash
nano .env
```

Then edit the camera IPs and Jetson WebRTC candidate in:

```bash
nano config.yml
```

## Validate before starting

```bash
docker compose config
```

Then:

```bash
docker compose pull
```

Start:

```bash
docker compose up -d
```

Watch startup:

```bash
docker logs -f frigate
```

Check:

```bash
docker compose ps
```

The Frigate UI should be available at:

```text
https://JETSON_SERVER_VLAN_IP:8971
```

## First-start TensorRT model generation

The first startup can take substantially longer because:

```text
YOLO_MODELS=yolov7-320
```

causes the Frigate JetPack 6 image to generate the TensorRT engine on the Jetson.

The generated model is persisted under:

```text
/srv/frigate/config/model_cache/
```

Do not copy a TensorRT engine generated on the RTX 3090 Ti to the Jetson. TensorRT engines are platform-specific.

## Camera VLAN

Replace:

```text
192.168.60.20
```

with the EmpireTech camera address.

Replace:

```text
192.168.60.30
```

with the Reolink Doorbell address.

Replace:

```text
192.168.50.10
```

with the Jetson's Server VLAN address.

## FortiGate policy intent

Recommended traffic direction:

```text
SERVER VLAN
    |
    | TCP 554
    | TCP 80/443 where required by camera
    v
CAMERA VLAN
    |
    +-- EmpireTech
    +-- Reolink Doorbell

SERVER VLAN
    |
    | TCP 1883
    v
MQTT VLAN / MQTT broker
```

Do not allow arbitrary camera-to-server initiation.

The exact FortiGate rules should be created after the actual IP addresses and MQTT broker location are known.

## Important Reolink note

The Reolink Doorbell configuration intentionally uses HTTP-FLV for the primary stream and a secondary RTSP stream for the doorbell's two-way-audio/WebRTC path.

Make sure the Doorbell's HTTP service and RTSP service are enabled.

## Initial performance strategy

The initial configuration intentionally uses:

```text
Detection: 5 FPS
YOLO:      yolov7-320
Detect:    lower-resolution substream
Record:    high-resolution main stream
Decode:    Jetson NVDEC
```

Once the first camera is working, benchmark:

```text
YOLOv7-320
YOLOv7-416
YOLOv7-640
```

and potentially the Jetson DLA variant.

Do not optimize before we have actual Frigate CPU/GPU/NVDEC measurements.

## Next phase

After the first successful startup:

1. Verify NVDEC with `jtop`
2. Verify TensorRT detector
3. Verify EmpireTech live stream
4. Verify detection
5. Verify recording
6. Verify go2rtc
7. Verify WebRTC
8. Verify Reolink Doorbell
9. Verify MQTT events
10. Add Home Assistant
11. Add Qwen3-VL/Ollama
12. Benchmark Jetson power modes
