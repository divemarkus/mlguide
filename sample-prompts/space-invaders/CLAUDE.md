# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This directory contains prompt templates and HTML outputs for testing different local ML models to generate a Space Invaders game. Each model has:
- A `.md` file with the prompt used and notes about the model
- An `.html` file with the generated Space Invaders game

## Directory Structure

```
sample-prompts/space-invaders/
├── CLAUDE.md                    # This file
├── [model-name].md              # Prompt template and notes for each model
└── [model-name].html            # Generated HTML game output
```

## Files by Model

| Model | Prompt File | Output File |
|-------|-------------|-------------|
| Qwen3-Coder-Next | qwen3-coder-next.md | qwen3-coder-next.html |
| Qwen3-Coder-30B | qwen3-coder-30b.md | qwen3-coder-30b.html |
| Qwen3-Coder-30B v2 | qwen3-coder-30b.md | qwen3-coder-30b-v2.html |
| Qwen3.5-9B | qwen3.5-9b.md | qwen3.5-9b.html |
| Qwen3.6-27B | qwen3.6-27b.md | qwen3.6-27b.html |
| Qwen3.6-27B v2 | qwen3.6-27b.md | qwen3.6-27b-v2.html |
| Gemma-4-e4b | gemma-4-e4b.md | gemma-4-e4b.html |
| GPT-OSS-20B | gpt-oss-20b.md | gpt-oss-20b.html |
| DeepSeek-R1 | deepseek-r1-058-qwen3-8b.md | deepseek-r1-058-qwen3-8b.html |

## Common Commands

### View Model Prompts
```bash
cat [model-name].md
```

### View Generated HTML
```bash
cat [model-name].html
```

### Open in Browser
```bash
open [model-name].html
```

## Development Workflow

1. Create a new `.md` file with the prompt and model specifications
2. Submit the prompt to an ML model
3. Save the HTML output as `[model-name].html`
4. Update the `.md` file with model notes (VRAM usage, tokens/sec, etc.)

## HTML Game Output

All generated HTML files are self-contained Space Invaders games using:
- Vanilla JavaScript
- HTML5 Canvas
- CSS (no external libraries or CDNs)

The games feature:
- Player ship with left/right movement (arrow keys or A/D)
- Shooting with spacebar
- Multiple rows of aliens
- Collision detection
- Score tracking
- Game Over / Win states
