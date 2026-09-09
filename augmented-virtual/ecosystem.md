# Ecosystem

Yes. These terms get thrown around together, but they are **different layers of the XR software stack**. This matters a lot for the glasses we've been discussing, especially if you're thinking about **PC gaming, SteamVR, VertoXR, your RTX 3090 Ti, and eventually local AI/XR**.

The simplest mental model is:

```text
                    YOUR GAME / APP
                         │
              ┌──────────┴──────────┐
              │                     │
           OpenXR                 OpenVR
        modern standard          older Valve API
              │                     │
              └──────────┬──────────┘
                         │
                   XR RUNTIME
                         │
              ┌──────────┴──────────┐
              │                     │
           SteamVR              Other runtimes
              │
          Driver/API
              │
          XR GLASSES
```

But there's an important wrinkle: **VertoXR sits more to the side as an application/bridge**, rather than being a replacement for OpenXR or SteamVR.

---

# 1. SteamVR

Valve's **SteamVR** is the software platform/runtime that makes PC VR work.

[SteamVR official page](https://store.steampowered.com/steamvr/)

Think of it as:

> **"The VR operating environment for your Windows gaming PC."**

It handles things such as:

* headset/display communication
* head tracking
* controllers
* tracking hardware
* rendering/compositing
* VR games
* Steam integration
* VR input
* device drivers

Valve describes SteamVR as the runtime containing the OpenVR runtime and supporting hardware from multiple vendors. ([Steamworks][1])

### For your setup

Your:

**RTX 3090 Ti**

↓

**SteamVR**

↓

**Bigscreen Beyond 2e**

↓

**SteamVR game**

is a normal PCVR architecture.

For example:

**Assetto Corsa → SteamVR → Beyond 2e**

or

**Half-Life: Alyx → SteamVR → Beyond 2e**

---

# 2. OpenVR

**OpenVR is an API**, originally developed by Valve.

This is where the terminology gets confusing.

SteamVR is the **runtime/platform**.

OpenVR is the **programming interface** that applications and hardware drivers can use to communicate with SteamVR.

Valve's documentation explicitly describes OpenVR as an API/runtime interface for accessing VR hardware from multiple vendors. ([Steamworks][1])

Think:

```text
Game
 │
 │ OpenVR API
 ↓
SteamVR
 │
 ↓
VR hardware
```

### Important:

**OpenVR is older.**

The XR industry has largely moved toward **OpenXR** as the cross-platform standard.

So you will still encounter OpenVR because:

* older VR games use it
* SteamVR supports it
* drivers use it
* compatibility layers use it

But for new XR development, **OpenXR is the important standard to understand.**

---

# 3. OpenXR

This is the big one.

**OpenXR is an open industry standard/API from Khronos.**

[Khronos OpenXR specification](https://registry.khronos.org/OpenXR/)

Khronos describes OpenXR as the API between an XR application and an **XR runtime**. It provides standardized access to things such as tracking, input, rendering and frame submission. ([Khronos Registry][2])

Think:

> **USB-C is a standardized connector. OpenXR is somewhat analogous to a standardized software interface for XR.**

Instead of developers writing:

```text
MyGame → Meta Quest code
MyGame → SteamVR code
MyGame → Vive code
MyGame → Windows MR code
...
```

they can target:

```text
MyGame
   ↓
OpenXR
   ↓
XR Runtime
   ↓
Headset
```

That's enormously important for the future.

### OpenXR 1.1

Khronos currently publishes the **OpenXR 1.1 specification**, with the registry updated as recently as September 2026. ([Khronos Registry][3])

---

# 4. OpenXR Runtime

This is another term you'll encounter constantly.

An **OpenXR runtime** is the actual software implementation of the OpenXR API.

Khronos defines it explicitly as software implementing the OpenXR API. Multiple runtimes can be installed, but only one can be active at a time. ([Khronos Registry][2])

Examples include runtimes associated with:

* SteamVR
* Meta
* Windows/PC XR platforms
* Virtual Desktop
* other headset vendors

So:

```text
              OPENXR APP
                   │
                   ↓
             OpenXR API
                   │
                   ↓
            OpenXR RUNTIME
                   │
                   ↓
               HEADSET
```

This is why you'll sometimes see:

> "Which OpenXR runtime are you using?"

It means:

> "Which software is currently providing the OpenXR interface to your headset?"

---

# 5. VertoXR

**VertoXR is completely different.**

It's a relatively new third-party application designed specifically to turn lightweight AR/XR glasses into a more capable **spatial desktop + gaming platform**.

[VertoXR official site](https://vertoxr.com/)

It's open-source and built in **Rust**. Its documentation describes:

* multiple virtual desktops
* window positioning
* workspace layouts
* gesture controls
* SteamVR
* WebXR
* OpenTrack
* cross-platform support

([VertoXR][4])

This is particularly relevant to the five glasses we've been discussing.

---

# VertoXR is VERY interesting for you

VertoXR currently lists support for:

### VITURE

* One
* One Lite
* Pro XR
* Pro 2
* Luma
* Luma Pro
* Luma Cyber
* Luma Ultra
* Beast

### XREAL

* One
* One S
* One Pro
* R1
* xbx A01
* Air
* Air 2
* Air 2 Pro
* Air 2 Ultra
* Light

### RayNeo

* GT
* GT Max
* Air 2
* Air 2s
* Air 3s
* Air 3s Pro
* Air 4 Pro

### Rokid

* Air
* Max
* Max 2

([VertoXR][5])

**That's basically our entire shortlist.**

---

# VertoXR's killer feature

Imagine your **RTX 3090 Ti PC**.

Instead of:

```text
Windows
 └── Monitor
```

you could potentially have:

```text
                   VertoXR
                      │
       ┌──────────────┼──────────────┐
       │              │              │
    Browser        VS Code       Terminal
       │              │              │
       └──────────────┼──────────────┘
                      │
                XR glasses
```

And position the windows spatially.

VertoXR describes itself as a portable desktop workspace with multiple virtual displays and flexible layouts. ([VertoXR][5])

That makes it **far more relevant to your home-lab use case than I initially emphasized.**

---

# 6. OpenTrack

This is another one worth knowing.

**OpenTrack** is primarily a **head-tracking application/protocol ecosystem**, not an XR rendering standard.

It takes head orientation/movement and exposes it to applications.

For example:

```text
Move head
   ↓
XR glasses IMU
   ↓
OpenTrack
   ↓
Flight simulator
   ↓
Camera moves
```

That's incredibly useful for:

* Microsoft Flight Simulator
* DCS
* racing simulators
* Elite Dangerous
* Star Citizen
* other games supporting head tracking

VertoXR specifically supports using compatible glasses as an **OpenTrack head-tracking device**. ([GitHub][6])

---

# 7. WebXR

Another important one.

**WebXR** is essentially XR functionality through a web browser.

Instead of installing:

> VR application.exe

you can visit a website that uses WebXR.

For example:

```text
Chrome / Edge
      │
    WebXR
      │
      ↓
XR glasses
```

VertoXR provides a WebXR bridge and an integrated WebXR browser. It can expose the glasses' orientation data to WebXR applications and support things like 360° video and browser-based XR experiences. ([VertoXR][7])

This is going to become increasingly interesting as browsers become XR platforms.

---

# 8. The really important distinction

Here's the table I'd keep.

| Technology             | What it is              | Primary purpose                              |
| ---------------------- | ----------------------- | -------------------------------------------- |
| **SteamVR**            | Runtime/platform        | PC VR gaming                                 |
| **OpenVR**             | Valve API               | Older SteamVR applications/drivers           |
| **OpenXR**             | Industry-standard API   | Modern cross-platform XR                     |
| **OpenXR Runtime**     | Software implementation | Connects OpenXR apps to hardware             |
| **VertoXR**            | Application/bridge      | Spatial desktop + XR glasses + SteamVR/WebXR |
| **OpenTrack**          | Head-tracking software  | Feed head movement into games                |
| **WebXR**              | Web API                 | XR inside browsers                           |
| **Direct DisplayPort** | Video transport         | Send pixels to glasses                       |
| **3DoF**               | Tracking capability     | Head rotation                                |
| **6DoF**               | Tracking capability     | Head position + rotation                     |

---

# 9. 3DoF vs 6DoF

This is probably the most important hardware distinction for your glasses.

### 3DoF

Tracks:

* pitch
* yaw
* roll

Basically:

> **Where is your head pointing?**

```text
       ↙  ↓  ↘
        HEAD
       ↖  ↑  ↗
```

That's what glasses like the **XREAL One** can do natively.

---

### 6DoF

Tracks:

**rotation + physical position**

So:

* head turns
* head moves forward
* head moves backward
* head moves left
* head moves right
* head moves up
* head moves down

```text
              6DoF

          ↑
          │
     ←────●────→
          │
          ↓

       + rotation
```

That's what allows genuine:

> "Put this virtual object on the table and walk around it."

That's much closer to true AR/MR.

---

# 10. Why this matters to your five glasses

This is the interesting part.

### XREAL One

```text
USB-C
  ↓
XREAL X1
  ↓
Native 3DoF
  ↓
Spatial screen
```

Optional:

```text
XREAL Eye
  ↓
6DoF capabilities
```

---

### RayNeo GT Max

```text
USB-C
  ↓
RayNeo spatial hardware
  ↓
Native 3DoF
  ↓
Pinned / Steady / Follow
```

And VertoXR can potentially add another software layer.

---

### VITURE Luma

```text
USB-C
  ↓
Luma
  ↓
SpaceWalker
  ↓
3DoF / multi-screen
```

VertoXR is another option.

---

### VITURE Pro 2

More basic hardware:

```text
USB-C
  ↓
Pro 2
  ↓
Display
  ↓
VITURE software / VertoXR
```

---

### xbx a01+

```text
USB-C
  ↓
xbx
  ↓
Display
```

No native spatial computing.

But VertoXR may provide software-based functionality around it; VertoXR explicitly lists xbx A01 among supported devices. ([VertoXR][5])

---

# The stack I'd pay attention to for YOUR setup

This is the architecture I'd investigate:

```text
                         YOUR RTX 3090 Ti
                               │
                    ┌──────────┴──────────┐
                    │                     │
                 Games                  AI
                    │                     │
             SteamVR / OpenXR         Ollama
                    │                  Qwen
                    │                  Vision
                    │                     │
                    └──────────┬──────────┘
                               │
                            Windows
                               │
                         VertoXR
                               │
              ┌────────────────┼────────────────┐
              │                │                │
           OpenXR           OpenVR          OpenTrack
              │                │                │
              └────────────────┼────────────────┘
                               │
                         XR glasses
                               │
                  ┌────────────┴────────────┐
                  │                         │
               Display                   IMU
                  │                         │
               Micro-OLED              3DoF
```

And **that is why VertoXR caught my attention for your situation**.

It potentially becomes the glue between inexpensive lightweight AR glasses and your much more powerful PC.

---

# One very important caveat about VertoXR

I would **not yet treat VertoXR as equivalent in maturity to SteamVR or OpenXR**.

Its own documentation currently shows some features as **"Coming soon"**, including parts of SteamVR/WebXR Game Mode, while its website already advertises those capabilities. ([VertoXR][8])

So I'd classify it as:

**SteamVR:** mature ecosystem
**OpenXR:** industry standard
**OpenVR:** legacy but still important
**WebXR:** emerging web standard
**VertoXR:** promising third-party bridge/workspace project

---

## And there's a bigger implication for your AR-glasses decision

If you're considering the **RayNeo GT Max vs XREAL One vs VITURE Luma**, don't just ask:

> "Which has the best screen?"

I'd now ask:

> **"Which one has the best hardware + software ecosystem for turning my RTX 3090 Ti into the compute engine for lightweight glasses?"**

That's a **different question**, and I think it's much closer to what you're actually trying to build.

In that context, **XREAL One + VertoXR + SteamVR/OpenXR/OpenTrack** is particularly interesting, while **RayNeo GT Max + VertoXR** deserves a much closer look too. VertoXR currently claims support for both. ([VertoXR][5])


[1]: https://partner.steamgames.com/doc/features/steamvr/openvr?language=english&utm_source=chatgpt.com "OpenVR (Steamworks Documentation)"
[2]: https://registry.khronos.org/OpenXR/specs/1.0-khr/html/xrspec.html "The OpenXR™ Specification"
[3]: https://registry.khronos.org/OpenXR/?utm_source=chatgpt.com "Khronos OpenXR Registry - The Khronos Group Inc"
[4]: https://docs.vertoxr.com/docs/intro/ "Welcome to VertoXR | VertoXR Documentation"
[5]: https://vertoxr.com/?utm_source=chatgpt.com "VertoXR"
[6]: https://github.com/rohitsangwan01/Verto_XR/blob/main/Readme.md "Verto_XR/Readme.md at main · rohitsangwan01/Verto_XR · GitHub"
[7]: https://docs.vertoxr.com/docs/features/webxr-extension/ "WebXR | VertoXR Documentation"
[8]: https://docs.vertoxr.com/docs/getting-started/ "Getting Started | VertoXR Documentation"
