# Coming Soon

These three are **much more interesting than they initially look**, because each represents a different answer to the same emerging question:

> **What if the computer is something you wear, rather than something you carry?**

And one of them — **Raven Prism** — is almost exactly the open-source/privacy-first architecture you were describing in the previous discussion.

## My quick take

| Product         | What it really is                              | Most interesting thing                                |
| --------------- | ---------------------------------------------- | ----------------------------------------------------- |
| **Raven Prism** | 🧠 **Standalone Linux AI computer in glasses** | **Open Linux + local LLMs + physical camera privacy** |
| **URXR One**    | 🥽 **93g spatial-computing display**           | **6DoF + hand tracking + 90° FOV without a puck**     |
| **Perisphere**  | 🎧 **Smart headphones with hidden XR display** | **Headphones + display + 3D cameras in one device**   |

If I were watching these for **your interests**, I'd put them:

**Raven Prism → URXR One → Perisphere**

But for *actual near-term product maturity*, I'd be more cautious with all three because they're emerging products rather than established platforms.

---

# 1. 🧠 Raven Prism — this is the one I'd watch VERY closely

![Image](https://images.openai.com/static-rsc-4/c0HeCk89XMVAb4HiWqZCGP9tI3kI__XLM-hcmQUIlxMz6uHdIdH8mYGOZ6so4kPtoPCpZFl0-kfyWBT11EEZ5RIfwuhlO1CZgOEsUSNVWpNAukDwRCrncM5-JHo1M82Q0l15D0ccNRctw7iJ6OmWpHjD-FCw9_Lqew4E1ytPcLcKzJ6ClGZjQuk10O-Hw0vW?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/qS5aLPyQStZPeRjWZzwa_L4PcaqcGjoOtcbZHAePPCOb-3M1ejsoDYtLQMrKrByhzPhTfp_GfvgDPEBlPq9ico27GEnKbAZ6X8DtYfBMOEE-Ng8FQl1ZxD-F3ahmwNHqkb34C188ZaZFs9TdZ7TQovEtt4t3H9_Y-atuHIEbodbo-iJIkWAK_81k_t5Q8TMY?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/wnwL6OO4aCVjPvvhVMQr7b45Le5ySo3ZoTArxneMx8rzmYDRpn3kcQunpd3jQPfaCht16kLBMyTNIPVU29LdK_ijCBuhdTfX_xu66JSI7mevWz5WyskjWeemVr0ar7JgVyhufb5LS7Z3Uz4mEpsRDQbCyrypBILx-ClWbfDhbFTMjcIpWhLM0gWxW4Yhce_P?purpose=fullsize)

[Raven Resonance / Raven Prism](https://raven.computer/?utm_source=chatgpt.com)

This is **much closer to the future architecture you described earlier**.

Raven isn't positioning Prism as "AR glasses."

They're calling it an:

> **Ambient Computer**

And the architecture is fascinating.

### It runs Linux.

Raven says Prism has a **64-bit ARM processor with mobile RAM and storage**, runs real applications, supports Bluetooth/Wi-Fi, and is capable of running **local language models**. ([Raven Resonance][1])

That immediately separates it from something like One Pro.

### One Pro

```text
Glasses
   ↓
Display peripheral
   ↓
Phone / PC
```

### Raven Prism

```text
Glasses
   ↓
Linux computer
   ↓
Apps
   ↓
Local AI
   ↓
Cloud AI if desired
```

That is **exactly the direction you were describing**.

---

# Raven's privacy architecture is particularly good

This is the part I think you'll appreciate.

Raven doesn't merely say:

> "You can disable the camera."

They've designed a **physical camera cover**.

Camera:

**physically blocked → camera cannot see.**

They also have **Beakon indicator lights** showing when the camera is being used. Raven says the OS requires user consent before sensors are activated or data is transmitted to an AI model. ([Raven Resonance][1])

That's a fundamentally better privacy model than:

> "Trust our software."

It becomes:

### Hardware-enforced privacy.

And that's exactly what you were envisioning with a modular camera on XREAL.

---

# Raven also has hot-swappable batteries

This is another clever idea.

Raven Wings are designed as **hot-swappable batteries**, allowing the glasses to continue operating while a battery is exchanged. ([Raven Resonance][1])

So instead of:

> "Battery died → take glasses off."

You could theoretically:

> "Swap battery → keep computing."

That's much closer to a **computer you wear continuously**.

---

# And then there's eye control

Raven is targeting:

**eye control + voice**

for hands-free interaction. ([Raven Resonance][1])

Imagine:

> Look at terminal window.

> "Open SSH."

> "Show me CPU utilization."

> "What's causing this Wazuh alert?"

That's very different from today's AR glasses where you're mostly manipulating a giant virtual monitor.

---

# Raven + your local LLM setup

This is the product that makes me think:

### **Your 3090 Ti becomes the heavy brain.**

Raven becomes the interface.

```text
                 Raven Prism
                      │
             ┌────────┴────────┐
             │                 │
          Local AI          Home AI
             │                 │
       Small LLM           RTX 3090 Ti
             │                 │
             └────────┬────────┘
                      │
                    Qwen
                      │
                    RAG
                      │
                 OpenWebUI
```

And because Raven is Linux-based, **you potentially have a much more open path to actually controlling this architecture** than with Android XR.

That's the huge attraction.

### But don't confuse "Linux" with "everything is open."

Raven hasn't published enough technical detail yet to know:

* exact SoC
* RAM
* GPU/NPU
* Linux distribution
* kernel openness
* bootloader policy
* driver availability
* camera APIs
* whether you can install arbitrary Linux software
* exact LLM performance

So I'm **very interested, but not yet convinced**.

---

# 2. 🥽 URXR One — this is the sleeper

![Image](https://images.openai.com/static-rsc-4/NHIXmyxrlhVuo-aK8VfNCt3SY-09UgnnmLxhIXJvYdASdZMxZUr1j5TiCWRhHvEbi3Ec6qIkYFYv6rMyuR25fIu3pb93nIo1k1JdhEyN3JMGynvJiRGivSC4INBH5SiY9ToJgJ7uLmgPvyLLq9_mXK3GvHs53nRX_njm6MtG5L2QQFYY23HyAO0_u41kaBEy?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/u1m7QFW24fiHIX_3kFV0z5ebAEF_u3ZyMjXRiH-FR5haTh6Kpc-L2keBf7aD9h0dT-0HBHc_fV5oKgacGfnQ4q13015IJixo5AeALFIXutSKOjowSE0tqGAE7Q1MWMXzUTnIEXpgG6-eX78IX-eJPGBec4cz5IVQtPuOSo6YE_ZPH1itHFQrOuCjfhA9P-IC?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/Hnvps9EH81CCwmYC36x6VNoKbywBPdeld6Ghwd4bNdTG3wzznU2UjZJbNfQKWTyb9355DHKpk7TyE7Oq1UF5DrH35oawsLOcV8XhovJfrafZ7SpkOIBXB7V4u6IOToRYr-v-XmdwyZJpBQGxW80GPE6lCVX7VUeOZ52IVBZ4y_Mctd_lGUijQ4SjMbI5JhPj?purpose=fullsize)

[Unseen Reality URXR One](https://www.unseen-reality.com/?utm_source=chatgpt.com)

This one caught my attention because it solves something XREAL One Pro doesn't:

### **6DoF without a puck.**

The URXR One puts:

* dual 2448×2064 Micro-OLED
* 90° FOV
* 36 PPD
* 6DoF SLAM
* hand tracking
* video see-through
* 1000Hz IMU
* spatial processing

into a claimed **93g** frame. ([Unseen Reality][2])

That's remarkable on paper.

---

# Compare that with One Pro

|                    | **XREAL One Pro** |       **URXR One** |
| ------------------ | ----------------: | -----------------: |
| Weight             |           **87g** |                93g |
| Resolution/eye     |         1920×1080 |      **2448×2064** |
| FOV                |               57° |            **90°** |
| Refresh            |         **120Hz** |               90Hz |
| 3DoF               |               Yes |                Yes |
| 6DoF               |      Requires Eye |       **Built in** |
| Hand tracking      |                No |            **Yes** |
| Video see-through  |                No |            **Yes** |
| Cameras            |                No |            **Yes** |
| Built-in speakers  |           **Yes** |                 No |
| Spatial processing |                X1 | **On-glasses SPU** |
| PC/Mac             |               Yes |                Yes |
| Phone              |               Yes |                Yes |
| Puck required      |                No |             **No** |

URXR claims its spatial processing unit performs SLAM, video see-through and reprojection **on the glasses**, rather than relying on the host device. ([Unseen Reality][2])

That's a big deal.

---

# 90° FOV is HUGE

This may be the most visually significant difference.

One Pro:

**57°**

URXR:

**90° diagonal**

That's a massive jump.

URXR claims approximately:

**80° horizontal × 56° vertical**

depending on measurement convention. ([Tech Times][3])

This starts approaching genuine VR/MR territory.

And yet:

**93g.**

That's why I'd call this a **sleeper product**.

---

# But there's a major downside for you

### Cameras are built in.

URXR requires forward-facing cameras for its 6DoF SLAM and video see-through system. ([Unseen Reality][2])

So it conflicts with your:

> **"I don't want a camera on my face."**

preference.

And unlike Raven, I don't see a comparable **physical camera privacy mechanism** documented.

That's important.

---

# There's another concern: Kickstarter

The company is currently crowdfunding URXR One.

The official site says:

**$999 MSRP**

with campaign pricing currently shown around **$799**, while other campaign coverage reports early tiers around $699. ([Unseen Reality][2])

Target shipping is **mid-October 2026**, with companion software and iOS/Android support rolling out around that period and later. ([Unseen Reality][4])

So this is **not equivalent to buying an XREAL One Pro from an established consumer ecosystem**.

There is execution risk.

A third-party campaign analysis currently rates the project as medium-low trust, primarily because this is a first-time crowdfunded hardware product with manufacturing/shipping still ahead. ([BackerGuardian][5])

I'd therefore treat URXR as:

> **Extremely interesting technology, but not yet a low-risk purchase.**

---

# 3. 🎧 Perisphere — weird, but actually clever

![Image](https://images.openai.com/static-rsc-4/vS0V4IKxWUngt_D4_fcraY6wHQQGzbdwJC2OJsiVGDrrWlsTrm65nJwQxAnNxFHHrRQL5zJybQbHEl_vlhRod-KH1rzgd9Pwaa6nZH8shciuvK8wurbmU4t3DcHuhbCWQkELPfrG5SQFWoaVYepOObOQojU-ma5nFlmMLxdI3h9HJn8p4iGW2AlJaDwIQ8qQ?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/JUm_qS18PGPYMH5D3voi0gRaHWes0E5MmI664J7HQ4e_wTFN4w03dBZlepthuOh8Cj8WJeuPL_8XuvblQgGUEERF8-O2dTltFbOq_xmLcpl4jowid3r3nq_c-zOWr-lRKXMokZTk4eWyaa9VL4o-sCpwKGXOII8fvtwA1K40JzB_nZBVMxuHQ_AbwXVYf0HG?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/jZXjPADEZ9-nmNsPOfY1bYKxy_16sUU_6-5DDVT-H1Njq2iQbe4PLb-xqBu5pmpoRc2Tnu5RbrDIpYHLEeCUNm7KIL2HlGQeH-JYbK56lyMjvc3aGOOpDXZT3ZEG3uXDqw74ECVVBuLc1unyk3XSs6gGVW84WzZ9jOqjpES1uz82zyNWxL3pq8pdR7PNwA39?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/nGEanFISn6M7LfcQWVku0tlgfBTJrrh-60qf093cARlmOcmM4WBhnvaJjBq9AibtV0NRndcGK34BPvKZZuWU2gdB-wf_Xt59UvtneT1GNXlQHBt6QfZWukQlnE1sQgdYZtW5h8z7ZhVoMCFvKUJaZa0wXjv7v3Cb_Cu8YpMyljuNyCS7k0NwP2pXwp1ddbxb?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/sJqRK4ZEiQGkjFO9okZDfCQeJj-HfUY4QUXuggrGDEzMwccAInk11PlWGnNAL1aDHzmnANPI-37fWBt6xDhbhvuGK8A3uXvvxY0g6_7-U6-T0OUvG3Jv3lKqHPF4I6oN-_frP6vq9v4RXE24vFfcwYk8QnVuCKAwjnBK3aLqacHTUqxJKRx6vEoYWluZd1iY?purpose=fullsize)

[Geeks Loft Perisphere](https://www.geeksloft.com/?utm_source=chatgpt.com)

This one takes an entirely different approach.

Instead of:

> "Let's make glasses."

They ask:

> **"What if your headphones became the XR device?"**

That's surprisingly clever.

The display folds down from the headphone headband when you want it and disappears when you don't. ([GeeksLoft][6])

### Specs currently published:

* dual 1920×1080 displays
* 53° FOV
* 1,800 nits
* rotating/folding display
* spatial audio
* dual cameras
* 3D capture
* smartphone/Wi-Fi connectivity
* battery
* 2D/3D viewing

([GeeksLoft][7])

---

# The clever part

You can wear them like:

### Normal headphones

```text
🎧
```

Then:

### Display down

```text
🎧
 ↓
🥽
```

The display physically disappears when you're not using it. ([GeeksLoft][6])

That's a very different approach to social acceptability.

---

# And Perisphere has something neither One Pro nor Raven currently emphasizes:

### 3D capture.

It has **two cameras positioned for stereoscopic capture**, allowing first-person 3D video recording. ([GeeksLoft][7])

So you could potentially:

> Look at something → capture it in 3D → share it.

That's interesting for:

* travel
* family memories
* sports
* concerts
* education
* remote presence

---

# But I see Perisphere as a different category

I'd classify it:

### **Entertainment-first wearable**

rather than:

### **AI-first spatial computer**

The company itself calls it a **smart headphone**, not an AR/VR device. ([GeeksLoft][7])

And I haven't found evidence yet that it has the sort of:

**local LLM + open OS + spatial computing**

architecture you're interested in.

---

# The three actually represent three future directions

This is the part I think is most interesting.

## 🧠 Raven

### "The computer becomes the glasses."

```text
Glasses
   ↓
Linux
   ↓
Apps
   ↓
AI
```

**Best vision for an open/local AI future.**

---

## 🥽 URXR

### "The glasses become a lightweight spatial computer."

```text
Glasses
   ↓
6DoF
   ↓
Hand tracking
   ↓
90° FOV
   ↓
Host device
```

**Best technical challenge to XREAL/Quest.**

---

## 🎧 Perisphere

### "The headphones become the XR device."

```text
Headphones
     ↓
Audio
     +
Display
     +
Cameras
     +
3D capture
```

**Best alternative form factor.**

---

# Now put them next to XREAL Aura

This gets REALLY interesting.

|                       | **Raven Prism**    | **XREAL Aura**                      | **URXR One**    | **XREAL One Pro** | **Perisphere**        |
| --------------------- | ------------------ | ----------------------------------- | --------------- | ----------------- | --------------------- |
| Philosophy            | **Open computer**  | Android XR computer                 | Spatial display | Personal display  | Smart headphones      |
| OS                    | **Linux**          | **Android XR**                      | Companion/host  | XREAL             | Proprietary/companion |
| Local LLM             | **Explicitly yes** | Hardware supports it; ecosystem TBD | Not advertised  | No                | Not advertised        |
| Weight                | TBD                | ~91–95g                             | **93g**         | **87g**           | TBD                   |
| FOV                   | TBD                | **70°**                             | **90°**         | 57°               | 53°                   |
| 6DoF                  | TBD                | **Yes**                             | **Yes**         | No*               | TBD                   |
| Hand tracking         | TBD                | **Yes**                             | **Yes**         | No*               | No                    |
| Camera                | Yes                | Yes                                 | Yes             | **No**            | Yes                   |
| Physical camera cover | **Yes**            | No                                  | Not documented  | N/A               | No                    |
| Compute               | **On glasses**     | External puck                       | **On glasses**  | On glasses        | Internal/phone        |
| Open ecosystem        | **Linux**          | Android XR                          | TBD             | Limited           | TBD                   |
| AI                    | **Local-first**    | Gemini + XR AI                      | TBD             | Limited           | Not central           |
| Battery               | Hot-swap           | Puck                                | Power Hub       | External          | Built-in              |
| Best use              | **AI/work**        | Spatial computing                   | MR/productivity | Display/gaming    | Media/capture         |

*One Pro can gain additional spatial capabilities with XREAL Eye.

---

# And here's my ranking for YOU

Based on everything we've discussed—not just specifications:

### 🥇 **Raven Prism**

**Most aligned with your philosophy.**

Why?

**Linux.**

**Local LLMs.**

**Open ecosystem.**

**Physical camera cover.**

**Hardware privacy.**

**ARM computer on your face.**

**Third-party accessories.**

That is almost a direct implementation of the architecture you were describing earlier.

The problem:

**We don't know enough yet.**

Raven is still "launching later this year" and has not published the full hardware specification. ([Raven Resonance][1])

---

### 🥈 **XREAL Aura**

**Most credible large-platform ecosystem.**

Google + Android XR + Qualcomm + Gemini + Google Play.

This has the greatest chance of becoming a **real mass-market spatial-computing ecosystem**.

But:

**closed-ish ecosystem + cameras + external puck.**

---

### 🥉 **URXR One**

**Most technically exciting lightweight spatial display.**

93g.

2448×2064.

90°.

6DoF.

Hand tracking.

Video see-through.

And **no external compute puck**.

That's an impressive engineering target. ([Unseen Reality][2])

But:

**Kickstarter + cameras + immature ecosystem.**

---

### 4. **XREAL One Pro**

Still the one I'd buy **today** if your primary requirement is:

> "Give me the smallest, lightest, polished display glasses with no camera."

87g, 57°, 120Hz, 3DoF, Bose audio. ([XREAL Tutorials][8])

It's the **least ambitious**, but also the least complicated.

---

### 5. **Perisphere**

The most unusual.

I actually like the concept.

But it doesn't fit your **local AI / open ecosystem / home-lab** interests nearly as well.

Its strength is:

> **"I want great headphones that secretly turn into a private cinema/3D camera."**

That's cool.

---

# One thing I would watch VERY closely

There is a fascinating convergence happening:

### Raven

**Linux + local AI + privacy**

### XREAL Aura

**Android XR + Gemini + spatial computing**

### URXR

**on-glasses spatial processing + 6DoF**

### Qualcomm

**XR silicon + on-device AI**

### NVIDIA

**local/edge/cloud AI infrastructure**

### OpenXR

**common application layer**

If these pieces converge, we could end up with something much closer to your earlier vision:

```text
                         OPEN XR
                            │
             ┌──────────────┼──────────────┐
             │              │              │
           Linux        Android XR       OpenXR
             │              │              │
          Raven           Aura          URXR
             │              │              │
             └──────────────┼──────────────┘
                            │
                     AI abstraction
                            │
            ┌───────────────┼───────────────┐
            │               │               │
         On-device       Home Lab        NVIDIA
            AI             GPU            AI
            │               │               │
            └───────────────┼───────────────┘
                            │
                         YOU
```

**That is the ecosystem I'd want to see emerge.**

And of the three you just introduced, **Raven Prism is the one I'd put on your personal watchlist**. Not because it has the best published display specs—it doesn't even publish enough specs yet—but because its **design philosophy is almost exactly what you were asking for: lightweight computer + Linux + local LLM + modular accessories + physical camera privacy.** ([Raven Resonance][1])

I would **not buy it yet**, though. I'd wait for the final SoC, RAM, display resolution/FOV, weight, battery runtime, price, camera specifications, Linux openness, and actual local-LLM benchmarks. Those will tell us whether Raven is a genuinely disruptive product or a very attractive prototype.

[1]: https://raven.computer/ "Raven Resonance"
[2]: https://www.unseen-reality.com/ "Unseen Reality | URXR One Lightweight Spatial Display Glasses"
[3]: https://www.techtimes.com/articles/322587/20260801/spatial-computing-glasses-urxr-one-93-grams-6dof-tracking-699-kickstarter.htm "Spatial Computing Glasses URXR One: 93 Grams, 6DoF Tracking, $699 on Kickstarter"
[4]: https://www.unseen-reality.com/ "Unseen Reality | URXR One Lightweight Spatial Display Glasses"
[5]: https://backerguardian.com/campaign/urxr-one "URXR One: 93g Spatial Display Glasses Trust Analysis | BackerGuardian"
[6]: https://www.geeksloft.com/ "Perisphere - The Smart Headphones"
[7]: https://www.geeksloft.com/ "Perisphere - The Smart Headphones"
[8]: https://tutorials.xreal.com/docs/glasses/one-series/spec/ "Specifications | Tutorials"
