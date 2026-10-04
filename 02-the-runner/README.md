# 🫀 The Runner — The "Body" of Local AI

The **Runner** is the software that turns a model's weights into a functioning inference system.

A model file sitting on an SSD is just data. The runner loads that model into memory, prepares its tokenizer and configuration, executes the neural-network operations, manages CPU/GPU/NPU acceleration, maintains inference state such as the KV cache, and produces the model's output.

The original idea was:

> **The Runner (The Body): Tools like Ollama, LM Studio, or llama.cpp are the "bodies." They are actual programs that talk to your hardware and, when configured to do so, can communicate over a network.**

That is still a useful beginner analogy, but modern local AI has become more layered.

The cleanest way to understand it is:

> **Engine → Runtime/Server → Application → Agent**

These layers often overlap, but the distinction helps explain what each component actually does.

---

# 1. The Local AI Stack

```text
┌──────────────────────────────────────────────┐
│                    USER                      │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│                APPLICATION                   │
│                                              │
│ LM Studio • Open WebUI • IDE • Custom App    │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│              RUNTIME / SERVER                │
│                                              │
│ Ollama • llama-server • llmster • vLLM       │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│              INFERENCE ENGINE                │
│                                              │
│ llama.cpp • MLX • ONNX Runtime •             │
│ TensorRT-LLM • other accelerator runtimes    │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│                    MODEL                     │
│                                              │
│ Qwen • Llama • Gemma • Mistral • Nemotron    │
│                                              │
│ Weights + Architecture + Tokenizer           │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│                   HARDWARE                   │
│                                              │
│ CPU • GPU • NPU • RAM • VRAM • Unified RAM   │
└──────────────────────────────────────────────┘
```

Not every system contains every layer as a separate program.

For example:

```text
Ollama
 ├── runtime
 ├── model management
 ├── server
 └── inference stack

LM Studio
 ├── application
 ├── runtime management
 ├── server
 ├── CLI
 └── llama.cpp / MLX engines

llama.cpp
 ├── inference engine
 ├── CLI
 ├── server
 └── hardware backends
```

The boundaries are therefore conceptual rather than absolute.

---

# 2. What Does a Runner Actually Do?

When you enter:

```text
What is the capital of France?
```

the computer does considerably more than:

```text
prompt → model → answer
```

A simplified inference path looks like this:

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
Model weights + configuration
   │
   ▼
Neural-network operations
   │
   ▼
CPU / GPU / NPU kernels
   │
   ▼
Logits
   │
   ▼
Sampling / decoding
   │
   ▼
Next token
   │
   └──────────────┐
                  ▼
               Repeat
                  │
                  ▼
               Response
```

The runner coordinates this process.

It is responsible for things such as:

- loading model files
- allocating memory
- initializing the hardware backend
- tokenization
- executing neural-network operations
- managing context
- managing the KV cache
- sampling/decoding
- streaming output
- GPU/CPU/NPU offloading
- batching multiple requests
- exposing APIs
- loading and unloading models

Modern inference servers can also provide:

- structured output
- tool/function calling
- multimodal inputs
- embeddings
- speculative decoding
- monitoring
- concurrent requests

The exact capabilities depend on the engine and runtime.

---

# 3. A Model File Is Not a Running Model

Suppose you have:

```text
Qwen-XXXX-Q4_K_M.gguf
```

on your SSD.

Nothing is executing.

It is simply a file containing model data.

Conceptually:

```text
SSD
 │
 ▼
Model file
 │
 ▼
Runner
 │
 ├── reads metadata
 ├── loads tensors
 ├── allocates memory
 ├── initializes backend
 ├── initializes tokenizer
 └── prepares inference
       │
       ▼
   RAM / VRAM
```

Only after the runner loads and initializes the model can the hardware execute it.

This is why:

> **Model = learned parameters and architecture**

while:

> **Runner = software that executes those parameters**

---

# 4. The Runner Is the Hardware Translator

The model should not have to know whether it is running on:

```text
RTX 3090 Ti
Apple Silicon
AMD Radeon
Intel GPU
NVIDIA data-center GPU
CPU
NPU
```

The inference software provides the hardware-specific implementation.

For example:

```text
                    Inference Runtime
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
      CUDA                Metal             ROCm/HIP
        │                  │                  │
     NVIDIA             Apple GPU          AMD GPU
```

Other backends can include Vulkan, SYCL, OpenCL, CANN, WebGPU and specialized accelerator APIs.

This abstraction is one of the most important reasons local AI works across such a wide variety of hardware.

---

# 5. llama.cpp — The Inference Engine

[llama.cpp](https://github.com/ggml-org/llama.cpp) is best described as an **inference engine, library and toolkit**, rather than simply an application.

Its project describes itself as:

> LLM inference in C/C++

It is built on the **ggml** tensor ecosystem and is designed for efficient inference across a very wide range of hardware.

Today llama.cpp includes:

```text
llama.cpp
│
├── inference library
├── CLI
├── llama-server
├── model loading
├── quantization
├── multimodal/VLM support
├── CPU backends
├── GPU backends
├── structured generation
├── tool/function calling
└── REST APIs
```

It supports CPU+GPU hybrid inference, multiple quantization levels, NVIDIA CUDA, AMD HIP, Apple Metal, Vulkan, SYCL and other backends.

It can also download and run compatible models directly from Hugging Face:

```bash
llama cli -hf ggml-org/Qwen3.5-0.8B-GGUF
```

and launch an OpenAI-compatible server:

```bash
llama serve -hf ggml-org/Qwen3.5-0.8B-GGUF
```

The current `llama-server` also supports features such as continuous batching, parallel multi-user inference, multimodal input, embeddings, structured JSON, tool/function calling and speculative decoding.

**Why it matters:**

llama.cpp is one of the foundational pieces of the modern local-LLM ecosystem.

It is particularly valuable when you want:

- maximum control
- broad hardware compatibility
- GGUF models
- CPU inference
- GPU offloading
- hybrid CPU/GPU inference
- lightweight servers
- embedded/local deployments
- direct experimentation with inference

---

# 6. Ollama — Runtime + Model Management + Server

[Ollama](https://ollama.com) sits at a higher level than llama.cpp.

It is best thought of as a **local model runtime, model-management system and API server**.

Conceptually:

```text
Ollama
│
├── Model management
├── Model storage
├── Model loading
├── Inference
├── Hardware acceleration
├── Local HTTP API
├── OpenAI-compatible API
├── Anthropic-compatible API
├── Python/JavaScript integrations
└── Application integrations
```

For example:

```text
Open WebUI
     │
     ▼
Ollama API
     │
     ▼
Local model
     │
     ▼
GPU
```

Ollama's local API is available at:

```text
http://localhost:11434/api
```

and its OpenAI-compatible API is available at:

```text
http://localhost:11434/v1
```

Local requests do not require an API key.

Ollama now also has a distinct cloud capability. Therefore, it is important not to equate:

> **Ollama = always completely offline**

The correct statement is:

> **Ollama can run models locally, while also providing separate cloud-model capabilities.**

For a privacy-first deployment, Ollama can also be configured to disable its cloud features.

---

# 7. Ollama and Hardware

Ollama provides hardware-specific acceleration through different backends.

For example:

```text
RTX 3090 Ti
     │
     ▼
   CUDA
     │
     ▼
   Ollama
     │
     ▼
   Qwen
```

On Apple Silicon:

```text
Apple Silicon
     │
     ▼
   Metal
     │
     ▼
   Ollama
     │
     ▼
   Qwen
```

Ollama currently supports NVIDIA GPUs including the RTX 30-series, AMD GPUs through ROCm/HIP, Apple GPUs through Metal, and additional Windows/Linux GPU support through Vulkan.

For your RTX 3090 Ti specifically, Ollama lists the card as supported NVIDIA hardware.

Ollama can also report whether a model is running entirely on the GPU, entirely in system memory, or split between CPU and GPU.

For example:

```text
100% GPU
```

or:

```text
48% CPU / 52% GPU
```

This is important when a model is larger than available VRAM.

---

# 8. LM Studio — Application + Runtime Platform

[LM Studio](https://lmstudio.ai) occupies a different position.

It is primarily a **local AI application platform**, but it also contains substantial runtime and server functionality.

Conceptually:

```text
                 LM Studio
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
         GUI       Runtime     API
          │          │          │
      Model Hub      │       Applications
                     │
              ┌──────┴──────┐
              ▼             ▼
          llama.cpp         MLX
              │             │
             GGUF      MLX models
```

LM Studio currently supports:

- GGUF models through llama.cpp
- MLX models on Apple Silicon
- local model management
- Hugging Face model discovery/download
- local APIs
- network model serving
- MCP
- structured output
- tool use
- CLI workflows

---

# 9. LM Studio Is No Longer "Just a GUI"

This is one of the biggest updates to the old local-AI mental model.

LM Studio introduced **llmster**, a standalone, headless version of its core runtime.

```text
Old mental model:

LM Studio
    │
    ▼
   GUI
    │
    ▼
llama.cpp
```

That is now incomplete.

A better model is:

```text
                    LM Studio
                        │
              ┌─────────┴─────────┐
              ▼                   ▼
             GUI               llmster
                                  │
                       ┌──────────┴──────────┐
                       ▼                     ▼
                   llama.cpp               MLX
                       │                     │
                     GGUF              MLX models
```

`llmster` can run without the GUI on:

- Linux servers
- GPU workstations
- cloud machines
- CI systems
- local headless systems

For example:

```bash
lms daemon up
lms get <model>
lms server start
```

This makes LM Studio much more relevant to homelab and server deployments than its older "desktop GUI" reputation suggests.

---

# 10. LM Studio and Parallel Inference

A modern AI server doesn't necessarily have to process:

```text
User 1
   ↓
Model
   ↓
User 2
   ↓
Model
```

one request at a time.

Modern inference engines can use **continuous batching** to process multiple requests concurrently.

LM Studio's llama.cpp engine supports parallel requests and continuous batching.

Conceptually:

```text
User 1 ──┐
User 2 ──┼──► Model
User 3 ──┤
User 4 ──┘
```

This is an important transition:

> A powerful desktop GPU can become a multi-user AI inference server.

This matters enormously in a homelab.

---

# 11. MLX — Apple's ML Framework

[MLX](https://github.com/ml-explore/mlx) deserves a special category.

MLX is an **array and machine-learning framework**, originally designed specifically around Apple Silicon's architecture.

Its major architectural advantage is Apple's unified memory.

```text
          Apple Unified Memory
        ┌───────────────────────┐
        │                       │
        │    CPU + GPU share    │
        │    the same memory    │
        │                       │
        └───────────────────────┘
```

MLX is designed so arrays can be accessed by CPU and GPU without the traditional explicit device-to-device copies required by many other architectures.

That makes it particularly attractive for:

- Apple Silicon local LLMs
- model experimentation
- fine-tuning
- LoRA
- inference
- multimodal workloads
- research

An important 2026 update:

> **Do not describe MLX as strictly "Apple-only" anymore.**

The MLX project now also provides CUDA and CPU Linux packages.

However, its defining strength and original design remain closely associated with Apple Silicon and unified memory.

---

# 12. ONNX Runtime — Portable Inference

**ONNX Runtime** occupies another part of the ecosystem.

ONNX is a model representation designed for interoperability, while **ONNX Runtime** is the software that executes ONNX models.

For generative AI, Microsoft's ONNX Runtime GenAI adds generation-oriented APIs and model/runtime functionality.

Think:

```text
Model
  │
  ▼
ONNX representation
  │
  ▼
ONNX Runtime
  │
  ├── CPU
  ├── GPU
  └── accelerator-specific execution providers
```

ONNX Runtime is particularly useful when your priority is:

- cross-platform deployment
- Windows
- edge AI
- enterprise applications
- hardware abstraction
- integration with Microsoft's AI ecosystem
- portable inference pipelines

It is not simply another GGUF runner.

---

# 13. TensorRT-LLM — NVIDIA High-Performance Inference

For NVIDIA-heavy environments, another important runner/inference stack is **TensorRT-LLM**.

TensorRT-LLM is designed specifically to optimize and serve LLM workloads on NVIDIA GPUs.

Conceptually:

```text
Model
  │
  ▼
TensorRT-LLM
  │
  ▼
Optimized TensorRT engine/runtime
  │
  ▼
CUDA
  │
  ▼
NVIDIA GPU
```

It is much more oriented toward high-performance serving than beginner-friendly desktop inference.

It supports technologies including:

- in-flight batching
- paged KV caching
- quantization
- multi-GPU inference
- multi-node deployment
- speculative decoding
- optimized model implementations
- production-scale serving

This makes TensorRT-LLM particularly relevant for:

- NVIDIA servers
- datacenters
- high-throughput inference
- multi-GPU systems
- production AI services

For a home user with a single RTX 3090 Ti, Ollama or llama.cpp is generally much simpler.

For a large NVIDIA inference cluster, TensorRT-LLM becomes much more interesting.

---

# 14. Other Important Inference Runtimes

The ecosystem is considerably larger than Ollama and llama.cpp.

A useful high-level map is:

| Runtime / Engine | Primary role | Best fit |
|---|---|---|
| **llama.cpp** | General local inference engine | Local LLMs, GGUF, broad hardware |
| **Ollama** | Model runtime + management + API | Beginners, developers, homelabs |
| **LM Studio / llmster** | Desktop + headless AI platform | Desktop users and local servers |
| **MLX** | ML framework optimized around Apple Silicon | Macs, Apple research/fine-tuning |
| **ONNX Runtime GenAI** | Portable inference/runtime | Windows, edge, enterprise |
| **TensorRT-LLM** | NVIDIA-optimized LLM inference | High-performance NVIDIA serving |
| **vLLM** | High-throughput LLM serving | GPU servers, production inference |
| **SGLang** | High-performance serving/runtime | Advanced serving and agent workloads |

The important lesson is:

> **There is no single "best runner."**

The correct runtime depends on the hardware, model format, operating system, workload, and whether you are running one user or serving many.

---

# 15. Runner vs Application

This distinction is worth emphasizing.

### Runner

Makes the model execute.

```text
Model
 ↓
Runner
 ↓
Hardware
```

### Application

Makes the model useful to a human.

```text
User
 ↓
Application
 ↓
Runner
 ↓
Model
```

Examples:

**Runner**

```text
llama.cpp
Ollama
llmster
MLX
ONNX Runtime
TensorRT-LLM
vLLM
```

**Application**

```text
LM Studio
Open WebUI
IDE
Custom Python application
Mobile application
```

Although LM Studio itself spans both categories.

---

# 16. The Runner Does Not Give the Model Internet Access

This is one of the most important concepts in the entire guide.

A local model does not automatically know how to:

- browse the web
- execute Python
- execute shell commands
- read your filesystem
- query a database
- send an email
- control Docker
- access Git
- access your camera

Those capabilities come from surrounding software.

For example:

```text
             MODEL
               │
               ▼
             AGENT
               │
       ┌───────┼────────┐
       ▼       ▼        ▼
    Browser  Python    Files
       │       │        │
       └───────┼────────┘
               │
            Internet
            (optional)
```

The model might *request*:

> "Search the web for the latest NVIDIA news."

But the model itself isn't performing the HTTP request.

The agent/tool layer performs it and returns the result to the model.

---

# 17. The Runner Can Have Networking

There is an important distinction between:

> **Networking capability**

and:

> **Internet access by the model.**

For example, Ollama normally exposes a local HTTP API:

```text
localhost:11434
```

That is networking, but it doesn't mean the model is browsing the Internet.

A typical local architecture is:

```text
Browser
   │
   ▼
Open WebUI
   │
   ▼
localhost:11434
   │
   ▼
Ollama
   │
   ▼
Local Model
```

Everything can remain on the same computer.

---

# 18. Localhost vs LAN vs Internet

These should not be treated as the same thing.

### Local-only

```text
Computer
 ├── Application
 ├── Runner
 └── Model

        X
     Internet
```

### Local API

```text
Application
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
Laptop ───────┐
              │
Desktop ──────┼──► AI Server
              │       │
Phone ────────┘       ▼
                    Model
```

### Internet-enabled agent

```text
Model
  │
  ▼
Agent
  │
  ├── Files
  ├── Shell
  ├── Browser
  └── Internet
```

These represent very different security models.

---

# 19. Local AI Does Not Automatically Mean Secure AI

This distinction is especially important for self-hosted systems.

Consider:

```text
Local model
+
local runner
```

This can be highly private.

But:

```text
Local model
+
runner
+
LAN API
+
shell access
+
browser
+
filesystem
+
Internet
```

is a completely different security environment.

An AI server exposed to your LAN or Internet is still a network service.

Therefore:

> **"Local" describes where computation happens. It does not automatically describe how secure the system is.**

Treat an AI runtime like any other network service.

Use:

- authentication where appropriate
- firewall rules
- VLAN segmentation
- least privilege
- container isolation
- restricted filesystem access
- restricted network access
- logging
- monitoring

This becomes even more important when an agent can execute tools.

---

# 20. Your Homelab Example

Your existing architecture is an excellent example:

```text
                    Browser
                       │
                       ▼
                 ┌───────────┐
                 │ Open WebUI│
                 └─────┬─────┘
                       │
                       ▼
                 ┌───────────┐
                 │  Ollama   │
                 │   :11434  │
                 └─────┬─────┘
                       │
                       ▼
                 ┌───────────┐
                 │Local Model│
                 └─────┬─────┘
                       │
                       ▼
                 ┌───────────┐
                 │RTX 3090 Ti│
                 └───────────┘
```

Then additional components can be added:

```text
                     Open WebUI
                         │
                ┌────────┴────────┐
                ▼                 ▼
              Ollama            Qdrant
                │                 │
                ▼                 ▼
             Model             Vector DB
                │                 │
                └────────┬────────┘
                         ▼
                       Agent
                         │
             ┌───────────┼───────────┐
             ▼           ▼           ▼
          Browser      Python       Files
```

At that point, you are no longer simply running a chatbot.

You are operating a **local AI platform**.

---

# 21. The Modern Runner Architecture

The most useful architecture for this guide is therefore:

```text
┌─────────────────────────────────────────────────────────┐
│                         USER                            │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                     APPLICATION                         │
│                                                         │
│ LM Studio • Open WebUI • IDE • Custom Application       │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  RUNTIME / MODEL SERVER                 │
│                                                         │
│ Ollama • llama-server • llmster • vLLM • SGLang         │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    INFERENCE ENGINE                     │
│                                                         │
│ llama.cpp • MLX • ONNX Runtime • TensorRT-LLM           │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                         MODEL                           │
│                                                         │
│ Qwen • Llama • Gemma • Mistral • Nemotron • etc.        │
│                                                         │
│ Weights + Architecture + Tokenizer + Configuration      │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                        HARDWARE                         │
│                                                         │
│ CPU • NVIDIA GPU • AMD GPU • Apple GPU • NPU            │
│ RAM • VRAM • Unified Memory                             │
└─────────────────────────────────────────────────────────┘
```

And separately:

```text
                    OPTIONAL AGENT LAYER
                              │
              ┌───────────────┼────────────────┐
              ▼               ▼                ▼
           Browser          Python           Files
              │               │                │
              └───────────────┼────────────────┘
                              │
                         APIs / Internet
                              │
                           Optional
```

---

# 22. Engine vs Runtime vs Application vs Agent

This is the terminology I recommend using throughout the guide.

### 🧮 Inference Engine

The low-level machinery that executes the neural network.

Examples:

```text
llama.cpp
MLX
ONNX Runtime
TensorRT-LLM
```

### 🫀 Runtime / Model Server

Loads models, manages inference and often exposes APIs.

Examples:

```text
Ollama
llama-server
llmster
vLLM
SGLang
```

### 🖥️ Application

Provides a user-facing experience.

Examples:

```text
LM Studio
Open WebUI
IDE
Custom application
```

### 🤖 Agent

Adds autonomous behavior and tool use.

Examples:

```text
OpenClaw
Hermes
LangChain / LangGraph
coding agents
Flowise
```

These categories overlap. They are **architectural roles**, not rigid product classifications.

---

# 23. Comparison: The Major Local Runtimes

| | llama.cpp | Ollama | LM Studio | MLX | ONNX Runtime | TensorRT-LLM |
|---|---|---|---|---|---|---|
| Primary role | Inference engine | Runtime/server | AI platform | ML framework | Portable runtime | NVIDIA LLM runtime |
| GUI | Optional | Minimal | Excellent | No | No | No |
| CLI | Excellent | Excellent | Excellent | Excellent | Yes | Yes |
| API server | Yes | Yes | Yes | Via ecosystem | Yes | Yes |
| GGUF | Excellent | Excellent | Excellent | Supported in current MLX core | No | Not primary |
| MLX | No | No | Yes | Native | No | No |
| NVIDIA | CUDA | CUDA | CUDA/llama.cpp | CUDA available | Provider-dependent | Excellent |
| AMD | HIP/Vulkan | ROCm/Vulkan | Runtime-dependent | CUDA/CPU focus | Provider-dependent | No |
| Apple | Metal | Metal | MLX + llama.cpp | Excellent | Supported paths | No |
| CPU inference | Excellent | Yes | Yes | Yes | Excellent | Primarily GPU |
| Hybrid CPU/GPU | Yes | Yes | Yes | Unified memory model | Provider-dependent | GPU-focused |
| Best for | Control/portability | Easy local AI servers | Desktop + server | Apple ML | Portable deployment | NVIDIA performance |

---

# 24. The "Body" Analogy — Final Version

The analogy is still useful, but it should now include the entire AI organism.

### 🧠 Model = Brain

Contains the learned parameters and architecture.

It provides the learned capability.

It does not inherently browse the Internet, execute programs or access your files.

### 🫀 Runtime / Engine = Body

Loads the model and performs its computations.

It manages:

- CPU/GPU/NPU
- memory
- model loading
- inference
- KV cache
- token generation

### 🖥️ Application = Interface

Provides the interface through which humans interact with the AI.

### 🤖 Agent = Nervous System

Coordinates:

```text
Goal
 ↓
Model
 ↓
Choose action
 ↓
Tool
 ↓
Observe result
 ↓
Model
 ↓
Repeat
```

### 🖐️ Tools = Senses and Limbs

Examples:

```text
Browser
Filesystem
Python
Shell
Git
APIs
Databases
Cameras
Microphones
```

### 🛡️ Security / Sandbox = Protective Boundary

Controls what the agent is actually allowed to access.

This distinction becomes increasingly important as AI moves from answering questions to taking actions.

---

# 25. The Canonical Statement

> ## 🫀 The Runner — The "Body"
>
> The **runner** is the software that turns a model file into a functioning inference system. It loads the model's weights into memory, prepares the model for execution, performs the neural-network computations, manages CPU/GPU/NPU acceleration, handles context and KV-cache state, and generates the model's output.
>
> Examples include **llama.cpp, Ollama, LM Studio's runtime/server stack, MLX, ONNX Runtime, TensorRT-LLM, vLLM, and SGLang**.
>
> A runner may also expose an API so other applications can communicate with the model. For example, Ollama provides local HTTP and OpenAI-compatible APIs, llama.cpp provides `llama-server`, and LM Studio provides local APIs and the headless `llmster` runtime.
>
> The runner also translates the model's mathematical operations into instructions that the available hardware can execute. Depending on the platform, this can involve **CUDA, ROCm/HIP, Metal, Vulkan, CPU instruction sets, or other accelerator backends**.
>
> The model itself does not automatically gain Internet access, web browsing, Python execution, shell access, filesystem access, database access or other tools. Those capabilities are provided by the surrounding application or agent system.
>
> **In other words:**
>
> **Model = what the AI has learned.**
>
> **Inference engine = how the neural network is executed.**
>
> **Runtime/server = how the model is loaded, managed and exposed.**
>
> **Application = how humans interact with it.**
>
> **Agent = how the AI uses tools to accomplish tasks.**
>
> **Security runtime = what the AI is actually allowed to do.**