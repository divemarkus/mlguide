# MLX Models (Apple Silicon)

I checked the **current Apple-Silicon MLX ecosystem**, including the latest Ollama MLX releases and current MLX Community models. I am **excluding GGUF/llama.cpp-only models** and models that merely happen to run on macOS. The table below is specifically about **MLX implementations optimized for Apple Silicon**.

Your known machine is a **MacBook Pro M1 with 32 GB unified memory**, so I've also marked what makes practical sense on that machine.

# Best MLX Models for Apple Silicon — September 2026

| Rank | Model | MLX Footprint | Context | Vision | Coding | Agents | 32 GB M1 | Primary Use |
|---:|---|---:|---:|:---:|:---:|:---:|:---:|---|
| 🥇 **1** | **Qwen3.8 27B MLX** | **18 GB** | **256K** | ✅ | ★★★★★ | ★★★★★ | 🟢 | **Best overall** |
| 🥈 **2** | **Qwen3.5 35B-A3B MLX / NVFP4** | **22 GB** | **256K** | ✅ | ★★★★★ | ★★★★★ | 🟡 | **Best high-end model** |
| 🥉 **3** | **Muse Glimmer 30B MLX** | **19 GB** | **128K+** | ✅ | ★★★★★ | ★★★★★ | 🟡 | **Best agentic model** |
| **4** | **Qwen3.6 27B MLX** | **19 GB** | **256K** | ✅ | ★★★★★ | ★★★★★ | 🟢 | **Coding / reasoning** |
| **5** | **Gemma 4 31B MLX** | **19 GB** | **256K** | ✅ | ★★★★½ | ★★★★½ | 🟡 | **Dense reasoning** |
| **6** | **Gemma 4 26B MLX** | **18 GB** | **256K** | ✅ | ★★★★½ | ★★★★½ | 🟢 | **MoE efficiency** |
| **7** | **Qwen3.5 27B MLX / NVFP4** | **20 GB** | **256K** | ✅ | ★★★★★ | ★★★★★ | 🟢 | **Coding / general** |
| **8** | **Qwen3.5 9B MLX** | **8.9 GB** | **256K** | ✅ | ★★★★ | ★★★★ | 🟢🟢 | **Fast daily model** |
| **9** | **Gemma 4 12B MLX** | **7.7 GB** | **256K** | ✅ | ★★★★ | ★★★★ | 🟢🟢 | **Fast multimodal** |
| **10** | **Qwen3.5 4B MLX** | **4 GB** | **256K** | ✅ | ★★★½ | ★★★½ | 🟢🟢 | **Ultra-fast/lightweight** |

**Why these models?** They currently have explicit MLX variants in the Ollama ecosystem or native MLX Community releases. Ollama's current MLX engine is specifically designed around Apple's unified-memory architecture. ([Ollama MLX announcement](https://ollama.com/blog/mlx)) ([Ollama MLX performance update](https://ollama.com/blog/mlx-performance))

---

# 🥇 1. Qwen3.8 27B MLX

### The model I would start with

```bash
ollama run qwen3.8:27b-mlx
```

| Specification | Qwen3.8 27B MLX |
|---|---:|
| Parameters | 27B |
| MLX size | **18 GB** |
| Context | **256K** |
| Vision | ✅ |
| Coding | ★★★★★ |
| Reasoning | ★★★★★ |
| Agentic | ★★★★★ |
| Apple Silicon | **Excellent** |

The current Ollama MLX build is **18 GB**, with **256K context** and text/image input. Qwen3.8 focuses heavily on coding, professional work, research and long-horizon agentic tasks. ([Ollama Qwen3.8](https://ollama.com/library/qwen3.8))

There is also a native MLX Community version:

[Qwen3.8-27B-4bit — MLX Community](https://huggingface.co/mlx-community/Qwen3.8-27B-4bit)

And an interesting newer mixed-precision version:

[Qwen3.8-27B-OptiQ-4bit — MLX Community](https://huggingface.co/mlx-community/Qwen3.8-27B-OptiQ-4bit)

The OptiQ version uses 4-bit weights for most layers but selectively uses 8-bit for more sensitive layers. Its vision tower remains BF16. ([Hugging Face](https://huggingface.co/mlx-community/Qwen3.8-27B-OptiQ-4bit))

### Why #1?

For your 32 GB M1:

```text
27B model
     │
     ├── 18 GB MLX
     ├── 256K context
     ├── Vision
     ├── Coding
     └── Agentic capabilities
```

That's an unusually good **capability / memory / Apple Silicon** combination.

---

# 🥈 2. Qwen3.5 35B-A3B MLX

This is the **heavy hitter I'd test on your M1**.

```bash
ollama run qwen3.5:35b-mlx
```

Current MLX build:

| | |
|---|---:|
| Total parameters | **35B** |
| Active parameters | **~3B** |
| MLX footprint | **22 GB** |
| Context | **256K** |
| Vision | ✅ |
| Architecture | MoE |

Ollama currently lists the MLX version at **22 GB**. ([Ollama Qwen3.5](https://ollama.com/library/qwen3.5))

The architecture is particularly interesting:

```text
             Qwen3.5
                │
              35B
                │
        ┌───────┴───────┐
        │               │
     Total           Active
     35B               ~3B
```

So you're getting the capacity of a much larger model without activating the entire network for every token.

### Even more interesting: NVFP4

Ollama's MLX engine now supports **NVFP4**, and its testing shows NVFP4 can produce higher-quality results than common 4-bit quantization while also being faster in their measurements. ([Ollama MLX performance](https://ollama.com/blog/mlx-performance))

For coding agents, there is also:

```bash
ollama run qwen3.5:35b-a3b-coding-nvfp4
```

This is the one I'd put behind:

- OpenCode
- Claude Code
- Codex
- OpenClaw
- Hermes

---

# 🥉 3. Muse Glimmer 30B MLX

This is probably the **most interesting new agent model** for what you're building.

```bash
ollama run muse-glimmer:30b-mlx
```

| | Muse Glimmer |
|---|---:|
| Parameters | **30B** |
| MLX size | **19 GB** |
| Context | **128K+** |
| Vision | ✅ |
| Tool use | ✅ |
| Agentic | ★★★★★ |
| License | Apache 2.0 |

Meta Superintelligence Labs released Muse Glimmer in August 2026 as a **30B multimodal model purpose-built for local agent workloads**. ([Ollama Muse Glimmer announcement](https://registry.ollama.com/blog/muse-glimmer))

It is specifically positioned for:

- Claude Code
- Codex
- Pi
- OpenClaw
- Hermes
- OpenCode

And the important Apple Silicon piece:

> Muse Glimmer's MLX implementation uses DFlash and image input support.

Ollama reports **1.5×–1.8× faster performance on Apple Silicon** with DFlash. ([Ollama Muse Glimmer](https://registry.ollama.com/blog/muse-glimmer))

That makes it unusually relevant to your **local-agent/MLX research**.

---

# 4. Qwen3.6 27B MLX

```bash
ollama run qwen3.6:27b-mlx
```

| | Qwen3.6 27B |
|---|---:|
| MLX size | **19 GB** |
| Context | **256K** |
| Vision | ✅ |
| Coding | ★★★★★ |
| Agentic | ★★★★★ |
| Reasoning | ★★★★★ |

Ollama currently provides both:

```text
qwen3.6:27b-mlx   19 GB
qwen3.6:35b-mlx   24 GB
```

with 256K context and image input. ([Ollama Qwen3.6](https://ollama.com/library/qwen3.6))

Qwen3.6 specifically emphasizes:

- agentic coding
- repository-level reasoning
- frontend workflows
- preservation of reasoning context

That makes it particularly attractive for **coding agents**. ([Ollama Qwen3.6](https://ollama.com/library/qwen3.6))

For your 32 GB Mac, I'd use the **27B**, not the 35B.

---

# 5. Gemma 4 31B MLX

```bash
ollama run gemma4:31b-mlx
```

| | Gemma 4 31B |
|---|---:|
| Parameters | 31B |
| Architecture | Dense |
| MLX | ✅ |
| Size | **19 GB** |
| Context | **256K** |
| Vision | ✅ |
| Coding | ★★★★½ |
| Agents | ★★★★½ |

Ollama currently lists the MLX version at approximately **19 GB / 256K / Text + Image**. ([Ollama Gemma 4](https://ollama.com/library/gemma4))

Gemma 4 is designed specifically for:

- reasoning
- coding
- agentic workflows
- multimodal understanding

### And there's an important MLX performance feature

Gemma 4 was the first model to receive Ollama's **multi-token prediction (MTP)** implementation.

Ollama reports that Gemma 4 generated tokens **nearly 90% faster on average on Apple Silicon** across its coding-agent benchmark. ([Ollama — Faster Gemma 4 on MLX](https://ollama.com/blog/faster-gemma-4-mlx-mtp))

That's a major reason Gemma 4 deserves to be high on an Apple Silicon-specific list.

---

# 6. Gemma 4 26B MLX

```bash
ollama run gemma4:26b-mlx
```

| | Gemma 4 26B |
|---|---:|
| Parameters | ~26B |
| Active parameters | **~4B** |
| Architecture | **MoE** |
| MLX | ✅ |
| Size | **18 GB** |
| Context | **256K** |
| Vision | ✅ |

The 26B model is an MoE with approximately **4B active parameters**. ([Ollama Gemma 4](https://ollama.com/library/gemma4))

Ollama currently has a dedicated:

```text
gemma4:26b-mlx
18 GB
256K
Text + Image
```

build. ([Ollama Gemma 4 26B MLX](https://www.ollama.com/library/gemma4%3A26b-mlx))

This would be one of my **benchmark-against-Qwen** models on your Mac.

---

# 7. Qwen3.5 27B MLX / NVFP4

```bash
ollama run qwen3.5:27b-mlx
```

Current MLX footprint:

**20 GB / 256K / Text + Image**. ([Ollama Qwen3.5](https://ollama.com/library/qwen3.5))

There is also:

```bash
ollama run qwen3.5:27b-nvfp4
```

which uses the MLX backend.

Ollama's current tags show the MLX/NVFP4 version at approximately **20 GB**. ([Ollama Qwen3.5 tags](https://ollama.com/library/qwen3.5/tags))

For your Mac, I'd favor the NVFP4 version when available.

---

# 8. Qwen3.5 9B MLX

This is where the **speed/utility ratio** gets very good.

```bash
ollama run qwen3.5:9b-mlx
```

| | Qwen3.5 9B |
|---|---:|
| MLX size | **8.9 GB** |
| Context | **256K** |
| Vision | ✅ |
| Coding | ★★★★ |
| Agents | ★★★★ |
| 32 GB M1 | 🟢🟢 |

Ollama currently lists the MLX version at **8.9 GB**, with 256K context and image input. ([Ollama Qwen3.5 9B MLX](https://ollama.com/library/qwen3.5%3A9b-mlx))

This is probably the model I'd use when you want your MacBook to remain responsive while you're doing other things.

---

# 9. Gemma 4 12B MLX

```bash
ollama run gemma4:12b-mlx
```

| | Gemma 4 12B |
|---|---:|
| MLX size | **7.7 GB** |
| Context | **256K** |
| Vision | ✅ |
| Coding | ★★★★ |
| Agents | ★★★★ |
| 32 GB M1 | 🟢🟢 |

Ollama currently lists the MLX build at **7.7 GB / 256K / Text + Image**. ([Ollama Gemma 4 12B MLX](https://ollama.com/library/gemma4%3A12b-mlx))

The combination of the small footprint and Gemma 4's MTP optimization makes this one of the most interesting **fast local models for Apple Silicon**.

---

# 10. Qwen3.5 4B MLX

```bash
ollama run qwen3.5:4b-mlx
```

Current MLX footprint:

**~4 GB / 256K / Text + Image**. ([Ollama Qwen3.5](https://ollama.com/library/qwen3.5))

This isn't the model I'd use when you want maximum reasoning capability, but it becomes extremely useful for:

- lightweight agents
- routing
- classification
- extraction
- simple automation
- background tasks
- always-on local assistants

---

# What I would NOT recommend on your 32 GB M1

There are many impressive MLX conversions that are technically available but aren't sensible for your machine.

For example, Qwen3.8 currently has a **BF16 MLX build around 56 GB**. ([Ollama Qwen3.8 tags](https://ollama.com/library/qwen3.8/tags))

Likewise, Qwen3.5 27B has an MLX BF16 version around **55 GB**. ([Ollama Qwen3.5 tags](https://ollama.com/library/qwen3.5/tags))

Those are interesting for **64 GB+ Apple Silicon**, not your 32 GB machine.

---

# Apple Silicon Memory Guide

This is how I'd think about MLX models for your hardware:

| Apple Unified Memory | MLX Sweet Spot | Examples |
|---:|---|---|
| **16 GB** | 3–12B | Qwen3.5 4B/9B, Gemma 4 12B |
| **24 GB** | 7–27B | Qwen3.8 27B |
| **32 GB** | **9–35B quantized** | **Your M1** |
| **48 GB** | 27–70B | Serious local AI |
| **64 GB** | 35–70B+ | High-end local AI |
| **96 GB** | 70B+ | Large-model territory |
| **128 GB** | 70–120B+ | MLX powerhouse |
| **192 GB+** | Huge MoE / 200B+ | Extreme local inference |

Remember that model size isn't your entire memory budget:

```text
Unified Memory
│
├── MLX model weights
├── KV cache
├── Context
├── Vision/audio components
├── Ollama / MLX runtime
└── macOS + applications
```

So I wouldn't try to run a **30 GB model with a huge context** on a 32 GB Mac and expect a comfortable experience.

---

# My MLX Stack for Your MacBook Pro

If I were setting up your machine, I'd install these **six** first:

| Priority | Model | Role |
|---:|---|---|
| 🥇 | **Qwen3.8 27B MLX** | Main local AI |
| 🥈 | **Qwen3.5 35B-A3B NVFP4** | Heavy coding/reasoning |
| 🥉 | **Muse Glimmer 30B MLX** | Agentic AI |
| 4 | **Qwen3.6 27B MLX** | Coding/reasoning comparison |
| 5 | **Gemma 4 31B MLX** | Dense-model comparison |
| 6 | **Gemma 4 12B MLX** | Fast daily model |

### Install them

```bash
# 1. Best overall
ollama run qwen3.8:27b-mlx

# 2. Heavy coding/reasoning
ollama run qwen3.5:35b-a3b-nvfp4

# 3. Agentic
ollama run muse-glimmer:30b-mlx

# 4. Coding/reasoning
ollama run qwen3.6:27b-mlx

# 5. Dense reasoning
ollama run gemma4:31b-mlx

# 6. Fast daily driver
ollama run gemma4:12b-mlx
```

## The Apple Silicon story is getting very interesting

The reason I'd pay attention to MLX now is that Apple isn't merely providing a Mac-compatible inference path.

The stack is increasingly becoming:

```text
                         Apple Silicon
                              │
                     ┌────────┴────────┐
                     │ Unified Memory  │
                     └────────┬────────┘
                              │
                            Metal
                              │
                             MLX
                              │
              ┌───────────────┼───────────────┐
              │               │               │
           Ollama          mlx-lm          mlx-vlm
              │               │               │
              └───────────────┼───────────────┘
                              │
                       MLX Model Ecosystem
                              │
               ┌──────────────┼──────────────┐
               │              │              │
             Qwen           Gemma        Muse Glimmer
               │              │              │
               └──────────────┼──────────────┘
                              │
                         Local Agents
                              │
           OpenClaw / Hermes / OpenCode / Codex
```

Ollama's March 2026 MLX release specifically targeted local assistants and coding agents, and its June update added NVFP4, fused Metal kernels, more efficient GPU sampling and model-state snapshots for agent workloads. ([Ollama MLX](https://ollama.com/blog/mlx)) ([Ollama MLX performance](https://ollama.com/blog/mlx-performance))

On **M5/M5 Pro/M5 Max**, Ollama additionally reports that MLX can use Apple's **GPU Neural Accelerators** for both prompt processing and generation. ([Ollama MLX](https://ollama.com/blog/mlx))

### My bottom line for your M1/32 GB

**Start with these three:**

| Model | Why |
|---|---|
| **Qwen3.8 27B MLX** | Best overall balance |
| **Qwen3.5 35B-A3B NVFP4** | Maximum capability I'd seriously test |
| **Muse Glimmer 30B MLX** | Most interesting agent-focused model |

Then keep **Gemma 4 12B MLX** around as the fast model.

And if you eventually move from the M1/32 GB to an **M5 Pro/Max with 64–128 GB unified memory**, the MLX game changes substantially. At that point I'd start looking seriously at **70B+ and large MoE MLX models**, rather than stopping at the 27–35B class.