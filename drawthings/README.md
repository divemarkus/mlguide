
## 🎨 Draw Things (macOS) — Complete Guide (2026)

![Image](https://drawthings.ai/images/macOS-Draw-Things-V2-1230x1000-3.webp?purpose=fullsize)

If you’re serious about **privacy-first AI image generation on macOS**, **Draw Things** is one of the best tools available right now. It’s essentially the **LM Studio of image generation**—but optimized for Apple Silicon.

---

# 🧠 What Draw Things Actually Is

**Draw Things** is a **native macOS/iOS app for running diffusion models locally**.

### Core idea (same pattern as your stack):

* **Model = weights (brain)**
* **Draw Things = runner (body)**
* **Your prompts/workflows = control layer**

This mirrors your repo’s architecture explanation perfectly :

> Models don’t do anything alone — tools like runners (Draw Things, Ollama, LM Studio) execute them.

---

# ⚙️ Why Draw Things Exists (Background)

Draw Things became popular because:

* Apple added **Metal GPU acceleration (M1 → M5)**
* Stable Diffusion models became **portable (.ckpt → .safetensors)**
* Users wanted **offline, private image generation**

So instead of:

* ❌ Midjourney (cloud)
* ❌ DALL·E (API)

You get:

* ✅ Fully local inference
* ✅ No API keys
* ✅ No telemetry (unless you add it)

---

# 💻 macOS Optimization (Why it’s Good)

Draw Things is **heavily optimized for Apple Silicon**:

| Feature              | Why it matters                         |
| -------------------- | -------------------------------------- |
| Metal acceleration   | Uses Apple GPU efficiently             |
| Unified memory       | Shares RAM/VRAM → huge models possible |
| CoreML support       | Faster inference on some models        |
| Quantization support | Run larger models on smaller Macs      |

👉 This is why even:

* M1 Pro → usable
* M3/M4/M5 → **very powerful for diffusion**

---

# 🧩 Key Features You Need to Know

### 1. Image Generation Modes

* Text → Image
* Image → Image
* Inpainting (edit parts of image)
* ControlNet (pose, depth, edges)

---

### 2. Prompt System (Critical Skill)

You already saw how powerful prompting is in your repo (Space Invaders example) 

Same concept applies here:

```
Prompt:
"ultra realistic cyberpunk knight, 4k, cinematic lighting"

Negative:
"blurry, low quality, distorted face"
```

👉 Prompting = **90% of quality**

---

### 3. LoRA Support

* Fine-tunes style without full model
* Lightweight (~100MB–1GB)
* Stackable

---

### 4. ControlNet (Advanced)

* Pose control (OpenPose)
* Depth maps
* Edge detection

👉 This is where Draw Things becomes **production-grade**

---

### 5. Batch + Seeds

* Reproducibility (same seed = same image)
* Batch generation for exploration

---

# 🚀 Best Models for Draw Things (2026)

## 🔥 1. SDXL (Still the baseline)

![Image](https://images.openai.com/static-rsc-4/c5SmVRFdeeGKqPUyiFHw4tICBeQnaevHnOI6pafj3C7qCwqHzhpAcG-pPlka8hCkwJ9eXvvYO6cCUZDzzirryitH_QXZPt32hwTuDbSuXh2XQG6NKCbjl-JtgScgsLvrqwjlCj3hARJNENjPXZ9swI5zmeHLRJTFaY-Sj0K88NgUFNbEEhyTSXhepHTrO4-D?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/Ue0-VSt4fIyFtocTRtasHew7SUGP94xWrRxjdsEDagoMbpze06GLCo1esvqAf7Mkv4QGuecN-8A6aPWS7idrnN4F5N9rV7A83D-r9vNiCEIG0q3oj64MDz7zOpS__FoF4jBE3D4ebBHdrQEWB-AegvmjTGTi-MmlRpOrcQz1IYOD5lGtcXzakbhJjVF3tpCN?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/j9bebVC4uTR_zP3LT_6UQDr9Ty4pv--me3INNPWlyR4dm4dzLr7ajuL2vqDhW6zDSQXCRS3S9dHlx9XutIb_dDorbpdsRaKNIwZjC8tVy0Lc3msnIQ8BoF8wbFtgFbaPlTIKcbaq5CaDnaYk6VyeGVwg1RIkDONRO-a7T1wrh_qQannRaaiwCLuHM1gNMZnZ?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/flg-o1wqhpLyRDvDjBDpwH40fvy3f_G5UbgVUWIGRC6kndi0l1CzWbexvlpEJmwUGANX87arCl8fWirAPL2hxg8jvnBciBklPERrbb61oIiL2C6notysGGSQugvQ57jdRLfKLPNpTyDq6Ej8FYR7eHcLxUDOry6NBkRFu7MIgUzVOqOUkobK4NJyRKYkRXmf?purpose=fullsize)

* **Stable Diffusion XL (SDXL 1.0)**
* Best all-around model

**Use for:**

* Realism
* General art
* Prototyping

---

## 🔥 2. SDXL Turbo / Lightning

![Image](https://images.openai.com/static-rsc-4/Pvghc26fumUfGW_n4fr8a2SM996M6PjjclT4y3eNw9URnVXj-4nf-pm1RKvugDZg-SbPblh2LzJGrqGka0yMAefAT_9ZttGtT_moO4S8dY_x1aWp2T0bvUjxt1-ffUIDW7qGfQic2mKMfJwXo0MrlEKOkSCdo2GQrVf22tAsEBBeXpxOndHXW55vhZHZMGk4?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/op0t3WPNwHIGd5iXJkLSB--zSpzDA5GEqo-vUdiSPUaICwWPCzSm3RzQLVD4oR9VkXsJ_vaFh8d3i0YO9ISOpHpvHvG1i4pUVQMRNkSWvyB2XbkvOh1cnb8zrM17l61wPpgafNFRi0fp1-ceSncAZh6IrgrBm6_ugqAef1afhUB4BFIyh_7liQNQMYDng-AM?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/MUlF9XgL9J-vLq8Ppl9togTQQ97JuyrxM3uoGtlJSTd9qPU0BtwQZMTdEPRnbsaVxMHntRpJ9dwmmL3yjlVX8gZhWoGO0WIpFJXNojFFWmwvrP4FjbLl58Cu10ECZS4Qz1Ac325V55priRqQq5zMDzLEUQ_n7LelLtBcboaRwPQ1PMBn8bV2PCGCiRwL7Is6?purpose=fullsize)

* Ultra-fast (1–4 steps)
* Lower quality but great iteration

**Use for:**

* Rapid prototyping
* UI ideas
* concept iteration

---

## 🔥 3. Juggernaut XL / RealVisXL

![Image](https://images.openai.com/static-rsc-4/PztAx_nNj6lmmhqTny97R-h8ajOauHwSYy57ztIDyhaOugJ3SPmQLDF59gleM-r6Z9kS44Ajwd--08WV6GhNY1Mx6cz6J41iOA3EZ7AVplSL2RzJmy-0ASQ6_M10N9kCrWqJ7NtuyHhBH57H0HQnoRKXgVJinbw-kyi5bGTjTjQ-6sIsIjfCm8Y-uHLkGg_h?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/xiEIpf22e5ig8C69xQ-YXrmb_yZMAeDgeEBgFFg3RVAByjMyS-gLt0bnHjuG7TgyKXMQGwkmoQUAGkZKkC4xWtaHDzcdcpZrOa0leN1Cj6H42LbPcA78qkIMh9zC5fIccxqFLboB_pe0NhxBzJzAn5quLK7HwjFdbLIYazvvGXdK19qI1Zkhua5EZm4G_LPq?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/cvFgwwByN0NkkfZl3CZEciVY_cyxGlCqxbHLfeK4VqxVYIAFblNedD57Ertqer8tJsT9FOPxqQZEcdH-hktoTCXs6BVS3bPlKbmQvW0_s5oOQe4VI9Z0QD0BeBmOrNHQQ2VdRuWyjF3UTZ1OjJDZqxaaZX2GZnrgLdlMWsvh1kXp4IDcqC8RtCrde83EiFVi?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/J8dK8aygSGHOteooXlWMmcKhe72iYLFaB71gNtT-__qyHEayJI6Y3DrLT5hgyPHGuxNHqyt-78WsYMhkbeUXZGrJI3AWjkEEcT6UyHqCckO60lxXcrH5RpUyRODfEnRvcN9T_5xswYcdwCfuFeVmX-V25lWiPLecWt8AJCxXW3sk4ZUG-s5-lxinB4gn3PEB?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/ZMiXFhwBWIJtQHQv0TBUnW-shfqPJJHtM4YB7H47FsB8kjyswOgYxhyK0PCQHVKhg6YKbO5BGxViOzWTCA70JLdwb7IhYb7CNq-ny7d5ETSI509WToyD3mtlkq_osYNQ4nCU4gD1vDt2Kz-oyp0C_tGU2XuwfDRbIC6_7fkVSrtTvrOiIyZMKAzbG47OTq2g?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/1wBF43Xc2-ivMOItvjADxiZypXpPUxRxELz5HkDd_vbbTr3cTCdO8u-4pHRyWeQ7j7ucR3EDKCuHHXglkn4u-_4YIB19oVqW96FlAqGiLMeSw6Ped3aOQwtgvulncF2VZtfVyF0haO1Eb_IwKnGa9rw6UgwPtIoMFVhAKnmCMh2V-f3l0mAV6QCPyRnajxQ5?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/1H6C8ZEHC0P89lUvf7bkMSaLDohIEiyRl9SI-UKOVqjaxcw03VFmwsb2-rSvP8rfL05yoixAQf31J45oMGxLJekLNdKznHFIc82uVCXzD1BV0T8tkjquWW22KT2-eLcoWFhC892Iws1x7WEpQzw78y_KngQcQLm8n5-NEAenKjuG_N6cddu4POM4RQlS-eLV?purpose=fullsize)

* Fine-tuned SDXL variants

**Use for:**

* Hyper-realism
* portraits
* cinematic scenes

---

## 🔥 4. Anime Models (Very Popular)

![Image](https://images.openai.com/static-rsc-4/bQouItyAK5IbBowPkiGgae-aoI4EDUJkXmroerr77eJWBXdfdgwVqyVR9o2YA9cfjNHsQVDBMOXu-rKtUhHLcVmfC5B7o3VPODmz1Mlyw_H5aHyNTZ1X0hkxfxSxRKLQQDWcDq8kfcukND7542_8MIkZXMbuHIF2dRI4E131O6YUxZBJF2t4wcXhHQMSf7OF?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/saDC6L5JGgH8661VuVqZGOiTOm7cu32bXJKA3KjOu9yXTOV8-YROAYftN4ZRp5xasxY4NUuO2nS8rkyENP2wg3vfDsb_fjMCIab1Y_Sc3J019NyLZpdoVPHwKrnGHIO5qmTnZgpb7Pl4rdOtNmFd9qwJij7ZJasq7G0dBbOKFYHkLS_od9shk7g9YhPHq9AU?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/9s9WnW8aur6fz4MsHFTQWzbkvvMalXPrDsl5hQFtcg5vw4jHDKcIqJ8iCXyUYDZn4umDuxfH9ssQzLWAPvvqESPuGdvskZpJ9OFN6UyxpamCLH_rmSDH6Grzju2Wcs4Bpj3aflRbhA4F8pqO9zS-Ny2MKdrnPpgs85OccX4CZz-dZnZkb6nbO-oOWXR3xE0-?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/H9VQkCG1CzNsa-fZJd_7DYfb7j5CwU5vtWET0zJ-Wzx19R7UDvHKhpXkp8pf9KDfHcVNSrX3Pl1FWJn4QW9Uz7qbCDHDPBQKC-kEZfd30ta9lFo7GBLM0cFp-GbMJo0eNDUQdlRsObr7qf2qSYIHPUDIAWF9WvhWR-dMMMvNpgjGvyjUyY-DHFnNpUMyIA-e?purpose=fullsize)

* Anything v5
* AOM / Counterfeit

**Use for:**

* Anime
* stylized art

---

## 🔥 5. Flux (Emerging 2025–2026)

![Image](https://images.openai.com/static-rsc-4/auuV7IEGq53R6vdz8sahAax1LOnE-qJcGSuJWQ0A6JY9BUyGjIiZTAyyjda_bauSP32kDZ8MX01h6pvu3k_fV8L6gI0Izuhvk1vp0QOTkjtmtLX9e41M5OuT-7wISngEbiGmSGmx7KoM8uHNGx0InQ-EUkeTsHZn7TSzJV5z3nIlwzWY57hYIcYrBx7N-Cif?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/sx3YrhCwUTpDvuzEk8MGILcVEsiVtA2-hVfT3b7N9n5-Yj_bHOMOwneyHA7h28xaDe0cx8rVwQjQadqb8_Qr4E8EnBMKJT-L5oEm9wP12NhudsAD1uI1Fvl-FuijhWfefiMQSQLzDJE7PmTC7Bp-1HpjzKlyux9L_qK87FFm07XfCLCh2qATkkEhMz1OlxOM?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/WRnd-4MCkYRpnsw6-Elrmf5A3dHzt1klC-PPE-ajGJQNQ9H6LdcwqIRozYLliq8d3XWW-eCp-ht2mH1w_qpO0rkWJScwmEF6q4BK6OvxJxh-3tPctXvhkVbZPgyHrHGqHHx7x7vvC9I1gIODNuB83iJ5VF5a-R-couZ-28snpN8mcGHouI1Pc-Zosg5nIOjT?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/4T-PADJFhCYR_Ke7pFkh4R3Xz9WIO_0gqDavczE8mMB4F8wULlQed1IRCrloYv6uAqXFTnQGUGDgDe0IYtVi6kEs0eUQXQcuVLnbY_gGR7fA0uTwSa7qH_H-BaoIa4MirJ1xnIFDjbzIZNYigOI-HBqU4IqCF5xVrYWiAQhROv4_5NWz_75s72aK1Xo3suml?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/RKccIvCsOnud4_w9oXDzlBHC8lPln3QmSxeKf-FSnE0adYmZbYQbCVkZWnENPs1ExElLjii-gQge56KSDdAe-zxVeBF2tCQvX6La-LqQ4C3gglGVXn9kPVJNb3PksmCYsiB3KSLRpJYdW1k-X0MU4_ydp_DzFVfYyJKtUQI6yqfZ3S80uOSpOmNbbMpM1zSV?purpose=fullsize)

* Next-gen diffusion transformer hybrid
* Better:

  * text rendering
  * prompt adherence

👉 Heavier, but worth it on high-end Macs

---

## 🔥 6. Qwen Image 1.0 6-bit

> Check-out [sample prompt here](./sample-prompts/knight-v1.md)

* Strong open-source image model with excellent prompt adherence
* The **6-bit** Draw Things build is the practical sweet spot for Apple Silicon
* Better than many older models at:

  * text-in-image
  * complex scene instructions
  * multilingual prompts

**Use for:**

* Posters and signs
* UI mockups with readable text
* detailed prompt-following tests

👉 Good target for Macs with **16GB+ unified memory**.

---

## 🔥 7. Z-Image-Turbo

* Fast 6B image-generation model
* Designed for quick, low-latency generations
* Often runs well with fewer steps than heavier diffusion models

**Use for:**

* Fast ideation
* realistic portraits
* product-shot style images
* rapid prompt iteration

👉 Treat this like a modern fast lane: not always the absolute best final render, but excellent when you want speed.

---

# ⚡ Performance Expectations (Mac)

| Machine | Experience                 |
| ------- | -------------------------- |
| M1/M2   | Good (SD 1.5 / light SDXL) |
| M3/M4   | Excellent                  |
| M5      | Near workstation-level     |

---

# 🧠 Real Use Cases (Where It Actually Shines)

### 🧑‍💻 Engineering / Dev

* UI mockups
* game assets
* concept art pipelines
* AI-generated dashboards

👉 You literally already generated a game with LLMs — now add visuals.

---

### 🎨 Creative

* Character design
* Storyboarding
* Branding assets

---

### 🧠 Research / ML

* Model comparison
* prompt engineering
* LoRA training experiments

---

### 🔒 Privacy workflows

* Medical images (non-sensitive prototypes)
* internal design assets
* offline creative tools

---

# ⚠️ Limitations (Be Realistic)

* Not as strong as Midjourney in aesthetics (out-of-box)
* Heavy models = RAM pressure
* Prompting skill required
* Model management can get messy

---

# 🧰 Pro Setup (What You Should Do)

Since you’re already building a **local AI stack**, the *correct way* to use Draw Things:

### 1. Model strategy

* Keep:

  * 1 base (SDXL)
  * 1 realism (Juggernaut)
  * 1 fast (Turbo)

---

### 2. Storage

* Use external SSD (models get huge)

---

### 3. Pipeline

* LLM (Ollama) → generates prompts
* Draw Things → generates images
* Store outputs → version control

---

### 4. Automation (advanced)

* Script prompt generation
* Batch export images
* Build internal tools

---

# 🧠 Key Insight (Important)

Draw Things is NOT “just an app”

It’s:

> A **local diffusion runtime optimized for Apple Silicon**

Just like:

* Ollama → LLM runtime
* LM Studio → dev environment

---
