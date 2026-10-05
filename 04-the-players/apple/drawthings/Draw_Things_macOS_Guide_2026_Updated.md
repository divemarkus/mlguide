# 🎨 Draw Things (macOS) — Complete Local AI Image Generation Guide (2026)

> **Updated:** October 2026  
> **Focus:** Local/offline image generation on Apple Silicon  
> **Primary Macs covered:** M1 MacBook Pro 32GB, M4 Max MacBook Pro 36GB, Mac mini M6 32GB

![Draw Things macOS](https://drawthings.ai/images/macOS-Draw-Things-V2-1230x1000-3.webp?purpose=fullsize)

---

## Table of Contents

- [What Draw Things Actually Is](#-what-draw-things-actually-is)
- [Why Draw Things Matters in 2026](#-why-draw-things-matters-in-2026)
- [How Draw Things Fits the Local AI Stack](#-how-draw-things-fits-the-local-ai-stack)
- [Apple Silicon and Draw Things](#-apple-silicon-and-draw-things)
- [Key Features](#-key-features)
- [Current Draw Things Model Landscape](#-current-draw-things-model-landscape)
- [Best Models in 2026](#-best-models-in-2026)
  - [FLUX.2 [klein] 4B](#1-flux2-klein-4b)
  - [FLUX.2 [klein] 9B](#2-flux2-klein-9b)
  - [FLUX.2 [dev]](#3-flux2-dev)
  - [Z-Image Turbo](#4-z-image-turbo)
  - [Qwen Image 2512](#5-qwen-image-2512)
  - [Qwen Image Edit](#6-qwen-image-edit)
  - [SDXL](#7-sdxl-and-sdxl-finetunes)
  - [Anima / ERNIE Image / Krea 2 / Ideogram 4](#8-newer-model-families)
- [Model Recommendations by Mac](#-model-recommendations-by-mac)
- [Performance and Memory](#-performance-and-memory)
- [What to Download First](#-what-to-download-first)
- [Uncensored Models](#-uncensored-models)
- [Privacy and Offline Operation](#-privacy-and-offline-operation)
- [LoRAs, ControlNet and Editing](#-loras-controlnet-and-editing)
- [Resolution and Workflow Recommendations](#-resolution-and-workflow-recommendations)
- [Pro Local Workflow](#-pro-local-workflow)
- [Limitations](#-limitations)
- [Quick Reference](#-quick-reference)
- [Additional Resources](#-additional-resources)

---

# 🧠 What Draw Things Actually Is

**Draw Things** is a native Apple application for running image and video generation models locally on Apple hardware.

The most useful mental model is:

```text
Model = weights / learned capability
        ↓
Draw Things = inference runtime
        ↓
Apple GPU / Neural Accelerators / CPU
        ↓
Image / video
```

This is the same architectural idea used elsewhere in your local AI stack:

```text
Ollama      → LLM inference
LM Studio   → LLM inference / model management
ComfyUI     → node-based media workflows
Draw Things → Apple-native image/video inference
```

Draw Things is particularly interesting on Apple Silicon because it maintains its own local inference stack rather than simply being a thin graphical wrapper around another runtime.

Draw Things is also sandboxed and distributed through Apple's App Store. Its current workflow is deliberately simple: download a model once, choose recommended settings, and generate locally. citehttps://releases.drawthings.ai/p/public-beta-of-local-code-by-draw

---

# 🚀 Why Draw Things Matters in 2026

The original Draw Things guide was centered around:

- SDXL
- SDXL Turbo
- Juggernaut XL
- RealVisXL
- early FLUX

That is now an incomplete picture.

Draw Things has added support for a much broader generation stack, including:

- FLUX.2 [klein] 4B / 9B
- FLUX.2 [dev]
- Z-Image Turbo and Z-Image Base
- Qwen Image
- Qwen Image 2512
- Qwen Image Edit
- Anima Preview
- ERNIE Image
- Krea 2
- Ideogram 4
- SeedVR2 upscaling/restoration
- LTX-2.x video
- Wan 2.x video
- additional LoRA and editing workflows

The current Draw Things release history shows continued support additions through September 2026, including Krea 2, MiniMax H3-series models, Ideogram 4, ERNIE Image, Anima Preview 3, FLUX.2 [klein], Z-Image, Qwen Image and SeedVR2. citehttps://drawthings.ai/downloads/

---

# 🧩 How Draw Things Fits the Local AI Stack

A useful local-first architecture is:

```text
                 LOCAL AI MACHINE
                       │
        ┌──────────────┴──────────────┐
        │                             │
      LLM                         Image / Video
        │                             │
   Ollama / LM Studio            Draw Things
        │                             │
 Qwen / Llama / etc.        FLUX / Z-Image / Qwen
        │                             │
        └──────────────┬──────────────┘
                       │
                 Local storage
```

For your workflow:

```text
Ollama / LM Studio
        │
        ├── Generate / improve prompt
        │
        ▼
Draw Things
        │
        ├── Text → Image
        ├── Image → Image
        ├── Inpainting
        ├── Upscaling
        └── Video
```

This makes Draw Things complementary to your Ollama/LM Studio environment rather than a replacement for it.

---

# 🍎 Apple Silicon and Draw Things

Apple Silicon is particularly well suited to local image generation because CPU, GPU and system memory share a unified memory architecture.

Important variables are:

1. Unified memory capacity
2. GPU core count
3. Memory bandwidth
4. Model precision/quantization
5. Resolution
6. Number of steps
7. Context/reference-image complexity
8. Whether the model uses Apple Neural Engine acceleration

Draw Things has continued optimizing its inference stack specifically for Apple hardware.

In April 2026, Draw Things added Apple Neural Engine support for 8-bit S models on M3/M4. On M4, Draw Things reports up to 1.8× acceleration for the supported operations, while also reducing energy use and heat in some workloads. citehttps://engineering.drawthings.ai/p/making-apple-neural-engine-work-in

This is important:

> **The Neural Engine is not simply replacing the GPU.**

Draw Things uses Core ML selectively as an accelerator inside its own inference runtime.

---

# 🧩 Key Features

## 1. Text → Image

Describe what you want and generate an image.

```text
cinematic photograph of a futuristic Seattle skyline,
rain-soaked streets, neon reflections,
35mm photography, realistic lighting
```

---

## 2. Image → Image

Use an existing image as a starting point and transform it.

Useful for:

- changing style
- changing lighting
- concept exploration
- variations
- product visualization

---

## 3. Inpainting

Paint/mask an area and regenerate only that region.

Useful for:

- removing objects
- replacing objects
- repairing faces/hands
- changing clothing
- correcting backgrounds

---

## 4. Outpainting / Canvas Work

Extend an image beyond its original boundaries.

This is particularly useful for:

- wallpapers
- banners
- desktop backgrounds
- concept art
- cinematic compositions

---

## 5. LoRA

LoRAs provide a relatively small set of learned weights that can modify a base model.

Typical uses:

- character consistency
- style
- clothing
- visual identity
- specific artistic techniques

Current Draw Things releases support LoRA workflows for multiple newer model families, including FLUX.2 [klein], Z Image, Qwen Image and ERNIE Image. citehttps://drawthings.ai/downloads/

---

## 6. Control / Structural Guidance

Depending on the model and workflow, Draw Things supports techniques such as:

- ControlNet
- pose guidance
- depth
- edges
- reference images
- masks
- image conditioning

---

# 🚀 Current Draw Things Model Landscape

The most important change in 2026 is that there is no longer one obvious "best model."

Different models excel at different tasks.

| Model family | Main strength | Memory demand | 2026 recommendation |
|---|---|---:|---|
| **FLUX.2 [klein] 4B** | Fast generation/editing | Low–moderate | ⭐⭐⭐⭐⭐ |
| **FLUX.2 [klein] 9B** | Quality + editing | Moderate–high | ⭐⭐⭐⭐⭐ |
| **FLUX.2 [dev]** | Maximum quality/control | High | ⭐⭐⭐⭐ |
| **Z-Image Turbo** | Speed + realism | Very low | ⭐⭐⭐⭐⭐ |
| **Qwen Image 2512** | Prompt adherence/text | High | ⭐⭐⭐⭐⭐ |
| **Qwen Image Edit** | Image editing | High | ⭐⭐⭐⭐⭐ |
| **SDXL** | Mature ecosystem | Moderate | ⭐⭐⭐ |
| **SDXL fine-tunes** | Specialized styles | Moderate | ⭐⭐⭐⭐ |
| **Anima Preview** | Newer generation/style workflows | Varies | ⭐⭐⭐⭐ |
| **ERNIE Image** | New generation/editing workflows | Varies | ⭐⭐⭐⭐ |
| **Krea 2** | New generation/editing workflows | Varies | ⭐⭐⭐⭐ |
| **Ideogram 4** | Strong text/design workflows | Varies | ⭐⭐⭐⭐ |

---

# 1. 🔥 FLUX.2 [klein] 4B

## Best new lightweight general-purpose choice

FLUX.2 [klein] is one of the most important additions to Draw Things.

The 4B variant is particularly interesting for Apple Silicon because it brings much of the newer FLUX generation architecture into a much smaller model.

It supports:

- text → image
- image editing
- multi-reference editing
- fast generation

Draw Things added native FLUX.2 [klein] support in January 2026. citehttps://drawthings.ai/downloads/

### Why I like it for your Macs

```text
M1 32GB       → GOOD
M4 Max 36GB   → EXCELLENT
M6 32GB       → EXCELLENT
```

It is one of the first models I would install on all three systems.

---

# 2. 🔥 FLUX.2 [klein] 9B

## Best balance of modern quality and local capability

This is the model you were referring to.

FLUX.2 [klein] 9B is a 9-billion-parameter rectified-flow model supporting text-to-image and multi-reference editing.

The official model card describes it as a distilled model designed for very fast generation. Draw Things added support for the FLUX.2 [klein] series and subsequently added 9B-KV support. citehttps://huggingface.co/black-forest-labs/FLUX.2-klein-9B citehttps://drawthings.ai/downloads/

### Important memory distinction

The full BF16 model is much larger than the quantized versions. Black Forest Labs lists approximately 29GB VRAM for the full 9B model.

Draw Things uses its own quantized variants and optimized runtime, so you should not equate the official BF16 memory requirement with the memory requirement of every Draw Things build. citehttps://huggingface.co/black-forest-labs/FLUX.2-klein-9B

### Your Macs

```text
M1 32GB       → POSSIBLE, but heavy
M4 Max 36GB   → GOOD / VERY GOOD
M6 32GB       → GOOD, but memory constrained at higher resolutions
```

For the 9B model, use the Draw Things recommended/quantized variant rather than manually importing the largest BF16 checkpoint.

---

# 3. 🔥 FLUX.2 [dev]

## Quality-first FLUX

FLUX.2 [dev] is a larger, heavier model.

Draw Things added FLUX.2 [dev] support in December 2025. citehttps://drawthings.ai/downloads/

The Draw Things test set shows FLUX.2 [dev] among the strongest models tested for difficult scenes and anatomy.

However:

> **Do not make this your first model on a 32GB Mac.**

Recommended:

```text
M1 32GB       → ❌ Not recommended
M4 Max 36GB   → ⚠️ Heavy
M6 32GB       → ⚠️ Heavy
64GB+ Mac     → ✅ Much more appropriate
```

For your three machines, FLUX.2 [klein] is the much better starting point.

---

# 4. ⚡ Z-Image Turbo

## Best "always loaded" model

This is one of the most important models for lower-memory Apple Silicon.

Z-Image Turbo is a **6B-parameter** DiT model.

The Draw Things implementation's 6-bit variant occupies approximately **4 GiB when fully loaded into RAM**.

That is dramatically smaller than Qwen Image's roughly 11 GiB requirement.

Draw Things also reports that its implementation can be up to 54% faster than other available implementations across Apple devices. citehttps://releases.drawthings.ai/p/quantify-z-image-turbo-efficiency

### This is my #1 recommendation for your M1

```text
M1 32GB       → ⭐⭐⭐⭐⭐
M4 Max 36GB   → ⭐⭐⭐⭐⭐
M6 32GB       → ⭐⭐⭐⭐⭐
```

It is ideal for:

- quick generations
- prompt experimentation
- portraits
- realistic scenes
- rapid iteration
- keeping a model available without consuming enormous memory

---

# 5. 🧠 Qwen Image 2512

## Best for difficult prompts and text

Qwen Image became one of the important open image models supported by Draw Things.

The Qwen Image family is particularly strong at:

- prompt adherence
- complex scenes
- text inside images
- posters
- signs
- multilingual prompts
- composition

Draw Things' testing found Qwen Image particularly strong in difficult text-in-image cases and capable of maintaining composition over a wide range of resolutions. citehttps://releases.drawthings.ai/p/introducing-qwen-image-support

Draw Things provides multiple quantization levels.

For Qwen Image 1.0, Draw Things reported approximately:

| Variant | Peak runtime memory | Suggested system |
|---|---:|---|
| 6-bit | ~11 GiB | 16GB+ |
| 8-bit | ~16 GiB | 24GB+ |
| FP16 | ~30 GiB | 48GB+ |
| BF16 | ~30 GiB | 48GB+ on M3+ |

The same general memory lesson applies to the newer Qwen Image family:

> **Use the quantized variant on 32GB machines.**

citehttps://releases.drawthings.ai/p/introducing-qwen-image-support

### Your Macs

```text
M1 32GB       → GOOD with 6-bit
M4 Max 36GB   → VERY GOOD with 6-bit
M6 32GB       → GOOD with 6-bit
```

---

# 6. 🖼️ Qwen Image Edit

For editing an existing image rather than simply generating from text, Qwen Image Edit deserves its own category.

Draw Things supports Qwen Image Edit and later variants, including multi-image editing workflows. citehttps://drawthings.ai/downloads/

Good for:

- changing clothing
- modifying objects
- relighting
- changing backgrounds
- image transformations
- maintaining much of the original scene

Important limitation:

> Image editing models are not general reasoning models.

Draw Things' own test set demonstrates that current image-editing models can perform impressive visual transformations but still fail at simple reasoning tasks. citehttps://releases.drawthings.ai/p/draw-things-test-set-a-status-update

---

# 7. 🧱 SDXL and SDXL Fine-Tunes

SDXL is no longer the cutting edge, but it remains extremely useful.

The reason is the ecosystem.

There are enormous numbers of:

- LoRAs
- checkpoints
- ControlNet models
- styles
- community workflows
- fine-tunes

Examples include:

- Juggernaut XL
- RealVisXL
- anime/illustration models
- specialized photography models

### Where SDXL still wins

If you find a specialized LoRA/checkpoint that does exactly what you want, SDXL can remain the better tool despite newer models being technically stronger.

---

# 8. 🆕 Newer Model Families

Draw Things' 2026 releases have expanded considerably beyond FLUX and Qwen.

### Anima

Draw Things added Anima Preview 3 support, including model import and LoRA workflows. citehttps://drawthings.ai/downloads/

### ERNIE Image

Draw Things added ERNIE Image with model import, LoRA import and LoRA training support. citehttps://drawthings.ai/downloads/

### Krea 2

Current Draw Things releases support importing Krea 2 models and, in earlier 2026 releases, Krea 2-series workflows. citehttps://drawthings.ai/downloads/

### Ideogram 4

Draw Things added support for Ideogram 4-series models and LoRAs in July 2026. citehttps://drawthings.ai/downloads/

These are worth exploring, but I would not fill a 32GB Mac with every new model.

Start with a small, complementary model library.

---

# 🖥️ Model Recommendations by Mac

## Your M1 MacBook Pro — 32GB

### Best choices

| Model | Recommendation |
|---|---|
| Z-Image Turbo | ⭐⭐⭐⭐⭐ |
| FLUX.2 [klein] 4B | ⭐⭐⭐⭐⭐ |
| Qwen Image 6-bit | ⭐⭐⭐⭐ |
| FLUX.2 [klein] 9B | ⭐⭐⭐ |
| SDXL | ⭐⭐⭐⭐ |
| FLUX.2 [dev] | ❌ |

### Important M1 limitation

Older Apple Silicon has less favorable support for some BF16 workloads. Draw Things specifically notes that BF16 support on older M1/M2 hardware is limited.

Therefore:

> Prefer quantized models on the M1 rather than assuming the largest precision variant is better. citehttps://engineering.drawthings.ai/p/bf16-and-image-generation-models-803cf0515bee

---

# 💻 M4 Max MacBook Pro — 36GB

M4 Max is a major step up.

Apple's M4 Max can have up to a 40-core GPU and up to 546GB/s unified-memory bandwidth. The 36GB configuration is a real M4 Max configuration, although the 36GB version is paired with the lower 14-core CPU/32-core GPU configuration in Apple's MacBook Pro lineup. citehttps://www.apple.com/mac/compare/?modelList=MacBook-Pro-16-M4-Max%2CMacBook-Pro-16-M3

### Best choices

| Model | Recommendation |
|---|---|
| Z-Image Turbo | ⭐⭐⭐⭐⭐ |
| FLUX.2 [klein] 4B | ⭐⭐⭐⭐⭐ |
| FLUX.2 [klein] 9B | ⭐⭐⭐⭐⭐ |
| Qwen Image 6-bit | ⭐⭐⭐⭐⭐ |
| FLUX.2 [dev] | ⭐⭐⭐⭐ |
| SDXL | ⭐⭐⭐⭐ |

### The sweet spot

For this machine:

```text
FLUX.2 [klein] 9B
        +
Z-Image Turbo
        +
Qwen Image 2512 6-bit
```

That gives you:

- quality
- speed
- editing
- text rendering
- manageable memory usage

without trying to run enormous BF16 models.

---

# 🖥️ Mac mini M6 — 32GB

The M6 Mac mini is a particularly interesting Draw Things machine because it combines 32GB unified memory with much newer Apple compute.

Apple's M6 Mac mini has:

- 12-core CPU
- 12-core GPU
- Neural Accelerators in each GPU core
- dual 16-core Neural Engine
- up to 170GB/s memory bandwidth
- up to 32GB unified memory

Apple claims up to 4× faster AI performance than the previous M4 Mac mini. citehttps://support.apple.com/en-us/128108 citehttps://www.apple.com/newsroom/2026/08/apple-unveils-a-more-powerful-mac-mini-featuring-the-all-new-m6-and-m5-pro/

### Best choices

| Model | Recommendation |
|---|---|
| Z-Image Turbo | ⭐⭐⭐⭐⭐ |
| FLUX.2 [klein] 4B | ⭐⭐⭐⭐⭐ |
| FLUX.2 [klein] 9B | ⭐⭐⭐⭐ |
| Qwen Image 6-bit | ⭐⭐⭐⭐ |
| FLUX.2 [dev] | ⭐⭐⭐ |
| SDXL | ⭐⭐⭐⭐ |

### Important point

The M6 is faster than the M4 Max in some newer AI operations, but **32GB is still 32GB**.

For image generation, memory capacity remains a major constraint.

Do not confuse:

```text
faster inference
```

with:

```text
ability to load a larger model
```

The M6 32GB can execute a supported model very quickly, but it cannot magically fit a model that requires more memory.

---

# ⚡ Performance and Memory

## The most important rule

For local image generation:

> **Model memory + activations + resolution + working memory must fit into unified memory.**

You should leave memory available for:

- macOS
- Draw Things
- browser
- other applications
- model cache
- image buffers

Do not plan on using 100% of physical memory.

---

## Practical memory tiers

### 32GB Mac

Best target:

```text
4B–6B models
+
quantized 9B models
```

### 36GB M4 Max

Best target:

```text
4B–9B quantized models
+
selected larger models
```

### 48GB+

Now larger models become much more comfortable.

### 64GB+

This is where large FLUX/Qwen workflows become substantially easier.

---

# 📐 Resolution Matters

A model that comfortably generates:

```text
768 × 768
```

may consume substantially more memory at:

```text
1536 × 1536
```

and particularly:

```text
2048 × 2048
```

Therefore, don't judge a model solely by whether it loads.

Judge it by whether it can:

1. load
2. generate
3. generate at useful resolution
4. avoid excessive swap
5. repeat generations without becoming painfully slow

---

# 🎯 Recommended Resolution Strategy

## 32GB systems

Start:

```text
768 × 768
```

Then:

```text
832 × 1216
1216 × 832
```

or:

```text
1024 × 1024
```

depending on the model.

For large final images:

```text
Generate smaller
      ↓
Upscale
      ↓
Final output
```

This is often much more efficient than attempting 2K generation directly.

Draw Things also supports dedicated upscaling/restoration workflows, including SeedVR2. citehttps://drawthings.ai/downloads/

---

# 🏆 What I Would Download

Rather than downloading 20 models, build a small library.

## M1 MacBook Pro 32GB

```text
1. Z-Image Turbo
2. FLUX.2 [klein] 4B
3. Qwen Image 2512 — 6-bit
4. One SDXL realism model
```

---

## M4 Max 36GB

```text
1. FLUX.2 [klein] 9B
2. Z-Image Turbo
3. Qwen Image 2512 — 6-bit
4. FLUX.2 [klein] 4B
5. One SDXL specialist
```

---

## M6 Mac mini 32GB

```text
1. FLUX.2 [klein] 4B
2. Z-Image Turbo
3. FLUX.2 [klein] 9B
4. Qwen Image 2512 — 6-bit
5. One SDXL specialist
```

---

# 🔞 Uncensored Models

## Can Draw Things handle them?

### Generally: yes, with an important distinction.

Draw Things is a **model runtime**, not the model itself.

If a compatible community checkpoint/LoRA is supported by Draw Things, the app can generally run it locally.

Draw Things also exposes an **Uncurated** model section and supports importing custom models and LoRAs for many architectures. Its release notes document increasingly broad custom-model and LoRA support. citehttps://drawthings.ai/downloads/

However:

> **Draw Things supporting a model does not make that model uncensored.**

There are three separate layers:

```text
                 ┌────────────────────┐
                 │ Model weights      │
                 │ Safety behavior    │
                 └─────────┬──────────┘
                           │
                 ┌─────────▼──────────┐
                 │ Draw Things        │
                 │ Runtime            │
                 └─────────┬──────────┘
                           │
                 ┌─────────▼──────────┐
                 │ Your local device  │
                 └────────────────────┘
```

A community model may have different safety behavior from an official model, but compatibility, licensing and model-specific behavior must be checked individually.

### FLUX.2 [klein] is NOT an uncensored model

This is especially important given your question about FLUX.2.

The official FLUX.2 [klein] 9B model has safety mitigations and an explicit non-commercial license. Its model card states that its repository includes input/output safety filters and usage restrictions. citehttps://huggingface.co/black-forest-labs/FLUX.2-klein-9B

So:

```text
FLUX.2 [klein] 9B
        ≠
uncensored model
```

### What "uncensored" means here

For local image generation, people generally use the term to describe community models whose weights have not been safety-tuned to refuse certain categories of prompts.

Draw Things can run compatible community models, but:

- architecture must be supported
- model format must be supported
- model license matters
- LoRA compatibility matters
- memory requirements still apply

And local operation does **not** override the model's license or applicable law.

---

# 🔒 Privacy and Offline Operation

Draw Things is particularly attractive if your objective is:

> **Keep the image-generation workload on my Mac.**

The Free Edition supports local compute and downloading models to generate images locally and privately on the device. Draw Things also offers optional cloud/managed-server features, so users should distinguish **Local Compute** from Cloud Compute. citehttps://drawthings.ai/pricing/

For a strictly local workflow:

```text
Internet
   │
   ├── Download Draw Things
   ├── Download model
   │
   X  disconnect / remain offline
   │
   ▼
Draw Things
   │
   ▼
Apple Silicon
   │
   ▼
Image
```

Once the required model assets are present locally, generation itself can be performed locally.

---

# 🧠 LoRAs, ControlNet and Editing

A modern Draw Things workflow is not simply:

```text
Prompt → Model → Image
```

It can become:

```text
Base model
     │
     ├── LoRA
     │
     ├── reference image
     │
     ├── structural guidance
     │
     ├── mask
     │
     └── prompt
          │
          ▼
      Draw Things
          │
          ▼
        Image
```

This is where a smaller model can become much more capable.

Instead of downloading a huge number of base models:

```text
3–5 excellent base models
+
targeted LoRAs
```

is often the better strategy.

---

# 🧪 Model Testing Strategy

Do not simply ask:

> "Which model is best?"

Use a repeatable test.

### Test prompt

```text
A photorealistic photograph of a modern
Pacific Northwest home at sunset, wet pavement,
warm interior lighting, detailed landscaping,
three cars in the driveway, realistic reflections,
cinematic photography.
```

Test:

- same prompt
- same resolution
- same aspect ratio
- same number of steps
- same seed where supported

Compare:

1. Prompt adherence
2. Anatomy
3. Composition
4. Lighting
5. Text rendering
6. Fine detail
7. Generation time
8. Memory usage

Draw Things has also begun publishing its own human-evaluated Test Set, which is useful because image-model evaluation by another LLM can miss important visual errors. citehttps://releases.drawthings.ai/p/draw-things-test-set-a-status-update

---

# 🧰 Pro Local Workflow

For your environment I would use:

```text
                ┌───────────────┐
                │ Ollama /      │
                │ LM Studio     │
                └───────┬───────┘
                        │
                  Prompt creation
                        │
                        ▼
                ┌───────────────┐
                │ Draw Things   │
                └───────┬───────┘
                        │
             ┌──────────┼──────────┐
             ▼          ▼          ▼
           Image      Edit       Upscale
             │          │          │
             └──────────┼──────────┘
                        ▼
                  Local storage
```

For automation, Draw Things also has a command-line generation project, **draw-things-cli**, which the Draw Things team describes as a scriptable local media-generation CLI powered by the same custom inference stack. citehttps://releases.drawthings.ai/archive

That opens the door to:

```text
LLM
 ↓
Generate prompt
 ↓
draw-things-cli
 ↓
Generate image
 ↓
Save to NAS
 ↓
Home Assistant / web dashboard / asset pipeline
```

---

# ⚠️ Limitations

## 1. Memory remains king

A 32GB Mac cannot become a 64GB Mac because the M6 GPU is faster.

---

## 2. Larger resolution costs more

2K generation can be dramatically more demanding than 768/1024 generation.

---

## 3. Newer ≠ always better

A newer model may be:

- more accurate
- slower
- larger
- less compatible with existing LoRAs
- worse for a particular style

---

## 4. Community model compatibility varies

A model found online is not automatically compatible with Draw Things.

Check:

- architecture
- format
- quantization
- text encoder requirements
- VAE requirements
- LoRA compatibility

---

## 5. Model licenses matter

"Open weights" does not necessarily mean:

```text
public domain
```

or:

```text
commercially unrestricted
```

Always check the model's license.

---

# 🏁 Final Recommendations

## 🥇 Best all-around model for your 32GB Macs

### Z-Image Turbo

Why:

- only 6B parameters
- approximately 4GiB for Draw Things' 6-bit fully-loaded variant
- fast
- strong prompt adherence
- realistic results
- excellent for iteration

citehttps://releases.drawthings.ai/p/quantify-z-image-turbo-efficiency

---

## 🥇 Best newer general-purpose model

### FLUX.2 [klein] 4B

Excellent choice for:

- M1 32GB
- M4 Max 36GB
- M6 32GB

---

## 🥇 Best quality/size compromise

### FLUX.2 [klein] 9B

Especially good on:

```text
M4 Max 36GB
```

and usable on the 32GB systems with appropriate quantization and resolution.

---

## 🥇 Best for text and complex prompts

### Qwen Image 2512

Use the quantized version on your 32/36GB machines.

---

## 🥇 Best mature ecosystem

### SDXL + specialist checkpoint/LoRA

Still worth keeping because the community ecosystem is enormous.

---

# 🧠 The 2026 Draw Things Mental Model

The old model:

```text
SDXL → FLUX
```

is no longer sufficient.

The current landscape is better represented as:

```text
                     Draw Things
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
      FAST              QUALITY           EDITING
        │                 │                 │
 Z-Image Turbo     FLUX.2 [dev]      Qwen Image Edit
 FLUX.2 4B         FLUX.2 9B         FLUX.2 klein
        │                 │                 │
        └─────────────────┼─────────────────┘
                          │
                    SPECIALISTS
                          │
          ┌───────────────┼────────────────┐
          │               │                │
       Qwen Image       SDXL          Krea / Ideogram
       2512             ecosystem      / ERNIE / Anima
```

### For your machines:

```text
M1 MacBook Pro 32GB
    ↓
Z-Image Turbo
FLUX.2 klein 4B
Qwen Image 6-bit
SDXL

M4 Max MacBook Pro 36GB
    ↓
FLUX.2 klein 9B       ← primary
Z-Image Turbo         ← fast
Qwen Image 2512 6-bit
FLUX.2 dev            ← experiment

Mac mini M6 32GB
    ↓
FLUX.2 klein 4B       ← primary
Z-Image Turbo         ← fast
FLUX.2 klein 9B
Qwen Image 2512 6-bit
SDXL
```

---

# 🔗 Additional Resources

- Draw Things: https://drawthings.ai/
- Draw Things Downloads / release history: https://drawthings.ai/downloads/
- Draw Things Releases: https://releases.drawthings.ai/
- Draw Things Engineering: https://engineering.drawthings.ai/
- Hugging Face: https://huggingface.co/
- FLUX.2 [klein] 9B: https://huggingface.co/black-forest-labs/FLUX.2-klein-9B
- FLUX.2 [klein] Base 9B: https://huggingface.co/black-forest-labs/FLUX.2-klein-base-9B
- Civitai: https://civitai.com/
- ComfyUI: https://www.comfy.org/

---

# 📌 Bottom Line

**Draw Things in 2026 is much more than a Stable Diffusion app.**

It is becoming a serious **Apple-native local media-generation runtime**, supporting increasingly capable image/video architectures while optimizing them specifically for Apple Silicon.

For your hardware, don't chase the largest model.

Use:

> **Z-Image Turbo for speed → FLUX.2 [klein] for general quality → Qwen Image for difficult prompts/text → specialist SDXL models/LoRAs when you need them.**

And if your goal is privacy:

> **Download the model once, keep the model and generated assets local, and use Draw Things' Local Compute rather than Cloud Compute.**
