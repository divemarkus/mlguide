

---

# My System Specs for Local LLM Workloads

## Processor (CPU)

**AMD Ryzen™ AI MAX+ 395**

* 16 Cores / 32 Threads. Up to 5.1 GHz boost. 80MB cache

The CPU plays a major role in **token generation, preprocessing, and orchestration** of LLM tasks. While GPUs handle most inference workloads, the CPU is responsible for:

* Tokenization and prompt preprocessing
* Running inference when models fall back to CPU
* Managing containerized environments (Docker, Kubernetes, etc.)
* Parallel workloads such as embeddings, RAG pipelines, and vector database queries

With **16 cores and 32 threads**, this processor can comfortably support:

* Multiple concurrent LLM inference sessions
* Background data processing tasks
* AI development environments (Python, Jupyter, VSCode, etc.)

Large CPU cache (80MB) also improves performance for **model loading, vector operations, and dataset processing**.

---

## Neural Processor (NPU)

**AMD XDNA™ NPU – up to 50 TOPS**

The integrated **Neural Processing Unit** is designed for specialized AI acceleration and low-power inference workloads.

Although current LLM frameworks primarily rely on GPU acceleration, the NPU can be used for:

* Smaller on-device AI models
* Speech recognition and transcription
* Vision models and embeddings
* Future AI frameworks optimized for NPUs

As software support improves, the NPU may assist with **hybrid AI pipelines** that offload certain inference tasks from the CPU or GPU. I believe Apple's latest release M5 supports this.

---

## Graphics (GPU)

**AMD Radeon™ 8060S Integrated GPU**

The GPU is the **primary engine for running local LLMs**. Most modern inference engines such as:

* **Ollama**
* **LM Studio**
* **vLLM**

rely on GPU compute to dramatically accelerate token generation.

GPU acceleration enables:

* Faster inference speed (tokens/sec)
* Larger model support
* Parallel prompt processing
* Reduced CPU load

Even though this is an integrated GPU, its **shared memory architecture with high-speed LPDDR5X** allows it to function similarly to discrete GPUs when enough memory is allocated.

---

## Memory (RAM)

**128GB LPDDR5X 8000 MHz (Quad Channel)**

System memory is extremely important for local LLM workloads.

Key benefits:

* Large models can load directly into memory
* High-speed memory bandwidth improves GPU performance
* Supports large datasets and vector embeddings

* Enables running multiple AI services simultaneously

Typical memory usage for local AI stacks:

| Component         | Typical RAM Usage |
| ----------------- | ----------------- |
| LLM models        | 8GB – 80GB        |
| Vector databases  | 2GB – 20GB        |
| Docker containers | 1GB – 10GB        |
| Development tools | 2GB – 8GB         |

With **128GB of RAM**, the system can support:

* Large 70B parameter quantized models
* Multiple simultaneous models
* Full AI pipelines (RAG, embeddings, agents, etc.)

---

## GPU Memory Allocation

The system allows **dynamic allocation of system RAM to the GPU**.

Current configuration:

* **64GB GPU VRAM**
* **64GB system RAM**

This shared memory architecture allows the GPU to load **very large models** that normally require high-end discrete GPUs.

For example:

| Model Size             | Approx VRAM Needed |
| ---------------------- | ------------------ |
| 7B models              | 6–10GB             |
| 13B models             | 12–20GB            |
| 34B models             | 30–40GB            |
| 70B models (quantized) | 50–80GB            |

Because LLMs load primarily into **VRAM**, allocating more memory to the GPU allows significantly larger models to run locally.

Potential optimization:

* Allocate **96GB GPU VRAM / 32GB system RAM**

Windows 11 will still operate, but not until you run large prompts. In real-world benchmarks. 64GB each is the best W11 setup.

---

## Storage

**1TB PCIe 4.0 NVMe SSD (M.2 2230)**

Storage performance is critical for:

* Model loading times
* Dataset access
* Vector database storage
* Container images

LLM models can be very large:

| Model     | Approx Size |
| --------- | ----------- |
| 7B model  | 4GB – 8GB   |
| 13B model | 8GB – 16GB  |
| 34B model | 20GB – 40GB |
| 70B model | 40GB – 80GB |

A fast **PCIe Gen4 NVMe SSD** significantly reduces model loading time and improves performance when streaming data for AI workflows.

---

## Future Upgrade Path

### Storage Upgrade

Replace the current **1TB drive with a 2TB NVMe SSD**.

This allows storing:

* Larger model collections
* Multiple quantization versions
* Vector databases
* AI datasets

---

### Operating System Optimization

Install **Ubuntu** for dedicated AI workloads.

Linux typically provides:

* Better GPU driver optimization
* Lower system memory usage
* Improved container performance
* More compatibility with AI frameworks

Running local AI stacks such as:

* **Ollama**
* **Docker**
* **PyTorch**

on Ubuntu can significantly improve efficiency when hosting large models.

---

## Summary

* Future upgrade path, 2TB NVMe, securing original 1TB NVMe Gen4.
* Install Ubuntu and allocate 96gb RAM to GPU and rest to Ubuntu 22/24.

