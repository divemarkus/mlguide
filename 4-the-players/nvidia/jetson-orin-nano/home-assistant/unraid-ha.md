# unRAID and Home Assistant (HA)

Yes — and this changes the architecture discussion in an important way.

For your environment, I would **seriously consider putting Home Assistant on the unRAID server and keeping Frigate on the Jetson**.

The reason is that the two workloads have very different requirements:

- **Frigate** benefits directly from the Jetson's NVIDIA GPU/TensorRT acceleration.
- **Home Assistant** benefits much less from GPU acceleration and is a relatively light CPU/RAM workload.
- **unRAID** is already your persistent-storage/data platform.
- HA can then survive a Jetson/Frigate restart independently.

The resulting architecture is cleaner than putting everything on the Jetson.

---

# 1. What is Home Assistant on unRAID?

Home Assistant can be run on unRAID as a **Docker container**.

unRAID's Apps interface is essentially an application/container management mechanism; when you install a Docker-based application from Community Applications, you're generally deploying a Docker container rather than installing a special "unRAID version" of the application.

There are also other HA installation approaches, including running Home Assistant OS in a VM, but for **your particular infrastructure**, I would favor the **Home Assistant Container** approach.

Home Assistant documents the Container installation separately from Home Assistant OS:

- [Home Assistant Installation](https://www.home-assistant.io/installation/)
- [Home Assistant Container](https://www.home-assistant.io/installation/linux#install-home-assistant-container)
- [Home Assistant Container documentation](https://www.home-assistant.io/integrations/homeassistant/)

---

# 2. Your unRAID server is actually a very good HA host

Your hardware:

```text
unRAID
│
├── ASRock H170M
├── Intel Xeon E5-1650 v3 @ 3.50 GHz
├── 32 GB ECC RAM
├── Large storage pool
├── unRAID Basic
│
├── Docker
│   ├── Pi-hole
│   └── Jellyfin
│
└── VM
    └── Ubuntu / Wazuh
```

For Home Assistant, this is **massively more than enough**.

HA itself is not particularly CPU-intensive.

Even with:

- hundreds of entities
- MQTT
- automations
- dashboards
- history
- integrations
- notifications
- Frigate events
- network monitoring
- energy monitoring
- backups

your Xeon has plenty of headroom.

---

# 3. I would separate HA and Frigate

This is the architecture I'd now recommend:

```text
                         FORTIGATE
                            │
              ┌─────────────┴─────────────┐
              │                           │
          SERVER VLAN                 CAMERA VLAN
              │                           │
       ┌──────┴───────┐             ┌─────┴─────┐
       │              │             │           │
    unRAID          Jetson       EmpireTech   Reolink
       │              │
       │              │
       ▼              ▼
  Home Assistant    Frigate
     Docker        Docker
       │              │
       │          TensorRT
       │          NVIDIA GPU
       │              │
       └──────┬───────┘
              │
             MQTT
              │
       ┌──────┴──────┐
       │             │
      HA          Frigate
```

That is a **better separation of responsibilities**.

---

# 4. Why Frigate belongs on the Jetson

This part I would keep exactly where we originally planned it.

Your Jetson Orin Nano Super is special because of:

```text
Jetson
 │
 ├── NVIDIA GPU
 │
 ├── JetPack 6
 │
 ├── TensorRT
 │
 └── hardware video decode
```

Frigate can use the Jetson-specific TensorRT image:

```text
ghcr.io/blakeblackshear/frigate:stable-tensorrt-jp6
```

and NVIDIA runtime:

```yaml
runtime: nvidia
```

That gives Frigate access to the Jetson acceleration stack.

See:

- [Frigate Installation](https://docs.frigate.video/frigate/installation/)
- [Frigate Hardware Acceleration](https://docs.frigate.video/configuration/hardware_acceleration_video/)

Moving Frigate to your Xeon would mean giving up the primary reason we selected the Jetson in the first place.

So:

> **Frigate → Jetson**

is still the right answer.

---

# 5. Home Assistant is different

HA doesn't need:

```text
TensorRT
CUDA
NVIDIA runtime
GPU inference
```

It needs:

```text
CPU
RAM
storage
network access
MQTT
device discovery
```

Your Xeon is therefore an excellent HA platform.

And there's another advantage.

## Persistence

HA generates a lot of:

- history
- recorder data
- logs
- database data
- backups
- configuration
- integrations
- automation state

Your unRAID server is already designed around persistent storage.

---

# 6. This creates a much cleaner architecture

I'd now make the two machines:

## Jetson = Edge AI / NVR

```text
JETSON ORIN NANO SUPER
│
├── Ubuntu / JetPack 6
│
└── Docker
    │
    └── Frigate
        ├── TensorRT
        ├── NVIDIA GPU
        ├── RTSP
        ├── go2rtc
        ├── object detection
        └── camera events
```

## unRAID = Home Automation / Data Platform

```text
UNRAID
│
├── Docker
│   │
│   ├── Home Assistant
│   ├── Pi-hole
│   └── Jellyfin
│
├── VM
│   └── Wazuh / Ubuntu
│
└── Storage
    ├── HA backups
    ├── Frigate recordings
    ├── camera snapshots
    ├── alerts
    ├── documents
    └── other data
```

That's a much more logical division.

---

# 7. And MQTT becomes the bridge

This is where the architecture gets nice.

You could eventually have:

```text
                 MQTT
                  │
       ┌──────────┴──────────┐
       │                     │
    unRAID                 Jetson
       │                     │
       ▼                     ▼
Home Assistant            Frigate
       │                     │
       │                  cameras
       │
       └────── automations
```

For example:

```text
EmpireTech
    │
    ▼
Frigate
    │
    │ "person detected"
    ▼
MQTT
    │
    ▼
Home Assistant
    │
    ├── Send alert
    ├── Save snapshot
    ├── Trigger light
    ├── Trigger alarm
    └── Record event
```

This is exactly the sort of event-driven architecture HA is good at.

---

# 8. There's an even bigger advantage: failure isolation

Consider what happens if the Jetson needs to be rebooted.

### Current architecture

```text
Jetson
│
├── Frigate
└── HA
```

Reboot Jetson:

```text
Frigate ❌
HA ❌
```

But with:

```text
Jetson
└── Frigate

unRAID
└── Home Assistant
```

a Jetson reboot gives you:

```text
Frigate ❌

Home Assistant ✅
MQTT       ✅
Pi-hole    ✅
Jellyfin   ✅
Wazuh      ✅
```

That's a much better infrastructure design.

---

# 9. Your unRAID server can become the "data dump"

You mentioned:

> "Eventually unRAID will keep backup alerts, video streams, etc, as far as data dump."

**Exactly.**

I would actually formalize that role.

Think:

```text
                 DATA FLOW
                     │
      ┌──────────────┼──────────────┐
      │              │              │
      ▼              ▼              ▼
    Frigate          HA           Other
      │              │
      │              │
      └───────┬──────┘
              │
              ▼
            unRAID
              │
      ┌───────┼────────┐
      │       │        │
      ▼       ▼        ▼
   Video    Events   Backups
```

So unRAID becomes your **persistent data layer**, while Jetson is the **compute/AI edge**.

---

# 10. I'd eventually organize unRAID like this

Something along these lines:

```text
/mnt/user/
│
├── appdata/
│   ├── homeassistant/
│   ├── pihole/
│   └── jellyfin/
│
├── frigate/
│   ├── recordings/
│   ├── clips/
│   ├── snapshots/
│   └── exports/
│
├── homeassistant/
│   ├── backups/
│   ├── database/
│   └── exports/
│
├── security/
│   ├── alerts/
│   └── events/
│
└── backups/
    ├── jetson/
    ├── homeassistant/
    └── frigate/
```

The exact structure can be optimized later for your cache/pool/array configuration.

---

# 11. One thing I would NOT do

I wouldn't put **Frigate recordings directly on the unRAID array initially** without considering your cache/pool architecture.

You have a couple of choices.

### Option A — Jetson local recording cache

```text
Camera
  ↓
Frigate
  ↓
Jetson NVMe
  ↓
UnRAID
```

Advantages:

- Fast writes
- Low network dependency
- Frigate remains operational if unRAID temporarily disappears
- Less SMB/NFS complexity

### Option B — Frigate directly to unRAID

```text
Camera
  ↓
Frigate
  ↓
NFS
  ↓
unRAID
```

Advantages:

- Recordings immediately reside on large storage
- Simple centralized storage

Disadvantages:

- Network/storage dependency
- More sensitive to NFS problems
- More network traffic
- Potentially more write activity across the network

For your lab, **I'd probably implement a hybrid**.

---

# 12. Hybrid recording architecture

Something like:

```text
                    CAMERA
                       │
                       ▼
                    Frigate
                       │
              ┌────────┴────────┐
              │                 │
              ▼                 ▼
         Jetson NVMe        unRAID/NFS
         short-term          long-term
           cache               storage
              │
              └──────────────►
```

For example:

```text
Jetson
  └── 1–2 days high-performance cache

unRAID
  └── 14–30+ days retention
```

The exact retention depends on:

- camera count
- resolution
- FPS
- bitrate
- continuous vs motion recording
- H.264/H.265
- retention policy

We can calculate that later from your actual EmpireTech/Reolink cameras.

---

# 13. Home Assistant backups become much easier

HA has its own backup system.

You could have:

```text
Home Assistant
      │
      ▼
Backup
      │
      ▼
unRAID
      │
      ├── daily
      ├── weekly
      └── monthly
```

And potentially replicate those somewhere else later.

For example:

```text
HA
 │
 ▼
unRAID
 │
 ├── local backup
 │
 └── secondary backup
```

This is one of the reasons I prefer HA on unRAID for your setup.

---

# 14. But there's one important HA networking issue

This is the biggest consideration.

If HA is running in a Docker container on unRAID, I would use:

```yaml
network_mode: host
```

rather than putting HA on the normal Docker bridge.

That allows Home Assistant to properly participate in:

- mDNS
- Zeroconf
- SSDP
- UPnP
- device discovery
- LAN integrations

This becomes particularly important because your home automation network will likely contain devices across several VLANs.

Your FortiGate then controls what HA is allowed to reach.

---

# 15. Your FortiGate becomes extremely important

I'd envision:

```text
                 FORTIGATE
                     │
        ┌────────────┼────────────┐
        │            │            │
     HOME VLAN   SERVER VLAN   CAMERA VLAN
        │            │            │
     phones       unRAID        cameras
     clients      Jetson
                     │
               Home Assistant
```

And firewall rules such as:

```text
HOME VLAN
   │
   └──→ HA                 ALLOW

SERVER VLAN
   │
   ├──→ MQTT               ALLOW
   ├──→ HA                 ALLOW
   └──→ cameras            controlled

CAMERA VLAN
   │
   └──→ Frigate            ALLOW
```

Critically:

```text
CAMERA VLAN
      │
      X
      │
   HA/unRAID
```

should generally remain blocked for unsolicited camera-initiated connections.

---

# 16. What I'd do with your existing containers

You currently have:

```text
unRAID
│
├── Pi-hole
├── Jellyfin
└── Wazuh VM
```

I'd add:

```text
unRAID
│
├── Pi-hole
├── Jellyfin
├── Home Assistant       ← NEW
│
└── VM
    └── Wazuh
```

And leave:

```text
Jetson
└── Frigate
```

This is clean.

---

# 17. What about Home Assistant OS as a VM?

This is the alternative worth mentioning.

You could run:

```text
unRAID
│
└── VM
    └── Home Assistant OS
```

instead of:

```text
unRAID
│
└── Docker
    └── Home Assistant Container
```

HA OS in a VM gives you:

- HA Supervisor
- HA Apps
- HA backups
- HA OS management
- easier HA-specific administration

But for **your particular environment**, I prefer the Docker container.

Why?

Because you already have:

```text
unRAID
Docker
VMs
Linux
networking
infrastructure experience
```

and you are deliberately building a larger infrastructure stack.

I don't see much value in introducing another VM unless you specifically want the HA OS/Supervisor ecosystem.

---

# 18. The architecture I'd lock in

At this point I'd change our original design from:

```text
JETSON
├── Home Assistant
└── Frigate
```

to:

```text
                         FORTIGATE
                             │
             ┌───────────────┼────────────────┐
             │               │                │
         HOME VLAN       SERVER VLAN      CAMERA VLAN
             │               │                │
             │         ┌─────┴──────┐     ┌───┴────┐
             │         │            │     │        │
             │      unRAID        Jetson  EmpireTech Reolink
             │         │            │
             │         │            │
             │         ▼            ▼
             │     Home Assistant  Frigate
             │       Docker       TensorRT
             │         │            │
             │         └─────┬──────┘
             │               │
             │              MQTT
             │
             └───────────────┘

                         │
                         ▼

                       unRAID
                    DATA PLATFORM
                         │
          ┌──────────────┼──────────────┐
          │              │              │
       HA backups     Frigate        Alerts/events
                      recordings
```

---

# 19. My recommendation for each workload

| Workload | Host | Reason |
|---|---|---|
| **Frigate** | **Jetson** | TensorRT/NVIDIA acceleration |
| **Home Assistant** | **unRAID Docker** | Persistent, powerful, independent of Jetson |
| **MQTT** | **Existing/shared broker** | Central event bus |
| **Pi-hole** | unRAID | Already working |
| **Jellyfin** | unRAID | Existing media workload |
| **Wazuh** | unRAID VM | Existing architecture |
| **Frigate recordings** | unRAID | Large persistent storage |
| **HA backups** | unRAID | Centralized persistent storage |
| **HA database/history** | unRAID | Persistent storage |
| **AI inference** | Jetson | NVIDIA/TensorRT |
| **Firewall/VLANs** | FortiGate | Network/security boundary |

---

# Bottom line

**I would change our previous plan.**

Now that I know the actual unRAID hardware and its intended role, I think the better architecture is:

```text
┌───────────────────────┐       ┌────────────────────────┐
│   JETSON ORIN NANO    │       │        unRAID          │
│       SUPER 8GB       │       │ Xeon E5-1650v3 / 32GB  │
│                       │       │                        │
│ Ubuntu + JetPack 6    │       │ Docker                 │
│        │              │       │   │                    │
│        ▼              │       │   └── Home Assistant   │
│     Frigate           │◄──────┤                        │
│     TensorRT          │ MQTT  │ Storage                │
│     NVIDIA GPU        │       │   ├── HA backups       │
│     go2rtc            │       │   ├── Frigate video    │
│        │              │       │   ├── alerts           │
└────────┼──────────────┘       │   └── other data       │
         │                      │                        │
         │ Camera VLAN          │ Pi-hole                │
         ▼                      │ Jellyfin               │
 EmpireTech / Reolink           │ Wazuh VM               │
                                └────────────────────────┘
```

**Frigate stays on the Jetson because that's where its AI acceleration belongs. Home Assistant moves to unRAID because that's where your persistent services and data belong.**

And importantly, **HA and Frigate don't need to be on the same physical host**. The Frigate integration communicates over the network, while MQTT provides the event bus. That's actually a cleaner distributed architecture.

The next step I'd take is therefore to **remove Home Assistant from the Jetson Compose file we just created**, leave the Jetson as a dedicated Frigate/NVIDIA appliance, and create a **separate unRAID Home Assistant Docker configuration** that mounts its persistent `/config` into your unRAID storage. Then we can design the **Jetson → Frigate → MQTT → HA → unRAID storage** pipeline around your actual VLANs.