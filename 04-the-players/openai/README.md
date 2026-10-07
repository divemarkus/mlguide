# OpenAI

> **OpenAI is building an AI platform where the model is increasingly becoming an agent that can reason, use tools, operate software, write code, research, and execute multi-step work—not merely a chatbot.**

OpenAI itself describes the company as an AI research and deployment company whose mission is to ensure AGI benefits humanity. Its current structure combines the nonprofit OpenAI Foundation with OpenAI Group, a public benefit corporation. [OpenAI](https://openai.com/about/)

---

# OpenAI: From Model → Assistant → Agent → Platform



The evolution is easier to understand as a progression:

```text
                    OPENAI
                       │
              ┌────────┴────────┐
              │                 │
          RESEARCH           DEPLOYMENT
              │                 │
       ┌──────┴──────┐    ┌─────┴──────────┐
       │             │    │                │
     GPT models   Reasoning  ChatGPT       API
       │             │    │                │
       └──────┬──────┘    ├── Chat
              │           ├── Work
              ▼           └── Codex
          INTELLIGENCE             │
              │                    │
              ▼                    ▼
        TOOL USE / AGENTS ──→ COMPUTER USE
              │                    │
              └────────┬───────────┘
                       ▼
                AUTONOMOUS WORK
```

That last transition is the important one.

OpenAI's own recent research direction explicitly centers on **frontier models, reasoning, multimodal systems, and safe deployment**. [OpenAI](https://openai.com/research/)

---

# 1. The Model Layer

At the bottom is the thing most people think of as "OpenAI":

## GPT

GPT is the underlying model family.

And even this has changed dramatically.

As of **October 2026**, OpenAI's current generation is GPT-6:

| Model | Position | Typical role |
|---|---|---|
| **GPT-6 Astra** | Maximum intelligence | Hardest reasoning, coding, science, computer use |
| **GPT-6.1 Sol** | Near-Astra | Professional work, coding, computer use |
| **GPT-6 Luna** | Fast/efficient | Everyday work and high-volume tasks |

OpenAI describes Astra as its most capable model, while Sol and Luna extend similar capabilities down the cost/performance curve. [OpenAI](https://openai.com/index/practical-guide-building-gpt-6/)

This is an important distinction:

```text
GPT ≠ ChatGPT

GPT = intelligence/model

ChatGPT = product built around that intelligence
```

---

# 2. ChatGPT

## The front door to OpenAI

ChatGPT started as a conversational interface to GPT.

It has become much more than that.

```text
                     CHATGPT
                        │
        ┌───────────────┼────────────────┐
        │               │                │
       CHAT            WORK            CODEX
        │               │                │
   Questions       Long-running       Software
   Reasoning       projects           engineering
   Research        Files/apps         Agents
   Learning        Delegation         Dev tools
```

OpenAI currently describes ChatGPT as its main user-facing product for writing, thinking, learning and solving problems, while its APIs provide composable building blocks for developers. [OpenAI](https://openai.com/academy/applications-of-ai/)

And **Chat** itself isn't going away.

It is still the fast conversational layer.

---

# 3. ChatGPT Work

This is probably the most important new piece for understanding where OpenAI is heading.

**Work is an agentic layer above ordinary Chat.**

Instead of:

> "Answer this question."

you can increasingly say:

> "Take care of this."

And the system can research, manipulate files, use applications, browse, create artifacts, and work through a multi-step task.

OpenAI describes Work as an agent capable of taking action across apps and files, staying with a project for hours when necessary and turning a goal into finished work. [OpenAI](https://openai.com/index/chatgpt-for-your-most-ambitious-work/?_bhlid=b229619b8c31d33de07faa7f27a4a4f2202c57cd\)

Conceptually:

```text
CHAT

User
 │
 ▼
Question
 │
 ▼
AI response


WORK

User
 │
 ▼
Goal
 │
 ├── Research
 ├── Reason
 ├── Browse
 ├── Read files
 ├── Use applications
 ├── Write
 ├── Analyze
 ├── Create artifacts
 └── Verify
       │
       ▼
   Finished work
```

That's a **fundamental architectural shift**.

---

# 4. Codex

And now we arrive at the part you asked about.

Codex began as a **software-engineering-specialized agent**.

It could:

- understand a repository
- modify code
- run tests
- debug
- refactor
- create features
- review changes
- work in isolated environments
- eventually operate computers and browsers
- run multiple agents in parallel

But Codex itself has evolved.

OpenAI says Codex has moved beyond simple code generation toward an agent capable of using computers, apps, browsers, images, persistent workflows and other tools. [OpenAI](https://openai.com/index/codex-for-almost-everything/)

And that's why the product boundaries have started collapsing.

---

# 5. The Codex App → ChatGPT Desktop

This is the part that caused your original confusion.

You weren't imagining it.

OpenAI **actually released a standalone Codex macOS application** in February 2026.

It was designed as a command center for multiple coding agents working in parallel. [OpenAI](https://openai.com/index/introducing-the-codex-app/)

Then OpenAI changed direction.

### The Codex app was merged into the new ChatGPT desktop app.

OpenAI's migration documentation is explicit:

> The new ChatGPT desktop app includes **Chat and Work under ChatGPT, alongside Codex**.

If you already had the Codex app, updating it converts it into the new ChatGPT desktop application. [OpenAI Help Center](https://help.openai.com/en/articles/20001276-moving-to-the-new-chatgpt-desktop-app)

So the evolution looks like this:

```text
2025
────────────────────────────────────

ChatGPT ──────────── General AI
Codex   ──────────── Coding Agent
                         │
                         │
                    separate products


Early 2026
────────────────────────────────────

ChatGPT ──────────── General AI
Codex App ────────── Agent command center


Mid/Late 2026
────────────────────────────────────

                 CHATGPT DESKTOP
                       │
              ┌────────┼────────┐
              │        │        │
             Chat     Work    Codex
              │        │        │
           Converse   Agent   Coding
                       │
                       ▼
                Multi-step work
```

**That's why your instinct was correct: you don't need a separate Codex macOS application anymore.**

The functionality didn't disappear.

**The container changed.**

---

# 6. This Is the Key Mental Model

Your Mac should now look conceptually like:

```text
                         macOS
                           │
                  ┌────────┴────────┐
                  │                 │
             CHATGPT APP        DEVELOPER
                  │                 │
        ┌─────────┼─────────┐       │
        │         │         │       │
       Chat      Work     Codex   VS Code
        │         │         │       │
        │         │         │    Codex IDE
        │         │         │    Claude Code
        │         │         │
        └─────────┼─────────┘
                  │
             OpenAI account
                  │
          ┌───────┴────────┐
          │                │
       Cloud AI         Local AI
          │                │
       OpenAI           Ollama
       Codex             MLX
       Work           LM Studio
```

And **this is why I would not install a separate Codex macOS application today.**

You want:

```text
ChatGPT.app
     │
     ├── Chat
     ├── Work
     └── Codex
```

rather than:

```text
ChatGPT.app
Codex.app        ← unnecessary separate desktop app
```

OpenAI's current documentation confirms that Codex remains a separate view inside the ChatGPT desktop app, with its own history and developer-oriented workflow. [OpenAI Help Center](https://help.openai.com/en/articles/20001275-chatgpt-work-and-codex)

---

# 7. But Don't Throw Codex Away

This distinction is important.

You **don't need the standalone Codex application**.

You absolutely **still want Codex**.

For you, I'd think of it as:

```text
                   CODEX
                     │
       ┌─────────────┼─────────────┐
       │             │             │
   ChatGPT.app     VS Code       Terminal
       │             │             │
     Codex       Codex IDE      Codex CLI
       │             │             │
       └─────────────┼─────────────┘
                     │
               SAME ACCOUNT
                     │
                     ▼
              SAME AI AGENT
```

OpenAI explicitly describes Codex as usable across ChatGPT, IDEs, terminal and cloud, all tied to your ChatGPT account. 

For your workflow, I'd therefore install:

```text
ChatGPT
├── Chat
├── Work
└── Codex

VS Code
└── Codex extension

Terminal
└── Codex CLI
```

That is considerably more useful than installing another GUI application.

---

# 8. And OpenAI Is Going Beyond Coding

This is where things get particularly interesting.

Codex was originally:

```text
AI programmer
```

It's becoming:

```text
AI agent
```

OpenAI's April 2026 update explicitly described Codex expanding into computer use, apps, browsers, image generation, persistent preferences, PR review, remote devboxes and ongoing work. [OpenAI](https://openai.com/index/codex-for-almost-everything/)

By June, OpenAI reported that more than **5 million people were using Codex weekly**, with non-developers already accounting for roughly 20% of users. [OpenAI](https://openai.com/index/codex-for-every-role-tool-workflow/)

That's a major signal.

---

# 9. The Bigger OpenAI Architecture

Here's how I'd draw the **2026 OpenAI stack**:

```text
┌────────────────────────────────────────────────────────────┐
│                         OPENAI                             │
│                                                            │
│  Research → Models → Agents → Products → Platform          │
│                                                            │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  GPT-6 FAMILY                                              │
│  ├── Astra      Maximum capability                         │
│  ├── Sol        Professional / efficient                   │
│  └── Luna       Fast / economical                          │
│                                                            │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  AGENT / INTELLIGENCE LAYER                                │
│  ├── Reasoning                                             │
│  ├── Computer use                                          │
│  ├── Browser use                                           │
│  ├── Tool use                                              │
│  ├── Multi-agent orchestration                             │
│  └── Long-running tasks                                    │
│                                                            │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  PRODUCTS                                                  │
│  ├── ChatGPT                                               │
│  │   ├── Chat                                              │
│  │   └── Work                                              │
│  │                                                         │
│  ├── Codex                                                 │
│  │   ├── Desktop                                           │
│  │   ├── Cloud                                             │
│  │   ├── CLI                                               │
│  │   └── IDE                                               │
│  │                                                         │
│  └── Other experiences / tools                             │
│                                                            │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  DEVELOPER PLATFORM                                        │
│  ├── OpenAI API                                            │
│  ├── Responses / agent infrastructure                      │
│  ├── Agents API                                            │
│  ├── Models                                                │
│  └── Enterprise integrations                               │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

And there's another important recent development: OpenAI introduced the **Agents API in September 2026**, exposing the same kind of agent harness/infrastructure used for Codex and ChatGPT Work to developers. [OpenAI](https://openai.com/index/introducing-the-agents-api/)

That's an enormous architectural clue.

---

# 10. The Roadmap I See

I wouldn't call this a secret OpenAI roadmap—it's a **technology/product trajectory inferred from OpenAI's public releases**.

```text
2022
│
│  ChatGPT
│  "Talk to an AI"
│
▼
2023
│
│  Multimodal AI
│  Vision / voice / tools
│
▼
2024
│
│  Reasoning + multimodality
│  AI becomes a general assistant
│
▼
2025
│
│  Agents + Codex
│  "Give AI a task"
│
▼
2026
│
│  ChatGPT Work
│  Codex
│  Computer use
│  Multi-agent workflows
│  Long-running tasks
│
▼
TODAY
│
│  AI can increasingly:
│
│  THINK
│   ↓
│  PLAN
│   ↓
│  USE TOOLS
│   ↓
│  OPERATE COMPUTERS
│   ↓
│  WRITE CODE
│   ↓
│  VERIFY RESULTS
│   ↓
│  DELIVER ARTIFACTS
│
▼
NEXT
│
│  Agents become the interface
│
│  Human
│    ↓
│  Goal
│    ↓
│  Agent
│    ├── Models
│    ├── Tools
│    ├── Computer
│    ├── Browser
│    ├── APIs
│    ├── Files
│    ├── Other agents
│    └── Memory/context
│
▼
     AUTONOMOUS KNOWLEDGE WORK
```

That trajectory is consistent with OpenAI's recent product direction: Work, Codex, computer use, multi-agent workflows and now the Agents API. [OpenAI](https://openai.com/index/codex-for-almost-everything/)

---

# 11. What Happened to Sora?

This is actually a good example of why your new Custom Instructions about **freshness** are important.

Sora was one of OpenAI's major products.

But **Sora's web/app experience was discontinued April 26, 2026, and the API was discontinued September 24, 2026.** [OpenAI](https://openai.com/index/sora/)

So if someone gave you an OpenAI product diagram from 2025:

```text
ChatGPT
Codex
Sora
DALL-E
...
```

you shouldn't blindly treat that as today's architecture.

OpenAI is consolidating capabilities into newer experiences.

That's exactly why I think your new instruction:

> *"Technology, especially AI/ML, changes rapidly..."*

is an excellent one.

---

# 12. And This Explains Your Mac Setup

For **your Mac**, I'd now think of OpenAI as one layer of your broader AI lab:

```text
┌──────────────────────────────────────────────┐
│                  YOUR MAC                    │
├──────────────────────────────────────────────┤
│                                              │
│  CLOUD / AGENTIC AI                          │
│                                              │
│  ┌────────────────────────────────────────┐  │
│  │             ChatGPT.app                │  │
│  │                                        │  │
│  │  Chat       Work        Codex          │  │
│  │   │          │           │             │  │
│  │   ▼          ▼           ▼             │  │
│  │ General    Agent       Coding          │  │
│  │ AI         Work        Agent           │  │
│  └────────────────────────────────────────┘  │
│                                              │
│  DEVELOPMENT                                 │
│  ┌────────────────────────────────────────┐  │
│  │ VS Code                                │  │
│  │ ├── Codex                              │  │
│  │ └── Claude Code                        │  │
│  └────────────────────────────────────────┘  │
│                                              │
│  LOCAL AI                                    │
│  ┌────────────────────────────────────────┐  │
│  │ Ollama │ LM Studio │ MLX/oMLX          │  │
│  └────────────────────────────────────────┘  │
│                                              │
│  LOCAL IMAGE AI                              │
│  ┌────────────────────────────────────────┐  │
│  │ Draw Things                            │  │
│  └────────────────────────────────────────┘  │
│                                              │
└──────────────────────────────────────────────┘
```

And that's actually a **very powerful architecture** because you're not replacing your local AI stack with OpenAI.

You're adding another layer:

```text
             YOUR AI LAB
                  │
       ┌──────────┴───────────┐
       │                      │
   CLOUD AI                 LOCAL AI
       │                      │
   OpenAI                   Ollama
   ChatGPT                  LM Studio
   Work                     MLX/oMLX
   Codex                    Qwen/etc.
       │                      │
       └──────────┬───────────┘
                  │
              YOU / IDE
                  │
        ┌─────────┴─────────┐
        │                   │
      VS Code            Terminal
        │                   │
      Codex             Codex CLI
      Claude            Local models
```

## My recommendation for your Mac

**Don't install a separate Codex desktop application.**

Install/update the **current ChatGPT macOS app** and use:

- **Chat** → normal AI/research/conversation
- **Work** → delegated multi-step work
- **Codex** → serious software engineering
- **Codex CLI** → terminal-centric agentic development
- **Codex IDE extension** → VS Code workflow

Keep **Ollama / LM Studio / MLX/oMLX / Draw Things** as your local/private AI layer.

The interesting part isn't that OpenAI eliminated Codex.

**They absorbed the Codex desktop shell into ChatGPT while keeping Codex itself as a distinct agentic capability.**

That's a much more logical architecture.

And honestly, for someone building the kind of **local AI + agent + DevOps + infrastructure environment** you're building, this is much more interesting than simply having another chatbot on the Mac.

### References

- [OpenAI — About](https://openai.com/about/) — mission, organizational structure and company overview. [OpenAI](https://openai.com/about/)
- [OpenAI — GPT-6 model guide](https://openai.com/index/practical-guide-building-gpt-6/) — current GPT-6 model family and positioning. 
- [OpenAI — ChatGPT Work and Codex](https://help.openai.com/en/articles/20001275-chatgpt-work-and-codex) — current Chat/Work/Codex desktop architecture.
- [OpenAI — Moving to the new ChatGPT desktop app](https://help.openai.com/en/articles/20001276-moving-to-the-new-chatgpt-desktop-app) — explains the Codex-app-to-ChatGPT-app migration.
- [OpenAI — Codex for (almost) everything](https://openai.com/index/codex-for-almost-everything/) — current Codex capabilities and computer-use direction.
- [OpenAI — Codex for every role, tool, and workflow](https://openai.com/index/codex-for-every-role-tool-workflow/) — Codex expansion beyond traditional software development.
- [OpenAI — Agents API](https://openai.com/index/introducing-the-agents-api/) — current developer-facing agent infrastructure.
- [OpenAI — Sora discontinuation](https://help.openai.com/en/articles/20001152-what-to-know-about-the-sora-discontinuation) — current status of Sora.