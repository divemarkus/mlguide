# MLX Model Selection for Mac mini M6 (32 GB)

**MoE vs Dense • NVFP4 vs Standard Quantization • MLX Format Explained**

> Understanding the model tag suffixes and architecture choices that matter for a 32 GB Apple Silicon Mac mini running local agents.

---

## The Question

On a Mac mini M6 with 32 GB unified memory, which do you pick for local agent workloads?

```bash
qwen3.6:35b-a3b-coding-nvfp4
# or
qwen3.6:27b-mlx
```

Both fit. Both are Qwen3.6. Both run on MLX. But they're different models with different tradeoffs.

---

## Quick Comparison

| | **35B-A3B-Coding-NVFP4** | **27B-MLX** |
|---|---|---|
| **Architecture** | MoE (Mixture of Experts) | Dense |
| **Total parameters** | 35B | 27B |
| **Active parameters** | ~3B per token | 27B per token |
| **MLX footprint** | ~22 GB | ~19 GB |
| **Quantization** | NVFP4 (mixed precision) | Standard 4-bit |
| **Context** | 256K | 256K |
| **Vision** | Yes | Yes |
| **Fine-tuning** | Coding-specific | General-purpose |
| **Memory headroom** | ~10 GB | ~13 GB |
| **Best for** | Coding agents | General workloads |

---

## MoE vs Dense — The Architectural Difference

This is the distinction that matters most.

### Dense (27B)

```text
27B Dense Model

Input token
    │
    ▼
All 27B parameters activate
    │
    ▼
Output
```

Every token passes through the full network. All 27B parameters fire for every token generated.

### MoE (35B-A3B)

```text
35B MoE Model (A3B = Active 3B)

Input token
    │
    ▼
Expert router selects 3B experts
    │
    ├── 3B activated
    ├── 32B sleeping
    │
    ▼
Output
```

The model has 35B total parameters but activates only ~3B per token. The expert router decides which subset of parameters handles each token.

**Practical consequences:**

| | MoE (35B-A3B) | Dense (27B) |
|---|---|---|
| Inference speed | Faster (3B active) | Slower (27B active) |
| Total capacity | 35B parameter space | 27B parameter space |
| Disk/memory footprint | 22 GB (NVFP4) | 19 GB (4-bit) |
| Energy efficiency | Better per token | Higher GPU utilization |

You get the representational capacity of a larger model without the compute cost of activating everything.

---

## The "Coding" Suffix — Fine-Tuning Matters

The `35b-a3b-coding-nvfp4` tag carries a **coding-specific fine-tune** on top of the base MoE architecture.

What that means:

| Capability | Coding fine-tune | General |
|---|---|---|
| Code generation | Specialized | Good |
| Repository-level reasoning | Trained on codebases | General context |
| Tool use / function calling | Optimized | Standard |
| SWE-bench / HumanEval | Benchmarked | Baseline |
| General conversation | Good | Excellent |
| Creative writing | Capable | Strong |

For agent workflows — Claude Code, Hermes, OpenClaw, coding automation — the coding fine-tune is purpose-built.

For general research, documentation, or personal assistant work, the difference is less noticeable.

---

## NVFP4 — Mixed-Precision Quantization

NVFP4 is Ollama's mixed-precision format for MLX:

```text
NVFP4 quantization
    │
    ├── Most layers:     4-bit
    ├── Sensitive layers: 8-bit
    └── Vision tower:    BF16
```

Standard 4-bit quantization (`27b-mlx`) applies uniform compression to all layers.

Ollama's testing shows NVFP4 can produce **higher-quality results than uniform 4-bit quantization while also being faster** on Apple Silicon.

The tradeoff: slightly larger disk footprint (22 GB vs 19 GB) for better output quality, especially on complex reasoning tasks where sensitive layers benefit from higher precision.

---

## What Does "-MLX" Mean?

The `-mlx` suffix indicates **MLX format** — Apple's native ML framework weight format.

It is **not a fine-tune**. It is a **format conversion**.

```text
Qwen3.6 27B (base model weights)
    │
    ├──→ GGUF format ──→ llama.cpp ──→ any platform
    ├──→ NVFP4 format ─→ Ollama CUDA ──→ NVIDIA GPUs
    └──→ MLX format ───→ Ollama MLX ──→ Apple Silicon only
```

The MLX format runs natively on Metal, exploits unified memory, and avoids device-memory transfers. The model weights are the same underlying Qwen3.6 — only the packaging is Apple-specific.

---

## Memory Planning on 32 GB

```text
32 GB Mac mini M6
│
├── macOS + system:        ~3-5 GB
├── Ollama runtime:        ~1-2 GB
│
├── Model (35B NVFP4):    ~22 GB
├── KV cache (256K ctx):   ~2-4 GB (varies with actual usage)
├── Remaining headroom:    ~2-10 GB
│
└── OR
├── Model (27B MLX):      ~19 GB
├── KV cache (256K ctx):   ~2-4 GB
└── Remaining headroom:    ~5-13 GB
```

Both fit comfortably. The 27B gives you more headroom for:

- Longer actual context windows
- Concurrent workloads (agent + background tasks)
- Running alongside other services (Home Assistant, Docker)

The 35B still leaves ~10 GB for system and cache, which is sufficient for single-purpose agent work.

---

## Recommendation

| Use Case | Pick |
|---|---|
| **Coding agents** (Claude Code, Hermes, OpenClaw) | `35b-a3b-coding-nvfp4` |
| **General-purpose AI** | `27b-mlx` |
| **Maximum speed** | `35b-a3b-coding-nvfp4` (MoE is faster) |
| **Long context RAG** | `27b-mlx` (more headroom) |
| **Running alongside other services** | `27b-mlx` |
| **Only pick one** | `35b-a3b-coding-nvfp4` |

The 35B-A3B-coding-NVFP4 is the better default for agent work on this machine. It has the coding fine-tune, NVFP4 quality advantages, MoE efficiency (faster inference despite larger parameter count), and still fits your 32 GB with acceptable headroom.

The 27B-MLX is your choice when you need the extra memory headroom or want a general-purpose model.

---

## Cross-References

- [MLX Models Overview](../../01-the-model/mlx-models.md) — full MLX model ranking
- [Mac mini M6 Overview](./m6-mini.md) — hardware architecture
- [Mac mini Quick Start](./m6-mini-start.md) — setup guide
- [Ollama](../../02-the-runner/ollama/README.md) — runtime documentation
- [oMLX](../../02-the-runner/omlx/README.md) — Apple Silicon inference server
