# The Model - Brain

This is one of the most important concepts to understand if you're going to build the **Machine Learning / Local AI Guide**, because once someone understands *what a model actually is*, terms like **GGUF, Q4_K_M, ONNX, Safetensors, MLX, FP16, BF16, MoE, tokenizer, inference runtime** start making sense rather than looking like alphabet soup.

The key correction I'd make to the original beginner statement is:

> **A model is not an AI application. It is learned numerical data plus the architecture/configuration needed to interpret that data. The runtime turns those numbers into an operating AI system.**

---

# 1. First: What Actually Is an AI Model?

Let's start at the lowest level.

Suppose you download:

```text
Qwen3-8B-Instruct-Q4_K_M.gguf
```

It might be several gigabytes.

It isn't a program in the traditional sense.

It doesn't contain:

```text
browser.exe
network.dll
python.exe
shell.exe
```

Instead, it contains enormous numbers.

For example, conceptually:

```text
0.01842
-0.37291
0.004821
1.72831
-0.09123
...
```

There can be **billions or tens/hundreds of billions of these values**.

These numbers are called **parameters**, commonly referred to as **weights**.

---

# 2. What Did Those Numbers Learn?

During training, the neural network was repeatedly shown enormous amounts of data.

Very simplified:

```text
"The capital of France is ____"
```

The model predicts:

```text
London      0.02
Berlin      0.01
Paris       0.94
Madrid      0.01
...
```

It gets feedback about the error.

Then millions/billions/trillions of training examples later, the parameters have been adjusted so the network becomes extremely good at predicting patterns.

The important thing is:

### The model doesn't store a traditional database of answers.

It learns **statistical representations**.

That's why saying:

> "The model contains everything it knows"

is somewhat misleading.

A better mental model is:

> **The weights encode a huge distributed mathematical representation of patterns learned during training.**

---

# 3. The Model Is a Mathematical Machine

A neural network can be thought of as a gigantic mathematical function:

```text
Input
  ↓
Tokenization
  ↓
Neural network
  ↓
Probability distribution
  ↓
Next token
  ↓
Repeat
  ↓
Output
```

For an LLM:

```text
You: What is the capital of France?

              ↓

        Tokenizer

              ↓

       [tokens/numbers]

              ↓

      Transformer network

              ↓

     probability distribution

              ↓

            Paris

              ↓

        next-token loop
```

This is why LLMs are fundamentally **prediction engines**.

---

# 4. What Is Actually Inside a Model File?

A modern model distribution typically contains several things.

For example:

```text
Qwen/
│
├── model weights
│
├── tokenizer
│
├── model configuration
│
├── vocabulary
│
└── metadata
```

The exact arrangement depends on the model format and ecosystem.

The **weights** are the important part, but they're not necessarily sufficient by themselves.

You also need to know things such as:

```text
What architecture?
How many layers?
Hidden dimension?
Number of attention heads?
Vocabulary?
Tokenizer?
Context configuration?
Position encoding?
```

This information allows the runtime to correctly interpret the weights.

---

# 5. The Transformer Is the "Brain Architecture"

Most modern LLMs are based on the **Transformer architecture**.

For example:

```text
Qwen
Llama
Gemma
Mistral
DeepSeek
GPT-family architectures
```

have transformer-derived architectures, although the exact architecture and implementation details differ.

Conceptually:

```text
              MODEL
                │
        ┌───────┴────────┐
        │                │
    Architecture       Weights
        │                │
    Transformer       Billions of
                       numbers
```

The architecture says:

> **How should these numbers be mathematically used?**

The weights say:

> **What did training teach this network?**

---

# 6. An Important Distinction: Model ≠ Model File

This is where things get interesting.

Imagine the same underlying model is distributed as:

```text
model.safetensors
model.gguf
model.mlpackage
model.mlx
model.onnx
```

These aren't necessarily five different AI models.

They can represent the **same learned model in different representations designed for different runtimes/hardware**.

Think:

```text
                   SAME MODEL
                       │
        ┌──────────────┼──────────────┐
        │              │              │
      GGUF         Safetensors       ONNX
        │              │              │
    llama.cpp       PyTorch/HF     ONNX Runtime
        │              │              │
     CPU/GPU       Training/       Cross-platform
     local AI       inference
```

And:

```text
                   SAME MODEL
                       │
                     MLX
                       │
                  Apple Silicon
```

This distinction is critical.

---

# 7. The Major Model Formats

Here's the map I would put into your guide.

| Format                     | Primary ecosystem             | Best use                          |
| -------------------------- | ----------------------------- | --------------------------------- |
| **GGUF**                   | llama.cpp ecosystem           | Local LLM inference               |
| **Safetensors**            | Hugging Face / PyTorch        | Training + general inference      |
| **ONNX**                   | ONNX Runtime / Windows / edge | Cross-platform inference          |
| **MLX**                    | Apple Silicon                 | Mac local AI                      |
| **PyTorch `.bin` / `.pt`** | PyTorch                       | Training/research                 |
| **TensorRT / engines**     | NVIDIA                        | High-performance NVIDIA inference |
| **Core ML / MLPackage**    | Apple                         | Apple deployment                  |
| **Diffusers format**       | Hugging Face                  | Image/video generation            |

The important thing:

> **These formats solve different problems.**

---

# 8. GGUF — The Local LLM Workhorse

If you're getting into local LLMs, **GGUF is probably the single most important format to understand.**

GGUF was created for the **GGML/llama.cpp ecosystem**.

The official llama.cpp documentation explicitly requires models to be stored in GGUF for llama.cpp, and models in other formats can be converted to GGUF. ([GitHub][1])

A GGUF file contains more than raw tensor data.

It has:

```text
GGUF
│
├── Header
├── Metadata
├── Tensor descriptions
└── Tensor data
```

The current GGUF structure includes tensor names, dimensions, types, offsets and metadata. ([GitHub][2])

---

# 9. Why GGUF Became So Important

GGUF is extremely convenient for **local inference**.

For example:

```text
Qwen3-8B-Q4_K_M.gguf
```

Download it.

Open it in:

* LM Studio
* llama.cpp
* many local AI applications
* various model servers

And you're running.

That's radically simpler than setting up a research environment.

---

# 10. The Magic Word: Quantization

Now we get to:

```text
Q4
Q5
Q6
Q8
FP16
BF16
```

This is arguably more important to a local AI user than the file extension itself.

---

# 11. What Is Quantization?

Imagine a model has:

```text
1.234567
```

Instead of storing that value with extremely high precision, we can approximate it:

```text
1.23
```

Or even more aggressively:

```text
1.2
```

You lose some numerical precision.

But you save enormous amounts of memory.

That's **quantization**.

---

# 12. Why Quantization Matters So Much

Suppose you have a model with:

```text
8 billion parameters
```

Very roughly:

### FP32

```text
8B × 4 bytes
≈ 32 GB
```

### FP16

```text
8B × 2 bytes
≈ 16 GB
```

### INT8

```text
8B × 1 byte
≈ 8 GB
```

### 4-bit

```text
8B × 0.5 bytes
≈ 4 GB
```

There is additional overhead, so actual files aren't exactly these numbers.

But this illustrates why quantization changed local AI.

---

# 13. Q4_K_M — What Does That Weird Name Mean?

You'll encounter names such as:

```text
Q4_K_M
Q5_K_M
Q6_K
Q8_0
```

The important part for beginners:

```text
Q4 ≈ 4-bit quantization
Q5 ≈ 5-bit
Q6 ≈ 6-bit
Q8 ≈ 8-bit
```

Higher precision generally means:

```text
better numerical fidelity
       ↓
larger model
       ↓
more memory
       ↓
potentially slower
```

Lower precision:

```text
smaller
  ↓
less memory
  ↓
easier local deployment
```

But the relationship isn't simply "Q8 is always better."

Modern quantization schemes are sophisticated.

---

# 14. The Local AI Sweet Spot

For many local LLM applications:

```text
Q4_K_M
```

is an excellent starting point.

That's why you'll see:

```text
Llama-3.1-8B-Instruct-Q4_K_M.gguf
```

or:

```text
Qwen3-14B-Q4_K_M.gguf
```

This gives a strong balance between:

**quality ↔ memory ↔ speed**

Your existing LM Studio notes similarly recommend Q4_K_M models as practical starting points for GPUs with limited VRAM.

---

# 15. Safetensors

Now let's move upstream.

You'll frequently encounter:

```text
model.safetensors
```

This is particularly common on Hugging Face.

Safetensors is designed to store tensors safely and efficiently and supports zero-copy loading. ([Hugging Face][3])

One important security advantage:

### Safetensors doesn't use Python pickle to deserialize the weights.

That matters because pickle files can potentially execute arbitrary code when loaded.

Hugging Face specifically describes Safetensors as a secure alternative to pickle-based weight files. ([Hugging Face][4])

---

# 16. Safetensors Is Often the "Master" Distribution

A typical Hugging Face repository might look something like:

```text
Qwen/
│
├── config.json
├── tokenizer.json
├── tokenizer_config.json
│
├── model-00001-of-00004.safetensors
├── model-00002-of-00004.safetensors
├── model-00003-of-00004.safetensors
└── model-00004-of-00004.safetensors
```

That's very different from:

```text
Qwen3-14B-Q4_K_M.gguf
```

The first is much closer to the **research/development distribution**.

The second is optimized for **local inference**.

---

# 17. The Conversion Pipeline

This is an extremely useful concept.

Think:

```text
                 TRAINING
                    │
                    ▼
              PyTorch Model
                    │
                    ▼
               Safetensors
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
        GGUF                 ONNX
          │                   │
      llama.cpp          ONNX Runtime
          │                   │
          ▼                   ▼
     Local LLM          Edge / Apps
```

And on Apple:

```text
              Hugging Face
                    │
                    ▼
                   MLX
                    │
                    ▼
             Apple Silicon
```

This is why **model conversion** is such a major part of the local AI ecosystem.

---

# 18. ONNX

Now we get into a very different philosophy.

**ONNX = Open Neural Network Exchange.**

The idea is essentially:

> Define a standardized representation of a neural network so different ML frameworks and runtimes can work with it.

This is particularly useful for deployment.

Think:

```text
PyTorch
   │
   ▼
 ONNX
   │
 ├── Windows
 ├── NVIDIA
 ├── AMD
 ├── Intel
 ├── CPU
 └── Edge devices
```

ONNX is particularly interesting for your **Windows AI / Windows ML** research.

---

# 19. ONNX's Big Advantage

Suppose a developer trains a model in PyTorch.

They don't necessarily want the production application to require the entire PyTorch ecosystem.

Instead:

```text
Training environment
       ↓
     ONNX
       ↓
Production inference runtime
```

This separation can make deployment easier.

---

# 20. ONNX vs GGUF

This is a really important comparison.

|                    | GGUF                | ONNX             |
| ------------------ | ------------------- | ---------------- |
| Main purpose       | Local LLM inference | Model deployment |
| Famous runtime     | llama.cpp           | ONNX Runtime     |
| Quantization       | Excellent           | Supported        |
| LLM focused        | ⭐⭐⭐⭐⭐               | ⭐⭐⭐              |
| Edge AI            | ⭐⭐⭐                 | ⭐⭐⭐⭐⭐            |
| Desktop local AI   | ⭐⭐⭐⭐⭐               | ⭐⭐⭐⭐             |
| Windows ML         | ⭐⭐⭐                 | ⭐⭐⭐⭐⭐            |
| Easy for beginners | ⭐⭐⭐⭐⭐               | ⭐⭐⭐              |
| Model training     | ❌                   | ❌                |

So:

**GGUF is particularly attractive for people running LLMs locally.**

**ONNX is particularly attractive for developers deploying models across hardware/software environments.**

---

# 21. MLX — Apple's Secret Weapon

For someone with an Apple Silicon Mac, **MLX deserves special attention.**

MLX is Apple's machine-learning framework designed around Apple Silicon's unified memory architecture.

Conceptually:

```text
CPU
 │
 ├──────────────┐
 │              │
 ▼              ▼
Unified Memory
       ▲
       │
      GPU
```

Instead of treating CPU RAM and GPU VRAM as completely separate pools, Apple Silicon has unified memory.

That is particularly useful for local AI.

---

# 22. Why MLX Is Interesting for Mac

Consider:

```text
MacBook Pro
48GB unified memory
```

You don't have:

```text
48GB RAM + 24GB VRAM
```

You effectively have a shared memory architecture.

A sufficiently optimized MLX model can exploit that architecture very effectively.

That's one reason Apple Silicon Macs have become surprisingly capable local AI machines.

---

# 23. MLX vs GGUF

For a Mac user:

|                      | MLX   | GGUF      |
| -------------------- | ----- | --------- |
| Apple Silicon        | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐      |
| NVIDIA               | ❌     | ⭐⭐⭐⭐⭐     |
| CPU inference        | Good  | Excellent |
| Apple unified memory | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐      |
| llama.cpp            | ❌     | ⭐⭐⭐⭐⭐     |
| Research             | ⭐⭐⭐⭐  | ⭐⭐⭐       |
| Easy deployment      | ⭐⭐⭐⭐  | ⭐⭐⭐⭐⭐     |

So on your Mac:

```text
MLX
```

is something I would absolutely learn.

But:

```text
GGUF
```

remains extremely useful because the ecosystem around llama.cpp is enormous.

---

# 24. PyTorch

Then there's:

```text
PyTorch
```

This is where a lot of modern AI development happens.

You may encounter:

```text
.pth
.pt
.bin
.safetensors
```

PyTorch isn't really "a model format" in the same sense as GGUF.

It's more accurate to think:

> **PyTorch is an ML framework/ecosystem that can load, manipulate, train and run model weights.**

This is where researchers and developers spend much of their time.

---

# 25. Training vs Inference

This distinction is extremely important.

### Training

You're changing the weights.

```text
Dataset
   ↓
Neural network
   ↓
Error
   ↓
Backpropagation
   ↓
Update weights
   ↓
Repeat
```

### Inference

The weights are generally fixed.

```text
Prompt
  ↓
Tokenizer
  ↓
Model
  ↓
Output
```

Most local AI users are doing:

# **Inference**

They download a model that somebody else trained.

---

# 26. And Then There Are Image Models

This is where the word "model" becomes even more confusing.

An LLM isn't the only type of AI model.

You have:

```text
LLMs
│
├── Text generation
├── Coding
├── Reasoning
└── Agents

Vision models
│
├── Image classification
├── OCR
└── Image understanding

Diffusion models
│
├── Image generation
├── Image editing
└── Video generation

Audio models
│
├── Speech recognition
├── TTS
└── Music generation
```

---

# 27. Stable Diffusion / Flux Are Not LLMs

For example:

```text
Flux
Stable Diffusion
SDXL
```

are generative image models.

Their architecture and model packaging can look quite different.

A Diffusers model may look like:

```text
model/
│
├── transformer/
├── text_encoder/
├── vae/
├── scheduler/
└── model_index.json
```

Hugging Face describes Diffusers as a directory-based pipeline containing components such as the transformer/UNet, text encoder, VAE and scheduler. ([Hugging Face][5])

This is why:

> "Download an AI model"

doesn't necessarily mean:

> "Download one `.gguf` file."

---

# 28. The Model ≠ The Runtime

This is probably the **most important concept in the entire guide**.

Suppose you download:

```text
Qwen3-8B-Q4_K_M.gguf
```

The GGUF doesn't magically run itself.

You need:

```text
                 MODEL
                   │
                   ▼
                Runtime
                   │
          ┌────────┼────────┐
          ▼        ▼        ▼
         CPU      GPU      NPU
```

Examples:

| Runtime      | Typical model ecosystem            |
| ------------ | ---------------------------------- |
| llama.cpp    | GGUF                               |
| Ollama       | Various models, often GGUF-derived |
| LM Studio    | GGUF / llama.cpp ecosystem         |
| Transformers | Safetensors/PyTorch                |
| ONNX Runtime | ONNX                               |
| MLX          | MLX models                         |
| TensorRT-LLM | NVIDIA optimized models            |
| Core ML      | Apple deployment                   |

Your own architecture documentation captures this nicely as:

> **Model = Brain; Runner = Body.** 

That's a very good analogy for the guide.

---

# 29. The Runtime Provides the "Body"

The runtime handles things the model itself does not.

For example:

```text
                 MODEL
                   │
             "What should
              I predict?"
                   │
                   ▼
              RUNTIME
                   │
       ┌───────────┼───────────┐
       │           │           │
       ▼           ▼           ▼
     CPU          GPU         NPU
       │           │           │
       └───────────┼───────────┘
                   ▼
              Memory
                   │
                   ▼
             Tokenization
                   │
                   ▼
             Output tokens
```

The runtime handles:

* loading the weights
* allocating memory
* GPU acceleration
* CPU acceleration
* tokenization
* inference
* context management
* sampling
* batching
* sometimes networking/API
* sometimes tool calling

---

# 30. This Explains Why the Model Can't Browse the Web

Your original statement said:

> "It doesn't have a networking stack."

That's exactly the distinction.

Suppose:

```text
Qwen3-8B.gguf
```

is sitting here:

```text
C:\AI\Models\
```

Nothing happens.

It doesn't spontaneously:

```text
open socket
↓
DNS lookup
↓
HTTPS request
↓
download webpage
```

It doesn't have that capability.

Instead:

```text
User
 │
 ▼
AI Application
 │
 ▼
Runtime
 │
 ▼
Model
```

If the **application/runtime** provides a web-search tool:

```text
Model
 │
 │ "I need web search"
 ▼
Tool system
 │
 ▼
Internet
 │
 ▼
Search results
 │
 ▼
Model
```

That's fundamentally different.

---

# 31. Same Thing With Code Execution

A model can output:

```python
print(2 + 2)
```

But the model itself did not execute Python.

It predicted the tokens:

```text
print
(
2
+
2
)
```

Something else must execute it.

For example:

```text
LLM
 │
 ▼
Agent runtime
 │
 ▼
Python interpreter
 │
 ▼
Operating system
```

This distinction becomes **extremely important when you start building AI agents.**

---

# 32. Agents Are Where the Architecture Gets Interesting

You can now see the evolution:

### Level 1 — Model

```text
Prompt → Model → Response
```

### Level 2 — Runtime

```text
Prompt
 ↓
Runtime
 ↓
Model
 ↓
Response
```

### Level 3 — Tool use

```text
              ┌── Browser
              │
Model → Agent ├── Python
              │
              ├── Files
              │
              └── APIs
```

### Level 4 — Agentic system

```text
                ┌── LLM
                │
                ├── Tools
                │
                ├── Memory
                │
                ├── Browser
                │
                ├── Code execution
                │
                └── Databases
                      │
                      ▼
                    Agent
```

That's essentially the direction you're heading with:

```text
Ollama
Open WebUI
Qdrant
Flowise
OpenCode
```

Your local stack describes exactly this type of architecture.

---

# 33. A Model Is Not Necessarily an "AI Assistant"

This is another misconception worth putting prominently in your guide.

Downloading:

```text
Qwen3-30B
```

doesn't give you:

> "ChatGPT locally."

It gives you:

> **A neural network capable of generating tokens.**

The assistant experience comes from layers around it:

```text
             AI ASSISTANT
                  │
       ┌──────────┴──────────┐
       │                     │
    Interface             Runtime
       │                     │
       └──────────┬──────────┘
                  │
                Model
                  │
          ┌───────┴────────┐
          │                │
       Weights          Tokenizer
```

And potentially:

```text
                  Assistant
                     │
       ┌─────────────┼─────────────┐
       │             │             │
      RAG          Tools         Memory
       │             │             │
     Qdrant       Python        Database
```

---

# 34. The Complete Local AI Stack

Here's the architecture I'd recommend teaching in the guide:

```text
┌─────────────────────────────────────────────┐
│                 USER                        │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│             AI APPLICATION                 │
│                                             │
│ LM Studio / Open WebUI / Custom App        │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│                RUNTIME                      │
│                                             │
│ llama.cpp / Ollama / MLX / ONNX Runtime    │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│                 MODEL                       │
│                                             │
│ Qwen / Llama / Gemma / Mistral / etc.      │
│                                             │
│       Weights + Architecture + Tokenizer    │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│               HARDWARE                      │
│                                             │
│ CPU / GPU / NPU / Unified Memory            │
└─────────────────────────────────────────────┘
```

And then **tools sit beside the model**, not inside it:

```text
                    MODEL
                      │
          ┌───────────┼───────────┐
          │           │           │
        Files       Browser      Python
          │           │           │
          └───────────┼───────────┘
                      │
                    Agent
```

---

# 35. Where Each Format Fits

Here's the cheat sheet I'd ultimately give beginners.

| Format / Technology | Think of it as                        | Best use                                 |
| ------------------- | ------------------------------------- | ---------------------------------------- |
| **GGUF**            | Local LLM package                     | LM Studio, llama.cpp, many desktop LLMs  |
| **Q4/Q5/Q6/Q8**     | Precision/quantization                | Fit models into available memory         |
| **Safetensors**     | Safe tensor storage                   | Hugging Face, training, development      |
| **ONNX**            | Portable inference representation     | Windows, edge, cross-platform deployment |
| **MLX**             | Apple Silicon ML ecosystem            | Mac local AI                             |
| **PyTorch**         | ML development framework              | Training/research/inference              |
| **TensorRT**        | NVIDIA optimization/runtime ecosystem | High-performance NVIDIA inference        |
| **Core ML**         | Apple deployment format/ecosystem     | iPhone/iPad/Mac apps                     |
| **Diffusers**       | Image/video model pipeline            | Stable Diffusion, Flux, etc.             |

---

# 36. And This Is Why Hardware Matters

Now we can connect the model to your earlier **"Can my computer run this?"** question.

Suppose:

```text
Model = 32B parameters
Quantization = Q4
```

You might have approximately:

```text
~16GB+ model storage/memory requirement
```

But that isn't the complete requirement.

You also need memory for:

```text
Model weights
+
KV cache
+
Context
+
Runtime
+
OS
+
Application
```

So:

```text
32B Q4
```

does **not** mean:

> "I need exactly 16GB RAM."

It means:

> "The model weights may require roughly this order of memory, and additional memory is required for inference."

This is why a machine can technically load a model but perform terribly once memory pressure begins.

---

# 37. MoE Makes This Even More Interesting

You recently experimented with:

```text
Qwen3-Coder-Next
```

and saw it consume enormous amounts of memory.

This is a perfect example.

An MoE model might be described as:

```text
80B parameters
3B active parameters
```

That does **not** mean:

> "Only 3B parameters need to be stored."

The model may have roughly:

```text
80B total parameters
```

but only approximately:

```text
3B active parameters
```

used for a particular token.

So:

```text
Storage/memory
       ↓
closer to total model
       
Computation per token
       ↓
related to active parameters
```

That's one reason MoE models can be computationally attractive while still requiring substantial memory.

Your Qwen3-Coder-Next experiment is therefore a very good real-world example for the guide.

---

# 38. The Mental Model I Want Beginners to Remember

I'd boil this entire chapter down to five concepts:

### ① Model

> **The learned mathematical knowledge.**

### ② Format

> **How that model is packaged/stored.**

Examples:

```text
GGUF
Safetensors
ONNX
MLX
```

### ③ Quantization

> **How precisely the weights are represented.**

Examples:

```text
FP16
BF16
Q8
Q6
Q5
Q4
```

### ④ Runtime

> **The software that actually executes the model.**

Examples:

```text
llama.cpp
Ollama
MLX
ONNX Runtime
TensorRT
```

### ⑤ Application / Agent

> **The software that gives the model capabilities beyond raw inference.**

Examples:

```text
LM Studio
Open WebUI
Flowise
OpenCode
custom applications
```

---

# 39. The "AI Stack" in One Picture

```text
                     YOU
                      │
                      ▼
             ┌─────────────────┐
             │   APPLICATION   │
             │                 │
             │ LM Studio       │
             │ Open WebUI      │
             │ Custom App      │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │     AGENT       │
             │   (optional)    │
             │                 │
             │ Tools / Memory  │
             │ Browser / Code  │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │     RUNTIME     │
             │                 │
             │ Ollama          │
             │ llama.cpp       │
             │ MLX             │
             │ ONNX Runtime    │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │      MODEL      │
             │                 │
             │ Qwen            │
             │ Llama           │
             │ Gemma           │
             │ Mistral         │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │     FORMAT      │
             │                 │
             │ GGUF            │
             │ Safetensors     │
             │ ONNX            │
             │ MLX             │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │    HARDWARE     │
             │                 │
             │ CPU GPU NPU     │
             │ RAM / VRAM      │
             └─────────────────┘
```

## The single sentence I'd put in the beginner guide

> **A model is learned mathematical parameters; a model format is how those parameters are packaged; a runtime is the software that executes them; and an AI application or agent adds the interface, memory, tools, files, web access, and other capabilities that make the raw model useful.**

That distinction will make the rest of your **Machine Learning AI Guide** dramatically easier to understand.

And I'd make **GGUF vs Safetensors vs ONNX vs MLX** a dedicated chapter, because it naturally leads into the next important subject: **how to choose the correct model for your hardware — including VRAM/RAM calculations, quantization, context size, MoE, and why a "14B model" can behave very differently on a 12GB RTX GPU, 32GB Mac, or 128GB unified-memory machine.**

[1]: https://github.com/ggml-org/llama.cpp/blob/master/docs/models.md "llama.cpp/docs/models.md at master · ggml-org/llama.cpp · GitHub"
[2]: https://github.com/ggml-org/llama.cpp/blob/master/ggml/include/gguf.h "llama.cpp/ggml/include/gguf.h at master · ggml-org/llama.cpp · GitHub"
[3]: https://huggingface.co/docs/safetensors/index "Safetensors · Hugging Face"
[4]: https://huggingface.co/docs/diffusers/main/using-diffusers/using_safetensors "Load safetensors · Hugging Face"
[5]: https://huggingface.co/docs/diffusers/using-diffusers/other-formats "Model formats · Hugging Face"
