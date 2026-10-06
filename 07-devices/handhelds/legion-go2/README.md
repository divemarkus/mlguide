# Lenovo Legion Go 2 — Local LLM & AI Capability

## 1. Hardware Profile

**Target configuration:** Lenovo Legion Go 2 — Ryzen Z2 / 32GB / 1TB

| Component | Specification | Local LLM relevance |
|---|---|---|
| **CPU** | AMD Ryzen Z2, 8 cores / 16 threads | Good CPU inference for small models |
| **CPU architecture** | Zen 5 | Excellent general-purpose compute |
| **GPU** | Integrated AMD Radeon, 12 CU | Provides GPU acceleration, but no dedicated VRAM |
| **GPU architecture** | RDNA 3.5-class | Useful for compatible inference runtimes |
| **Memory** | **32GB LPDDR5X-7500** | **Major advantage for local AI** |
| Memory type | Unified/shared system memory | CPU + GPU share 32GB |
| SSD | **1TB PCIe 4.0 NVMe** | Plenty of room for models |
| Display | 8.8" 1920×1200 OLED | Excellent local-AI interface |
| USB | **2× USB-C / USB4** | External GPU/storage/display possibilities |
| OS | Windows 11 | Excellent compatibility with Ollama/LM Studio |
| Battery | **74Wh** | Large for a handheld |
| Weight | ~920g | Portable, but relatively heavy |
| Networking | Wi-Fi 6E | Excellent for connecting to your home AI servers |

### The most important specification isn't the CPU or GPU.

It's this:

> **32GB of system memory.**

Because the Legion Go 2 has an integrated GPU, that 32GB is effectively the machine's combined CPU/GPU memory pool.

That gives the Go 2 considerably more flexibility than a typical 16GB handheld.

---

# 2. The Fundamental Limitation

The Legion Go 2 does **not** have dedicated VRAM.

Your RTX 3090 Ti has:

> **24GB dedicated GDDR6X VRAM**

The Legion has:

> **32GB shared LPDDR5X**

Those are not equivalent.

The Legion's 32GB has to service:

```text
CPU
│
├── Windows
├── applications
├── model weights
├── KV cache
└── GPU
     └── integrated graphics
```

So you shouldn't think:

> "Legion has 32GB, therefore I can run a 30B model."

You *may* be able to load one, but inference performance can be poor.

For local LLMs, **memory capacity determines what can fit; compute and memory bandwidth determine how fast it runs.**

---

# 3. What Can the Legion Go 2 Actually Run?

I'd divide models into four tiers.

## Tier 1 — Excellent

### 1B–4B models

This is the Legion's sweet spot.

Examples:

- Qwen3 1.7B / 4B
- Qwen3.5 small variants
- Gemma small models
- Phi small models
- Llama small models
- DeepSeek small/distilled models

Typical quantization:

**Q4_K_M / Q5_K_M**

These models can be genuinely useful rather than merely technical demonstrations.

### Good uses

- Offline assistant
- Summarization
- Simple coding
- Text generation
- Classification
- Extraction
- Lightweight agents
- Personal knowledge queries

**Rating: ⭐⭐⭐⭐⭐**

---

# 4. Tier 2 — Very Usable

## 7B–8B models

This is where the Legion becomes particularly interesting.

Examples:

- **Qwen3 8B**
- Llama 3.x 8B
- Gemma 3 4B/12B-class depending configuration
- Mistral 7B-class models
- Qwen coding models in this range

I'd use:

**Q4_K_M**

or

**Q5_K_M**

for quality.

A 7–8B Q4 model is roughly in the neighborhood of:

**4–6GB**

for the model weights, leaving substantial memory for Windows and KV cache.

### This is probably the Legion's best general-purpose LLM class.

**Rating: ⭐⭐⭐⭐½**

---

# 5. Tier 3 — Possible but Compromised

## 12B–14B models

Examples:

- Qwen 14B-class models
- Gemma 12B
- other 12B–14B instruct/coding models

A Q4 model can fit comfortably into 32GB system memory.

But the question becomes:

> **Is it fast enough to be useful?**

That's where the integrated GPU becomes the bottleneck.

I'd consider these models for:

- Longer reasoning
- Better coding
- Better writing
- More capable offline assistant

but **not as the default model**.

**Rating: ⭐⭐⭐**

---

# 6. Tier 4 — Experimental

## 20B–35B models

Technically, 32GB gives you enough memory for heavily quantized models in this range.

For example:

**Q4 30B**

could potentially fit.

But:

```text
Model fits
     ≠
Model runs well
```

You'll increasingly encounter:

- CPU bottleneck
- memory-bandwidth limitations
- large KV-cache requirements
- long prompt processing
- low tokens/sec
- Windows memory overhead

I'd classify 20B–35B models as:

> **Interesting experiments rather than practical Legion models.**

**Rating: ⭐⭐**

---

# 7. 70B Models

Technically possible only with extremely aggressive quantization/offloading tricks.

Practically:

**No.**

Even if you manage to load a heavily quantized 70B model, the performance would make little sense compared with simply connecting the Legion to your 3090 Ti server.

**Rating: ⭐**

---

# 8. Recommended Model Map

For your particular use case, I'd build the Legion's local model library like this:

| Model class | Legion Go 2 | Quantization | Purpose |
|---|---|---|---|
| **Qwen3 4B** | 🟢 Excellent | Q4/Q5 | General assistant |
| **Qwen3.5 small** | 🟢 Excellent | Q4/Q5 | General/agent |
| **Gemma small** | 🟢 Excellent | Q4/Q5 | General |
| **Phi small** | 🟢 Excellent | Q4/Q5 | Reasoning |
| **Qwen3 8B** | 🟢 Excellent | Q4/Q5 | **Primary LLM** |
| **Llama 8B** | 🟢 Excellent | Q4/Q5 | General |
| **Qwen coding 7–8B** | 🟢 Excellent | Q4/Q5 | **Coding** |
| **Gemma 12B** | 🟡 Good | Q4 | Higher-quality assistant |
| **Qwen 14B** | 🟡 Good | Q4 | Advanced reasoning |
| **20B–24B** | 🟠 Experimental | Q4 | Testing |
| **30B–35B** | 🟠 Experimental | Q4 | Testing only |
| **70B** | 🔴 No | — | Use 3090 Ti |

---

# 9. Recommended Local AI Software

I'd keep the Legion installation simple.

## Option 1 — Ollama

**Best for:**

- API access
- simple model management
- local services
- connecting applications to models

Example:

```bash
ollama run qwen3:8b
```

This is probably the easiest starting point.

But remember our earlier conclusion:

> **Ollama on the Legion is a convenience, not the foundation of your AI infrastructure.**

---

# 10. Option 2 — LM Studio

I actually like **LM Studio** particularly well for the Legion.

Why?

Because the Legion is a **portable AI workstation** rather than your permanent AI server.

LM Studio gives you:

- GUI model management
- GGUF support
- CPU/GPU configuration
- model downloading
- local OpenAI-compatible API
- easy experimentation
- straightforward performance testing

For the Legion, I'd probably install:

**LM Studio + Ollama**

rather than choosing only one.

---

# 11. The Legion as an AI Client

This is where the Go 2 becomes much more interesting in your lab.

Rather than trying to make it your primary inference server:

```text
                 HOME LAB
                     │
       ┌─────────────┴─────────────┐
       │                           │
 RTX 3090 Ti                  RTX 3070 Ti
 24GB VRAM                     8GB VRAM
       │                           │
       ▼                           ▼
 Main LLM Server              Secondary LLM
 Ollama                       Ollama
       │                           │
       └─────────────┬─────────────┘
                     │
                    LAN
                     │
             ┌───────▼────────┐
             │ Legion Go 2    │
             │                │
             │ Windows 11     │
             │ LM Studio      │
             │ Ollama client  │
             │ OpenWebUI      │
             └───────┬────────┘
                     │
                USB-C / USB4
                     │
             RayNeo GT Max
```

This is the architecture I'd recommend for you.

The Legion becomes:

> **portable AI terminal + local fallback inference + gaming machine**

while your 3090 Ti remains:

> **AI compute server**

---

# 12. The RayNeo GT Max Makes This Even More Interesting

Your Legion + RayNeo combination could effectively become a **portable AI workstation**.

```text
             Lenovo Legion Go 2
             ┌─────────────────┐
             │ Ryzen Z2        │
             │ 32GB RAM        │
             │ 1TB NVMe        │
             │ Windows 11      │
             └────────┬────────┘
                      │
                    USB-C
                      │
             ┌────────▼────────┐
             │ RayNeo GT Max   │
             │ AR Display      │
             └─────────────────┘
```

You could have:

**RayNeo → display**

**Legion → keyboard/controller/input**

**3090 Ti server → heavy LLM inference**

That is a much more compelling use of the Legion than trying to squeeze a 30B model through its integrated GPU.

---

# 13. What I'd Actually Install

If this were my Legion Go 2 configuration for your lab, I'd keep it lean:

### Core

- Windows 11
- Steam
- Lenovo Legion Space

### Local AI

- **LM Studio**
- **Ollama**
- Open WebUI client/access
- Git
- VS Code

### Models

I'd start with:

```text
Qwen 3 4B
Qwen 3 8B
Qwen coding 7–8B
Gemma 4B
one 12–14B Q4 experimental model
```

Then benchmark them.

---

# 14. The Most Important Test

Rather than relying on theoretical specifications, I'd benchmark:

### Prompt processing

**tokens/sec**

### Generation

**tokens/sec**

### RAM usage

### GPU utilization

### Power consumption

### Temperature

### Battery drain

### Context length

For example:

```text
Model: Qwen 3 8B
Quant: Q4_K_M
Context: 8K
Backend: Vulkan
Power: 20W
```

Then measure:

```text
Prompt: XX tok/s
Generation: XX tok/s
RAM: XX GB
GPU: XX%
CPU: XX%
```

That will tell us much more about the Legion's actual AI capability than synthetic benchmarks.

---

# 15. Final Position

I'd classify the Legion Go 2 like this:

### Local LLM capability

**★★★★☆**

### Local LLM performance

**★★★☆☆**

### AI portability

**★★★★★**

### Serious LLM server

**★★☆☆☆**

### Gaming computer

**★★★★★**

### Portable AI terminal

**★★★★★**

The key takeaway:

> **The Legion Go 2's 32GB RAM makes it unusually interesting for local AI, but its integrated GPU prevents it from being a serious high-performance LLM server.**

Its real strength is the combination of:

**32GB RAM + Zen 5 + integrated GPU + 1TB NVMe + USB4 + Windows + portability.**

And in your home lab, I'd use it as a **portable AI endpoint that can run small models locally while accessing your 3090 Ti for serious inference**.

That gives you the best of both worlds without pretending the Z2 is something it isn't.

---

# Update on Memory Allocation

I would revise the LLM section to say:
The Legion Go 2 has 32GB of shared LPDDR5X-7500 memory. Its integrated Radeon GPU does not have dedicated VRAM, but the BIOS exposes a UMA Frame Buffer Size setting that allows the user to reserve a portion of system memory for graphics. The available allocation options depend on BIOS/driver version. For local LLM use, Auto or a moderate UMA allocation is preferable to simply maximizing VRAM, because the LLM, OS, CPU and GPU all compete for the same 32GB physical memory.

That's more technically accurate.
One particularly interesting experiment
When you get the Go 2, I'd like to test three configurations:
- Configuration	Purpose
- UMA Auto	Maximum flexibility
- UMA 8GB	Balanced GPU/LLM workload
- UMA 16GB	Maximum fixed GPU allocation

Then run the same Qwen 3 8B Q4 GGUF through llama.cpp/Ollama and measure:
- prompt processing tok/s
- generation tok/s
- GPU utilization
- CPU utilization
- available RAM
- power consumption
- temperature
- battery drain

That would give us a real Legion Go 2 LLM profile, rather than relying on theoretical specifications.
And given that you're specifically looking at the 32GB Costco Z2, I think that 32GB shared-memory architecture is actually one of the most interesting aspects of this machine for our local-LLM experiment.