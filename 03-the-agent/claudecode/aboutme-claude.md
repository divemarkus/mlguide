# 👋 About Me — Claude Code

> **You just met me.** I'm Claude Code — a coding agent that lives in your terminal, reads your files, edits your code, and ships real work.
>
> This file is your quick-reference guide to what I actually do, how I work, and how to get the most out of me — whether you're browsing locally or connecting via Anthropic.

---

## 🧠 Who Am I?

I am **Claude Code**, Anthropic's coding agent. Not a chatbot. Not a code-completion tool. Not a model you paste output from.

I am a **filesystem agent with tool access**. I read your code, edit your files, run commands, search repos, review PRs, and coordinate multi-step workflows — all autonomously.

| Property | Value |
|---|---|
| **Cloud models** | Sonnet (default), Opus (reasoning), Haiku (fast) |
| **Local fallback** | Qwen3.6, Llama, Gemma via Ollama |
| **Platform** | Terminal agent on macOS, Linux, Windows |
| **Primary hardware** | Apple Silicon (Mac mini, MacBook, iPad) |
| **Access type** | Cloud API (primary) or local inference (privacy mode) |
| **Best for** | Coding, repo analysis, multi-step workflows, code review |

---

## 🛠️ What I Can Actually Do

### Filesystem Operations
| Capability | Example |
|---|---|
| **Read files** | `Read(file_path)` — I read before I write, always |
| **Edit files** | `Edit(file_path)` — precise string replacements, not full rewrites |
| **Write files** | `Write(file_path)` — create or fully replace files |
| **Run commands** | `Bash(command)` — terminal access with output |
| **Search code** | `Grep(pattern)` — find code, configs, patterns |
| **List directories** | `ls`, `find` — explore project structure |

### Agent Capabilities
| Capability | Description |
|---|---|
| **Sub-agents** | Spawn parallel agents for independent work |
| **Multi-phase workflows** | Pipeline → verify → report, all coordinated |
| **Persistent memory** | Write/read memory files between sessions |
| **Code review** | Review PRs, find bugs, suggest improvements |
| **Self-evaluation** | Check my own output before delivering it |

### Project Setup
| Capability | Description |
|---|---|
| **Repo analysis** | "Analyze this repository and configure yourself" |
| **CLAUDE.md creation** | Set project-level instructions I follow by default |
| **Configuration** | Update settings, keybindings, hooks, permissions |
| **Documentation** | Write, edit, and maintain project docs |

---

## 🎯 How I Actually Work

### I Don't "Answer Questions" — I Take Actions

```
You:     "Refactor the auth module to use JWT"
Me:      1. Read the current auth files
         2. Identify what needs changing
         3. Edit each file with the new pattern
         4. Run tests to verify
         5. Report what changed
```

**I produce working code, not suggestions.** I modify files on your disk directly.

### I Read Before I Write

```
❌ Wrong:  "I'll write the new auth module"
✅ Right:   "Let me read the existing auth module first"
```

I match your codebase's patterns, conventions, and style. I don't guess.

### I Work Iteratively

```
Step 1: Analyze the repo
Step 2: Plan the changes
Step 3: Implement incrementally
Step 4: Test and verify
Step 5: Summarize what changed
```

Don't ask for everything at once. Step-by-step produces better results.

---

## 💬 Best Prompts for Me

### First-Time Setup (The Magic Prompt)
```
Analyze this repository and configure yourself for the project.
```
I'll inspect the repo, understand the stack, and create `CLAUDE.md` with project-specific instructions.

### Code Review
```
Review the current diff for bugs, simplifications, and efficiency.
```

### Refactoring
```
Refactor the auth module to use JWT.
- Keep existing tests passing
- Match the repo's coding style
- Explain each change
```

### Repo Analysis
```
Analyze this repository completely.
1. Explain the architecture
2. Identify frameworks and dependencies
3. Suggest improvements
4. Recommend a development workflow
```

### The "Senior Engineer" Prompt
```
You are my senior software engineer.
- Keep code maintainable
- Prefer simple solutions
- Explain architectural decisions
- Validate all changes
- Think step-by-step before editing
```

---

## 🔑 Things Most People Miss

### 1. I Remember Things
I can write memory files that persist between sessions. Tell me your preferences once, and I'll remember them.

### 2. I Have Built-in Code Review
I can review your PRs for bugs, suggest simplifications, and evaluate my own work — without you asking.

### 3. I Can Delegate to Themselves
I can spawn parallel sub-agents for independent tasks. Need to review a diff across multiple dimensions? I'll run them in parallel.

### 4. I Follow CLAUDE.md by Default
The `CLAUDE.md` file isn't optional documentation — it's my operating instructions for this repo. I read it and follow it.

### 5. I'm Optimized for Apple Silicon
My tooling works natively on macOS. Apple Silicon is my primary hardware platform.

### 6. My Context Window Is Bounded
I can't read an entire large repo at once. I read files on demand, summarize as I go, and use search tools.

### 7. I'm a Cloud Model First
The local Qwen setup is a privacy compromise. The cloud versions (Sonnet, Opus, Haiku) have significantly deeper capabilities.

### 8. I Produce Working Code, Not Suggestions
I don't generate text you copy-paste. I modify files on your disk directly. The output is the actual code.

---

## 📊 Capability Comparison

| Feature | Claude Code (Cloud) | Claude Code (Local Qwen) | Chatbot | Code Completion |
|---|---|---|---|---|
| **File editing** | ✅ | ✅ | ❌ | ❌ |
| **Terminal access** | ✅ | ✅ | ❌ | ❌ |
| **Repo analysis** | ✅ | ✅ | Partial | ❌ |
| **Code review** | ✅ | Partial | ❌ | ❌ |
| **Multi-step workflows** | ✅ | Partial | ❌ | ❌ |
| **Sub-agent delegation** | ✅ | ❌ | ❌ | ❌ |
| **Persistent memory** | ✅ | Partial | ❌ | ❌ |
| **Tool use loop** | ✅ | Partial | ❌ | ❌ |
| **Context window** | 200K tokens | Limited | Varies | Short |
| **Reasoning depth** | Opus > Sonnet > Haiku | Qwen3.6 / Llama | Varies | N/A |

---

## 🚀 Quick Start

### Connect via Anthropic (Recommended)
```bash
# Use the cloud API — full capabilities
claude
```

### Run Locally (Privacy Mode)
```bash
# Use a local model — privacy-first, slightly less capable
ollama launch claude --model qwen3.6:35b-a3b-coding-nvfp4
```

### First Command
```
Analyze this repository and configure yourself for the project.
```

### After Setup
```
Review the current diff.
Refactor the auth module.
Write tests for this function.
Create a CLAUDE.md for this repo.
```

---

## 🎨 How to Get the Most Out of Me

### Do This ✅
| Action | Why |
|---|---|
| Give me context-rich prompts | I work better with specifics |
| Use iterative prompting | Step-by-step beats "do everything" |
| Let me create CLAUDE.md | It's my config file for this repo |
| Ask me to review my own work | I can self-evaluate |
| Use sub-agents for parallel work | Faster than sequential |
| Tell me your preferences | I'll remember them |

### Avoid This ❌
| Action | Why |
|---|---|
| Ask for everything at once | I work better step-by-step |
| Give vague prompts | "Fix it" is harder than "fix the null check on line 42" |
| Ignore my file edits | I modify files directly — review the diff |
| Assume I can read everything | I read on demand, not all at once |
| Treat me as a chatbot | I'm a filesystem agent with tool access |

---

## 📁 Where to Find Me

| Location | What You'll Find |
|---|---|
| **This file** (`aboutme-claude.md`) | What I am and what I do |
| **`claudecode.md`** | How to use me with local Ollama models |
| **`README.md`** | Setup guide for macOS + Ollama + Claude Code |
| **`getting-started.md`** | Beginner's guide to local AI |
| **`privacy.md`** | Why local AI matters for privacy |
| **`CLAUDE.md`** | My project-level instructions (auto-loaded) |
| **Memory files** | Persistent preferences and project context |

---

## 💡 The One-Sentence Summary

> **I'm Claude Code — a coding agent that reads your files, edits your code, runs commands, and ships real work, powered by Anthropic's cloud models (or your local hardware for privacy).**

---

## 🤝 How to Talk to Me

| You Say | I Do |
|---|---|
| "Fix this bug" | Read the file → find the issue → write the fix → verify |
| "Review this diff" | Analyze changes → find bugs → suggest improvements |
| "Refactor the auth module" | Read current code → design new structure → write it → test |
| "Analyze this repo" | Inspect structure → understand stack → summarize → recommend |
| "Create a CLAUDE.md" | Study the repo → write project-specific instructions |
| "Write tests for this" | Read the code → write tests → run them → fix failures |

---

## 🏷️ Tags

`#claude-code` `#anthropic` `#coding-agent` `#filesystem-agent` `#tool-use` `#local-ai` `#apple-silicon` `#ollama` `#qwen3.6` `#cloud-api` `#sonnet` `#opus` `#haiku` `#code-review` `#multi-agent` `#persistent-memory` `#claudemd` `#privacy-first` `#local-inference` `#self-hosted`

---

*Last updated: 2026-10-22 | Built for discovery — local or via Anthropic*
