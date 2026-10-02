# Home Assistant (HA)

**Home Assistant (HA) fits extremely well into your home lab**, but for *your* hardware and architecture I would **not** put Frigate inside Home Assistant OS.

For your **Jetson Orin Nano Super 8GB + EmpireTech/Reolink cameras + FortiGate VLAN architecture**, I recommend:

> **Ubuntu/JetPack 6 → Docker Compose → Home Assistant Container + Frigate Container + MQTT + supporting services**

rather than:

> Home Assistant OS → Frigate App/Add-on.

The key reason is the **Jetson NVIDIA GPU/TensorRT path**. Frigate's current documentation specifically says NVIDIA GPUs aren't supported by HA Apps because HA Apps don't support the NVIDIA runtime, while Frigate has a dedicated Jetson image for JetPack 6+ with hardware decoding and TensorRT detection. [Frigate installation documentation](https://docs.frigate.video/frigate/installation/)

---

# 1. What Home Assistant actually is


Think of Home Assistant as the **orchestration/control plane for your house**.

It isn't merely a smart-home GUI.

At the center is an event/state engine:

```text
                    HOME ASSISTANT
                         │
       ┌─────────────────┼─────────────────┐
       │                 │                 │
   AUTOMATION         DASHBOARD         EVENTS
       │                 │                 │
       ├──────────┬──────┴──────┬──────────┤
       │          │             │
     LIGHTS     SECURITY       CLIMATE
       │          │             │
     LOCKS      CAMERAS       HVAC
       │          │             │
     SENSORS    FRIGATE       POWER
```

It can combine things that normally live in completely separate ecosystems.

For example:

```text
EmpireTech camera
       │
       ▼
     Frigate
       │
       │ "person detected"
       ▼
 Home Assistant
       │
       ├── Turn on exterior lights
       ├── Send phone notification
       ├── Display camera
       ├── Record event
       ├── Lock/unlock something
       └── Trigger another automation
```

That's where HA becomes particularly interesting for your lab.

---

# 2. Where HA fits into *your* home lab

I'd think about your architecture in layers.

## Layer 1 — Network/security

```text
                     INTERNET
                         │
                     FortiGate
                         │
             ┌───────────┴───────────┐
             │                       │
        HOME VLAN               IoT/CAMERA VLAN
             │                       │
       PCs / phones          EmpireTech / Reolink
             │                       │
             └──────────┬────────────┘
                        │
                   Jetson Orin
```

Your FortiGate remains the **security boundary**.

HA should *not* replace your firewall, routing, segmentation, or security controls.

---

# 3. HA becomes your automation control plane

Your Jetson could become something like:

```text
                 JETSON ORIN NANO SUPER
                        8 GB
                         │
                  Ubuntu / JetPack 6
                         │
                    Docker Engine
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
   Home Assistant     Frigate           MQTT
        │                │                │
        │                │                │
        └────────────┬───┴────────────────┘
                     │
                     ▼
                 HOME / IoT
```

Then HA can eventually integrate:

- Frigate
- MQTT
- ESPHome
- Zigbee
- Z-Wave
- Matter
- Wi-Fi devices
- thermostats
- lighting
- locks
- power monitoring
- solar
- batteries
- UPS
- network equipment
- presence detection
- phones
- media systems
- dashboards
- alarms
- cameras

And because HA exposes a huge event/state model, you can build surprisingly sophisticated logic.

---

# 4. The important distinction: Frigate App vs Frigate Integration

This causes **a lot of confusion**.

There are actually two different things:

## Frigate

The actual NVR:

```text
Cameras
   ↓
Frigate
   ├── RTSP
   ├── recording
   ├── detection
   ├── object tracking
   ├── snapshots
   └── events
```

## Frigate Integration

The Home Assistant integration:

```text
Frigate
   │
   │ API/MQTT
   ▼
Home Assistant
```

The integration exposes things such as:

- camera entities
- detection sensors
- object events
- motion
- recordings
- snapshots
- PTZ controls
- detection states

The official Frigate documentation distinguishes the Frigate application from the HA integration. The integration is needed regardless of whether Frigate runs as a standalone Docker container or an HA App.

[Frigate Home Assistant Integration documentation](https://docs.frigate.video/integrations/home-assistant/)

---

# 5. Option A — Frigate as an HA App

This would look like:

```text
             Jetson
               │
          Home Assistant OS
               │
       ┌───────┴────────┐
       │                │
 Home Assistant     Frigate App
       │                │
       └───────┬────────┘
               │
             MQTT
```

This is attractive because it is extremely easy to administer.

HA OS gives you:

- OS management
- HA
- Apps
- backups
- updates
- UI management
- Supervisor

HA itself recommends HA OS as the installation method for most users.

[Home Assistant installation methods](https://www.home-assistant.io/installation/)

**But there's a major problem for your Jetson.**

---

# 6. The NVIDIA problem

This is the critical part.

Frigate's current installation documentation states:

> NVIDIA GPUs are not supported because HA Apps do not support the NVIDIA runtime.

Your Jetson is precisely the sort of system where we **want** NVIDIA acceleration.

Frigate provides a dedicated Jetson image:

```text
ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6
```

and instructs JetPack 6+ users to use the NVIDIA runtime.

[Frigate installation documentation](https://docs.frigate.video/frigate/installation/)

[Frigate hardware acceleration documentation](https://docs.frigate.video/configuration/hardware_acceleration_video/)

So:

## HA OS + Frigate App

```text
Jetson GPU
    │
    X
NVIDIA runtime unavailable
```

versus:

## Ubuntu + Docker + Frigate

```text
Jetson GPU
    │
    ▼
NVIDIA Container Runtime
    │
    ▼
Frigate
    │
    ├── NV hardware decode
    └── TensorRT
```

That's a **major architectural difference**.

---

# 7. Option B — HA Container + Frigate Docker

This is what I recommend for you.

```text
                    JETSON
              Ubuntu + JetPack 6
                       │
                  Docker Engine
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
 Home Assistant      Frigate        MQTT
   Container         Container      Container
        │              │              │
        │              │              │
        └───────┬──────┴──────────────┘
                │
             Network
                │
       ┌────────┴────────┐
       ▼                 ▼
   Home VLAN         Camera VLAN
                         │
                 EmpireTech/Reolink
```

This gives you much better control over the system.

---

# 8. Why I particularly like this for your lab

You're not building a consumer smart-home appliance.

You're building a **home-lab infrastructure platform**.

That changes the answer.

You already have experience with:

- Docker
- Ubuntu
- networking
- VLANs
- FortiGate
- Linux
- monitoring
- infrastructure
- containers
- security

So HA OS's simplicity isn't as valuable to you as it would be to the average HA user.

You will probably appreciate having:

```text
docker compose
docker logs
docker stats
docker inspect
journalctl
nvidia-smi
nvtop
systemctl
tcpdump
iptables/nftables
```

available underneath everything.

---

# 9. And it gives us much better failure isolation

Imagine Frigate crashes.

With separate containers:

```text
Home Assistant       RUNNING
      │
      │
      ├───────────────┐
      │               │
      ▼               ▼
    MQTT           Frigate
   RUNNING          CRASHED
```

Your automation system continues operating.

Conversely:

```text
Frigate
  │
  X
```

doesn't take HA down.

That's desirable.

---

# 10. It also makes upgrades much cleaner

You could independently upgrade:

```text
Home Assistant
       │
       ▼
ghcr.io/home-assistant/home-assistant

Frigate
       │
       ▼
ghcr.io/blakeblackshear/frigate

MQTT
       │
       ▼
Mosquitto
```

You can pin versions, test updates, roll back containers, and maintain backups independently.

HA Container does require you to manage the Linux host and updates yourself, but that is exactly the model HA describes as intended for users who already run Docker.

[Home Assistant installation documentation](https://www.home-assistant.io/installation/)

---

# 11. Jetson-specific Frigate architecture

This is where your Jetson gets interesting.

Your Jetson Orin Nano Super can perform:

```text
                 IP CAMERA
                     │
                   RTSP
                     │
                     ▼
                  Frigate
                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
     Hardware Decode        TensorRT
       Jetson GPU          Detection
          │                     │
          └──────────┬──────────┘
                     ▼
                 AI Events
```

Frigate's documentation says the Jetson image supports the Jetson media engine and TensorRT, with `stable-tensorrt-jp6` for JetPack 6+.

[Frigate hardware acceleration documentation](https://docs.frigate.video/configuration/hardware_acceleration_video/)

There is one important Jetson Orin Nano detail:

**The Orin Nano doesn't have a hardware video encoder.**

Frigate therefore uses software encoding on this platform, while still benefiting from hardware decoding and TensorRT object detection.

That's something we'll account for in your configuration.

---

# 12. MQTT becomes important

I'd also make MQTT a first-class service.

```text
                  MQTT
                   │
          ┌────────┴────────┐
          │                 │
       Frigate              HA
          │                 │
     camera events      automations
```

Frigate's HA integration requires MQTT to be configured and connected to the same MQTT broker as HA for many of the integration entities to work.

[Frigate Home Assistant Integration documentation](https://docs.frigate.video/integrations/home-assistant/)

So I would have:

```text
mosquitto
```

as another Docker service.

---

# 13. Your camera VLAN

This is where your existing FortiGate architecture becomes very useful.

I'd structure it approximately like:

```text
                    FORTIGATE
                       │
             ┌─────────┴──────────┐
             │                    │
          VLAN 10               VLAN 50
         HOME/LAN              CAMERAS
             │                    │
       ┌─────┴─────┐        ┌─────┴──────┐
       │           │        │            │
      HA         Clients   EmpireTech   Reolink
       │
       │
       └───────────────┐
                       │
                     Frigate
                       │
                  Jetson Docker
```

And then **do not give the cameras unrestricted Internet access**.

For example:

```text
CAMERA VLAN
    │
    ├──→ Frigate       ALLOW
    ├──→ NTP           ALLOW
    ├──→ DNS           controlled
    │
    └──→ Internet      DENY
```

Depending on the exact camera models and firmware, we'll refine the rules.

This is especially attractive for EmpireTech/Reolink because Frigate can consume the cameras' local RTSP streams without requiring a cloud video path.

---

# 14. HA + Frigate can become your security automation engine

Here's where I'd eventually take your system.

## Example 1 — Person detection

```text
EmpireTech
    ↓
Frigate
    ↓
person detected
    ↓
MQTT
    ↓
HA
    ↓
Is it after 11 PM?
    ↓
YES
    ↓
Turn exterior lights on
    ↓
Push notification
    ↓
Display camera
```

## Example 2 — Familiar person

Eventually:

```text
Camera
  ↓
Frigate
  ↓
person
  ↓
AI / face recognition layer
  ↓
known person
  ↓
HA
```

Then HA can make decisions based on identity/context.

---

# 15. And this opens up your local AI stack

This is where I think your lab becomes particularly interesting.

You already have a local-AI environment.

Eventually:

```text
                    HOME ASSISTANT
                          │
             ┌────────────┼─────────────┐
             │            │             │
          Frigate        MQTT        Sensors
             │
             ▼
       Camera events
             │
             ▼
       Local AI layer
             │
       ┌─────┴─────┐
       ▼           ▼
   Qwen/etc.    Vision model
       │           │
       └─────┬─────┘
             ▼
       HA automation
```

For example:

> "There is a person in the driveway at 2:17 AM."

could become:

> "Unknown person detected in driveway at 2:17 AM. Front exterior lighting activated. Snapshot attached."

without sending the video to a cloud AI service.

That fits your **local-first/privacy-first** philosophy extremely well.

---

# 16. One thing I would NOT do

I wouldn't turn HA into your entire home-lab operating system.

In other words, avoid:

```text
HA OS
 ├── HA
 ├── Frigate
 ├── databases
 ├── AI
 ├── monitoring
 ├── random services
 ├── Docker
 └── everything else
```

That's exactly where the abstraction starts fighting you.

Instead:

```text
Ubuntu / JetPack
       │
     Docker
       │
       ├── Home Assistant
       ├── Frigate
       ├── Mosquitto
       └── future services
```

Much cleaner.

---

# 17. What I would put on the Jetson

For **this particular Jetson**, I'd initially keep it lean:

```text
JETSON ORIN NANO SUPER 8GB
│
├── Ubuntu + JetPack 6
│
├── Docker
│
├── Docker Compose
│
├── Home Assistant
│
├── Frigate
│    ├── TensorRT
│    ├── NVIDIA runtime
│    ├── RTSP
│    ├── recordings
│    └── detection
│
├── Mosquitto
│
└── optional later
     ├── go2rtc / auxiliary services
     ├── Node-RED
     ├── local AI service
     └── monitoring exporter
```

I would **not** immediately install 15 different HA add-ons.

Keep the Jetson as a focused appliance.

---

# 18. Storage is another architectural issue

This is important.

Don't make the Jetson's internal storage the permanent repository for multiple cameras' recordings if we can avoid it.

I'd prefer:

```text
Cameras
    │
    ▼
 Frigate
    │
    ▼
 NAS / UnRAID storage
    │
    ├── recordings
    ├── clips
    └── snapshots
```

while keeping:

```text
Jetson local SSD
    │
    ├── HA configuration
    ├── Frigate configuration
    ├── database
    └── temporary cache
```

Your existing UnRAID server is particularly useful here.

Frigate supports separating its configuration and media storage, which is useful for this architecture.

[Frigate installation documentation](https://docs.frigate.video/frigate/installation/)

---

# 19. My recommended architecture

For **your lab**, I'd ultimately build this:

```text
                         INTERNET
                            │
                       ┌────▼────┐
                       │FortiGate│
                       └────┬────┘
                            │
                 ┌──────────┴──────────┐
                 │                     │
             HOME VLAN             CAMERA VLAN
                 │                     │
                 │              ┌──────┴───────┐
                 │              │              │
                 │          EmpireTech       Reolink
                 │
                 │
          ┌──────▼───────────────────────────┐
          │      JETSON ORIN NANO SUPER      │
          │             8 GB                 │
          │                                  │
          │       Ubuntu / JetPack 6         │
          │              │                   │
          │            Docker                │
          │              │                   │
          │    ┌─────────┼─────────┐         │
          │    │         │         │         │
          │    ▼         ▼         ▼         │
          │   HA      Frigate   Mosquitto    │
          │    │         │         │         │
          │    │      TensorRT    │          │
          │    │      NVDEC       │          │
          │    └───────┬─┴────────┘         │
          │            │                    │
          └────────────┼────────────────────┘
                       │
                       ▼
                    UnRAID
                       │
              Camera recordings
```

## My recommendation

| Component | Where I'd run it |
|---|---|
| Ubuntu | **Jetson** |
| JetPack 6 | **Jetson** |
| Docker | **Jetson** |
| Home Assistant | **Docker** |
| Frigate | **Docker** |
| Frigate AI | **Jetson TensorRT** |
| MQTT | **Docker** |
| Camera streams | **Camera VLAN → Frigate** |
| HA ↔ Frigate | **Frigate Integration + MQTT** |
| Recordings | **UnRAID/NAS** |
| Firewall/segmentation | **FortiGate** |
| Future local AI | **Separate container/service** |

So, **between your two choices, I would choose full Docker Compose by a fairly wide margin for this specific Jetson build.**

The interesting part is that this isn't because HA OS is bad. **HA OS is actually the recommended HA deployment for most people.** It's because your system has a very specific requirement—**Jetson NVIDIA/TensorRT acceleration for Frigate**—that makes the generic HA OS/App model a poor fit.

### One more architectural recommendation

I would also **not put HA and Frigate into separate Docker Compose projects initially**. Put them into **one controlled Compose stack**, but keep them as separate containers and persistent volumes. That gives us easy inter-container networking while retaining process/service isolation.

And we can build it around the exact **EmpireTech + Reolink + FortiGate VLAN + UnRAID** architecture we've already been working toward.

The next logical step is to build the actual **Jetson Docker Compose stack** with:

```text
homeassistant
frigate
mosquitto
```

plus the NVIDIA runtime, JetPack 6 Frigate image, persistent storage, NAS recording mount, VLAN-aware networking, healthchecks, restart policies, and a clean directory layout.

That would give you a production-grade foundation rather than a generic HA tutorial.