# Spark X2.5

**Spark-X2.5 is much more interesting for your Macs than its 1.7B/4B parameter counts initially suggest**.

I checked the official `XHToken/Spark-X2.5` repository and its companion MLX implementation. The project was launched in September 2026, and the important part for you is that it has **native MLX support, native Ollama support, and native LM Studio support**. The project explicitly says the MLX implementation loads the original Hugging Face `safetensors` checkpoint directly and **does not require GGUF conversion**. ([Spark-X2.5 GitHub](https://github.com/XHToken/Spark-X2.5))

# What exactly is Spark-X2.5?

Spark-X2.5 is a new **small language-model family** from the SparkLLM team:

| Model | Parameters | Native context | Architecture | Intended role |
|---|---:|---:|---|---|
| **Spark-X2.5-4B** | **4.11B** | **1,048,576** | Dense / hybrid attention | Main model |
| **Spark-X2.5-1.7B** | **~1.7B** | **1,048,576** | Dense / hybrid attention | Ultra-light model |

The official repository describes both as compact general-purpose models targeting **conversation, writing, translation, reasoning, coding, tool use and agentic workflows**, with support for **200+ languages**. ([Spark-X2.5 GitHub](https://github.com/XHToken/Spark-X2.5))

The surprising bit isn't the parameter count.

It is the **architecture**.

---

# The interesting part: 1M-token native context

Spark-X2.5 uses a hybrid attention pattern:

```text
Layer 1  → Sliding Window
Layer 2  → Sliding Window
Layer 3  → Sliding Window
Layer 4  → Full Attention
Layer 5  → Sliding Window
Layer 6  → Sliding Window
Layer 7  → Sliding Window
Layer 8  → Full Attention
...
```

More precisely, the 4B implementation has **36 layers: 27 sliding-window + 9 full-attention layers**, with a **512-token sliding window**. ([Spark-MLX-LLM](https://github.com/XHToken/Spark-MLX-LLM))

The concept is:

```text
Traditional 1M context model

Token
 ↓
████████████████████████████████████
       attention across huge context
```

versus Spark:

```text
Spark-X2.5

Token
 ↓
[512] [512] [512] [FULL]
   ↓     ↓     ↓     ↓
 cheap  cheap  cheap  expensive
```

Most layers don't need to attend over the entire million-token sequence.

That dramatically reduces the computational burden associated with very long contexts.

The official project explicitly identifies this hybrid attention design as the mechanism allowing **native 1M-token context** while reducing long-context computational overhead. ([Spark-X2.5 GitHub](https://github.com/XHToken/Spark-X2.5))

---

# Why I think this model is particularly interesting for you

You have three Apple Silicon machines:

| Machine | Unified memory | Spark-X2.5 4B | Spark-X2.5 1.7B |
|---|---:|:---:|:---:|
| **M1 MacBook Pro** | **32 GB** | 🟢 Excellent | 🟢🟢 |
| **M4 Max MacBook Pro** | **36 GB** | 🟢🟢 Excellent | 🟢🟢 |
| **M6 Mac mini** | **32 GB** | 🟢 Excellent | 🟢🟢 |

This is **not a model where you're fighting memory limitations**.

That's important.

The official Ollama 4B model is currently distributed as an **8.2 GB BF16 model**, while the 1.7B Ollama model is about **3.4 GB**. ([Ollama Spark-X2.5 4B](https://ollama.com/SparkLLM/Spark-X2.5-4B), [Ollama Spark-X2.5 1.7B](https://ollama.com/SparkLLM/Spark-X2.5-1.7B))

There is also a community MLX 4-bit build around **2.32 GB**. ([Hugging Face — Spark-X2.5 MLX 4-bit](https://huggingface.co/hermitdave/Spark-X2.5-4B-MLX-4bit))

That means the model is small enough that **all three of your Macs have enormous memory headroom**.

And that changes how I'd use it.

---

# Spark-X2.5 isn't intended to beat Qwen3.8 at everything

This is important.

Think of your models as different classes:

```text
                 LOCAL AI STACK
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
   Large Models    Medium Models   SLMs
        │             │             │
    Qwen3.8       Qwen3.6 etc.   Spark-X2.5
    27B           27–35B         1.7–4B
        │             │             │
  Maximum          Balanced       Efficient
  capability       capability     specialized
```

Spark-X2.5's proposition is:

> **"Give me surprisingly strong reasoning/agent capability in only a few billion parameters."**

The model's own benchmark table is particularly interesting here.

According to the project's published results, Spark-X2.5-4B scores:

| Benchmark | Spark-X2.5-4B | Qwen3.5-9B | Gemma4-12B |
|---|---:|---:|---:|
| BFCL-V4 | 65.1 | 66.1 | 37.4 |
| τ²-bench | 75.1 | 79.1 | 69.0 |
| τ³-bench | **30.4** | 9.3 | 13.3 |
| MCP-Atlas | **54.6** | 47.4 | 30.5 |
| MCP-Mark | **14.2** | 13.4 | — |
| WorkspaceBench | **31.2** | 25.5 | — |
| VitaBench2.0 | **25.2** | 15.6 | 12.4 |
| BrowseComp | **40.9** | 8.3 | 10.0 |
| SWE-Bench Pro | **44.4** | 33.8 | 21.9 |
| SWE-Bench Verified | 41.6 | **53.1** | 44.2 |
| SWE-Bench Multilingual | **53.3** | 43.3 | 32.5 |
| AIME 2026 | **90.7** | 88.2 | 82.1 |
| HMMT Feb 2026 | **81.2** | 70.8 | 65.6 |
| IMO-AnswerBench | **74.2** | 69.8 | 57.2 |

These are **the vendor's published benchmark results**, not independently reproduced measurements, and the benchmark methodology matters. The repository notes that results were obtained in thinking mode with `temperature=1.0`, `top_p=0.95`, and `top_k=-1`; some comparison numbers are taken from publicly released model cards/papers. ([Spark-X2.5 GitHub](https://github.com/XHToken/Spark-X2.5))

But there's something genuinely interesting in those numbers:

### Agentic capability is disproportionately strong for a 4B model.

That is precisely where I think Spark-X2.5 fits your environment.

---

# And it has real tool calling

This is another reason not to dismiss it as "just a tiny LLM."

The MLX implementation has a **Spark2_5-specific tool/function-call parser** and integrates with MLX LM. The project says the model has integrations with:

```text
Codex
Claude Code
OpenClaw
Hermes
```

and explicitly positions the model for agentic workflows. ([Spark-X2.5 GitHub](https://github.com/XHToken/Spark-X2.5))

The MLX implementation even has a dedicated tool parser:

```python
tokenizer.tool_parser(...)
```

and exposes tool-calling functionality through the MLX LM wrappers. ([Spark-MLX-LLM](https://github.com/XHToken/Spark-MLX-LLM))

---

# This is where I'd use Spark-X2.5

Rather than using it as your "main ChatGPT replacement", I'd use it as a **specialized local worker**.

## 1. Agent router

This is probably my favorite use.

Imagine:

```text
                    Your AI system
                         │
                    Router model
                         │
           ┌─────────────┼──────────────┐
           │             │              │
           ▼             ▼              ▼
       Simple task    Coding task    Hard reasoning
           │             │              │
           ▼             ▼              ▼
     Spark-X2.5 4B    Qwen3.5       Qwen3.8 27B
```

Spark handles things like:

- classify request
- extract information
- inspect files
- decide which tool to call
- execute simple tools
- perform routine automation
- summarize command output
- determine whether a larger model is necessary

This is **exactly where a 4B model can be extremely valuable**.

---

# 2. Always-on local agent

This is even more compelling.

You could have Spark running continuously on your:

### M6 Mac mini

```text
                 M6 Mac mini
                     │
                Spark-X2.5 4B
                     │
          ┌──────────┼──────────┐
          │          │          │
        Home       Docker     Network
      Assistant    tools      tools
```

It could act as a lightweight orchestration model while your larger M4 Max or RTX 3090 Ti handles heavyweight reasoning.

This is a very different philosophy from:

> "Put the biggest model possible on every machine."

Instead:

> **Use the smallest capable model for each job.**

That's becoming increasingly important in agent architectures.

---

# 3. Home Assistant

This is particularly compelling for your environment.

Spark-X2.5 supports tool calling and is lightweight enough to leave running.

You could construct something like:

```text
You:
"Turn on the office lights and tell me
 if the garage door is open."

             ↓

       Spark-X2.5 4B
             ↓
       Tool selection
          /       \
         ↓         ↓
     HA light    HA sensor
         │         │
         └────┬────┘
              ↓
       "Lights are on.
        Garage is closed."
```

This is precisely the sort of workload where a huge 30B model can be wasteful.

---

# 4. Frigate / NVR assistant

This is another **very interesting possibility** given your Frigate setup.

Your Frigate system could generate events such as:

```text
person detected
vehicle detected
package detected
unknown object
motion event
```

Spark could become the **natural-language reasoning layer**:

```text
                 Frigate
                    │
              Detection event
                    │
                    ▼
              Spark-X2.5
                    │
        ┌───────────┼───────────┐
        │           │           │
      classify    summarize    act
        │           │           │
        └───────────┼───────────┘
                    ↓
              Home Assistant
```

For example:

> "Was anyone at the front door while I was away?"

The system could query Frigate events and have Spark transform them into a concise answer.

That keeps the entire pipeline **local**.

---

# 5. MCP server orchestration

This is where I think Spark-X2.5 may become particularly interesting for you.

The repository specifically reports strong results on:

- MCP-Atlas
- MCP-Mark
- WorkspaceBench
- VitaBench

and calls out MCP/agent capability as a primary feature. ([Spark-X2.5 GitHub](https://github.com/XHToken/Spark-X2.5))

So you could build:

```text
                    Spark-X2.5
                         │
                    MCP Client
                         │
         ┌───────────────┼────────────────┐
         │               │                │
         ▼               ▼                ▼
      GitHub          Home Assistant    Network
        MCP               MCP             MCP
         │               │                │
         ▼               ▼                ▼
      Issues          Devices          Firewall
      Repos           Sensors          Network
```

That is much more exciting than simply chatting with a 4B model.

---

# 6. Coding assistant — but use it correctly

I wouldn't make Spark-X2.5 your **primary software-engineering model** on your M4 Max.

I'd do this instead:

```text
              Coding agent
                   │
             Spark-X2.5
                   │
          "What should I do?"
                   │
                   ▼
             Qwen3.6/3.5
                   │
             Actual coding
                   │
                   ▼
             Spark-X2.5
                   │
           Tests / validation
```

Spark can serve as:

- planner
- tool dispatcher
- test result interpreter
- lightweight code reviewer
- task classifier

while Qwen3.6/Qwen3.5 handles the difficult implementation work.

---

# 7. Your three Macs can become a mini AI cluster

This is the part I think you would really enjoy.

You now have:

```text
                   LOCAL AI LAB
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
   M1 MacBook       M4 Max MBP        M6 Mac mini
    32 GB             36 GB              32 GB
        │               │                │
        │               │                │
   Spark 4B          Large MLX         Spark 4B
   Fast worker       models             Always-on
        │               │                │
        └───────────────┼────────────────┘
                        │
                    LAN / API
                        │
              ┌─────────┴─────────┐
              │                   │
           Ollama             MLX Server
```

You don't necessarily want to **split one model across three Macs**.

Instead, use them as **independent inference nodes**.

For example:

| Machine | Role I'd give it |
|---|---|
| **M1 32 GB** | Experimental MLX / lightweight agents |
| **M4 Max 36 GB** | Primary heavy Apple Silicon inference |
| **M6 mini 32 GB** | **24/7 AI services / orchestration** |

That makes the M6 mini particularly interesting.

You could essentially turn it into your **AI appliance**.

---

# Native MLX is the part I really like

The official MLX implementation is:

**[XHToken/Spark-MLX-LLM](https://github.com/XHToken/Spark-MLX-LLM)**

It directly loads the original Hugging Face checkpoint:

```text
Hugging Face safetensors
          │
          ▼
      Spark-MLX-LLM
          │
          ▼
         MLX
          │
          ▼
   Apple Silicon GPU
```

**No GGUF conversion required.**

The project explicitly supports:

- Apple Silicon GPU
- Linux CPU
- CUDA on Linux
- BF16
- FP32
- sliding-window KV caches
- full-attention KV caches
- function-call parsing
- MLX LM wrappers
- Python API
- OpenAI-compatible server

([Spark-MLX-LLM](https://github.com/XHToken/Spark-MLX-LLM))

That's a legitimate MLX implementation rather than somebody simply making a GGUF and putting "Mac" in the README.

---

# How I'd deploy it on your M4 Max

For your M4 Max, I'd start with the **official MLX implementation**, rather than Ollama.

Clone:

```bash
git clone https://github.com/XHToken/Spark-MLX-LLM.git
cd Spark-MLX-LLM

python3 -m venv .venv
source .venv/bin/activate

python -m pip install -e '.[test]'
```

Verify MLX:

```bash
python -c 'import mlx.core as mx; print(mx.__version__)'
```

Then run:

```bash
spark-mlx-generate \
    --device gpu \
    --dtype bfloat16 \
    --model XHToken/Spark-X2.5-1.7B \
    --prompt "Explain what an MCP server does." \
    --max-tokens 512 \
    --temp 0
```

That command is taken directly from the project's MLX quick-start pattern, with the 1.7B checkpoint. ([Spark-X2.5 GitHub](https://github.com/XHToken/Spark-X2.5))

For the 4B model, you'd substitute:

```text
XHToken/Spark-X2.5-4B
```

---

# Or use Ollama

This is dramatically easier.

The official repository says Ollama support was added in **v0.34.1** on September 15, 2026. ([Spark-X2.5 GitHub](https://github.com/XHToken/Spark-X2.5))

### 4B

```bash
ollama run SparkLLM/Spark-X2.5-4B
```

### 1.7B

```bash
ollama run SparkLLM/Spark-X2.5-1.7B
```

The current Ollama registry shows:

- **4B:** ~8.2 GB BF16
- **1.7B:** ~3.4 GB
- **1M context**
- text generation

([Ollama 4B](https://ollama.com/SparkLLM/Spark-X2.5-4B), [Ollama 1.7B](https://ollama.com/SparkLLM/Spark-X2.5-1.7B))

For experimenting with agents, this is probably the easiest starting point.

---

# There's an important quantization detail

The MLX project gives us a very useful warning.

It says the model's **head-wise sigmoid attention gates** are sensitive to low-bit quantization.

Consequently:

| Precision | Memory | Tool calling |
|---|---:|---|
| BF16 | Highest | **Recommended** |
| INT8 | Medium | **Recommended** |
| 4-bit | Lowest | May reduce schema/tool accuracy |

The MLX project explicitly recommends **8-bit or BF16 for tool calling**, noting that 4-bit uses less memory but can reduce accuracy of schema-constrained arguments. ([Spark-MLX-LLM](https://github.com/XHToken/Spark-MLX-LLM))

This is actually very important.

Because you have **32–36 GB of unified memory**, you don't need to squeeze the model into 2 GB.

I'd use:

> **BF16 first → INT8 second → 4-bit only if speed/memory becomes important.**

---

# 4B vs 1.7B

I'd treat them differently.

| | Spark-X2.5-1.7B | Spark-X2.5-4B |
|---|---|---|
| Size | ~3.4 GB BF16 | ~8.2 GB BF16 |
| 1M context | ✅ | ✅ |
| Reasoning | Good | **Much better** |
| Tool use | Good | **Better** |
| Agentic | Good | **Strong for size** |
| Always-on | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Coding | Basic | **Useful** |
| Router | **Excellent** | Excellent |
| Main assistant | Limited | **Much more useful** |

### My choice

**4B for anything you actually care about.**

**1.7B for background/utility agents.**

---

# One thing I would test immediately

Because Spark-X2.5 is claiming very strong agentic performance for its size, I'd benchmark it against your existing local models using **the exact same agent harness**.

I'd run:

```text
                    SAME TASK
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
       Spark 4B     Qwen3.5 9B   Gemma 4 12B
          │            │            │
          └────────────┼────────────┘
                       │
                  Measure:
                       │
              ┌────────┼────────┐
              │        │        │
            Tools    Tokens    Time
              │        │        │
            Errors   Cost     TTFT
```

I'd especially test:

**MCP tool calling → multi-step agent → file manipulation → shell command → recovery from tool failure.**

That would tell you much more than a generic MMLU score.

---

# My recommended architecture for your environment

I think your three Macs give you an opportunity to build something pretty interesting:

```text
                       LAN
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
   M1 MacBook       M4 Max MBP        M6 Mac mini
    32 GB             36 GB              32 GB
        │               │                │
      MLX              MLX              MLX
        │               │                │
   Spark 1.7B       Qwen3.5/3.6      Spark-X2.5 4B
   Spark 4B         Qwen3.8          Always-on
        │               │                │
        │               │                │
        ▼               ▼                ▼
    Utility         Heavy AI         Agents/MCP
       AI             AI            Home Assistant
                                      Frigate
                                      GitHub
                                      Network
```

That gives you a **small-model / large-model hierarchy** instead of having every request hit your largest model.

## The part I find most compelling

Spark-X2.5 isn't interesting because **4B is bigger than 4B**.

It's interesting because the project is deliberately trying to push **agentic capability down into the small-model tier** while combining that with:

**1M native context + reasoning + tool calling + coding + MCP + MLX + Apple Silicon.**

That's exactly the direction I'd watch for the next generation of local AI.

And because you now have an **M4 Max 36 GB and an M6 32 GB**, I would actually deploy **Spark-X2.5 4B on both** and experiment with the **1.7B on the M6 as an always-on router/utility model**.

### References

- [Spark-X2.5 — Official GitHub](https://github.com/XHToken/Spark-X2.5)
- [Spark-MLX-LLM — Official MLX implementation](https://github.com/XHToken/Spark-MLX-LLM)
- [Spark-X2.5-4B — Ollama](https://ollama.com/SparkLLM/Spark-X2.5-4B)
- [Spark-X2.5-1.7B — Ollama](https://ollama.com/SparkLLM/Spark-X2.5-1.7B)
- [Spark-X2.5 collection — Hugging Face](https://huggingface.co/collections/XHToken/spark-x25)
- [Spark-X2.5 4B MLX 4-bit community build](https://huggingface.co/hermitdave/Spark-X2.5-4B-MLX-4bit)