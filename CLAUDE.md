# CLAUDE.md — mlguide Project Configuration

## Project Overview
This is **mlguide**, a comprehensive markdown-only documentation repository for running local AI/LLMs on personal hardware. It covers the full stack from AI frameworks through self-hosted applications, with heavy emphasis on Apple Silicon (Mac mini M6, MacBook, iPad, iPhone) and secondary coverage of NVIDIA, Linux (Asahi, Ubuntu, Unraid), Android, and mobile platforms.

## Content Style
- **Markdown only.** No code repositories, no scripts, no compiled binaries.
- Documentation is reference-grade: setup guides, comparison tables, sample prompts, hardware specs, architecture diagrams (ASCII).
- Tone: practical, direct, beginner-accessible but technically detailed.
- Heavy use of tables, code blocks, and ASCII architecture diagrams.
- All dates are 2026-era.

## Directory Structure (numbered, 00–11)
| Prefix | Content |
|--------|---------|
| `00-framework` | AI frameworks (PyTorch, TensorFlow, JAX, CUDA, ROCm, MLX, llama.cpp, vLLM, ONNX) |
| `01-the-model` | Model files, MLX models, ONNX models, Spark models |
| `02-the-runner` | Runtimes: Ollama, LM Studio, llama.cpp, oMLX |
| `03-the-agent` | Agent frameworks: Claude Code, Flowise, Hermes Agent, OpenClaw |
| `04-the-players` | Hardware/platform guides: Apple (MacBook, Mac mini, iPad, iPhone, MLX, Draw Things, text-to-speech), Google (Edge AI, Chrome, Gmail, Stitch), Linux (Asahi, Ubuntu, Unraid), Microsoft (GitHub, VS Code, Windows), NVIDIA (GPU, Jetson/Frigate), OpenAI |
| `05-infrastructure` | Docker, Ollama stack, infrastructure guides |
| `06-projects` | Project write-ups: AI NPC, ArtCraft, Brave, Bug Detector, Cantina AI, GEV, OpenAI tools, Osmantic ODS, Perplexity, PocketPal AI, REA, Space Invaders, Watches, Youtuber |
| `07-devices` | Emerging devices: Android XR, AR glasses (Xreal Aura, Lenovo), handhelds (Legion GO2, ROG Pro), VR headsets (SteamFrame), Snapdragon, future cases |
| `08-communication-tools` | Signal, Telegram |
| `09-sample-prompts` | Prompt templates organized by use case (bitcoin-encryption, homelab-dashboard, space-invaders variants) and model |
| `10-real-world` | Real-world deployments: RayNeo Shopify, Rust |
| `11-self-hosted` | Self-hosted apps: ComfyUI, HiDream-O1, Home Assistant, Invoke AI |

## Key Hardware Context
- **Mac mini M6**: 32GB unified memory, 1TB SSD, ARM64, primary lab host
- **NVIDIA Jetson Orin Nano**: Frigate NVR, home surveillance
- **Apple ecosystem**: iPad 8GB unified memory, iPhone, MacBook
- **Mobile AI**: Google Pixel 8/9, Samsung S24/S25, iPhone 15/16

## Key Software Stack
- **Runners**: Ollama (port 11434), LM Studio, llama.cpp, oMLX
- **Models**: Gemma 3/4-e2b-it, Qwen 3.5/3.6 Coder, Llama 3.1, DeepSeek R1
- **Agents**: Claude Code, Flowise, Hermes Agent, OpenClaw
- **Self-hosted**: Home Assistant (UTM VM), ComfyUI, Invoke AI
- **Infrastructure**: Docker Desktop (ARM64), UTM virtualization

## Working Conventions
- When editing or creating documentation, match the existing style: clear headings, practical tables, code blocks with bash examples, ASCII diagrams.
- Use `2026` as the reference year for all version/date references.
- All guides assume the reader has basic technical literacy but may be new to local AI.
- Cross-reference related guides using relative links (e.g., `./README.md`, `../drawthings/README.md`).
- The `getting-started.md` and `README.md` at root are the primary entry points.
- The `privacy.md` file is a key philosophical document — local AI = privacy-first.

## Memory & CLAUDE.md Interaction
- This file is the project-level configuration. Do NOT repeat its contents in memory files.
- Memory files (`~/.claude/projects/.../memory/`) should capture project-specific facts not derivable from the codebase (user preferences, ongoing work, decisions).
- Link related memories with `[[name]]` slugs.
