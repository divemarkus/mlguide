# LM Studio

LM Studio is a lightweight, local-first environment for experimenting with, fine-tuning, and serving large language models (LLMs). It provides an easy-to-use GUI and CLI tools to manage model downloads, run inference, test prompts, and prototype small applications — all on your own hardware or private cloud.

## Basic Facts
- Purpose: Local development, evaluation, and small-scale serving of LLMs.
- Scope: Single-machine or small-cluster usage; not intended as a full enterprise MLOps platform.
- Interfaces: Web-based UI, REST/gRPC APIs, and CLI.
- Models: Supports various open models (quantized or full precision) depending on runtime (CPU, GPU, or accelerated runtimes like Ollama).
- License: Depends on included components and models; check individual model licenses before production use.

## Key Features
- Model management: download, version, and switch models easily.
- Prompt studio: build, test, and compare prompts interactively.
- Experiment tracking: save sessions, inputs, outputs, and metrics.
- Local deployment: run model servers locally or expose via secure tunnels.
- Extensibility: plugin hooks for custom preprocessing, postprocessing, or connectors.

## Common Use-Cases
- Prompt engineering and rapid prototyping.
- Small-scale inference for demos or internal tools.
- Offline model evaluation and comparison.
- Education and exploration of LLM behavior without cloud costs.

## Quick Installation (Overview)
1. Prerequisites:
	- OS: Linux, macOS, or Windows (WSL recommended for Windows).
	- Python 3.10+ (if Python components used) or Docker.
	- Optional GPU drivers and CUDA (for GPU acceleration).
2. Install options:
	- Docker: run the provided container image for an isolated environment.
	- Native: clone the repo and install Python dependencies (see `requirements.txt`).
3. Example (Docker):
	- Build or pull the image, then run the container exposing the UI port.
4. Example (native):
	- Create venv, `pip install -r requirements.txt`, then `python -m lm_studio.server` (or the provided entrypoint).

## Configuration
- Configuration file: location and format (YAML/JSON/env) — describe here once determined.
- Common settings: model cache path, default model, port/UI auth, resource limits (CPU/GPU/memory).
- Environment variables: list critical vars (e.g., MODEL_PATH, LM_STUDIO_PORT, AUTH_TOKEN).

## Deployment Scenarios
- Local development: single-host running the UI and model process.
- Team sharing: host on a LAN with simple auth and firewall rules.
- Cloud deployment: containerize and deploy to a small VM or Kubernetes cluster (use GPU nodes for heavy models).
- Edge devices: lightweight quantized models on Jetson/NVidia modules — use model optimization and reduced batch sizes.

## Security & Privacy
- Models and data remain under local control by default.
- Recommend token-based auth or reverse proxy with TLS for network exposure.
- Sanitize logs and avoid logging sensitive prompts/outputs.
- Verify model licenses before commercial use.

## Examples / Quickstart
- Basic inference sample (curl):
  ```
  curl -X POST http://localhost:1234/api/v1/generate -d '{"model":"ggml-small","prompt":"Hello"}'
  ```
- Using the UI: open `http://localhost:1234` after starting the server.

## Troubleshooting
- Common issues: model download failures, insufficient GPU memory, port conflicts.
- Tips: check logs, increase swap for large-model CPU runs, verify drivers for GPU.

## FAQ / Notes
- Which models are recommended for small GPUs/CPU-only? List quantized and lightweight models.
- How to add new models? Explain model format and adding to model registry.
- Performance tuning: batch sizes, sequence length, CPU affinity, quantization options.

## References & Links
- Link to model sources and licenses.
- Link to related tooling (Ollama, LMflow, etc.) and docs.

Files:

- `lm-studio-install.md`: Install notes
- `sample-workspace.yml`: Example workspace configuration
