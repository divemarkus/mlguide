# GEV - God’s Eye View

Yes — **God’s Eye View is worth trying**, especially for you. Given your networking/infrastructure background and interest in OSINT, local AI, agents, and self-hosting, I would treat it as an **OSINT/spatial-intelligence visualization platform**, not merely a flashy globe demo.

![Image](https://images.openai.com/static-rsc-4/c0VYKPDmtPt-2ydrtiaqoF2X6Qv8ewgfBNs6denD3JLZYOEtXg9Vj6bz1xBM9kkarqsYieTtnz5ue_ESfmhNBkisgMg8ywCOhQhDqiuDwF4wYPEcCU4xSy79U8tpxKMNT-Cay6AB1bCzLPM0VRAQ98vdvQZTdD1NnpISfAUlB2l8XtOssF4XLzzpe0P9j9ho?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/0yBH3zs1Nx3Y7XJ3gsqs94-RHJB5o3FSdNdeL5sNMs4BNTqWu5T_0yqL53QCA6Q6qy1qizoXRWK4dGfAKoRa6k2iEmANTDtVlsyTK09nsK9cX9sgDnEHUtpIoz9vt-td-9gX4EZ_peXcl0483Ha2xcKNJFnuBEvwukOdzoyrNvDQCNCJskWE3NBW43E3L1ms?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/F5ANpT75OdSUE_ay76b_exic4Bhxqn_ZBvX4mco3u3p0BmG8Yekz5wmKwJBEa5b4w4-iI2IkV0wD0cYaZSIzfPefW2HY1g9fZGgQUeyAdc0o-I9lOt3gnmg3m88cNtoZfGG9_spuGC-JeZbooMOKRzEuywBKIF1fLjDrPFb47WZBLgxbjTbm7tF_IpKS6bzo?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/zXRCE_tA_0stlR-77WFHlSGkkLqVTyzl9Ws3MauRaRIqJH_SgtjBnkeVdLFHPzSUlyzpL-IF12qFe7AOf7D8yJE15WpDGCwS-X_BXDU2NKRa3ZtH4_8ZSRQyrvmL3WlQN6fyR3XuTOlpXPECAgbnGF25kFWIOZDBsWrGKrap-NeXwRld_KvsE0QwNRDVZ9FD?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/4EO0gZVbFXPtVs5Asin0l_bxNt1Pie6o6lvO-7GTYoet5B2ItoSI6TCs0i96WCT8xdITkqYk8Zq206eeapRRRjHHTxxrHi_DR9HSHgDmWeqdBJ0zvZoArUiK60psx8b5nl-Zvsdjy0PPguJPrKw9cVsJws679yUGi9jmH5vlim7tOlt-lkgx2s2B1Habrktz?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/TaYOFeW0dcLY3rgaaaPkZ5ngKbbMAdB-Cg7pMANSC2LnBK7iJwbsiIfaELu8WqYu-aSiGR73-epZ_qppPajZORRecx_JDI_dZz8rHiY3WLKV4blHpvYeYsu_1Y7kvcWtDdqMiVFqqJFo5FrvVOHkF3DqEL64C0OL1WZ2JC5dMB7H9DMXKKtY6Q-mWvylay6Y?purpose=fullsize)

## 1. What it actually is

[God's Eye View GitHub repository](https://github.com/bilawalsidhu/gods-eye-view?utm_source=chatgpt.com)

The simplest mental model is:

> **CesiumJS 3D Earth + a collection of public OSINT feeds + data-fusion logic + visualization + optional AI agent.**

It is **not** a satellite system, and it isn't obtaining classified imagery.

The interesting part is the **fusion**.

Instead of opening:

* ADS-B Exchange/OpenSky
* MarineTraffic/AIS
* CelesTrak
* USGS
* NASA FIRMS
* CCTV sites
* OpenStreetMap
* weather
* launch databases

in separate browser tabs, GEV puts their information into one geographic coordinate system.

The project describes itself as a "spy-satellite simulator" because the interface resembles an intelligence workstation, while the underlying information is publicly available. ([GitHub][1])

---

# 2. The technology stack

This is one of the things I particularly like about the project.

It **isn't an enormous React/Next.js enterprise monster**.

The core is:

| Component             | Technology                                    |
| --------------------- | --------------------------------------------- |
| Language              | **Vanilla JavaScript**                        |
| Module system         | ES modules                                    |
| 3D engine             | **CesiumJS**                                  |
| WebGL                 | Browser GPU/WebGL through Cesium              |
| Build/dev server      | **Vite**                                      |
| Satellite propagation | **satellite.js / SGP4**                       |
| Vector tiles          | Mapbox vector-tile + PBF                      |
| Geodesy               | EGM96                                         |
| Mapping               | Google 3D Tiles / Esri / OSM / Cesium ion     |
| AI voice              | **OpenAI Realtime API**                       |
| Runtime               | Node.js 24.14.x or 26.x                       |
| Backend               | **Vite middleware / local Node server**       |
| Database              | Primarily live feeds + local/bundled datasets |
| Deployment model      | Local-first                                   |

The repository's `package.json` confirms the relatively lightweight architecture, including Cesium, satellite.js, EGM96, MGRS, Vite and related packages. ([GitHub][2])

And the author explicitly says:

> "No framework. Vanilla JavaScript, CesiumJS, and Vite."

That's actually a significant architectural advantage if you want to **modify it yourself**. ([GitHub][3])

---

# 3. The "engine": CesiumJS

This is the heart of the visualization.

Cesium is essentially a **geospatial 3D rendering engine**.

Think:

**Google Earth engine + WebGL + programmable geospatial objects**

rather than a traditional GIS application.

GEV feeds Cesium things like:

```text
latitude
longitude
altitude
heading
velocity
timestamp
object type
metadata
```

Cesium then renders them against the globe.

For example:

```text
ADS-B aircraft
       ↓
latitude / longitude / altitude
       ↓
GEV data layer
       ↓
Cesium entity
       ↓
3D globe
```

The clever part is that GEV doesn't simply move a dot every 15 seconds.

Its live feeds can arrive at roughly 15–30 second intervals, so the application renders slightly behind real time and **interpolates between observations**, with dead reckoning filling gaps. ([GitHub][3])

That's why the aircraft appear to move smoothly rather than teleporting.

---

# 4. Satellite tracking is different

Satellites don't need somebody continuously reporting their position.

GEV gets orbital elements from **CelesTrak**.

It then uses:

**TLE → SGP4 propagation → current satellite position**

using `satellite.js`.

So conceptually:

```text
CelesTrak
   │
   │ TLE
   ▼
satellite.js
   │
   │ SGP4
   ▼
current orbital position
   │
   ▼
Cesium
   │
   ▼
3D satellite
```

This is genuine orbital mechanics rather than a pre-recorded animation.

The project also uses GMST realignment to keep orbital visualization synchronized. ([GitHub][3])

---

# 5. Where does all the data come from?

This is probably the most interesting part.

GEV currently has roughly **13 live layers**.

### Aircraft

**OpenSky Network**

Primary worldwide aircraft data.

Plus:

**adsb.lol**

for fallback and military traffic.

The README reports roughly 11,000+ live aircraft. ([GitHub][3])

---

### Military aircraft

This is particularly interesting.

GEV uses ADS-B-derived information from **adsb.lol**.

That means:

> It isn't "tracking secret military aircraft."

It is visualizing aircraft that happen to be broadcasting or otherwise represented in publicly accessible ADS-B data.

That distinction matters.

---

### Ships

**AISStream.io**

AIS = Automatic Identification System.

Ships broadcast things such as:

```text
MMSI
position
course
speed
heading
ship type
destination
```

GEV turns that into moving maritime contacts.

AIS is essentially the maritime equivalent of the aircraft-transponder concept.

([GitHub][4])

---

### Satellites

**CelesTrak**

Provides orbital elements.

GEV propagates them locally.

---

### Earthquakes

**USGS**

The earthquake layer represents recent seismic activity.

No key required. ([GitHub][4])

---

### Fires

**NASA FIRMS**

FIRMS = Fire Information for Resource Management System.

This provides satellite-derived active-fire detections.

You can therefore combine:

```text
NASA fire detection
        +
aircraft
        +
roads
        +
CCTV
        +
terrain
```

on the same map.

That's where this starts becoming genuine OSINT tooling rather than a pretty map.

---

### Traffic

This one has an important caveat.

Without a TomTom key, traffic can be **approximated/simulated**.

With TomTom:

> actual traffic flow information.

The README explicitly distinguishes the simulated/keyless traffic from the TomTom-backed live traffic. ([GitHub][3])

---

### CCTV

This is particularly cool.

It currently incorporates public cameras from sources including:

* Austin
* California/Caltrans
* London/TfL

The cameras aren't simply displayed as little video windows.

The application projects the camera into the 3D environment and estimates its field of view.

But the author explicitly warns that camera **poses are estimated** until calibrated. ([GitHub][3])

So don't interpret a viewshed as authoritative surveillance geometry.

---

### Radio

It uses:

**Radio Browser / broadcasters**

and associates radio stations with geographic coordinates.

So you can effectively fly around the globe and discover what is broadcasting there.

---

### Space launches

**Launch Library 2 / The Space Devs**

provides recent launch information.

Some visualizations are explicitly labeled:

**RECONSTRUCTED ESTIMATE**

That's important because the application deliberately distinguishes actual observations from reconstructed/modelled information. ([GitHub][3])

---

# 6. The backend is more interesting than it initially appears

At first glance you might think:

> "It's just JavaScript calling APIs."

Not quite.

The local Node/Vite server acts as a **security and data-proxy layer**.

Conceptually:

```text
                 INTERNET
                    │
       ┌────────────┼─────────────┐
       │            │             │
    OpenSky      AISStream      OpenAI
       │            │             │
       └────────────┼─────────────┘
                    │
             LOCAL SERVER
             Node/Vite
                    │
          caching / proxying
          authentication
          rate control
          sanitization
                    │
                    ▼
                Browser
                    │
                 Cesium
                    │
                    ▼
                WebGL/GPU
```

This is a **very good design decision**.

Private API credentials aren't sent to the browser.

For example:

* OpenAI key → server
* AISStream key → server
* OpenSky credentials → server

The browser talks to the local backend instead.

The project's security documentation describes server-side proxying, SSRF protection, response limits, sanitized errors and other controls. ([GitHub][5])

---

# 7. And then there is the AI agent

This is where I think **you'll really want to experiment**.

The AI isn't responsible for generating the globe.

It sits **above the spatial data and UI**.

For example:

> "How many aircraft are over Texas?"

GEV can query the current scene.

Or:

> "Which ships are approaching Oakland?"

Or:

> "Take me to LAX and select the nearest airborne aircraft."

The agent has access to **28 tools** according to the project documentation. ([GitHub][3])

So conceptually:

```text
                    OpenAI Realtime
                           │
                           ▼
                    AI Agent / Tools
                           │
             ┌─────────────┼─────────────┐
             ▼             ▼             ▼
          Camera        Layers        Queries
             │             │             │
             └─────────────┼─────────────┘
                           ▼
                    Scene Context
                           │
                           ▼
                        Cesium
```

This is **agentic UI control**, rather than simply:

> "ChatGPT tells me about a map."

The agent can actually manipulate the environment.

---

# 8. It also has visual grounding

There's an interesting second AI capability.

At street level, GEV can provide the AI with a screenshot of the viewport so it can interpret visible signage/buildings.

The project says the agent is instructed not to hallucinate labels. ([GitHub][3])

That's effectively:

**geospatial context + live telemetry + visual context + LLM**

which is a pretty compelling architecture.

---

# 9. The security model

Here's where I would deviate from the project's "just install it" approach.

**I would NOT start by exposing this on your LAN.**

The author explicitly says the application is:

> a local-first client

and **not a hardened production service**. ([GitHub][5])

That's perfectly acceptable for experimentation.

But your home lab is exactly the sort of environment where I'd isolate it properly.

### Start here:

```text
                 HOME LAN
                     │
                Firewall
                     │
              ┌──────┴──────┐
              │             │
           trusted        GEV VM
           clients          │
                            │
                       localhost:4173
                            │
                       Node/Vite
                            │
                    Internet APIs
```

Not:

```text
Internet
   │
   ▼
GEV :4173
```

And not initially:

```text
LAN
 │
 ▼
GEV :4173
 │
 ├── OpenAI key
 ├── Google key
 ├── AIS key
 └── other credentials
```

The project's own security documentation specifically warns that LAN exposure lets anyone on that network drive the proxy endpoints and potentially consume your API quotas. ([GitHub][5])

---

# 10. My recommended way for you to start

I'd **skip Pinokio** initially.

You have plenty of Linux/network engineering experience, so I would rather have you understand exactly what is running.

Use a dedicated Linux VM.

Something like:

```text
GEV VM

Ubuntu 24.04
2–4 vCPU
8 GB RAM
20–40 GB SSD
no GPU initially
```

You don't need a GPU for the server.

The **browser's GPU** is doing the heavy 3D rendering.

Your RTX workstation can therefore run Chrome/Edge and render the globe.

---

# 11. Phase 1 — completely keyless

This is important.

**Don't start by creating six API accounts.**

Start with the public feeds.

The current project documentation says the application can start with **no signup, no API key and no configuration**, using Esri imagery/OSM and public data sources. ([GitHub][3])

Install:

```bash
git clone https://github.com/bilawalsidhu/gods-eye-view.git
cd gods-eye-view
```

Use the supported Node version:

```bash
nvm install 24.14.0
nvm use 24.14.0
```

Then:

```bash
npm install
npm run doctor
npm run dev
```

Open:

```text
http://localhost:4173
```

The project explicitly supports Node 24.14.x or 26.x. ([GitHub][3])

---

# 12. First test: don't configure anything

I'd deliberately run it **keyless first**.

Test:

### Test 1 — Aircraft

Enable Flights.

Look around:

```text
SEA
↓
LAX
↓
SFO
↓
DFW
↓
Europe
```

Click aircraft.

Verify:

* callsign
* altitude
* speed
* heading
* track
* history

---

### Test 2 — satellites

Enable satellites.

Find:

**ISS**

Then compare its displayed location against an independent source.

This verifies your installation is functioning rather than blindly trusting the visualization.

---

### Test 3 — earthquakes

Turn on earthquakes.

Compare a few events with USGS directly.

---

### Test 4 — military aircraft

This is where the OSINT aspect becomes interesting.

Look at military tracks.

Then ask:

> What information is actually being observed?

You'll quickly see the difference between:

**observable telemetry**

and

**intelligence inference**.

That distinction is essential with OSINT.

---

# 13. Then add Cesium ion

This would be my **first optional key**.

The project supports Cesium ion for the more impressive photorealistic 3D experience, subject to its current personal/non-commercial eligibility and quotas. ([GitHub][3])

I would do:

```text
Phase 1
Public data
    ↓
Phase 2
Cesium ion
    ↓
Phase 3
AIS
    ↓
Phase 4
NASA FIRMS
    ↓
Phase 5
TomTom
    ↓
Phase 6
OpenAI
```

Not all six at once.

---

# 14. I would postpone Google Maps

This is important.

Google Maps is one of the few components that introduces **real billing exposure**.

The project's own documentation categorizes:

**Google Maps = metered**

and says the browser-visible key must be restricted. ([GitHub][5])

You don't need it to evaluate GEV.

You can get the core experience without it.

If you eventually enable Google:

### Create a dedicated Google Cloud project

Something like:

```text
gods-eye-view-lab
```

Don't reuse your general infrastructure project.

Then:

```text
API key
   │
   ├── HTTP referrer restriction
   │
   └── API restriction
           │
           └── Map Tiles API
```

And set:

**billing alerts + quotas**

before you start playing with it.

The repository explicitly warns that unrestricted Google keys can be abused and charged to you. ([GitHub][5])

---

# 15. OpenAI should also be a separate decision

Voice/agent functionality requires an OpenAI key.

But notice the architecture:

```text
Browser
   │
   │ short-lived session token
   ▼
OpenAI Realtime
```

Your actual `OPENAI_API_KEY` remains on the server. ([GitHub][3])

That's good.

I'd nevertheless create a **dedicated API key/project for GEV**, rather than giving it a general-purpose OpenAI credential.

Then you can see:

```text
GEV OpenAI usage
───────────────
Voice
AI HUD
Vision grounding
Agent tools
```

independently.

---

# 16. One security issue I want you to pay attention to

The current README contains a specific warning:

**Do not put credentials into Pinokio 8.0.40's native Configure panel.**

The project says that release can improperly save the nested application configuration and log submitted values.

Instead, use the application's own Provider Settings. ([GitHub][3])

This is another reason I'd use the **normal Git + Node installation** rather than Pinokio for your environment.

---

# 17. Where I think this becomes really interesting for your home lab

I wouldn't stop at:

> "Let's run God's Eye View."

I'd eventually turn it into a **local OSINT platform**.

Something like:

```text
                     GEV
                      │
          ┌───────────┴───────────┐
          │                       │
       Cesium                 Data Fusion
          │                       │
          │            ┌──────────┼──────────┐
          │            │          │          │
          │          ADS-B       AIS       Satellites
          │            │          │          │
          │          OpenSky    AISStream   CelesTrak
          │
          ├── CCTV
          ├── FIRMS
          ├── USGS
          ├── OSM
          ├── weather
          └── infrastructure
                      │
                      ▼
                Local event bus
                      │
                ┌─────┴─────┐
                │           │
             Qdrant      PostgreSQL
                │           │
                └─────┬─────┘
                      ▼
                 Local LLM
                      │
                 Qwen / etc.
                      │
                      ▼
                 OSINT Agent
```

**That** would be a fascinating extension of the project.

And it fits extremely well with the local-LLM infrastructure you've been exploring.

---

# 18. One particularly powerful future addition

Imagine:

> **"Show me all aircraft, ships and satellites within 200 km of this location."**

Then:

> **"Which of these have changed behavior in the last six hours?"**

Then:

> **"Show me the historical tracks."**

Then:

> **"Correlate unusual aircraft activity with fires, earthquakes, military installations and local news."**

Now you're moving from:

**visualization**

to:

**spatial intelligence / event correlation.**

GEV already provides much of the visualization foundation.

The project's author actually points out that historical/spatiotemporal data is substantially harder and more expensive than the live view — storing, tiling and querying what happened over time becomes a different engineering problem. ([GitHub][1])

That is precisely where your own infrastructure could become useful.

---

## My recommended starting architecture

For **your first installation**, I'd do:

```text
             Your workstation
             Chrome / Edge
                   │
                   │ localhost
                   ▼
        ┌─────────────────────┐
        │      GEV VM         │
        │                     │
        │ Ubuntu 24.04        │
        │ Node 24.14          │
        │ Vite                │
        │ God's Eye View      │
        │                     │
        │ localhost only      │
        └──────────┬──────────┘
                   │
                   │ outbound HTTPS
                   ▼
        ┌───────────────────────┐
        │ Public OSINT sources  │
        │                       │
        │ OpenSky               │
        │ adsb.lol              │
        │ CelesTrak             │
        │ USGS                  │
        │ NASA FIRMS            │
        │ OSM                   │
        │ etc.                  │
        └───────────────────────┘
```

**Phase 1:** zero API keys.

**Phase 2:** Cesium ion.

**Phase 3:** AISStream + FIRMS + TomTom.

**Phase 4:** OpenAI Realtime.

**Phase 5:** Google Maps only after billing restrictions are verified.

**Phase 6:** consider LAN access through your FortiGate, with authentication/reverse proxy and explicit rate limits.

And I would **not expose the GEV Node server directly to the Internet**. The project's own threat model specifically treats the server as a credential-bearing API broker. ([GitHub][5])

### Bottom line

**I'd give this a green light.**

It's unusually appropriate for your lab because the code is relatively understandable, the architecture is local-first, the data sources are inspectable, and the AI layer is genuinely interesting rather than just an LLM bolted onto a dashboard.

The best first experiment is **not** "install everything."

It's:

> **Run it completely keyless → inspect what data actually arrives → validate several feeds independently → add Cesium → then add AI.**

That gives us a clean security baseline and lets us understand exactly what we're trusting before turning it into a much more capable OSINT/agent platform.

[1]: https://github.com/bilawalsidhu/gods-eye-view/blob/main/README.md "gods-eye-view/README.md at main · bilawalsidhu/gods-eye-view · GitHub"
[2]: https://github.com/bilawalsidhu/gods-eye-view/blob/main/package.json "gods-eye-view/package.json at main · bilawalsidhu/gods-eye-view · GitHub"
[3]: https://github.com/bilawalsidhu/gods-eye-view "GitHub - bilawalsidhu/gods-eye-view: A spy satellite simulator in your browser, except the data is real. Live open source spatial intelligence on a photorealistic 3D globe. · GitHub"
[4]: https://github.com/bilawalsidhu/gods-eye-view/blob/main/DATA_SOURCES.md "gods-eye-view/DATA_SOURCES.md at main · bilawalsidhu/gods-eye-view · GitHub"
[5]: https://github.com/bilawalsidhu/gods-eye-view/blob/main/SECURITY.md "gods-eye-view/SECURITY.md at main · bilawalsidhu/gods-eye-view · GitHub"
