Getting started with [Claude Code](https://www.anthropic.com/claude-code) using local Ollama + MLX models is actually much simpler than most people expect.

Setup:

```bash
ollama launch claude --model qwen3.5:35b-a3b-coding-nvfp4
```

is already the important part. The rest is mostly about:

* giving the model the right environment
* teaching Claude Code your preferences
* using effective workflows/prompts

The MLX integration from [Ollama MLX blog post](https://ollama.com/blog/mlx) is especially good on Apple Silicon because it offloads efficiently to unified memory and uses Apple's MLX backend.

---

# The Short Answer

You do **not** need lots of presets before starting.

Claude Code is designed to:

* inspect your repo
* infer tooling
* generate commands
* update configs
* refactor code
* run agentic loops

You can mostly tell it:

```text
Analyze this repository and configure yourself for the project.
```

or:

```text
Inspect the repo and create any recommended local AI coding configs.
```

And let it work.

That said, there *are* a few important optimizations that dramatically improve results.

---

# Recommended First-Time Claude Code Workflow

## 1. Start Inside a Real Project Folder

Example:

```bash
cd ~/Projects/myapp
claude
```

or via your Ollama launcher setup.

Claude Code becomes much smarter when it can:

* inspect package.json
* inspect Docker files
* inspect README
* inspect git history
* inspect configs
* inspect existing architecture

This is where local coding models like Qwen3.5 Coding shine.

---

# 2. First Prompt to Run

This is one of the best first prompts:

```text
Analyze this repository completely.

Then:
1. Explain the architecture
2. Identify frameworks and dependencies
3. Identify build/test/lint commands
4. Suggest improvements
5. Create missing AI helper files if useful
6. Recommend a development workflow
7. Tell me what you would configure for maximum productivity
```

This lets Claude Code self-bootstrap.

---

# 3. Let Claude Create Project AI Files

Many people manually create these prematurely.

Instead:

```text
Create any recommended Claude Code configuration files, prompts, memory files, or development instructions for this repository.
```

Claude will often generate:

* AGENTS.md
* CLAUDE.md
* PROJECT_CONTEXT.md
* architecture notes
* coding standards
* workflow docs

This works surprisingly well.

---

# 4. Create a Persistent "System Prompt" File

This is one of the biggest productivity multipliers.

I strongly recommend adding something like:

```md
# CLAUDE.md

## Coding Style
- Prefer readable code over clever code
- Add comments for complex logic
- Keep functions small
- Avoid unnecessary dependencies

## Environment
- Use Docker when possible
- Prefer local-first workflows
- Avoid cloud APIs unless requested

## Testing
- Always add tests when modifying logic
- Explain how to run tests

## Security
- Never expose secrets
- Use least privilege
- Prefer read-only containers when possible
```

This aligns perfectly with privacy-first + infrastructure-heavy workflow. Docker hardening notes and local-first AI stack philosophy are excellent examples of this style already. 

---

# 5. Best Settings for Local Ollama Models

For local coding models, these matter more than people realize.

## Recommended Model Parameters

For coding:

```text
temperature: 0.1 - 0.3
```

Lower temperature:

* improves consistency
* reduces hallucinations
* improves refactors
* improves agentic loops

For architecture brainstorming:

* 0.5–0.7 is fine

---

# 6. Give Claude Tools, Not Just Questions

Claude Code works best agentically.

Bad:

```text
Build me a dashboard
```

Better:

```text
Build me a dashboard.

Requirements:
- Tailwind
- Responsive
- Beginner editable
- Modular structure
- Docker deployable
- Add comments
- Explain architecture
- Generate files incrementally
```

Your existing prompt engineering examples are actually very good examples of this style already. 

---

# 7. Local LLM Reality Check

Your model:

```text
qwen3.5:35b-a3b-coding-nvfp4
```

is VERY capable locally.

But there are tradeoffs.

## What It Excels At

* repo analysis
* code completion
* Docker
* infrastructure
* HTML/CSS/JS generation
* refactoring
* terminal workflows
* debugging
* architecture reasoning

## What May Struggle

* extremely long autonomous loops
* multi-hour agent chains
* massive context repositories
* advanced planning compared to cloud Claude Opus

Still:
Qwen3.5 Coding is one of the strongest local coding models available right now.

---

# 8. Important Claude Code Habits

## A. Use Iterative Prompting

Do NOT ask for everything at once.

Best pattern:

```text
Step 1: Analyze
Step 2: Plan
Step 3: Implement incrementally
Step 4: Test
Step 5: Refactor
```

---

## B. Ask It to Think Before Coding

Huge quality improvement:

```text
Before changing files:
- analyze the codebase
- explain the plan
- identify risks
- then implement
```

---

## C. Force Validation

Local models sometimes confidently break things.

Use:

```text
After modifications:
- run tests
- lint
- explain failures
- fix issues
```

---

# 9. Recommended Claude Code Stack

Your local-first stack direction is excellent already.

Recommended stack:

| Tool                                                                        | Role            |
| --------------------------------------------------------------------------- | --------------- |
| [Ollama](https://ollama.com?utm_source=chatgpt.com)                         | local inference |
| [Claude Code](https://www.anthropic.com/claude-code?utm_source=chatgpt.com) | coding agent    |
| [Open WebUI](https://openwebui.com?utm_source=chatgpt.com)                  | chat interface  |
| [Qdrant](https://qdrant.tech?utm_source=chatgpt.com)                        | vector memory   |
| [Flowise](https://flowiseai.com?utm_source=chatgpt.com)                     | visual agents   |
| [Netdata](https://www.netdata.cloud?utm_source=chatgpt.com)                 | monitoring      |
| [LM Studio](https://lmstudio.ai?utm_source=chatgpt.com)                     | model testing   |

Your Docker stack examples already align well with this architecture.

---

# 10. One of the Most Powerful Claude Code Prompts

This is a killer prompt for local coding agents:

```text
You are my senior software engineer.

Goals:
- Keep code maintainable
- Prefer simple solutions
- Explain architectural decisions
- Avoid unnecessary dependencies
- Validate all changes
- Think step-by-step before editing

Workflow:
1. Analyze
2. Plan
3. Implement incrementally
4. Test
5. Summarize changes
```

This massively stabilizes local models.

---

# 11. What Most Beginners Miss

The biggest leap in Claude Code productivity is NOT:

* model size
* GPU
* presets

It's:

* repository context
* persistent instructions
* incremental workflows
* tool integration
* good prompts

Your existing prompt engineering examples already show you're heading in the right direction.

---

# Recommended First Experiment

Try this in a real repo:

```text
Analyze this repository and modernize it.

Tasks:
- improve structure
- add dark mode
- improve Docker setup
- add linting and formatting
- improve responsiveness
- explain every major change before applying it
```

That’s the point where Claude Code starts feeling genuinely powerful locally.
