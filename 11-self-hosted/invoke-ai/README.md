# InvokeAI — Where It Fits in Your Local AI Image Stack

**InvokeAI is worth adding to your ML Guide**, especially because your hardware gives you an unusually good split between Apple Silicon and NVIDIA.

The important distinction is:

> **Draw Things is optimized for simplicity and Apple Silicon.  
> InvokeAI is optimized for a polished creative workflow + controllability.  
> ComfyUI is optimized for maximum workflow control and experimentation.**

All three can run many of the same underlying models. The major difference is **how much of the generation pipeline they expose to you**.

InvokeAI is currently at **6.14.2 (September 27, 2026)** and has expanded considerably beyond its original Stable Diffusion focus. Current Invoke includes node workflows, layer-based Canvas editing, ControlNet, LoRA workflows, video generation through Wan 2.2, Flux.2 Dev, Krea 2, Ideogram 4, Anima, Qwen Image models, and multi-GPU support. [InvokeAI Documentation](https://invoke.ai/)

---

# 1. What Is InvokeAI?


**InvokeAI** is an open-source, locally hosted generative-art platform.

It sits somewhere between:

- a traditional image-generation application
- a Photoshop-like creative environment
- a node-based workflow engine
- a model management system
- an image editing/inpainting environment

The project describes itself as a "creative engine" rather than simply an image generator. Its major differentiator is the **Unified Canvas**, where generation, inpainting, outpainting, compositing and layer-based editing can happen in one environment. [InvokeAI Documentation](https://invoke.ai/)

It is also **Apache 2.0 licensed**, self-hosted and designed to run locally. [InvokeAI Documentation](https://invoke.ai/)

That fits your privacy-first ML philosophy particularly well.

Your existing ML Guide emphasizes on-premise/offline-capable AI and keeping inference local. README

---

# 2. The Three Tools Are Not Really Competitors

I'd actually organize them like this:

```text
                    LOCAL IMAGE GENERATION
                           │
          ┌────────────────┼────────────────┐
          │                │                │
       Draw Things     InvokeAI          ComfyUI
          │                │                │
       EASY / FAST       CREATIVE        MAX CONTROL
          │             WORKFLOW            │
          │                │                │
     Apple-first       Hybrid GUI +       Node engine
                       node workflow
          │                │                │
       Beginner         Intermediate       Advanced
          │                │                │
       "Make image"   "Create/edit art"   "Build pipeline"
```

And there is an important common layer underneath:

```text
             MODEL ECOSYSTEM
                   │
      ┌────────────┼────────────┐
      │            │            │
     FLUX        Qwen         Z-Image
      │            │            │
   SDXL / SD1.5 / Wan / Krea / Anima / etc.
```

The **model is the actual generative intelligence**.

The application determines how you interact with it.

This is analogous to the "Brain vs Body" model in your existing guide: the model is the weights, while the runtime/application provides the machinery around them. README

---

# 3. InvokeAI's Big Differentiator: Unified Canvas

This is probably the feature I'd emphasize most in your guide.

Invoke's Canvas isn't simply an image viewer.

You can think of it as:

```text
                  INVOKEAI CANVAS

                       Image
                         │
             ┌───────────┴───────────┐
             │                       │
          Paint                   Generate
             │                       │
        Mask / Sketch           Text → Image
             │                       │
             ├───────────┬───────────┤
             │           │           │
          Inpaint     Outpaint     ControlNet
             │           │           │
             └───────────┴───────────┘
                         │
                    Final Image
```

That makes Invoke particularly interesting for:

- concept art
- character development
- iterative image editing
- environment design
- product visualization
- compositing
- storyboards
- correcting specific portions of an image
- maintaining composition while iterating

Invoke explicitly supports layer-based Canvas editing and ControlNet workflows. [InvokeAI Documentation](https://invoke.ai/)

---

# 4. InvokeAI Node Workflows

This is where Invoke starts overlapping with ComfyUI.

Invoke has its own node-based workflow system.

You can build something like:

```text
Prompt
   │
   ▼
Text Encoder
   │
   ▼
Model
   │
   ├──────────────┐
   │              │
Reference       ControlNet
Image             │
   │              │
   └───────┬──────┘
           ▼
       Sampler
           │
           ▼
          VAE
           │
           ▼
        Upscale
           │
           ▼
         Output
```

But **Invoke's node system isn't ComfyUI's node system**.

Invoke's documentation explicitly notes that its backend differs from ComfyUI and that Comfy workflows cannot simply be imported directly into InvokeAI. [InvokeAI Documentation](https://invoke.ai/features/workflows/comfyui-migration/)

That is important if you're thinking:

> "Can I download a ComfyUI workflow and just open it in Invoke?"

**No.**

You generally need to recreate/adapt the workflow.

---

# 5. InvokeAI vs ComfyUI

This is probably the most important comparison for you.

| Category | InvokeAI | ComfyUI |
|---|---:|---:|
| Ease of use | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Creative Canvas | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Node workflows | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Fine pipeline control | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Model experimentation | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Community workflows | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Custom nodes | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Image editing | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Inpainting/outpainting | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| ControlNet | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| LoRA | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Video | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Beginner friendliness | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| Reproducibility | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Production pipelines | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| "Just make an image" | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Experimental AI workflows | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

ComfyUI's advantage is enormous extensibility: the current Comfy ecosystem advertises thousands of community extensions/nodes and supports image, video, audio and 3D workflows. [Comfy](https://comfy.org/download/)

So:

### InvokeAI

> **"I want to create something."**

### ComfyUI

> **"I want to engineer the generation pipeline."**

That's a very useful distinction.

---

# 6. InvokeAI vs Draw Things

This one is particularly relevant to you because of your Macs.



| | Draw Things | InvokeAI |
|---|---:|---:|
| Apple Silicon | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Mac simplicity | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| NVIDIA | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Canvas editing | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Model breadth | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Node workflows | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Advanced workflows | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Installation | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Mobile/iPad ecosystem | ⭐⭐⭐⭐⭐ | ⭐ |
| Batch generation | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| LoRA | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Video | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Automation | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Experimentation | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

Draw Things has also evolved dramatically. Its 2026 releases added/expanded support for **FLUX.2 Klein 4B/9B, Krea 2, Ideogram 4, Anima, Qwen Image, Z-Image, LTX video**, LoRA training and Apple Neural Engine acceleration on newer Apple hardware. [Draw Things](https://drawthings.ai/downloads/)

So I wouldn't characterize Draw Things as merely a "simple Stable Diffusion app" anymore.

It's becoming a very serious **Apple-native generative media environment**.

---

# 7. Your M1 MacBook Pro 32GB

### Verdict: Very good InvokeAI machine

Invoke explicitly supports Apple Silicon and recommends **16GB+ unified memory**. [InvokeAI Documentation](https://invoke.ai/start-here/system-requirements/)

Your:

**M1 Pro/Max-class MacBook Pro + 32GB**

is therefore quite usable.

I'd use it for:

- SDXL
- FLUX variants
- smaller FLUX.2 models
- Qwen Image variants
- Z-Image
- LoRA experimentation
- image editing
- Canvas work
- learning Invoke workflows

But don't expect it to compete with your 3090 Ti for heavy NVIDIA-oriented workflows.

### Your M1's role

I'd designate it:

> **Portable AI art workstation**

Draw Things will probably feel better/faster on this machine for casual generation.

Invoke is worth installing if you specifically want to learn the Invoke workflow.

---

# 8. M4 Max 36GB

This becomes much more interesting.

Your **M4 Max / 36GB** is arguably the better Apple machine for InvokeAI.

Apple Silicon has a very different memory architecture from your NVIDIA machine:

```text
RTX 3090 Ti
24 GB VRAM
       │
       ▼
CUDA GPU memory
       │
       └── CPU RAM separate


M4 Max
36 GB Unified Memory
       │
       ├── CPU
       ├── GPU
       └── Neural Engine
```

That makes larger models possible without the same hard VRAM boundary, although **memory bandwidth and software optimization** still determine performance.

Draw Things has been particularly aggressive about exploiting Apple's hardware; its 2026 releases include Apple Neural Engine support on M4 and newer optimizations for M5 hardware. [Draw Things](https://drawthings.ai/downloads/)

InvokeAI supports Apple Silicon, but if you're looking for absolute Apple-specific optimization, **Draw Things remains the first application I'd reach for**.

### M4 Max recommendation

```text
Draw Things → primary
InvokeAI    → secondary / advanced workflows
ComfyUI     → experimentation
```

---

# 9. M6 Mac mini

Assuming you're referring to your newer **M6 Mac mini configuration**, this could become your most interesting **always-on Apple AI image server/workstation**.

I'd treat it differently from the laptops.

```text
M6 Mac mini
     │
     ├── InvokeAI server
     ├── Draw Things
     ├── ComfyUI
     ├── model repository
     └── network-accessible image generation
```

That fits particularly well with your existing philosophy of having machines that remain available as local infrastructure rather than simply being desktop applications.

Your ML environment already follows this model with local services such as Ollama, OpenWebUI, Qdrant and Flowise. OLLAMA-STACKv1

The Mac mini could effectively become:

> **Apple Silicon AI media appliance**

while the Windows 3090 Ti remains the heavy GPU workstation.

---

# 10. RTX 3090 Ti — Your Heavyweight

This is the machine I'd put first for **InvokeAI and ComfyUI**.

You have:

**RTX 3090 Ti — 24GB VRAM**

That is a very useful amount of VRAM for modern image-generation models.

Invoke's current requirements show:

| Model | Invoke recommended VRAM |
|---|---:|
| SD 1.5 | ~4GB |
| SDXL | ~8GB |
| FLUX.1 | ~10GB |
| FLUX.2 Klein 4B | ~12GB |
| FLUX.2 Klein 9B | ~24GB |
| Z-Image Turbo | ~8GB |
| Wan 2.2 A14B | ~12GB |
| Wan 2.2 TI2V-5B | ~8GB |

These are approximate requirements and vary by precision/resolution/workflow. [InvokeAI Documentation](https://invoke.ai/start-here/system-requirements/)

This is where your 3090 Ti becomes particularly attractive.

### 24GB is a sweet spot.

You can realistically experiment with:

- FLUX.1
- FLUX.2
- FLUX.2 Klein
- Qwen Image
- Qwen Image Edit
- Z-Image
- Wan
- LoRAs
- ControlNet
- high-resolution workflows
- multi-stage upscaling
- image-to-image
- inpainting
- video experimentation

Invoke's current release also supports **multi-GPU**, although that's not something you need immediately with a 3090 Ti. [InvokeAI Documentation](https://invoke.ai/releases/)

---

# 11. FLUX.2 Is Particularly Interesting

This is one reason I think Invoke belongs in your current guide.

Invoke now supports **FLUX.2 Dev**, while Draw Things and ComfyUI have also moved heavily into the FLUX.2 ecosystem. [InvokeAI Documentation](https://invoke.ai/releases/)

The current FLUX family is roughly:

```text
FLUX
 │
 ├── FLUX.1 Schnell
 │      └── fast generation
 │
 ├── FLUX.1 Dev
 │      └── high quality
 │
 ├── FLUX.1 Kontext
 │      └── instruction-based editing
 │
 ├── FLUX.2 Klein
 │      ├── 4B
 │      └── 9B
 │
 └── FLUX.2 Dev
        └── large / high-quality / multi-reference
```

Comfy's current documentation describes FLUX.2 Dev as a **32B** model with multi-reference generation and up to 4MP output, while FLUX.2 Klein 4B is aimed at much lower VRAM requirements. [Comfy](https://comfy.org/workflows/model/flux/)

For your hardware:

### RTX 3090 Ti

**FLUX.2 Klein 4B → easy**

**FLUX.2 Klein 9B → very interesting**

**FLUX.2 Dev → possible depending on quantization/offload/workflow**

### M4 Max 36GB

**Klein → excellent candidate**

**larger models → potentially very interesting**

### M1 32GB

**Klein/smaller variants → realistic**

### M6

Potentially the most interesting Apple platform of your group, depending heavily on its actual memory configuration and the maturity of the backend.

---

# 12. Where ComfyUI Wins

If you eventually want to get really deep into generative AI, **learn ComfyUI**.

Not because it is the easiest.

It isn't.

But because it exposes the machinery.

For example:

```text
                    PROMPT
                       │
                       ▼
                 Text Encoder
                       │
                       ▼
Image ──► VAE ──► Conditioning
                       │
                       ▼
Reference ──► IPAdapter
                       │
                       ▼
Pose ──► ControlNet
                       │
                       ▼
                  Sampler
                       │
                       ▼
                     VAE
                       │
                       ▼
                   Upscaler
                       │
                       ▼
                     Save
```

You can essentially turn an image-generation application into a **visual programming environment for generative models**.

That's why ComfyUI has become so dominant among technically sophisticated users.

And given your engineering background, I suspect you'll eventually appreciate ComfyUI more than the average user.

---

# 13. Where InvokeAI Wins

Invoke is the one I'd choose when you want to **actually make artwork** rather than spend your afternoon building a graph.

For example:

> "Take this image, extend the background, change the person's clothes, preserve the face, add this reference object, then upscale."

Invoke's Canvas is extremely well suited to this type of iterative work.

ComfyUI can absolutely do it.

But you may end up constructing:

```text
Load Image
   ↓
Mask
   ↓
VAE
   ↓
ControlNet
   ↓
Reference
   ↓
IPAdapter
   ↓
Conditioning
   ↓
Sampler
   ↓
VAE Decode
   ↓
Upscaler
   ↓
Save
```

Invoke tries to make that **creative activity** rather than **pipeline engineering**.

---

# 14. Where Draw Things Wins

For your Apple machines:

> **Draw Things is the "I want to generate something right now" application.**

It has become remarkably capable.

Its recent releases include:

- FLUX.2
- Krea 2
- Ideogram 4
- Anima
- Qwen Image
- Z-Image
- LTX video
- LoRA training
- Apple Neural Engine acceleration
- newer Apple-specific optimizations. [Draw Things](https://drawthings.ai/downloads/)

That makes it extremely attractive on:

**M1 → M4 → M6**

especially if you don't want to maintain a complicated Python environment.

---

# 15. My Recommendation for YOUR Machines

I would **not choose one**.

I'd deliberately install all three.

### Your AI Image Generation Lab

```text
                    YOUR IMAGE AI LAB
                           │
             ┌─────────────┼─────────────┐
             │             │             │
          Apple          Apple         NVIDIA
           M1            M4 Max       RTX 3090 Ti
          32GB            36GB          24GB
             │             │             │
             ▼             ▼             ▼
        Draw Things     Draw Things    ComfyUI
             │             │             │
          InvokeAI      InvokeAI       InvokeAI
             │             │             │
             └─────────────┼─────────────┘
                           │
                           ▼
                    Shared Models
                    FLUX / Qwen /
                  Z-Image / Wan /
                    LoRAs / etc.
```

And I'd add the M6 Mac mini as:

```text
                 M6 Mac mini
                     │
                     ▼
              ALWAYS-ON AI NODE
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
    InvokeAI      ComfyUI     Draw Things
        │            │
        └──────┬─────┘
               ▼
        Network / API Access
```

---

# 16. My Personal Ranking for You

Considering **your engineering background, local-first philosophy, Apple hardware and 3090 Ti**:

### 🥇 ComfyUI

**Most important to learn deeply.**

Maximum flexibility, huge ecosystem, excellent support for experimental models and workflows.

### 🥈 InvokeAI

**Best overall creative environment.**

Much friendlier than ComfyUI while still giving you serious workflow control.

### 🥉 Draw Things

**Best Apple-native experience.**

Extremely convenient and increasingly powerful.

But I would not call Draw Things "third-rate." Quite the opposite — on Apple Silicon it may be the **fastest path from model → image**.

---

# 17. The Stack I'd Actually Build

I'd make your setup:

```text
                         AI MEDIA LAB
                              │
             ┌────────────────┼─────────────────┐
             │                │                 │
         DRAW THINGS       INVOKEAI          COMFYUI
             │                │                 │
        Apple Native      Creative GUI       Workflow
             │             + Nodes            Engine
             │                │                 │
             └────────────────┼─────────────────┘
                              │
                              ▼
                       MODEL LIBRARY
                              │
             ┌────────────────┼─────────────────┐
             │                │                 │
           FLUX            QWEN IMAGE        Z-IMAGE
             │                │                 │
             ├─────────────── ┼─────────────────┤
             │                │                 │
            WAN            KREA 2            ANIMA
```

Then:

**M1 32GB**

→ portable/local experimentation

**M4 Max 36GB**

→ premium Apple image generation

**M6 Mac mini**

→ always-on local AI/media node

**RTX 3090 Ti**

→ heavy generation, experimentation, ComfyUI, large models and video

---

# 18. One Important Change I'd Make to Your ML Guide

I would create a new section called:

## Generative Media Runtimes

and put these underneath it:

| Tool | Primary Role | Best Hardware |
|---|---|---|
| **Draw Things** | Apple-native image/video generation | Apple Silicon |
| **InvokeAI** | Creative image generation + editing | Apple + NVIDIA |
| **ComfyUI** | Advanced visual workflow engine | NVIDIA especially |
| **Automatic1111** | Classic Stable Diffusion UI | NVIDIA |
| **Forge** | Faster/easier SD ecosystem | NVIDIA |
| **Fooocus** | Simple high-quality generation | NVIDIA |
| **Krita AI** | AI-assisted painting | GPU workstation |

Then separately have:

```text
                 GENERATIVE MEDIA
                        │
        ┌───────────────┼────────────────┐
        │               │                │
      IMAGE           VIDEO            AUDIO
        │               │                │
   InvokeAI          ComfyUI           ...
   Draw Things       Wan
   ComfyUI           LTX
```

That would fit your existing ML Guide architecture much better than treating InvokeAI as another "model runner." Your guide already separates **models, runners and agent frameworks**, which is exactly the right conceptual structure. README

**Bottom line:** I'd absolutely add InvokeAI to your toolkit. **ComfyUI should be your laboratory, InvokeAI your creative studio, and Draw Things your Apple-native quick-generation tool.** With your 3090 Ti plus Apple Silicon machines, you don't need to choose one ecosystem—you can use each where it is strongest.