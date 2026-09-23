# The Runner - Body

And I would **update the original analogy**, because the local-AI ecosystem has evolved significantly. In particular, Ollama and LM Studio are no longer merely "wrappers around llama.cpp"; they have become fairly sophisticated **model runtimes, servers, API layers, and application platforms**.

The cleanest way to teach this is to distinguish **engine → runtime/server → application → agent**.

---

# 🧠 The Runner: The "Body" of a Local AI

The original statement was:

> **The Runner (The Body): Tools like Ollama, LM Studio, or llama.cpp are the "bodies." They are actual programs written in languages like C++ or Go. They are the ones that talk to your hardware (CPU/GPU) and, if you allow them, your internet connection.**

That's fundamentally correct, but I'd make it more precise:

> **The Runner is the software that loads a model into memory, executes its mathematical operations, manages CPU/GPU/NPU acceleration, handles tokenization and context, and often exposes an API that applications can use to communicate with the model.**

And there's an important distinction:

**The runner itself may have networking capabilities, while the model does not.**

That distinction becomes very important for privacy.

---

# 1. The Four Layers

Think about local AI like this:

```text
┌──────────────────────────────────────────┐
│                 YOU                      │
└──────────────────┬───────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────┐
│             APPLICATION                  │
│                                          │
│ LM Studio / Open WebUI / custom app      │
└──────────────────┬───────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────┐
│          RUNTIME / SERVER                │
│                                          │
│ Ollama / llama.cpp / MLX / ONNX Runtime  │
└──────────────────┬───────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────┐
│                  MODEL                   │
│                                          │
│ Qwen / Llama / Gemma / Mistral / etc.    │
└──────────────────┬───────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────┐
│               HARDWARE                   │
│                                          │
│ CPU / GPU / NPU / RAM / VRAM             │
└──────────────────────────────────────────┘
```

Then you can add another layer:

```text
                 APPLICATION
                      │
                      ▼
                   AGENT
              ┌───────┼────────┐
              ▼       ▼        ▼
           Browser  Python    Files
              │       │        │
              └───────┼────────┘
                      ▼
                   MODEL
```

The **model doesn't become capable of these things** merely because you put it inside an agent.

The agent/runtime provides the capabilities.

---

# 2. What Does a Runner Actually Do?

When you type:

```text
What is the capital of France?
```

a lot more happens than:

```text
prompt → model → answer
```

A simplified execution path is:

```text
Prompt
  │
  ▼
Tokenizer
  │
  ▼
Tokens
  │
  ▼
Model weights loaded in RAM/VRAM
  │
  ▼
Neural-network operations
  │
  ▼
GPU / CPU / NPU kernels
  │
  ▼
Logits
  │
  ▼
Sampling
  │
  ▼
Next token
  │
  └───────────────┐
                  ▼
              repeat
                  │
                  ▼
              Response
```

The runner coordinates essentially all of this.

---

# 3. The Runner Has to Load the Model

Suppose you have:

```text
Qwen3-14B-Q4_K_M.gguf
```

sitting on your SSD.

Nothing is happening.

It's just a file.

When you tell Ollama or LM Studio to use it:

```text
SSD
 │
 ▼
Runner
 │
 ├── reads model metadata
 ├── reads tensors
 ├── allocates memory
 ├── initializes backend
 ├── initializes tokenizer
 └── loads model
       │
       ▼
    RAM/VRAM
```

Now the model is "alive" in the sense that the runtime can execute it.

---

# 4. The Runner Is Also a Hardware Abstraction Layer

This is one of the coolest aspects of modern local AI.

You might have:

```text
NVIDIA RTX 3090 Ti
```

or:

```text
Apple M5 Pro
```

or:

```text
AMD Radeon
```

or:

```text
Intel GPU
```

or even:

```text
CPU only
```

The **model doesn't fundamentally care**.

The runtime provides the hardware-specific implementation.

For example, llama.cpp currently supports backends including:

* CUDA → NVIDIA
* HIP → AMD
* Metal → Apple Silicon
* Vulkan → GPUs
* SYCL → Intel
* OpenCL → Adreno
* CANN → Ascend
* CPU backends
* WebGPU
* RPC/remote devices

and supports hybrid CPU/GPU inference. ([GitHub][1])

That's an enormous evolution from the original "llama.cpp is a little C++ program that runs Llama" description.

---

# 5. llama.cpp — The Engine

This is where I would change the analogy slightly.

## llama.cpp isn't really the "AI application."

It is better thought of as an **inference engine/library and toolkit**.

Its project description is extremely explicit:

> **"LLM inference in C/C++."**

It is built around the **ggml** tensor/inference ecosystem. ([GitHub][1])

Today it includes:

```text
llama
├── inference library
├── CLI
├── server
├── model loading
├── quantization
├── multimodal/VLM support
├── GPU backends
├── CPU backends
├── grammar/structured generation
└── APIs
```

And it can now directly launch a model from Hugging Face, for example:

```bash
llama cli -hf ggml-org/Qwen3.5-0.8B-GGUF
```

or start an OpenAI-compatible server:

```bash
llama serve -hf ggml-org/Qwen3.5-0.8B-GGUF
```

according to the current project documentation. ([GitHub][1])

---

# 6. Why llama.cpp Is So Important

A huge portion of the local LLM ecosystem builds upon or interoperates with the work done in this ecosystem.

For example:

```text
                 llama.cpp / ggml
                       │
          ┌────────────┼────────────┐
          │            │            │
       GGUF          kernels      runtime
          │            │            │
          └────────────┼────────────┘
                       │
              Local inference
```

That's why understanding llama.cpp gives you a much better understanding of local LLMs generally.

---

# 7. Ollama — More Than a Runner

Ollama is where the analogy gets more interesting.

[Ollama](https://ollama.com?utm_source=chatgpt.com)

Ollama is essentially a **local model management + inference + serving platform**.

You can think:

```text
Ollama
│
├── Model management
├── Model storage
├── Model loading
├── Inference
├── Hardware acceleration
├── Local HTTP API
├── OpenAI compatibility
├── Anthropic compatibility
├── Python library
├── JavaScript library
└── Application integrations
```

Its current documentation explicitly positions it for using open models in desktop applications and coding agents, as well as building applications around models. ([Ollama][2])

---

# 8. Ollama's Local Server

When Ollama is running, you can have:

```text
                   Ollama
                     │
             localhost:11434
                     │
       ┌─────────────┼─────────────┐
       │             │             │
    OpenWebUI      Python       VS Code
       │             │             │
       └─────────────┼─────────────┘
                     │
                   Model
```

The current local API is:

```text
http://localhost:11434/api
```

and Ollama also exposes OpenAI-compatible endpoints under:

```text
http://localhost:11434/v1
```

Local requests don't require an API key. ([Ollama][3])

That's enormously useful.

It means your model becomes a **local AI service** rather than merely something you chat with.

---

# 9. Ollama Talks to Your GPU

This is where the "body" analogy becomes very good.

Your model says, metaphorically:

> "I need to perform this enormous matrix multiplication."

Ollama's runtime says:

> "Okay. I'll execute that using CUDA."

For your RTX 3090 Ti, for example:

```text
Qwen
  │
  ▼
Ollama
  │
  ▼
CUDA
  │
  ▼
RTX 3090 Ti
```

Current Ollama documentation lists RTX 30-series GPUs including the **RTX 3090 Ti** as supported NVIDIA hardware. ([Ollama][4])

---

# 10. Ollama Is Not NVIDIA CUDA

Another important distinction:

```text
Model
 ↓
Ollama
 ↓
CUDA
 ↓
NVIDIA Driver
 ↓
GPU
```

These are different layers.

### CUDA

NVIDIA's GPU computing platform.

### Ollama

The AI model runtime/server.

### Model

The learned parameters.

So:

> **CUDA isn't the model runtime.**

It's one of the hardware acceleration technologies the runtime can use.

---

# 11. Ollama on Apple

On Apple hardware the path is different:

```text
Model
 ↓
Ollama
 ↓
Metal
 ↓
Apple GPU
 ↓
Unified Memory
```

Ollama currently supports Apple GPU acceleration through **Metal**. ([Ollama][4])

So the same Ollama application can have:

```text
Windows + NVIDIA
        ↓
      CUDA

Linux + AMD
        ↓
      ROCm/HIP

macOS
        ↓
      Metal
```

That's a major reason runtimes matter.

---

# 12. Ollama Also Supports Vulkan

This is particularly interesting for heterogeneous hardware.

Ollama currently provides additional GPU support through Vulkan on Windows and Linux. ([Ollama][4])

Conceptually:

```text
                 Ollama
                    │
       ┌────────────┼────────────┐
       ▼            ▼            ▼
     CUDA          ROCm        Vulkan
       │            │            │
    NVIDIA         AMD       Various GPUs
```

That makes the runner considerably more hardware-independent than the model itself.

---

# 13. LM Studio — The GUI + Runtime Platform

[LM Studio](https://lmstudio.ai?utm_source=chatgpt.com)

LM Studio is a different layer of the stack.

It provides:

```text
                  LM Studio
                      │
       ┌──────────────┼──────────────┐
       │              │              │
      GUI          Runtime          API
       │              │              │
    Model Hub     llama.cpp         HTTP
       │              │
       └──────────────┘
```

Current LM Studio documentation says it can run:

* **GGUF via llama.cpp**
* **MLX on Apple Silicon**

and provides local model serving and APIs. ([LM Studio][5])

---

# 14. LM Studio Has Evolved Significantly

This is an important 2026 update to the guide.

LM Studio isn't merely:

> "A nice GUI for llama.cpp."

Its architecture now includes a standalone server/runtime called:

```text
llmster
```

LM Studio introduced this in 0.4.0 as a **headless daemon** that can run without the GUI. It can operate on Linux servers, GPU rigs, CI systems and other machines. ([LM Studio][6])

So:

```text
Old mental model:

LM Studio
   ↓
GUI
   ↓
llama.cpp
```

is now incomplete.

A better model:

```text
                   LM Studio
                       │
             ┌─────────┴─────────┐
             │                   │
            GUI               llmster
                                 │
                     ┌───────────┴───────────┐
                     │                       │
                 llama.cpp                 MLX
                     │                       │
                  GGUF                  Apple models
```

---

# 15. LM Studio Can Now Be a Server

You can run LM Studio without treating it as a desktop chat application.

For example:

```text
                    LM Studio
                       │
                  llmster daemon
                       │
                 local API server
                       │
       ┌───────────────┼────────────────┐
       │               │                │
    Python           VS Code         Browser
```

LM Studio 0.4.0 added the standalone daemon, local server functionality and newer stateful APIs. ([LM Studio][6])

That's a big deal for your **homelab-oriented guide**.

---

# 16. LM Studio Also Does Something Interesting With MLX

On Apple Silicon:

```text
LM Studio
     │
     ├── llama.cpp
     │      └── GGUF
     │
     └── MLX
            └── MLX models
```

Current LM Studio documentation explicitly supports both engines on Apple Silicon. ([LM Studio][5])

So the user doesn't necessarily need to understand all the runtime complexity.

LM Studio can select/manage the appropriate runtime.

---

# 17. This Is What a Modern Runner Looks Like

The old concept:

```text
"Run this model."
```

has evolved into:

```text
                 LOCAL AI RUNTIME
                        │
       ┌────────────────┼─────────────────┐
       │                │                 │
   Model Loading     Hardware          Serving
       │                │                 │
    GGUF/MLX        CUDA/Metal        REST API
       │             ROCm/Vulkan       OpenAI API
       │                │               MCP
       └────────────────┼─────────────────┘
                        │
                     Model
```

This is a much better definition of **Runner** for your guide.

---

# 18. The Runner Doesn't Necessarily Need Internet

This is important for the privacy discussion.

Once you have:

```text
model.gguf
```

and:

```text
llama.cpp
```

you can run:

```text
┌───────────────┐
│ Your Computer │
│               │
│ llama.cpp     │
│      │        │
│      ▼        │
│    Model      │
└───────────────┘

       INTERNET
          X
```

No Internet is necessary for inference.

Likewise:

```text
Ollama
 ↓
Local Model
```

can operate locally.

Ollama's current documentation explicitly distinguishes local models from cloud models; local models run on your computer, while cloud models are a separate capability. ([Ollama][2])

---

# 19. But the Runner Can Have Networking

This is where the original statement needs nuance.

The runner may expose:

```text
localhost:11434
```

or:

```text
localhost:1234
```

for local applications.

That is networking.

But:

```text
localhost
```

is fundamentally different from:

```text
Internet
```

For example:

```text
Python
   │
   │ HTTP
   ▼
localhost:11434
   │
   ▼
Ollama
   │
   ▼
Qwen
```

Everything can remain on your machine.

---

# 20. And You Can Deliberately Put the Runner on the LAN

For example:

```text
               Home LAN

        ┌────────────────────┐
        │                    │
     Laptop              Desktop
        │                    │
        └─────────┬──────────┘
                  │
                  ▼
          Ollama Server
          192.168.1.50
                  │
                  ▼
             RTX 3090 Ti
                  │
                  ▼
                Qwen
```

Now your laptop can use the AI running on your desktop.

That's still **local/self-hosted inference**, but the network boundary has changed.

And that's why security matters.

---

# 21. The Runner Can Also Reach the Internet

For example:

```text
                 Model
                   │
                   ▼
                 Agent
                   │
              Web Tool
                   │
                   ▼
               Internet
```

But here's the critical distinction:

**The model didn't acquire networking capability.**

The application/agent gave it a tool.

For example:

```text
Qwen
 ↓
"I need current information"
 ↓
Agent
 ↓
Search API
 ↓
Internet
 ↓
Results
 ↓
Qwen
```

That's **tool use**, not an intrinsic capability of the weights.

---

# 22. This Becomes a Security Boundary

This is where your networking/security background makes the subject particularly interesting.

Consider three configurations.

### Completely isolated

```text
             ┌───────────────┐
             │ Local Model   │
             │               │
             │ Runner        │
             └───────────────┘
                     X
                Internet
```

### Local API

```text
Applications
     │
     ▼
localhost
     │
     ▼
Runner
     │
     ▼
Model
```

### LAN AI server

```text
LAN
 │
 ▼
AI Server
 │
 ▼
Runner
 │
 ▼
Model
```

### Internet-enabled agent

```text
                  Model
                    │
                    ▼
                  Agent
                    │
            ┌───────┴────────┐
            ▼                ▼
          Files           Internet
```

Those are four very different security models.

---

# 23. llama.cpp Is Particularly Interesting Here

Current llama.cpp isn't just a local executable anymore.

It provides:

```text
llama-cli
llama-server
llama library
```

and its server provides an OpenAI-compatible API. ([GitHub][1])

It can also use remote compute through its RPC backend, although the project explicitly warns that this functionality is currently proof-of-concept, fragile and insecure and should not be exposed to an open network. ([GitHub][7])

That's an excellent example of why:

> **"Local AI" does not automatically mean "secure AI."**

Network exposure is still a configuration decision.

---

# 24. And This Is Where Your Docker Stack Fits

Your existing architecture:

```text
OpenWebUI
     │
     ▼
  Ollama
     │
     ▼
 Local LLM
```

is actually very clean.

You have:

```text
Browser
   │
   ▼
Open WebUI
   │
   ▼
Ollama API
   │
   ▼
Model
   │
   ▼
GPU
```

Your uploaded Ollama stack follows this architecture, with Open WebUI pointing at Ollama's `11434` endpoint.

Then you can add:

```text
               Open WebUI
                   │
          ┌────────┴────────┐
          ▼                 ▼
       Ollama             Qdrant
          │                 │
          ▼                 ▼
       Model              Memory
          │                 │
          └────────┬────────┘
                   ▼
                Flowise
                   │
              Agent Tools
```

Now you're no longer simply "running an LLM."

You're operating an **AI platform**.

---

# 25. The Most Important Difference: Engine vs Runtime vs Application

I'd actually revise the guide to use these terms.

### Engine

The low-level inference machinery.

Examples:

```text
llama.cpp
MLX
ONNX Runtime
TensorRT-LLM
```

### Runtime / Server

Manages models and exposes inference capabilities.

Examples:

```text
Ollama
llmster
llama-server
```

### Application

Gives the human a useful interface.

Examples:

```text
LM Studio
Open WebUI
```

Although these boundaries overlap heavily.

### Agent framework

Adds tools, memory and autonomous workflows.

Examples:

```text
Flowise
OpenCode
LangGraph
```

---

# 26. Updated Architecture

I'd replace the old diagram in the guide with this:

```text
┌─────────────────────────────────────────────────────────┐
│                        USER                             │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    APPLICATION                          │
│                                                         │
│ LM Studio • Open WebUI • Custom App • IDE              │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                 RUNTIME / MODEL SERVER                  │
│                                                         │
│ Ollama • llama-server • llmster                         │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                   INFERENCE ENGINE                      │
│                                                         │
│ llama.cpp • MLX • ONNX Runtime • TensorRT               │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                       MODEL                             │
│                                                         │
│ Qwen • Llama • Gemma • Mistral • DeepSeek               │
│                                                         │
│ Weights + Architecture + Tokenizer                      │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                      HARDWARE                           │
│                                                         │
│ CPU • NVIDIA GPU • AMD GPU • Apple GPU • NPU            │
│ RAM • VRAM • Unified Memory                             │
└─────────────────────────────────────────────────────────┘
```

And independently:

```text
                    OPTIONAL
                  AGENT LAYER
                       │
       ┌───────────────┼────────────────┐
       ▼               ▼                ▼
    Browser          Python           Files
       │               │                │
       └───────────────┼────────────────┘
                       │
                    Internet
                    (optional)
```

---

# 27. Current Runner Comparison

|                      | **llama.cpp**    | **Ollama**           | **LM Studio**         |
| -------------------- | ---------------- | -------------------- | --------------------- |
| Primary role         | Inference engine | Model runtime/server | Desktop AI platform   |
| Language/core        | C/C++            | Go + inference stack | App + native runtimes |
| GUI                  | Optional/web UI  | Minimal              | ⭐⭐⭐⭐⭐                 |
| CLI                  | ⭐⭐⭐⭐⭐            | ⭐⭐⭐⭐⭐                | ⭐⭐⭐⭐                  |
| API                  | ✅                | ✅                    | ✅                     |
| GGUF                 | ⭐⭐⭐⭐⭐            | ⭐⭐⭐⭐⭐                | ⭐⭐⭐⭐⭐                 |
| MLX                  | ❌                | Metal backend        | ⭐⭐⭐⭐⭐ Mac             |
| NVIDIA               | CUDA             | CUDA                 | CUDA/llama.cpp        |
| AMD                  | HIP/Vulkan       | ROCm/Vulkan          | Supported runtimes    |
| Apple                | Metal            | Metal                | MLX + Metal           |
| Server               | ⭐⭐⭐⭐⭐            | ⭐⭐⭐⭐⭐                | ⭐⭐⭐⭐⭐                 |
| Beginner             | ⭐⭐⭐              | ⭐⭐⭐⭐                 | ⭐⭐⭐⭐⭐                 |
| Developer            | ⭐⭐⭐⭐⭐            | ⭐⭐⭐⭐⭐                | ⭐⭐⭐⭐⭐                 |
| Homelab              | ⭐⭐⭐⭐⭐            | ⭐⭐⭐⭐⭐                | ⭐⭐⭐⭐                  |
| Fine-grained control | ⭐⭐⭐⭐⭐            | ⭐⭐⭐⭐                 | ⭐⭐⭐⭐                  |

LM Studio's current architecture makes the last few rows particularly different from older versions: it now has a headless `llmster` daemon, local APIs, MCP capabilities and runtime management. ([LM Studio][6])

---

# 28. One More Important 2026 Development: Parallel Inference

This is another thing I'd add to the guide.

A local runner isn't necessarily serving:

```text
User 1
  ↓
Model
  ↓
User 2
  ↓
Model
```

Modern inference engines can process multiple requests efficiently.

LM Studio 0.4 introduced **continuous batching and parallel requests** for its llama.cpp engine, allowing multiple requests to the same model rather than simply queueing them one after another. ([LM Studio][6])

This matters enormously when your local machine becomes:

```text
              AI SERVER
                  │
       ┌──────────┼──────────┐
       ▼          ▼          ▼
     User 1     User 2     User 3
       │          │          │
       └──────────┼──────────┘
                  ▼
                Model
```

That's when a desktop GPU starts looking like a genuine **AI inference server** rather than just a chatbot machine.

---

# 29. Your "Body" Analogy — Updated

I'd retain the analogy because it's excellent for beginners, but make it more sophisticated:

### 🧠 Model = Brain

Contains learned parameters.

It knows patterns.

It doesn't inherently browse, execute programs, access files or operate a network connection.

### 🫀 Runtime / Engine = Body

Loads the brain.

Moves its computations.

Feeds it data.

Uses CPU/GPU/NPU.

Manages memory.

### 🖥️ Application = Interface

Lets you interact with it.

### 🤖 Agent = Nervous System

Coordinates:

```text
Think
 ↓
Choose tool
 ↓
Execute action
 ↓
Observe result
 ↓
Think again
```

### 🌐 Tools = Senses / Limbs

```text
Browser
Filesystem
Python
Shell
APIs
Databases
Cameras
Microphones
```

---

# 30. The Updated Statement for Your Guide

I would replace the original paragraph with this:

> ## 🫀 The Runner — The Body
>
> The **runner** is the software that turns a model file into a functioning inference system. It loads the model's weights into memory, executes the neural-network operations, manages CPU/GPU/NPU acceleration, handles tokenization and context, and generates the model's output.
>
> Examples include **llama.cpp, Ollama, LM Studio's runtime/server stack, MLX, ONNX Runtime, and TensorRT-based runtimes**.
>
> A runner may also expose a local or network API so other applications can use the model. For example, Ollama provides a local API at `localhost:11434`, while llama.cpp provides `llama-server`, and LM Studio provides local OpenAI-compatible and other APIs. ([Ollama][3])
>
> The runner is also responsible for translating the model's mathematical operations into instructions that your hardware can execute. Depending on the system, this can involve **CUDA on NVIDIA, ROCm/HIP on AMD, Metal on Apple Silicon, Vulkan, CPU instruction sets, or other accelerator backends**. ([Ollama][4])
>
> **The model itself does not automatically gain these capabilities.** Internet access, web browsing, Python execution, shell access, filesystem access, databases, and other tools are provided by the surrounding application or agent system.
>
> In other words:
>
> **Model = what the AI has learned.**
> **Runtime = how the AI thinks on your hardware.**
> **Application = how you interact with it.**
> **Agent = how it uses tools to accomplish tasks.**

That is the version I'd use as the **canonical architecture explanation** in your ML Guide. It also sets us up perfectly for the next layer: **what actually happens inside the GPU when a runner performs inference — tensors, matrix multiplication, attention, KV cache, GPU offloading, context length, tokens/sec, and why VRAM/RAM requirements behave the way they do.**

[1]: https://github.com/ggml-org/llama.cpp/blob/master/README.md "llama.cpp/README.md at master · ggml-org/llama.cpp · GitHub"
[2]: https://docs.ollama.com/ "Ollama documentation - Ollama"
[3]: https://docs.ollama.com/api "Introduction - Ollama"
[4]: https://docs.ollama.com/gpu "Hardware support - Ollama"
[5]: https://lmstudio.ai/docs/app "Welcome to LM Studio Docs! | LM Studio"
[6]: https://lmstudio.ai/blog/0.4.0 "Introducing LM Studio 0.4.0 | LM Studio Blog | LM Studio"
[7]: https://github.com/ggml-org/llama.cpp/blob/master/tools/rpc/README.md "llama.cpp/tools/rpc/README.md at master · ggml-org/llama.cpp · GitHub"
