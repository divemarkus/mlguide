
# ML Guide

This repository collects setup guides, configuration examples, and sample code for getting started with machine learning across several environments and tools.

---

## The Brain vs Body (analogy)

- The Model (The Brain): This is the file you download. It’s just "weights"—mathematical values that represent patterns of human language. It doesn’t have a networking stack, it doesn’t know what a "browser" is, and it can’t execute code.

- The Runner (The Body): Tools like Ollama, LM Studio, or llama.cpp are the "bodies." They are actual programs written in languages like C++ or Go. They are the ones that talk to your hardware (CPU/GPU) and, if you allow them, your internet connection.

- The Agent Framework (The Nervous System / Spinal Cord) — OpenClaw, LangChain, AutoGPT, agentic runtimes. They orchestrate thought → action cycles, decide which tools to call, and loop until goals are met. OpenClaw explicitly separates gateway, runner, agentic loop, and response path to enable multi‑stage tool chaining and observability. 

---

## Subtopics

- [Windows11](Windows11/README.md): Guides and scripts for Windows 11 (WSL, drivers, PowerShell scripts).
- [Ubuntu22](Ubuntu22/README.md): Ubuntu 22.04 setup, system packages, and sample configs.
- [Docker](Docker/README.md): Dockerfiles, compose examples and a small example app.
- [Jetson Orin Nano](jetson-orin-nano/README.md): Jetson-specific setup and examples for GPU/edge deployments.
- [LM Studio](lm-studio/README.md): Local model development with LM Studio — installs and workspace examples.
- [Ollama](ollama/README.md): Running and serving models with Ollama; example configs.
- [Sample Prompts](sample-prompts/README.md): Curated prompt examples and quick code previews.

---

Each subfolder contains a `README.md` and sample files (scripts, yml, bash, ps1) to help you get started quickly.

---

# 🧠 Machine Learning Setup Guide, 2026  
*Optimized for AMD & NVIDIA GPUs | Local LLMs | Privacy-First Workflows*

> **💡 Tip**: This guide is designed for *on-premise, offline-capable AI workflows* — ideal for developers, researchers, and privacy-conscious users who want to run large language models (LLMs) locally on several environments without (some) cloud dependencies.

---

Would you like me to update the changes 


<sup>
*...make it so* :O
</sup>

---

