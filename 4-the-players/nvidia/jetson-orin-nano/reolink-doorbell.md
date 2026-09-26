# 🥇 1. Reolink Video Doorbell WiFi

After going through the **current Frigate documentation and the manufacturers' current documentation**, I would narrow the Wi-Fi choices considerably.

There is an important correction to my previous answer: **Frigate's own documentation is considerably less enthusiastic about Wi-Fi cameras than I made it sound.** Frigate explicitly says Wi-Fi cameras are not recommended because their streams are more susceptible to connection loss and dropped video, particularly as the number of Wi-Fi cameras increases.

For **one Wi-Fi doorbell**, however, I think it is perfectly reasonable — especially if the rest of your cameras are wired EmpireTech/PoE cameras.

[Frigate and Reolink Cameras Documentation](https://docs.frigate.video/configuration/camera_specific/#reolink-cameras)

---

## Why it stands out

The current Reolink Wi-Fi doorbell has:

- **5MP**
- 2560×1920
- 4:3 image
- 2.4/5 GHz Wi-Fi
- H.264
- main + substream
- RTSP
- ONVIF
- RTMP
- microphone
- speaker
- two-way audio
- person detection
- package detection
- motion detection
- visitor notification
- microSD
- 24/7 recording
- IP65

Reolink's current documentation confirms all of those network protocols and the dual-band Wi-Fi capability.

### The 5MP resolution is particularly important

Frigate specifically recommends **5MP and below for Reolink** because of the known issues with higher-resolution Reolink cameras.

So the doorbell lands almost perfectly in Frigate's preferred Reolink territory:

> **5MP → H.264 → multiple streams → RTSP/HTTP-FLV → Frigate**

---

# The really important part: Frigate's Reolink configuration

This is where Reolink gets interesting.

Frigate currently says:

> **5MP or lower → HTTP-FLV**

rather than automatically using RTSP.

That's because Frigate has found the HTTP video streams to be more reliable on many Reolink models.

The Add Camera Wizard knows this.

### Current Frigate setup

You go:

**Settings → Global Configuration → Camera Management → Add Camera**

Then:

```text
Stream detection:
    Manual selection

Brand:
    Reolink
```

The wizard queries the camera and automatically chooses:

```text
≤ 5MP → HTTP-FLV
> 5MP → RTSP / HTTP-FLV depending on generation
```

Frigate then validates the stream.

That's a **big advantage** for you because you don't have to manually construct the initial YAML.

---

# Reolink's two-stream architecture

This is where I'd configure your doorbell:

```text
                 Reolink Doorbell WiFi
                         │
               ┌─────────┴─────────┐
               │                   │
            MAIN                  SUB
             5MP                 low-res
               │                   │
               │                   │
               ▼                   ▼
           RECORD               DETECT
                                  │
                                  ▼
                          Jetson TensorRT
                                  │
                                  ▼
                               Frigate
```

Frigate itself recommends separate streams for detection and recording where possible.

For your Jetson, this is ideal.

### I'd initially try:

**Main**

```text
2560 × 1920
20 FPS
H.264
AAC
```

**Sub**

Something around:

```text
640 × 480
10 FPS
H.264
```

and let Frigate detect at around **5 FPS**.

Frigate says 5 FPS is the appropriate default for almost all cameras.

---

# Reolink has another killer feature

## Two-way talk

This is where I think the Reolink decisively separates itself from the Tapo alternatives.

Frigate specifically documents **Reolink Doorbell two-way talk**.

The architecture is slightly unusual.

Frigate wants:

### Stable HTTP-FLV

for your normal video pipeline.

But:

### RTSP

for the two-way-talk path.

Frigate's documentation explicitly says the RTSP stream can be added separately for two-way audio, and that it **must not be prefixed with `ffmpeg:`**, because go2rtc needs to handle it directly.

So your eventual configuration will look conceptually like:

```text
                    Reolink Doorbell
                           │
              ┌────────────┼────────────┐
              │            │            │
           HTTP-FLV      RTSP         ONVIF
              │            │            │
              ▼            ▼            ▼
          Frigate       go2rtc       control
          recording     two-way
          detection     audio
```

That's **exactly the sort of configuration experiment I'd want to do with your Jetson**.

---

# And Frigate Live View supports it

With go2rtc + WebRTC configured, Frigate can provide:

- live video
- audio
- two-way talk
- full-resolution viewing
- camera controls

Frigate specifically says two-way talk requires a supported camera and WebRTC, and calls out the Reolink Doorbell configuration.

So you could eventually have:

**Phone → Frigate → Jetson → Reolink Doorbell**

rather than:

**Phone → Reolink cloud → Doorbell**

That's much closer to the architecture you're building.

---

# The biggest issue with all Wi-Fi choices

This is worth emphasizing.

Frigate itself says:

> Wi-Fi cameras are not recommended because streams are less reliable and can experience connection loss/lost video data.

So I would architect your system like this:

```text
                     HOME NETWORK
                          │
              ┌───────────┴───────────┐
              │                       │
        WIRED CAMERA VLAN         Wi-Fi AP
              │                       │
       ┌──────┼──────┐                │
       │      │      │                │
    EmpireTech ... EmpireTech     Doorbell
       │      │      │                │
       └──────┴──────┘                │
              │                       │
              └──────────┬────────────┘
                         │
                    Jetson Orin
                         │
                      Frigate
```

**Only the doorbell is Wi-Fi.**

That is very different from having six or eight Wi-Fi cameras.

---

# One subtle point about "Jetson only"

I interpret your requirement as:

> **The Jetson is the only NVR/AI computer. The doorbell does not require a Reolink NVR or hub.**

If that's what you mean, then the answer gets much cleaner:

### ✅ Reolink Wi-Fi Doorbell

**Jetson only: YES**

---

# Final architecture choice

I'd actually make your doorbell the **one exception to your otherwise all-EmpireTech camera system**:

```text
                 ┌─────────────────────┐
                 │   EMPIRETECH        │
                 │   PoE CAMERAS       │
                 └──────────┬──────────┘
                            │
                         RTSP/H265
                            │
                            │
                 ┌──────────▼──────────┐
                 │                     │
                 │  JETSON ORIN NANO   │
                 │       SUPER         │
                 │                     │
                 │  Frigate            │
                 │  TensorRT           │
                 │  go2rtc             │
                 │  MQTT               │
                 └──────────▲──────────┘
                            │
                      RTSP/HTTP-FLV
                            │
                    ┌───────┴────────┐
                    │                │
               Wi-Fi AP         Home Assistant
                    │
             Reolink Doorbell
                WiFi 5MP
```

And I'd configure the **Reolink specifically as Frigate documents it**, rather than treating it like a generic RTSP camera.

That gives us the cleanest path to testing **5MP detection, HTTP-FLV, RTSP, go2rtc, WebRTC, two-way talk, H.264/AAC, TensorRT, MQTT, package detection and local-only operation** on the Jetson.

Yes. **This is a good design**, and with your FortiGate background I'd segment it fairly aggressively:

```text
                 ┌──────────────────────┐
                 │      FORTIGATE       │
                 │                      │
                 │  Inter-VLAN Firewall │
                 └──────────┬───────────┘
                            │
             ┌──────────────┴──────────────┐
             │                             │
      CAMERA-WIFI VLAN               NVR/SERVER VLAN
        10.50.50.0/24                  10.50.10.0/24
             │                             │
             │                         Jetson
             │                       10.50.10.20
             │                             │
       Reolink Doorbell                    │
       10.50.50.20 ────────────────────────┘
                   video/control
```

And **you do not need to put the Jetson on the same VLAN as the doorbell**.

In fact, I'd prefer it this way.

The important discovery from the current Reolink and Frigate documentation is that the **Reolink Video Doorbell WiFi is a standalone RTSP/ONVIF device**. Reolink's current product documentation lists RTSP, RTMP and ONVIF for the Wi-Fi doorbell, and its current firmware page shows firmware updated in June 2026.

---

# 1. The important Frigate/Reolink detail

For this particular doorbell, **don't build the firewall around RTSP alone**.

Frigate's current Reolink documentation recommends:

**5MP or lower → HTTP-FLV**

and specifically says the HTTP video stream tends to be more reliable than RTSP for Reolink. The current Frigate configuration wizard will therefore select HTTP-FLV for a 5MP Reolink camera.

For two-way talk, however, Frigate adds a **secondary RTSP connection** to go2rtc. Frigate explicitly documents this architecture for Reolink cameras. 

So your network traffic will look roughly like:

```text
                    REOLINK DOORBELL
                           │
             ┌─────────────┼─────────────┐
             │             │             │
          HTTP-FLV       RTSP         ONVIF
          :80/:1935      :554          :8000
             │             │             │
             └─────────────┼─────────────┘
                           │
                           ▼
                    JETSON / FRIGATE
```

**That's the important part for your FortiGate rules.**

---

# 2. Firewall ports I would allow

I'd start with these.

| From | To | Port | Protocol | Purpose | Required? |
|---|---|---:|---|---|---|
| Jetson | Reolink | **80** | TCP | HTTP / HTTP-FLV | **YES** |
| Jetson | Reolink | **554** | TCP | RTSP / two-way audio | **YES** for TWT |
| Jetson | Reolink | **8000** | TCP | ONVIF | **YES** for discovery/control |
| Jetson | Reolink | **1935** | TCP | RTMP/HTTP-FLV backend | **YES** for recommended FLV config |
| Jetson | Reolink | 443 | TCP | HTTPS management | Optional |
| Reolink | DNS | 53 | UDP/TCP | DNS | Optional |
| Reolink | NTP | 123 | UDP | Time sync | **Recommended** |
| Reolink | Internet | — | — | Cloud/P2P/etc. | **DENY** |

The standard Reolink defaults are **RTSP 554**, **ONVIF 8000**, **Basic Service 9000**, HTTP 80 and RTMP 1935. Reolink explicitly identifies RTSP as the third-party streaming service and ONVIF as the third-party integration service. :chatgpt-content-reference{index="3"}

### But notice something important:

I **would not initially allow TCP/9000**.

Frigate doesn't need Reolink's Basic Service port for the normal RTSP/HTTP-FLV camera pipeline.

Port 9000 is primarily Reolink Client/App media/basic-service functionality. Reolink documents 9000 as the default Basic Service port. :chatgpt-content-reference{index="4"}

If you're making this a **Frigate-only camera**, leave it blocked.

---

# 3. Direction matters

I'd make the firewall policy **stateful and directional**:

### PRIMARY RULE

```text
SOURCE:
  Jetson 10.50.10.20

DESTINATION:
  Reolink Doorbell 10.50.50.20

SERVICES:
  TCP/80
  TCP/554
  TCP/8000
  TCP/1935

ACTION:
  ACCEPT
```

Then:

```text
SOURCE:
  Reolink Doorbell

DESTINATION:
  Jetson

ACTION:
  DENY
```

The second rule isn't actually necessary for return traffic because FortiGate is stateful. Replies to connections initiated by the Jetson will be permitted by the session state.

But I would still keep the policy conceptualized as:

> **Jetson initiates all camera connections.**

That gives you a very clean security model.

---

# 4. I'd actually make the camera VLAN Internet-denied

This is where your network-engineering background is useful.

I'd build:

```text
                 CAMERA-WIFI VLAN
                     10.50.50.0/24

                         │
               ┌─────────┴─────────┐
               │                   │
        Reolink Doorbell       Future WiFi
         10.50.50.20            Cameras
               │
               │
               ▼
          FORTIGATE
               │
        ┌──────┴──────┐
        │             │
      ALLOW          DENY
        │             │
        ▼             ▼
      Jetson       Everything
```

Specifically:

### Allow

```text
Camera → DNS
Camera → NTP
Jetson → Camera
```

### Deny

```text
Camera → Internet
Camera → LAN
Camera → Management VLAN
Camera → User VLAN
Camera → IoT VLAN
Camera → Guest VLAN
```

This gives you a proper **camera containment zone**.

---

# 5. DNS

There are two ways I'd handle DNS.

### Option A — Best isolation

Give the doorbell a static IP/DHCP reservation:

```text
10.50.50.20
```

Then don't depend on DNS for Frigate.

Your Frigate configuration uses:

```text
10.50.50.20
```

directly.

You can therefore eventually block:

```text
Camera → DNS
```

if you don't need Reolink cloud functionality.

### Option B — Allow internal DNS

Allow:

```text
10.50.50.20
       │
       ▼
FortiGate DNS
10.50.x.1:53
```

This is probably what I'd initially do.

---

# 6. NTP

I'd allow:

```text
Camera VLAN
     │
     ▼
FortiGate
     │
     ▼
NTP
UDP/123
```

Or better:

```text
Camera
  │
  ▼
FortiGate NTP
```

if you have the FortiGate acting as an NTP server.

Accurate camera time is useful for:

- recordings
- event timestamps
- doorbell events
- forensic review
- correlation with other cameras
- MQTT events

---

# 7. Do NOT expose the camera to the Internet

This is particularly important.

You don't need:

```text
Internet
    │
    ▼
WAN
    │
    ▼
Reolink
```

No port forwarding.

No:

```text
WAN → TCP/554
WAN → TCP/8000
WAN → TCP/80
```

Nothing.

Reolink's documentation discusses forwarding these ports for remote IP access, but **you don't want that architecture** for your installation.

Instead:

```text
Phone
 │
 ▼
VPN
 │
 ▼
Home Network
 │
 ▼
Frigate
 │
 ▼
Camera
```

That's considerably cleaner.

---

# 8. ONVIF is useful during setup

One nuance:

You probably don't need ONVIF continuously once you've configured the camera.

But I'd leave:

```text
Jetson → Doorbell
TCP/8000
```

enabled.

Why?

Because ONVIF can provide:

- discovery
- camera information
- profiles
- stream information
- camera capabilities
- some controls

Reolink's documentation identifies **8000 as the default ONVIF port**. :chatgpt-content-reference{index="6"}

And Frigate can use ONVIF during camera integration.

---

# 9. HTTP/FLV is the unusual one

This is the port that is easy to overlook.

Frigate's recommended Reolink configuration currently looks like:

```text
http://REOLINK_IP/flv?port=1935&app=bcs&stream=channel0_main.bcs...
```

The actual HTTP connection is to the camera, while the FLV stream references Reolink's RTMP service on **1935**. Frigate documents this exact architecture. :chatgpt-content-reference{index="7"}

Therefore:

### Allow

```text
Jetson → Doorbell
TCP/80
TCP/1935
```

That gives Frigate its preferred Reolink video path.

---

# 10. Two-way talk adds TCP/554

This is the other important piece.

Frigate's current Reolink configuration adds:

```text
rtsp://username:password@reolink_ip/Preview_01_sub
```

to go2rtc specifically for two-way audio. :chatgpt-content-reference{index="8"}

Therefore:

```text
Jetson
  │
  └── TCP/554 ──► Reolink
```

is required if you want to exploit **Frigate's two-way talk**.

Frigate's live-view documentation explicitly says Reolink Doorbell should use the recommended Reolink configuration for two-way talk. :chatgpt-content-reference{index="9"}

---

# 11. What about UDP?

For your initial configuration, I'd use **TCP RTSP**.

You don't need to open broad UDP ranges simply because you're using RTSP.

That's another benefit of this design:

```text
Jetson → Camera

TCP/80
TCP/554
TCP/8000
TCP/1935
```

Start there.

Don't prematurely create:

```text
ANY → ANY UDP
```

between VLANs.

---

# 12. What about WebRTC?

This is different.

Your **camera-to-Jetson** firewall doesn't necessarily need a bunch of WebRTC ports.

The architecture is:

```text
             Camera VLAN
                  │
                  │
             TCP 80/554/
             8000/1935
                  │
                  ▼
              Frigate
                  │
             go2rtc/WebRTC
                  │
                  ▼
              Browser
```

Frigate says WebRTC requires HTTPS access to Frigate and may require opening the appropriate ports depending on your deployment.

So that's a **separate firewall problem**:

> User device → Frigate

rather than:

> Frigate → Camera.

We can handle that separately.

---

# 13. FortiGate policy structure I'd use

Assuming:

```text
CAMERA_WIFI
    10.50.50.0/24

SERVER/NVR
    10.50.10.0/24

Jetson
    10.50.10.20

Doorbell
    10.50.50.20
```

I'd create an address object:

```text
ADDR_Reolink_Doorbell
10.50.50.20/32
```

and:

```text
ADDR_Jetson_Frigate
10.50.10.20/32
```

Then a custom service group:

```text
SVC_FRIGATE_REOLINK

TCP/80
TCP/554
TCP/8000
TCP/1935
```

Then:

### Policy 1

```text
Name:
    NVR_to_Reolink_Doorbell

Incoming:
    SERVER/NVR

Source:
    ADDR_Jetson_Frigate

Outgoing:
    CAMERA_WIFI

Destination:
    ADDR_Reolink_Doorbell

Service:
    SVC_FRIGATE_REOLINK

Action:
    ACCEPT

NAT:
    OFF

Log:
    ALL SESSIONS
```

### Policy 2

```text
Name:
    Camera_VLAN_to_NTP

Source:
    CAMERA_WIFI

Destination:
    FortiGate_NTP

Service:
    NTP

Action:
    ACCEPT
```

### Policy 3

```text
Name:
    Camera_VLAN_to_DNS

Source:
    CAMERA_WIFI

Destination:
    FortiGate_DNS

Service:
    DNS

Action:
    ACCEPT
```

### Then:

```text
CAMERA_WIFI → RFC1918/LAN
DENY
```

and:

```text
CAMERA_WIFI → INTERNET
DENY
```

---

# 14. One exception: initial setup

I'd temporarily permit your management workstation:

```text
ADMIN VLAN
    │
    └──► Reolink
          TCP/80
```

so you can:

1. Configure the doorbell.
2. Upgrade firmware.
3. Enable HTTP.
4. Enable RTSP.
5. Enable ONVIF.
6. Verify the ports.
7. Set the camera parameters.
8. Test the stream.
9. Remove the admin rule.

Reolink's current documentation says the relevant RTSP/ONVIF/HTTP services can be enabled/configured under the camera's **Advanced Network Settings → Server Settings**.

---

# 15. One thing I would NOT do

Don't let Frigate discover cameras using unrestricted broadcast/multicast across VLANs.

Instead of:

```text
Frigate
   │
   ├── multicast discovery
   ├── broadcast discovery
   └── anything
```

I'd simply configure:

```text
Frigate
   │
   ▼
10.50.50.20
```

This is much cleaner across VLAN boundaries.

Once you know the doorbell's IP, there's little reason to depend on L2 discovery.

---

# 16. Recommended final architecture

For your Home Lab, I'd actually take this one step further:

```text
                         FORTIGATE
                             │
              ┌──────────────┼───────────────┐
              │              │               │
              ▼              ▼               ▼
        CAMERA-POE       CAMERA-WIFI      SERVER/NVR
        VLAN 50          VLAN 51           VLAN 10
              │              │               │
              │              │               │
       EmpireTech       Reolink Doorbell    Jetson
       10.50.50.x       10.50.51.20         10.50.10.20
              │              │               │
              └──────────────┴───────┬───────┘
                                     │
                                  Frigate
                                     │
                              TensorRT / NVDEC
                                     │
                                     ▼
                              MQTT / HA / LAN
```

I'd actually **separate Wi-Fi cameras from PoE cameras into different VLANs**, even though they ultimately serve the same Frigate host.

That gives you:

- wired-camera containment
- Wi-Fi-camera containment
- no lateral camera communication
- no camera → user LAN
- no camera → Internet
- Jetson as the only camera consumer
- very easy FortiGate logging
- easy future expansion

---

## My recommended rule set

For the **Reolink Video Doorbell WiFi specifically**, I'd start with this:

| Direction | Destination | TCP | UDP | Purpose |
|---|---|---:|---:|---|
| **Jetson → Doorbell** | Doorbell | **80** | — | HTTP-FLV |
| **Jetson → Doorbell** | Doorbell | **1935** | — | Reolink FLV/RTMP backend |
| **Jetson → Doorbell** | Doorbell | **554** | — | RTSP / two-way talk |
| **Jetson → Doorbell** | Doorbell | **8000** | — | ONVIF |
| Doorbell → FortiGate | DNS | 53 | 53 | DNS, if needed |
| Doorbell → FortiGate | NTP | — | 123 | Time |
| Doorbell → Internet | ANY | ❌ | ❌ | **Block** |
| Doorbell → LAN | ANY | ❌ | ❌ | **Block** |
| Other VLANs → Doorbell | ANY | ❌ | ❌ | **Block** |

**No port forwarding from WAN.**

And I would **not allow TCP/9000 unless we discover that a specific feature of your doorbell actually needs it**. Reolink documents 9000 as the Basic Service port, but Frigate's current recommended Reolink pipeline does not require it. 

One other important detail: the current Reolink page for the **Video Doorbell WiFi** confirms it has both 2.4/5 GHz Wi-Fi and a physical LAN port, and supports 24/7 recording, RTSP, RTMP and ONVIF. 

