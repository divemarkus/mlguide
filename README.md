
# 🧠 Machine Learning Setup Guide, 2026  
*Optimized for AMD & NVIDIA GPUs | Local LLMs | Privacy-First Workflows*

> **💡 Tip**: This guide is designed for *on-premise, offline-capable AI workflows* — ideal for developers, researchers, and privacy-conscious users who want to run large language models (LLMs) locally on several environments without (some) cloud dependencies.

> This repository collects setup guides, configuration examples, and sample code for getting started with machine learning across several environments and tools.

---

## The Brain vs Body (analogy)

- The Model (The Brain): This is the file you download. It’s just "weights"—mathematical values that represent patterns of human language. It doesn’t have a networking stack, it doesn’t know what a "browser" is, and it can’t execute code.

- The Runner (The Body): Tools like Ollama, LM Studio, or llama.cpp are the "bodies." They are actual programs written in languages like C++ or Go. They are the ones that talk to your hardware (CPU/GPU) and, if you allow them, your internet connection.

- The Agent Framework (The Nervous System / Spinal Cord) — OpenClaw, LangChain, AutoGPT, Flowise, agentic runtimes. They orchestrate thought → action cycles, decide which tools to call, and loop until goals are met. OpenClaw explicitly separates gateway, runner, agentic loop, and response path to enable multi‑stage tool chaining and observability. 

---

## Links

- https://github.com/ollama
- https://github.com/lmstudio-ai
- https://github.com/anthropics
- https://github.com/NVIDIA
- https://github.com/openclaw
- [Impact of AI on Privacy - Video](https://youtu.be/h3AtWdeu_G0)
 - <details>
   Senator Bernie Sanders speaks with Anthropic's AI agent Claude.
   
   Sonnet 4.6 is part of Anthropic’s Claude 4.6 model family. It’s positioned as the best balance of speed, cost, and intelligence, sitting just below Opus but above Haiku.

   Key characteristics
   Hybrid reasoning model with strong agentic capabilities 

   1M‑token context window for long documents, multi‑day project compression, and extended reasoning 

   Improved coding performance, including consistency and instruction following 

   Enhanced computer‑use abilities, such as navigating spreadsheets or multi‑step web forms at human‑level skill 

   Adaptive thinking mode supported (recommended for complex tasks) 
   </details>

---


