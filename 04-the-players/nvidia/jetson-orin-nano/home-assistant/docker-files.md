# Home Assistant - Docker Files

Yes. I'll keep the **Frigate configuration essentially unchanged**, add Home Assistant as a second service, and give you the YAML as a **separate standalone output** so you can save it directly as `docker-compose.yml`.

One important point: since you're using **Home Assistant Container rather than HA OS**, HA should use `network_mode: host`. That is intentional for Home Assistant discovery and networking. Frigate remains on the normal Docker bridge network with its existing published ports.

## `docker-compose.yml`

Save the following as:

```text
/srv/homeassistant-frigate/docker-compose.yml
```

```yaml
services:

  # ============================================================
  # HOME ASSISTANT
  # ============================================================
  #
  # Home Assistant Container
  #
  # Host networking is intentional.
  #
  # Benefits:
  #   - Better device discovery
  #   - mDNS / Zeroconf support
  #   - Simplifies access to devices on the LAN
  #   - HA listens directly on port 8123
  #
  # Home Assistant does NOT require the NVIDIA runtime.
  #
  # ============================================================

  homeassistant:
    container_name: homeassistant
    restart: unless-stopped
    stop_grace_period: 60s

    image: ghcr.io/home-assistant/home-assistant:stable

    network_mode: host

    environment:
      TZ: ${TZ:-America/Los_Angeles}

    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /srv/homeassistant/config:/config


  # ============================================================
  # FRIGATE NVR
  # ============================================================
  #
  # Jetson-specific Frigate build:
  #
  #   JetPack 6
  #   TensorRT
  #   NVIDIA runtime
  #
  # IMPORTANT:
  # The TensorRT engine must be generated for THIS Jetson.
  # Do not copy a .trt engine from the RTX 3090 Ti.
  #
  # ============================================================

  frigate:
    container_name: frigate
    restart: unless-stopped
    stop_grace_period: 30s

    image: ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6
    runtime: nvidia

    shm_size: "512mb"

    environment:
      TZ: ${TZ:-America/Los_Angeles}

      # TensorRT model generated ON THIS JETSON.
      # Do not copy a .trt engine from the RTX 3090 Ti.
      YOLO_MODELS: ${YOLO_MODELS:-yolov7-320}

      # Keep true for the Orin Nano Super's normal FP16 path.
      USE_FP16: ${USE_FP16:-true}

      # Camera / MQTT variables used by config.yml.
      FRIGATE_EMPIRETECH_USER: ${FRIGATE_EMPIRETECH_USER}
      FRIGATE_EMPIRETECH_PASSWORD: ${FRIGATE_EMPIRETECH_PASSWORD}

      FRIGATE_REOLINK_USER: ${FRIGATE_REOLINK_USER}
      FRIGATE_REOLINK_PASSWORD: ${FRIGATE_REOLINK_PASSWORD}

      FRIGATE_MQTT_HOST: ${FRIGATE_MQTT_HOST}
      FRIGATE_MQTT_USER: ${FRIGATE_MQTT_USER}
      FRIGATE_MQTT_PASSWORD: ${FRIGATE_MQTT_PASSWORD}

    volumes:
      - /etc/localtime:/etc/localtime:ro

      # Frigate configuration
      - /srv/frigate/config:/config

      # Frigate recordings / clips / snapshots
      - /srv/frigate/media:/media/frigate

      # Temporary recording segment cache.
      # Reduces unnecessary NVMe writes.
      - type: tmpfs
        target: /tmp/cache
        tmpfs:
          size: 1000000000

    ports:

      # --------------------------------------------------------
      # Authenticated Frigate UI/API
      # --------------------------------------------------------
      - "8971:8971"

      # --------------------------------------------------------
      # go2rtc RTSP restream
      # --------------------------------------------------------
      - "8554:8554"

      # --------------------------------------------------------
      # go2rtc WebRTC
      # --------------------------------------------------------
      - "8555:8555/tcp"
      - "8555:8555/udp"

    # ==========================================================
    # NETWORK ARCHITECTURE
    # ==========================================================
    #
    # The Jetson is on the Server VLAN.
    #
    # FortiGate controls inter-VLAN access:
    #
    #   Server VLAN  --> Camera VLAN
    #       Jetson   --> EmpireTech / Reolink
    #
    #   Server VLAN  --> MQTT VLAN / broker
    #       Jetson   --> MQTT
    #
    #   Camera VLAN  -X-> Server VLAN
    #       Cameras cannot initiate arbitrary connections
    #       toward the Jetson.
    #
    # MQTT is intentionally NOT deployed in this Compose file.
    # The home lab uses an external/shared MQTT broker.
    #
    # ==========================================================
```

## Resulting directory structure

I'd use this layout:

```text
/srv/homeassistant-frigate/
├── docker-compose.yml
└── .env

/srv/homeassistant/
└── config/

/srv/frigate/
├── config/
│   └── config.yml
└── media/
```

Create the directories with:

```bash
sudo mkdir -p /srv/homeassistant/config
sudo mkdir -p /srv/frigate/config
sudo mkdir -p /srv/frigate/media
```

Then your deployment becomes:

```bash
cd /srv/homeassistant-frigate

docker compose config

docker compose pull

docker compose up -d
```

Check:

```bash
docker compose ps
```

You should see:

```text
NAME           STATUS
homeassistant  Up
frigate        Up
```

## Access

Home Assistant:

```text
http://JETSON-IP:8123
```

Frigate:

```text
http://JETSON-IP:8971
```

For example, if your Jetson is `192.168.10.20`:

```text
http://192.168.10.20:8123
http://192.168.10.20:8971
```

Home Assistant Container uses `/config` for its persistent configuration, while Frigate uses `/config` for its configuration and `/media/frigate` for its media storage.

References:

- [Home Assistant — Installation](https://www.home-assistant.io/installation/)
- [Home Assistant — Container installation](https://www.home-assistant.io/installation/linux#install-home-assistant-container)
- [Home Assistant — Configuration](https://www.home-assistant.io/docs/configuration/)
- [Frigate — Installation](https://docs.frigate.video/frigate/installation/)
- [Frigate — Home Assistant Integration](https://docs.frigate.video/integrations/home-assistant/)
- [Frigate — Hardware Acceleration](https://docs.frigate.video/configuration/hardware_acceleration_video/)

### One architectural detail to keep in mind

I'm deliberately **not adding Mosquitto** to this Compose file because your original architecture already specifies an **external/shared MQTT broker**. Both Frigate and Home Assistant will connect to that broker.

I'm also leaving `/srv/frigate/media` local for now. Once we establish the **UnRAID NFS storage path**, I'd change that layer so the Jetson handles the Frigate compute while **UnRAID handles long-term recordings**.

This gives us a clean base where the only two containers on the Jetson initially are:

```text
Jetson
│
├── Home Assistant
│   └── :8123
│
└── Frigate
    ├── :8971
    ├── :8554
    └── :8555
```

and Frigate retains full access to the Jetson's NVIDIA/TensorRT runtime.