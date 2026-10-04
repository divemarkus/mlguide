# llama.cpp

Yes. **llama.cpp has changed dramatically since the early LLaMA days.** If your mental model is still “that C++ project you compile to run a GGUF,” you’re missing a lot of what it is now.

The short version:

> **Ollama is a convenient LLM platform built around inference engines. llama.cpp is closer to the actual inference substrate.**

And in your environment, I would **not replace Ollama with llama.cpp**. I would add llama.cpp as a second, lower-level runner for cases where you want maximum control, unusual hardware, GGUF experimentation, benchmarking, or a very lean inference server.

Your own ML guide already has the right conceptual model: model = “brain,” runner = “body,” with Ollama, LM Studio and llama.cpp sitting at that layer. README

---

# llama.cpp in 2026


The project has evolved from essentially:

**LLaMA → C++ → CPU/GPU → GGML**

into a fairly complete inference platform:

```text
                         LOCAL AI APPLICATION
                                │
                ┌───────────────┴────────────────┐
                │                                │
             Agents                           Apps
        OpenClaw / Flowise              OpenWebUI / custom
                │                                │
                └───────────────┬────────────────┘
                                │
                         OpenAI-compatible API
                                │
                       ┌────────▼────────┐
                       │   llama-server  │
                       └────────┬────────┘
                                │
                       ┌────────▼────────┐
                       │    llama.cpp    │
                       │      ggml       │
                       └────────┬────────┘
                                │
          ┌─────────────────────┼──────────────────────┐
          │                     │                      │
       NVIDIA CUDA           Apple Metal            AMD HIP
          │                     │                      │
       RTX 3090 Ti          M-series Mac            Radeon
          │
       CPU / Vulkan / etc.
```

The current project supports CUDA, Metal, HIP, Vulkan, SYCL, CPU architectures and several other backends, and can hybridize CPU and GPU execution. [GitHub](https://github.com/ggml-org/llama.cpp)

That makes it much more interesting for your particular hardware mix.

---

# 1. The biggest misconception: llama.cpp ≠ just "Llama"

The name is historical.

Today llama.cpp supports a large range of architectures and isn't restricted to Meta's Llama models.

The important concept is:

**GGUF + ggml + backend**

rather than:

**Llama model + llama.cpp**

For example, you can run modern Qwen-family models, Gemma-family models, vision-language models, MoE models, etc., provided the architecture has support.

The current project explicitly supports 1.5-bit through 8-bit quantization and CPU/GPU hybrid inference. [GitHub](https://github.com/ggml-org/llama.cpp)

---

# 2. So why would I use it instead of Ollama?

This is the important question.

I'd divide the runners like this:

| Runner | Primary purpose | Ease | Control | Production serving | Experimentation |
|---|---|---:|---:|---:|---:|
| **Ollama** | Easy local LLM platform | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **LM Studio** | GUI experimentation | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **llama.cpp** | Low-level inference | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **vLLM** | High-throughput GPU serving | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **TensorRT-LLM** | NVIDIA optimization | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| **Transformers** | Research/development | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

Your current architecture is essentially:

```text
OpenWebUI
    │
    ▼
 Ollama
    │
    ▼
  Model
```

which is exactly what your existing stack documentation describes. ollama-setup

I would keep that.

llama.cpp becomes your **precision instrument**.

---

# 3. What makes modern llama.cpp interesting?

There are several capabilities that make it much more than an old-school CLI.

## A. GGUF is first-class

This is probably the biggest reason you'll encounter llama.cpp again.

If you download:

```text
Qwen3.x-XXB-Q4_K_M.gguf
```

you're often looking at a model intended for the GGUF/llama.cpp ecosystem.

You can directly load models from Hugging Face now:

```bash
llama cli -hf ggml-org/Qwen3.5-0.8B-GGUF
```

or launch a server:

```bash
llama serve -hf ggml-org/Qwen3.5-0.8B-GGUF
```

The current project supports direct Hugging Face retrieval and caching. [GitHub](https://github.com/ggml-org/llama.cpp)

That's a huge improvement over the old:

```text
download model
↓
find compatible tokenizer
↓
convert model
↓
compile llama.cpp
↓
figure out arguments
↓
run
```

workflow.

---

# 4. `llama-server` is the feature I'd pay attention to

This is where llama.cpp becomes relevant to your infrastructure work.

You can run:

```bash
llama-server \
    -m Qwen3-Next-80B-Q4_K_M.gguf \
    -c 32768 \
    -ngl 999 \
    --host 0.0.0.0 \
    --port 8080
```

and you now have an API server.

Current `llama-server` provides:

- OpenAI-compatible APIs
- Anthropic-compatible Messages API
- embeddings
- reranking
- multimodal requests
- parallel decoding
- continuous batching
- function/tool calling
- speculative decoding
- constrained JSON
- metrics
- web UI
- MCP server support

That's a **very different animal** from the llama.cpp you remember. [GitHub](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md?plain=1\)

---

# 5. And this matters for agents

This is one of the biggest changes.

You can now have:

```text
OpenClaw
   │
   ▼
OpenAI-compatible API
   │
   ▼
llama-server
   │
   ▼
Qwen / Gemma / Llama / etc.
```

And llama-server itself now has tool/MCP capabilities.

The server can expose MCP servers through stdio and expose their tools to the model. [GitHub](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md?plain=1\)

That makes llama.cpp considerably more interesting for your **agent infrastructure** work.

Your existing architecture currently has:

```text
Flowise
   ↓
Ollama
   ↓
LLM
```

which your documentation describes explicitly. README

You can instead experiment with:

```text
Flowise
   ↓
llama-server
   ↓
Qwen
```

without changing the higher-level application very much.

---

# 6. Speculative decoding

This is another modern feature worth knowing.

Normally:

```text
LLM
 ↓
token
 ↓
token
 ↓
token
 ↓
token
```

Speculative decoding uses a smaller/faster model to propose tokens:

```text
Small model
     │
     ▼
proposes tokens
     │
     ▼
Large model verifies them
     │
     ▼
accepted tokens
```

Potentially:

```text
Large model alone
     ↓
     ↓
     ↓
     ↓

Large + draft model
     ↓↓↓↓↓
```

The current llama-server explicitly supports speculative decoding. [GitHub](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md?plain=1\)

This becomes especially interesting when you're running a **large quantized model locally**.

---

# 7. CPU + GPU hybrid inference

This is probably one of the most relevant capabilities for your hardware.

Suppose:

```text
Model = 60 GB
GPU VRAM = 24 GB
RAM = 96 GB
```

A runner doesn't necessarily have to say:

> "Model doesn't fit. Sorry."

llama.cpp can split computation between GPU and CPU. [GitHub](https://github.com/ggml-org/llama.cpp)

Conceptually:

```text
                 MODEL
                   │
        ┌──────────┴──────────┐
        │                     │
      GPU                   RAM/CPU
   24 GB VRAM              96 GB RAM
        │                     │
        └──────────┬──────────┘
                   │
                output
```

This is particularly useful for your:

**RTX 3090 Ti + 96 GB RAM**

machine.

It's also part of why llama.cpp remains so popular for running models larger than the available VRAM.

---

# 8. And multi-GPU

llama.cpp has multi-GPU capabilities as well.

For example:

```text
RTX 3090 Ti
      +
RTX 5090
      │
      ▼
   llama.cpp
      │
      ▼
   100B+ model
```

The feature matrix shows multi-GPU support, with CUDA/HIP having the strongest parallel implementation. [GitHub](https://github.com/ggml-org/llama.cpp/wiki/Feature-matrix/288767490fe2d2f68d54425e12e8bd21b1d8f6fa)

This is one area where llama.cpp can become substantially more interesting than a simple desktop-oriented runner.

---

# 9. Remote GPU/RPC is particularly interesting

Here's a feature I think you'll appreciate.

llama.cpp has an RPC backend capable of exposing accelerators from another machine.

Conceptually:

```text
                 LAN
                  │
       ┌──────────┴──────────┐
       │                     │
   AI Server              GPU Server
       │                     │
 llama.cpp              RTX GPU
       │                     │
       └─────────RPC─────────┘
```

The main process can distribute model weights/KV cache across local and remote devices.

The project even has RDMA support for certain environments. [GitHub](https://github.com/ggml-org/llama.cpp/blob/master/tools%2Frpc%2FREADME.md)

**Important:** the upstream documentation currently describes this RPC functionality as proof-of-concept, fragile and insecure, so I would experiment with it only on your trusted LAN—not expose it through your FortiGate or Internet. [GitHub](https://github.com/ggml-org/llama.cpp/blob/master/tools%2Frpc%2FREADME.md)

But architecturally?

Very interesting.

---

# 10. Multimodal is now built in

Another thing that has changed substantially.

llama.cpp can now process:

```text
text
+
image
+
audio
```

depending on the supported model.

For example:

```text
Camera/image
     │
     ▼
Vision model
     │
 llama.cpp
     │
     ▼
JSON/tool call
     │
     ▼
Home Assistant / agent
```

The current multimodal subsystem uses `libmtmd` and supports image input and experimental audio input. [GitHub](https://github.com/L-Ark/llama.cpp/blob/master/docs/multimodal.md)

This makes llama.cpp potentially relevant to your **Frigate → VLM → Home Assistant** architecture.

---

# 11. This is where I would use llama.cpp with your Jetson

You have:

**Jetson Orin Nano Super 8 GB**

Your current plan is essentially:

```text
Jetson
 ├── Frigate
 ├── Ollama
 └── OpenWebUI
```

Your project documentation specifically positions Ollama as the LLM runtime on the Jetson. README

I would consider another architecture:

```text
                    CAMERA
                       │
                       ▼
                    Frigate
                       │
                       ▼
                  Detection event
                       │
                       ▼
                 llama-server
                       │
                  small VLM
                       │
                       ▼
              structured JSON
                       │
                       ▼
                Home Assistant
```

For an 8 GB edge machine, the ability to control:

- quantization
- GPU offload
- context
- batch size
- threads
- memory
- model format

directly can be valuable.

---

# 12. Apple Silicon is another huge llama.cpp territory

This is particularly relevant given your Mac interest.

llama.cpp treats Apple Silicon as a first-class backend using:

```text
ARM NEON
Accelerate
Metal
```

according to the current project documentation. [GitHub](https://github.com/ggml-org/llama.cpp)

So:

```text
MacBook / Mac mini
       │
       ▼
    Metal
       │
       ▼
    ggml
       │
       ▼
  llama.cpp
       │
       ▼
     GGUF
```

is an extremely natural architecture.

That's one reason you'll see llama.cpp underneath or adjacent to a lot of Mac local-AI tooling.

---

# 13. Where LM Studio fits

LM Studio is basically:

```text
              LM Studio
          ┌──────┼───────┐
          │      │       │
        GUI   Model    Server
              mgmt
                │
             llama.cpp
```

It gives you:

- GUI
- model discovery
- model management
- chat
- presets
- server
- experimentation

Your own documentation positions LM Studio exactly this way—as a local environment for experimentation, evaluation and serving. README

So if you want to **learn llama.cpp**, I'd actually use LM Studio alongside it rather than instead of it.

---

# 14. Where Ollama fits

Ollama is the opposite philosophy.

Instead of:

> "Give me every knob."

it's:

> "Give me a simple command and make it work."

Your current stack:

```text
OpenWebUI
     │
     ▼
   Ollama
     │
     ▼
    GPU
```

is excellent for a homelab service. Your existing Compose setup exposes Ollama on `11434` and connects OpenWebUI directly to it. docker-compose

I wouldn't rip that out.

---

# 15. Where vLLM fits

This is where the distinction becomes important.

Think:

### llama.cpp

**"I want maximum portability and control over local inference."**

### vLLM

**"I want to serve lots of requests efficiently on serious GPUs."**

Example:

```text
                100 users
                   │
                   ▼
                 vLLM
                   │
             ┌─────┴─────┐
             │           │
           GPU 0        GPU 1
```

Whereas llama.cpp is more naturally:

```text
            one powerful workstation
                     │
                     ▼
                llama.cpp
                     │
             ┌───────┴───────┐
             │               │
           GPU             CPU/RAM
```

Although llama.cpp can absolutely serve multiple users now; its server supports parallel decoding and continuous batching. [GitHub](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md?plain=1\)

---

# 16. llama.cpp vs Ollama — the practical difference

Here's the table I'd keep in your ML Guide:

| Capability | Ollama | llama.cpp |
|---|---:|---:|
| Easy installation | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Model management | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| GGUF | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Fine inference control | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| CPU inference | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| GPU offload | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| CPU/GPU hybrid | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Multi-GPU | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Apple Silicon | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| NVIDIA | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| AMD | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Vulkan | limited/indirect | ⭐⭐⭐⭐⭐ |
| Embedded/edge | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Multimodal | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Tool calling | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| MCP | via integrations | native server support |
| OpenAI API | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Speculative decoding | supported depending on stack | ⭐⭐⭐⭐⭐ |
| Remote inference | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| GUI | ❌ | basic |
| "Just make it work" | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Low-level experimentation | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

# 17. The really important part: GGUF

If you're learning local AI seriously, I would understand this stack:

```text
                    MODEL
                      │
              Hugging Face
                      │
                      ▼
             Quantized checkpoint
                      │
                      ▼
                    GGUF
                      │
          ┌───────────┼────────────┐
          │           │            │
       Ollama      LM Studio    llama.cpp
          │           │            │
          └───────────┼────────────┘
                      │
                    GPU
```

GGUF is essentially one of the major interchange/distribution formats for the local inference ecosystem.

And llama.cpp is one of the foundational projects behind that ecosystem.

---

# 18. What I would actually install on your machines

I would **not** create a giant llama.cpp Docker stack.

I'd deliberately keep it separate.

### RTX 3090 Ti / 96 GB workstation

Install:

```text
Ollama
llama.cpp
LM Studio
```

and use each for a different purpose:

```text
                 RTX 3090 Ti
                      │
       ┌──────────────┼──────────────┐
       │              │              │
    Ollama        llama.cpp       LM Studio
       │              │              │
    daily AI       advanced       experimentation
       │            testing
       │              │
 OpenWebUI       custom API
```

---

# 19. Your 3090 Ti becomes particularly interesting

Your machine has enough RAM to make llama.cpp experimentation genuinely useful.

For example:

```text
              96 GB system RAM
                    +
              24 GB VRAM
                    │
                    ▼
              llama.cpp
                    │
        ┌───────────┴───────────┐
        │                       │
     GPU layers             CPU layers
        │                       │
        └───────────┬───────────┘
                    ▼
               Large GGUF
```

You can therefore experiment with models that aren't realistic as a pure-VRAM workload.

That's exactly the kind of situation where I would reach for llama.cpp rather than Ollama.

---

# 20. And there's an even more interesting use: benchmarking

This is probably the **best reason for you personally** to learn it.

You can test:

```text
Qwen
Llama
Gemma
DeepSeek
Mistral
etc.
```

under controlled parameters:

```text
model
quantization
context
GPU layers
batch size
threads
KV cache
speculative decoding
```

and measure:

```text
Prompt processing
tokens/sec
memory
VRAM
TTFT
context performance
CPU utilization
GPU utilization
```

That turns your homelab into a proper **local AI lab** rather than simply a collection of applications.

---

# 21. Your ML Guide could evolve to this architecture

I'd actually update your "Brain / Body / Nervous System" model.

### Brain

```text
Models
│
├── Qwen
├── Llama
├── Gemma
├── DeepSeek
├── Mistral
└── etc.
```

### Body — inference runners

```text
Inference layer
│
├── llama.cpp      ← low-level / portable
├── Ollama         ← easy deployment
├── LM Studio      ← experimentation
├── vLLM           ← high-throughput serving
└── TensorRT-LLM   ← NVIDIA optimization
```

### Nervous system

```text
Agents / orchestration
│
├── OpenClaw
├── LangGraph
├── Flowise
├── OpenCode
└── MCP
```

### Senses / memory

```text
Tools
│
├── Vision
├── Audio
├── RAG
├── Qdrant
├── APIs
├── MCP
└── databases
```

Your existing guide already has the Brain/Body/Nervous System distinction; llama.cpp belongs squarely in **Body**, not in the agent layer. README

---

# 22. My recommendation for you

I would rank the runners for **your homelab** like this:

### 🥇 Ollama — everyday infrastructure

Keep this as your default.

```text
OpenWebUI
   ↓
Ollama
   ↓
LLMs
```

It's simple, reliable and fits your existing Docker architecture. Your documentation already has it as the core local inference engine. ollama-setup

### 🥈 llama.cpp — AI laboratory

This is where I'd start using it again.

```text
GGUF
 ↓
llama.cpp
 ↓
precise inference experiments
```

Especially:

- unusual models
- large GGUFs
- CPU/GPU hybrid
- multi-GPU
- speculative decoding
- multimodal
- benchmarking
- custom inference servers
- edge devices
- Apple Silicon
- controlled performance experiments

### 🥉 LM Studio — GUI laboratory

Use when you want:

```text
download → load → tweak → test → compare
```

without touching the command line.

### 🏅 vLLM — future server

Bring it in when you're building something like:

```text
multiple users
       ↓
   API gateway
       ↓
      vLLM
       ↓
multiple GPUs
```

---

# The big 2026 takeaway

**You haven't missed much by not using llama.cpp for everyday chat.**

Ollama probably saved you a tremendous amount of configuration time.

But you **are missing an important piece of the local-AI stack if you don't understand modern llama.cpp.**

The project is now much closer to:

> **"portable, highly optimized local inference infrastructure"**

than:

> "that old program for running leaked LLaMA models."

It now has an OpenAI-compatible server, multimodal support, tool/function calling, MCP integration, continuous batching, speculative decoding, CPU/GPU hybrid execution, broad accelerator support and experimental distributed/RPC inference. [GitHub](https://github.com/ggml-org/llama.cpp)

**For your ML Guide, I'd classify it as the "reference / low-level runner" that sits underneath the more user-friendly runners.**

And I think the next useful step would be to build a **hands-on llama.cpp lab on your RTX 3090 Ti**, using the same Qwen models you're already running in Ollama, and benchmark **Ollama vs llama.cpp vs LM Studio** with identical GGUF, quantization, context, GPU offload and prompts. That would make the differences *very* concrete.