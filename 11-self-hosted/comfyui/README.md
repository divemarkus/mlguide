# ComfyUI — Advanced Local Image & Video Generation Guide

ComfyUI is one of the most important pieces of software to understand if you want to move beyond "type a prompt and get an image."

The simplest description is:

> **ComfyUI is a visual, node-based inference engine for generative AI. Instead of hiding the AI pipeline behind a simple UI, it exposes the entire pipeline so you can construct, modify, automate, and reproduce it.**

That distinction is what makes ComfyUI so powerful.

It now covers **image generation, image editing, video generation, audio, 3D, vision, and even text-generation workflows**, with support for models such as Flux.2, Qwen Image, Wan 2.x, HunyuanVideo, LTX, Hunyuan3D and many others. [GitHub](https://github.com/Comfy-Org/ComfyUI/blob/master/README.md?plain=1\&utm_source=chatgpt.com)

For your hardware, I would make the **RTX 3090 Ti your primary ComfyUI production machine**, while treating the Apple Silicon machines as extremely useful secondary/workstation platforms.

---

# 1. What exactly is ComfyUI?

Traditional generative-AI applications tend to look like:

```text
Prompt
   ↓
[ Generate ]
   ↓
Image
```

ComfyUI looks more like:

```text
                    ┌──────────────┐
                    │ Text Prompt  │
                    └──────┬───────┘
                           ↓
                    ┌──────────────┐
                    │ Text Encoder │
                    └──────┬───────┘
                           ↓
┌──────────┐       ┌──────────────┐
│ Checkpoint├──────►│   Sampler    │
└──────────┘       └──────┬───────┘
                           ↓
                    ┌──────────────┐
                    │     VAE      │
                    └──────┬───────┘
                           ↓
                    ┌──────────────┐
                    │    Image     │
                    └──────────────┘
```

But that can become:

```text
Prompt
  ↓
Text Encoder ───────────────┐
                            │
Reference Image → CLIP ─────┤
                            │
Pose Image → ControlNet ────┤
                            ↓
                       Conditioning
                            ↓
                    Diffusion Model
                            ↓
                       Sampler
                            ↓
                         VAE
                            ↓
                      Base Image
                            ↓
                 ┌──────────┴─────────┐
                 ↓                    ↓
             Upscaler             Face Detail
                 ↓                    ↓
                 └──────────┬─────────┘
                            ↓
                     Final Image
```

And that entire graph can be saved and reproduced.

ComfyUI describes itself as a **node-based interface and inference engine**, with reusable subgraphs, workflow templates, API access and partial graph re-execution. [GitHub](https://github.com/Comfy-Org/docs/blob/main/index.mdx?utm_source=chatgpt.com)

That last part is particularly important.

---

# 2. Why ComfyUI is different

The killer feature isn't actually the UI.

It's the **workflow graph**.

Every operation becomes a node.

For example:

| Node | Function |
|---|---|
| Load Checkpoint | Load model |
| Load Diffusion Model | Load DiT/diffusion component |
| CLIP/Text Encoder | Convert prompt into conditioning |
| Load Image | Import image |
| VAE Encode | Image → latent |
| VAE Decode | Latent → image |
| KSampler | Run diffusion |
| ControlNet | Structural control |
| LoRA | Add model adaptation |
| IPAdapter/reference | Guide appearance |
| Upscaler | Increase resolution |
| Mask | Define editable region |
| Composite | Combine images |
| Save Image | Output |

You can connect these together however you want.

This is fundamentally different from something like:

- Midjourney
- DALL-E-style interfaces
- basic Stable Diffusion frontends
- one-click image generators

Those are designed to **hide complexity**.

ComfyUI is designed to **expose complexity**.

That's why it has become so important to advanced users.

---

# 3. ComfyUI is really an inference engine

This is an important distinction for your ML Guide.

ComfyUI isn't itself the AI model.

Think of the architecture as:

```text
                 MODEL
                   │
      ┌────────────┴────────────┐
      │                         │
 Flux / Qwen / Wan / SDXL   LoRA / ControlNet
      │                         │
      └────────────┬────────────┘
                   ↓
               ComfyUI
           workflow engine
                   ↓
          PyTorch / backend
                   ↓
             GPU / RAM
```

This is similar to the distinction you've already made in your guide between a model and its runtime.

Your guide describes the model as the "brain" and the runner as the "body." README

For generative media, ComfyUI is effectively a **visual programmable body/inference engine**.

---

# 4. Why ComfyUI has become so dominant

There are several reasons.

### 1. Model neutrality

It isn't locked to one model family.

Current ComfyUI support includes:

**Images**

- Stable Diffusion
- SDXL
- SD3.5
- Flux.1
- Flux.2
- Qwen Image
- Z-Image
- Hunyuan Image
- HiDream
- Lumina
- Chroma
- and others

**Image editing**

- Flux Kontext
- Flux.2 Klein
- Qwen Image Edit
- HiDream
- OmniGen2
- LongCat Image Edit

**Video**

- Wan 2.1
- Wan 2.2
- LTX-Video
- HunyuanVideo
- CogVideoX
- Cosmos
- Mochi
- and others

**Audio**

- ACE-Step
- Stable Audio
- MiniMax
- etc.

**3D / vision**

- Hunyuan3D
- SAM
- Depth Anything
- SUPIR
- etc. [GitHub](https://github.com/Comfy-Org/ComfyUI/blob/master/README.md?plain=1\)

That is an enormous ecosystem.

---

# 5. The real superpower: composability

Suppose you want:

> Create a woman from a reference photo, maintain her face, put her in a cyberpunk city, control her pose, generate multiple shots, upscale them, then turn the sequence into video.

A normal AI application might require five different applications.

ComfyUI can potentially represent the entire process as one graph:

```text
REFERENCE IMAGE
      │
      ├──► Face / Identity conditioning
      │
      └──► Image encoder
                │
PROMPT ─────────┤
                ↓
          Conditioning
                │
POSE IMAGE ──► ControlNet
                │
                ↓
          Diffusion Model
                │
                ↓
             Sampler
                │
                ↓
          Generated Frame
                │
                ├──► Upscale
                │
                ├──► Face enhancement
                │
                └──► Video frames
                         │
                         ↓
                    Video Model
                         │
                         ↓
                       Video
```

That's where ComfyUI starts becoming much more than an image generator.

It becomes a **generative media pipeline**.

---

# 6. Image generation

For images, ComfyUI can handle workflows ranging from very simple:

```text
Prompt
 ↓
Flux
 ↓
VAE
 ↓
Image
```

to extremely complicated production pipelines.

For example:

```text
Prompt
     ↓
Qwen / Flux text encoding
     ↓
Reference image
     ↓
IP/Reference conditioning
     ↓
ControlNet
     ↓
LoRA
     ↓
Diffusion
     ↓
Sampler
     ↓
VAE
     ↓
Upscaler
     ↓
Face restoration
     ↓
Final image
```

And because each stage is exposed, you can change **one variable at a time**.

That's excellent for experimentation.

---

# 7. Flux.2 is particularly interesting

You mentioned previously hearing about **Flux.2 Klein**.

ComfyUI now has official workflows for Flux.2.

For example, the official Flux.2 Klein 9B workflow is designed for high-quality image generation at relatively low latency, while another workflow exposes Flux.2 Klein for image editing. [Comfy](https://comfy.org/workflows/image_flux2_text_to_image_9b-1606e79dd224/)

This is exactly where ComfyUI shines:

```text
Flux.2 Klein
       +
Reference image
       +
Prompt
       +
Control
       +
Upscaling
       ↓
Production image
```

Instead of simply asking a model to produce an image, you can construct a repeatable **production recipe** around it.

---

# 8. Video is where ComfyUI gets really interesting

This is probably the area you're most interested in.

Modern video generation models are considerably more demanding than image models.

A simplified image workflow:

```text
Text
 ↓
Diffusion
 ↓
Image
```

A video workflow becomes:

```text
Text
 ↓
Conditioning
 ↓
Video diffusion / DiT
 ↓
Temporal latent
 ↓
VAE
 ↓
Frames
 ↓
Video encoding
```

And then:

```text
Reference Image
       ↓
     Image-to-Video
       ↓
     Video Model
       ↓
  Motion / Temporal
    consistency
       ↓
      Frames
       ↓
     Upscale
       ↓
   Interpolation
       ↓
      Video
```

ComfyUI officially supports a growing set of video models including **Wan 2.1/2.2, LTX-Video, HunyuanVideo, CogVideoX, Cosmos and Mochi**. [GitHub](https://github.com/Comfy-Org/ComfyUI/blob/master/README.md?plain=1\)

It also has nodes for turning generated image sequences into video and attaching audio. [GitHub](https://github.com/Comfy-Org/docs/blob/main/built-in-nodes/image/video/create-video.mdx)

---

# 9. Wan is particularly important

For your lab, I'd pay very close attention to the **Wan family**.

Video generation is one of the areas where GPU architecture and memory become extremely important.

A 1024×1024 image isn't remotely equivalent to generating:

```text
1024 × 1024 × 81 frames
```

You are effectively asking the model to reason across a huge temporal tensor.

That means:

**VRAM + memory bandwidth + GPU compute become critical.**

This is where your RTX 3090 Ti becomes extremely valuable.

---

# 10. Your hardware

Your four systems make a surprisingly good ComfyUI laboratory.

I'd categorize them like this:

| Machine | ComfyUI role | Rating |
|---|---|---:|
| **RTX 3090 Ti / Windows 11** | Main production | ⭐⭐⭐⭐⭐ |
| **M4 Max / 36 GB** | Secondary production / experimentation | ⭐⭐⭐⭐ |
| **M6 Mac mini / 32 GB** | Always-on / experimentation | ⭐⭐⭐ |
| **M1 MacBook Pro / 32 GB** | Portable / lightweight workflows | ⭐⭐⭐ |

The important distinction is that **Apple Silicon has unified memory**, whereas your 3090 Ti has dedicated VRAM.

---

# 11. RTX 3090 Ti — your ComfyUI monster

This is the machine I'd use first.

You have:

**RTX 3090 Ti**

with:

- 24 GB GDDR6X VRAM
- CUDA
- Tensor Cores
- mature PyTorch/CUDA ecosystem
- enormous ComfyUI custom-node compatibility

This is extremely useful for:

- Flux
- Flux.2
- SDXL
- Qwen Image
- Wan
- HunyuanVideo
- LTX
- ControlNet
- LoRA
- upscaling
- image-to-video
- video workflows

NVIDIA is currently the **reference-class platform for serious local ComfyUI work** because so much of the generative-AI ecosystem is optimized around CUDA.

---

# 12. Why NVIDIA is usually faster/easier

The pipeline is roughly:

```text
ComfyUI
   ↓
PyTorch
   ↓
CUDA
   ↓
NVIDIA GPU
   ↓
Tensor Cores
```

The software ecosystem around CUDA is enormous.

You get access to optimizations such as:

- CUDA kernels
- FP16
- BF16
- FP8 where supported
- quantization
- optimized attention implementations
- Triton
- various video-specific accelerators
- specialized custom nodes

And the custom-node ecosystem frequently assumes NVIDIA first.

That's not necessarily because Apple hardware is bad.

It's because **CUDA has been the dominant AI acceleration platform for years**.

---

# 13. Apple Silicon is different

Your Macs use:

```text
CPU
GPU
Neural Engine
RAM
   ↓
Unified Memory
```

Instead of:

```text
CPU RAM          GPU VRAM
   │                │
   └── PCIe ────────┘
```

This is a major architectural difference.

Your:

**M1 32 GB**

**M4 Max 36 GB**

**M6 32 GB**

can potentially allocate a large model across their unified memory without the same discrete-VRAM boundary.

That is useful for very large models.

ComfyUI officially supports Apple Silicon, and the current project supports Windows, Linux and macOS as well as NVIDIA, AMD, Intel and Apple Silicon hardware. [GitHub](https://github.com/Comfy-Org/ComfyUI/blob/master/README.md)

---

# 14. But unified memory does NOT equal 36 GB VRAM

This is an important warning.

A:

**36 GB Apple Silicon Mac**

doesn't mean:

> "I have the equivalent of a 36 GB NVIDIA GPU."

The memory is shared with:

- macOS
- CPU
- applications
- GPU
- system services

And the GPU architecture and software stack are different.

So:

```text
36 GB Unified Memory
```

should not be interpreted as:

```text
36 GB dedicated CUDA VRAM
```

Performance depends heavily on:

- memory bandwidth
- GPU architecture
- PyTorch/MPS implementation
- model architecture
- precision
- attention implementation
- CPU/GPU synchronization
- model offloading

---

# 15. The Apple Silicon advantage

There is nevertheless a **very real advantage**.

Large model:

```text
Model = 25 GB
```

On:

### 24 GB NVIDIA GPU

You potentially have:

```text
VRAM
24 GB
   ↓
OOM / offload / optimization
```

On:

### 36 GB Apple Silicon

You potentially have:

```text
Unified Memory
36 GB
   ↓
Model + OS + CPU + GPU
```

That can make some models possible that would otherwise require aggressive offloading.

ComfyUI itself has sophisticated RAM/VRAM management and model offloading specifically to make large workflows possible on constrained hardware. [GitHub](https://github.com/Comfy-Org/ComfyUI/blob/master/README.md?plain=1\)

---

# 16. But Apple has a major weakness: MPS

Apple Silicon generally runs ComfyUI through Apple's **Metal/MPS backend** rather than CUDA.

Conceptually:

```text
ComfyUI
   ↓
PyTorch
   ↓
MPS
   ↓
Metal
   ↓
Apple GPU
```

CUDA:

```text
ComfyUI
   ↓
PyTorch
   ↓
CUDA
   ↓
NVIDIA GPU
```

CUDA currently has substantially broader optimization and compatibility in generative AI.

And this becomes particularly obvious with cutting-edge video models.

---

# 17. Apple + ComfyUI current reality

This is the part I would emphasize strongly in your guide.

**Apple Silicon works.**

But:

> **NVIDIA remains the safer choice for advanced ComfyUI experimentation.**

There are currently open reports involving Apple MPS and newer video workloads, including:

- LTX-2.x BF16 attention producing black video
- LTX 2.5 issues requiring alternate attention modes
- Wan 2.1/2.2 output corruption
- very large attention matrices causing MPS problems
- FP8 limitations

These aren't hypothetical limitations; they are active issues being investigated in the ComfyUI/PyTorch ecosystem. [GitHub](https://github.com/Comfy-Org/ComfyUI/issues/15804)

That doesn't make Apple bad.

It means:

**Apple is currently less predictable at the bleeding edge.**

---

# 18. FP8 is another major difference

This is particularly important with newer models.

Some current workflows use:

```text
FP32
FP16
BF16
FP8
INT8
NVFP4
```

NVIDIA has a much broader hardware/software ecosystem for these reduced-precision formats.

Apple MPS has historically had limitations around FP8.

There are still ComfyUI reports showing FP8 model loading failures on MPS. [GitHub](https://github.com/Comfy-Org/ComfyUI/issues/10292)

So when you see a model release that says:

> "Use FP8"

your:

**3090 Ti**

is generally a much better target than your Mac.

---

# 19. Your M4 Max

Your **M4 Max 36 GB** is nevertheless an excellent ComfyUI machine.

I'd use it for:

### Excellent

- SDXL
- Flux
- Flux.2 Klein
- Qwen Image
- image editing
- LoRAs
- ControlNet
- upscaling
- experimentation
- moderate video

### Less ideal

- very large video workflows
- huge temporal contexts
- bleeding-edge CUDA-specific nodes
- FP8-heavy workflows
- workflows depending on CUDA-only extensions

The M4 Max is probably your **best Apple machine for ComfyUI**.

---

# 20. Your M1 MacBook Pro 32 GB

This machine is surprisingly useful.

It isn't going to compete with the 3090 Ti.

But it makes a great:

> **portable ComfyUI development / workflow machine.**

I'd use it for:

- learning ComfyUI
- building graphs
- testing prompts
- SD1.5
- lightweight SDXL
- smaller Flux variants
- LoRAs
- image editing
- workflow development

You can construct a workflow on the M1 and then move the JSON to your 3090 Ti.

That is one of ComfyUI's greatest advantages.

---

# 21. Your M6 Mac mini

I'd actually give this machine a slightly different role.

If you're planning to keep it **always-on**, it could become:

```text
             M6 Mac mini
                  │
          ┌───────┴────────┐
          │                │
       ComfyUI          Storage
          │
          │
       API Server
```

Then your other machines can interact with it.

For example:

```text
M1 MacBook
     │
     ├───────────────┐
     │               │
M4 Max              M6 Mini
     │               │
     └────── ComfyUI ┘
```

However, I would **not automatically make the M6 your primary heavy video generator** until we benchmark the actual M6 configuration you have.

The architecture and memory bandwidth matter more than simply saying "M6."

---

# 22. ComfyUI workflows are portable

This is another killer feature.

A workflow can be saved as JSON.

For example:

```text
flux2_portrait.json
wan_i2v.json
qwen_image_edit.json
upscale_pipeline.json
```

You can then:

```text
Build workflow
     ↓
Save JSON
     ↓
Git
     ↓
3090 Ti
     ↓
Mac
     ↓
another NVIDIA system
```

ComfyUI can also embed/recover workflows from generated media in supported formats, and the workflow library exposes downloadable workflow JSON. [GitHub](https://github.com/Comfy-Org/ComfyUI/blob/master/README.md?plain=1\)

That makes ComfyUI unusually attractive for your **GitHub-based ML Guide**.

---

# 23. This is where ComfyUI becomes "engineering"

For you specifically, I'd treat workflows almost like source code.

For example:

```text
comfyui/
│
├── workflows/
│   ├── image/
│   │   ├── flux2-klein.json
│   │   ├── qwen-image.json
│   │   └── sdxl.json
│   │
│   ├── video/
│   │   ├── wan22-t2v.json
│   │   ├── wan22-i2v.json
│   │   └── ltx.json
│   │
│   └── upscale/
│       └── 4x-upscale.json
│
├── models/
├── custom_nodes/
├── scripts/
└── README.md
```

Then Git becomes your workflow management system.

---

# 24. Custom Nodes

This is another reason ComfyUI is so powerful.

The base system provides the core graph.

Then developers can add **custom nodes**.

You can effectively extend ComfyUI with new:

- models
- samplers
- preprocessors
- video tools
- ControlNets
- image processors
- segmentation
- face recognition
- audio processing
- API integrations
- utility nodes

The official documentation provides a custom-node development and registry ecosystem. [GitHub](https://github.com/Comfy-Org/docs/blob/main/index.mdx)

This makes ComfyUI more like:

> **Blender + Python + AI inference pipelines**

than a traditional image generator.

---

# 25. Advanced toolset

This is where I would divide the ComfyUI learning curve.

### Beginner

```text
Prompt
 ↓
Model
 ↓
Sampler
 ↓
VAE
 ↓
Image
```

### Intermediate

```text
Checkpoint
 +
LoRA
 +
ControlNet
 +
Image conditioning
 +
Upscaling
```

### Advanced

```text
Multiple models
      ↓
Multiple conditioning paths
      ↓
ControlNet
      ↓
IP/reference conditioning
      ↓
Regional prompting
      ↓
Masks
      ↓
Multiple samplers
      ↓
Latent manipulation
      ↓
Upscaling
      ↓
Face/detail pass
```

### Expert

```text
Multiple diffusion models
        ↓
Custom conditioning
        ↓
LoRA stacks
        ↓
ControlNet
        ↓
Temporal conditioning
        ↓
Video latent manipulation
        ↓
Frame interpolation
        ↓
Upscaling
        ↓
Audio
        ↓
Final video
```

That's where ComfyUI starts becoming a serious **AI media engineering environment**.

---

# 26. ControlNet

One of the most important concepts to learn.

Instead of saying:

> "Make the person stand like this."

you provide an actual structural guide.

For example:

```text
Reference photo
      +
Pose skeleton
      +
Depth map
      +
Prompt
      ↓
ComfyUI
      ↓
Generated image
```

ControlNet can provide constraints such as:

- pose
- edges
- depth
- segmentation
- composition

This is one of the things that separates serious controlled generation from random image generation.

---

# 27. LoRA

LoRA is another foundational technology.

Think:

```text
Base Model
     +
LoRA
     ↓
Specialized behavior
```

Examples:

```text
Flux
 +
Character LoRA
```

or:

```text
Flux
 +
Anime LoRA
```

or:

```text
SDXL
 +
Product photography LoRA
```

ComfyUI makes stacking and controlling these components particularly transparent.

---

# 28. Reference conditioning

This gets even more interesting.

You can provide:

```text
Image A = person
Image B = clothing
Image C = environment
Prompt = scene
```

and construct a graph that combines them.

That gives you a form of **visual compositional programming**.

---

# 29. Inpainting / outpainting

ComfyUI can also selectively regenerate portions of an image.

Example:

```text
Original image
       ↓
Mask face
       ↓
Regenerate face
       ↓
Composite
```

Or:

```text
Original image
       ↓
Expand canvas
       ↓
Generate missing area
       ↓
Outpaint
```

This makes it possible to build much more sophisticated editing pipelines than simply "generate another image."

---

# 30. Upscaling

This is another area where ComfyUI is excellent.

You can separate:

```text
Generation resolution
```

from:

```text
Final delivery resolution
```

For example:

```text
Generate
1024 × 1024
       ↓
Upscale
2048 × 2048
       ↓
Detail enhancement
       ↓
4096 × 4096
```

This is generally much more practical than asking the diffusion model to directly generate an enormous image.

---

# 31. Video workflows can become pipelines

Imagine:

```text
IMAGE
 │
 ↓
Image-to-video
 │
 ↓
Wan
 │
 ↓
24 frames
 │
 ↓
Temporal enhancement
 │
 ↓
Upscale
 │
 ↓
Frame interpolation
 │
 ↓
Audio
 │
 ↓
MP4
```

And then automate it.

That's why I think your description of ComfyUI as a "video and image generation tool" is actually underselling it.

It's better described as:

> **A programmable generative-media pipeline engine.**

---

# 32. ComfyUI vs other tools

Here's how I would categorize the landscape.

| Tool | Philosophy | Strength |
|---|---|---|
| **ComfyUI** | Node graph | Maximum control |
| Automatic1111 | Traditional UI | Easy SD experimentation |
| Forge | Optimized SD UI | Faster/easier SD |
| InvokeAI | Production UI | Artist-friendly |
| Fooocus | Simplified generation | Ease of use |
| Draw Things | Apple-focused | Excellent Mac experience |
| Midjourney | Hosted generation | Ease + aesthetics |
| Runway | Hosted video | Polished video |
| Kling | Hosted video | High-end video |
| Sora | Hosted AI video | High-level generation |
| **ComfyUI** | Local/programmable | **Control + automation + models** |

The important point is:

**ComfyUI doesn't necessarily win at simplicity.**

It wins at:

> **Control.**

---

# 33. ComfyUI vs Draw Things

This is particularly relevant because you've already been exploring Draw Things.

### Draw Things

```text
User
 ↓
Simple UI
 ↓
Model
 ↓
Image
```

Excellent for:

- Mac
- quick generation
- experimentation
- artists
- mobile workflows
- simple editing

### ComfyUI

```text
User
 ↓
Workflow
 ↓
Nodes
 ↓
Models
 ↓
Conditioning
 ↓
Sampler
 ↓
Postprocessing
 ↓
Automation
 ↓
Output
```

ComfyUI is considerably more complicated.

But it gives you dramatically more control.

I'd keep **both**.

---

# 34. The really important feature: partial execution

Suppose your workflow is:

```text
Load Image
    ↓
ControlNet
    ↓
Flux
    ↓
Upscale
    ↓
Face enhancement
```

You change only the final upscaler.

ComfyUI doesn't necessarily need to recompute everything upstream.

Its execution engine can reuse parts of the graph whose inputs haven't changed. [GitHub](https://github.com/Comfy-Org/ComfyUI/blob/master/README.md?plain=1\)

That's extremely useful when experimenting.

---

# 35. ComfyUI can be an API

This is another reason I think it fits your infrastructure mindset extremely well.

Instead of:

```text
Human
 ↓
ComfyUI GUI
```

you can do:

```text
Python
   ↓
ComfyUI API
   ↓
Workflow
   ↓
GPU
   ↓
Image/video
```

So you can build:

```text
Home Assistant
       ↓
Webhook
       ↓
Python
       ↓
ComfyUI
       ↓
Image
       ↓
Nextcloud
```

Or:

```text
AI Agent
   ↓
"Generate product image"
   ↓
ComfyUI API
   ↓
Flux/Qwen
   ↓
Image
```

The official documentation specifically supports running workflows against a deployment and integrating ComfyUI into applications. [GitHub](https://github.com/Comfy-Org/docs/blob/main/index.mdx)

---

# 36. This fits your local-AI philosophy extremely well

Your ML guide emphasizes:

> **All inference happens locally unless explicitly configured otherwise.** ollama-setup

ComfyUI fits that philosophy almost perfectly.

The core application can operate fully offline, with models stored locally. ComfyUI also provides optional API nodes for external/paid services, meaning you can choose whether to leave your local environment. [GitHub](https://github.com/Comfy-Org/ComfyUI/blob/master/README.md?plain=1\)

So you could have:

```text
                  YOUR LAB
                     │
        ┌────────────┼────────────┐
        │            │            │
      Mac          Mac Mini      3090 Ti
        │            │            │
        └────────────┼────────────┘
                     │
                  ComfyUI
                     │
            Local Models
                     │
        ┌────────────┼────────────┐
        │            │            │
      Images       Video         Audio
```

No cloud required.

---

# 37. Your ideal ComfyUI architecture

I'd actually build your environment around the 3090 Ti.

### Primary

```text
Windows 11
RTX 3090 Ti
       │
       ↓
    ComfyUI
       │
       ├── Flux / Flux.2
       ├── Qwen Image
       ├── SDXL
       ├── Wan
       ├── HunyuanVideo
       ├── LTX
       └── Upscalers
```

### Apple development machines

```text
M1 MacBook Pro
        │
        └── ComfyUI development/testing

M4 Max MacBook
        │
        └── Apple Silicon production/testing

M6 Mac mini
        │
        └── Always-on ComfyUI/API/storage
```

Then you can decide per workflow:

```text
Image generation
       ↓
Mac OR 3090

Heavy video
       ↓
3090 Ti

Workflow development
       ↓
M1/M4

Always-on API
       ↓
M6
```

---

# 38. My recommendation for your four systems

### 🥇 RTX 3090 Ti — **Primary**

Use for:

- Flux
- Flux.2
- Qwen Image
- SDXL
- Wan
- HunyuanVideo
- LTX
- serious video
- high-resolution generation
- complex graphs
- custom nodes

**This should be your ComfyUI workhorse.**

---

### 🥈 M4 Max 36 GB — **Apple workstation**

Use for:

- Flux.2 Klein
- Qwen Image
- image editing
- SDXL
- LoRA
- ControlNet
- experimentation
- moderate video

It's also excellent when you want a **quiet, portable AI workstation**.

---

### 🥉 M6 Mac mini 32 GB — **Always-on node**

Potential uses:

- ComfyUI server
- API endpoint
- workflow testing
- lightweight image generation
- automation
- model storage
- local media pipeline

I would benchmark this before assigning it heavy video duties.

---

### M1 MacBook Pro 32 GB — **Learning / portable**

Excellent for:

- learning ComfyUI
- developing workflows
- lightweight models
- prompt experimentation
- image editing
- testing JSON workflows

Then transfer the workflow to the 3090 Ti.

---

# 39. The biggest thing to learn

Don't start by downloading 100 models.

Start by learning **one workflow**.

I'd recommend:

```text
Load Image
     ↓
Text Prompt
     ↓
Model
     ↓
Sampler
     ↓
VAE
     ↓
Save Image
```

Then add:

```text
LoRA
```

Then:

```text
ControlNet
```

Then:

```text
Reference image
```

Then:

```text
Upscaling
```

Then:

```text
Image-to-video
```

Then:

```text
API automation
```

That progression teaches the actual architecture.

---

# 40. The ComfyUI learning ladder I'd use for your ML Guide

```text
LEVEL 1
ComfyUI fundamentals
      ↓
LEVEL 2
Stable Diffusion / SDXL
      ↓
LEVEL 3
Flux / Qwen Image
      ↓
LEVEL 4
LoRA + ControlNet
      ↓
LEVEL 5
Reference / identity workflows
      ↓
LEVEL 6
Upscaling / restoration
      ↓
LEVEL 7
Image-to-video
      ↓
LEVEL 8
Wan / Hunyuan / LTX
      ↓
LEVEL 9
Complex multi-stage workflows
      ↓
LEVEL 10
ComfyUI API
      ↓
LEVEL 11
Python automation
      ↓
LEVEL 12
Agent → ComfyUI → Media pipeline
```

That last level is where I think this becomes particularly interesting for **your** lab.

---

# 41. ComfyUI + AI Agents

Imagine eventually doing:

```text
                    AI Agent
                       │
                       │ "Create a cinematic
                       │  cyberpunk sequence"
                       ↓
                 ComfyUI API
                       │
            ┌──────────┼──────────┐
            ↓          ↓          ↓
          Flux        Wan       Upscaler
            │          │          │
            └──────────┼──────────┘
                       ↓
                     Video
                       ↓
                    Nextcloud
```

Your existing local AI architecture already has the same philosophy: local models, agents, Qdrant, Flowise, APIs and automation. OLLAMA-STACKv1

ComfyUI becomes the **visual-generation engine inside that architecture**.

---

# 42. Why I would put ComfyUI in your ML Guide

I would give it a prominent position alongside:

```text
                 LOCAL AI
                    │
       ┌────────────┼────────────┐
       │            │            │
      LLM          Agent       Media
       │            │            │
    Ollama       OpenClaw     ComfyUI
    LM Studio    Hermes       Draw Things
       │            │            │
       └────────────┼────────────┘
                    │
               Automation
```

And explain the distinction:

| Tool | Primary job |
|---|---|
| Ollama | Run LLMs |
| LM Studio | Manage/test/serve LLMs |
| OpenWebUI | Chat interface |
| OpenClaw/Hermes | Agentic execution |
| Flowise | Visual AI orchestration |
| Draw Things | Easy local image generation |
| **ComfyUI** | **Advanced generative-media pipelines** |

---

# 43. Bottom line

**Yes — ComfyUI absolutely deserves a major section in your ML Guide.**

And I would go even further:

> **For local open-source image/video generation, ComfyUI should probably be your primary advanced platform.**

Not because it necessarily produces prettier images with one click.

It doesn't.

Its advantage is that it gives you **control over the entire generative pipeline**.

And the combination of:

**ComfyUI + Flux/Qwen + Wan/Hunyuan/LTX + ControlNet + LoRA + reference conditioning + upscaling + API automation**

is an extremely powerful local generative-media stack.

For your hardware specifically:

```text
             YOUR COMFYUI LAB
                    │
       ┌────────────┼────────────┐
       │            │            │
     M1 32GB      M4 Max       M6 32GB
       │           36GB          │
       │            │            │
       └────────────┼────────────┘
                    │
             Workflow Development
                    │
                    ▼
             RTX 3090 Ti 24GB
                    │
                    ▼
           ┌─────────────────┐
           │    ComfyUI      │
           ├─────────────────┤
           │ Flux / Flux.2   │
           │ Qwen Image      │
           │ SDXL            │
           │ Wan             │
           │ HunyuanVideo    │
           │ LTX             │
           │ ControlNet      │
           │ LoRA            │
           │ Upscaling       │
           └────────┬────────┘
                    │
             API / Automation
                    │
                    ▼
             Your AI Ecosystem
```

**The 3090 Ti is the machine I'd target for serious generation, especially video.** The Macs are still extremely valuable because they give you portable/quiet development and a large unified-memory environment, but current MPS limitations mean I would not replace the NVIDIA machine with Apple Silicon for cutting-edge ComfyUI video work. [GitHub](https://github.com/Comfy-Org/ComfyUI/issues/15804)

And importantly, ComfyUI is moving toward being more than a local UI: its current ecosystem includes workflow templates, APIs, custom nodes, MCP/agent integration and even access to partner models. [GitHub](https://github.com/Comfy-Org/docs/blob/main/index.mdx)

[ComfyUI official documentation](https://docs.comfy.org/)  
[ComfyUI official workflows](https://comfy.org/workflows/)  
[ComfyUI GitHub repository](https://github.com/Comfy-Org/ComfyUI)

