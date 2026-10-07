# ChatGPT in 2026: Your AI Workbench


The mental model I'd use is:

```text
                         CHATGPT
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
        CHAT              WORK              CODEX
          │                 │                 │
    Conversation        Agentic work      Software
    Reasoning           Research          engineering
    Search              Files             Repositories
    Learning            Apps              Terminals
    Analysis            Artifacts          Agents
          │                 │                 │
          └─────────────────┼─────────────────┘
                            │
                      PROJECTS / CONTEXT
                            │
           ┌────────────────┼────────────────┐
           │                │                │
        Your files       Connected apps    GitHub
           │                │                │
           └────────────────┼────────────────┘
                            │
                     OpenAI intelligence
```

The really important change is that **ChatGPT now surrounds the model with context, tools, applications, files, agents and persistent projects**.

---

# 1. Web vs. Desktop: What's Actually Different?

The distinction isn't simply:

> Web = basic  
> App = advanced

It's more nuanced.

| Capability | ChatGPT Web | ChatGPT macOS App |
|---|:---:|:---:|
| Chat | ✅ | ✅ |
| Projects | ✅ | ✅ |
| Files | ✅ | ✅ |
| Web search | ✅ | ✅ |
| Deep research | ✅ | ✅ |
| Work | ✅ | ✅ |
| Voice | ✅ | ✅ |
| Connected apps | ✅ | ✅ |
| GitHub integration | ✅* | ✅* |
| Local computer files | ❌ | **✅** |
| Desktop apps | ❌ | **✅** |
| Built-in browser | ❌ | **✅** |
| Codex | Limited/cloud workflows | **Full desktop Codex** |
| Codex local repositories | ❌ | **✅** |
| Codex terminals | ❌ | **✅** |
| macOS global ChatGPT shortcut | ❌ | **✅** |
| Continue cloud Work across devices | **✅** | **✅** |

\* Availability depends on plan, workspace, app and permissions.

OpenAI specifically says Work on the web/mobile runs in the cloud, while desktop Work can additionally access local files and desktop apps with permission. [OpenAI Help Center](https://help.openai.com/en/articles/20001275)

The current macOS application requires **macOS 14+ and M1 or newer (or Intel)**. [OpenAI Help Center](https://help.openai.com/en/articles/9275200-downloading-the-chatgpt-macos-app)

### The big desktop advantage

The desktop application is increasingly a **computer interface for ChatGPT**.

For example:

```text
             CHATGPT DESKTOP
                    │
       ┌────────────┼────────────┐
       │            │            │
     Files        Browser       Apps
       │            │            │
       └────────────┼────────────┘
                    │
                 Agent
                    │
        ┌───────────┼───────────┐
        │           │           │
      Read        Modify      Execute
        │           │           │
        └───────────┼───────────┘
                    ▼
                 Result
```

The built-in browser can browse pages, sign into sites, download files, work across tabs and even annotate pages. It maintains its own browser state rather than using your normal Chrome profile. [OpenAI Help Center](https://help.openai.com/en/articles/20001277-using-the-built-in-browser-in-the-chatgpt-desktop-app)

That's a pretty big difference from "chatbot in a browser tab."

---

# 2. ChatGPT's Major Capability Stack

I'd divide ChatGPT into roughly **10 capability areas**.

### 1. Conversation & reasoning

The obvious one:

- questions
- explanations
- brainstorming
- writing
- analysis
- problem solving
- mathematics
- technical discussions

But this is now just the foundation.

### 2. Web research

ChatGPT can search the web for current information and synthesize sources.

This is particularly important for **your AI/ML work**, because model releases, benchmarks, hardware and APIs become obsolete rapidly.

### 3. Deep research

Instead of asking:

> "What is Qwen?"

you can ask:

> "Research the current Qwen model family, compare architectures, context sizes, quantization options, MLX/Ollama support and real-world benchmarks, and tell me which models make sense for my Macs."

That's a completely different workload.

### 4. Work

Work is the agentic layer.

Instead of asking for an answer:

> "Produce the finished report."

ChatGPT can research, analyze, use files/apps, create artifacts and iterate toward the deliverable. OpenAI currently describes Work as an end-to-end task environment, available on web/mobile and desktop, with additional local computer access on desktop. [OpenAI Help Center](https://help.openai.com/en/articles/20001275-chatgpt-work-and-codex)

### 5. Projects

**Projects should absolutely be one of your Top 10 setup items.**

Projects are persistent workspaces containing:

```text
Project
├── Instructions
├── Chats
├── Files
├── Saved responses
├── Connected sources/apps
└── Project context
```

OpenAI describes Projects specifically as a way to keep chats, files and instructions together for ongoing work. [OpenAI Help Center](https://help.openai.com/en/articles/10169521-projects-in-chatgpt)

And there's an important feature:

> **Project instructions override your global Custom Instructions.** [OpenAI Help Center](https://help.openai.com/en/articles/10169521-projects-in-chatgpt)

That is extremely useful.

For example:

```text
GLOBAL INSTRUCTIONS
        │
        ▼
"My general ChatGPT behavior"
        │
        ├───────────────┐
        │               │
        ▼               ▼
 ML PROJECT         TRADING PROJECT
        │               │
        ▼               ▼
 ML-specific        Finance-specific
 instructions      instructions
```

You don't need to cram every behavior into your global 1,500-character limit.

---

# 3. Projects Could Be Your Biggest Upgrade

For you, I'd create something like:

```text
📁 Machine Learning / AI Guide
📁 Local LLM Lab
📁 Apple AI / ML
📁 Docker / Infrastructure
📁 Cybersecurity / SIEM
📁 GitHub / Development
📁 Trading / Markets
📁 Home Automation
```

Each project can have its own:

- instructions
- files
- conversations
- reference material
- connected apps
- accumulated context

Projects are available across web and desktop, and OpenAI currently allows unlimited project creation; file limits depend on plan. [OpenAI Help Center](https://help.openai.com/en/articles/10169521-using-projects-in-chatgpt%252525252525252525252525252525252525252525252525252525253F.pls)

---

# 4. What About Your GitHub Repository?

This is **particularly interesting for you.**

Yes, you can connect GitHub to ChatGPT.

OpenAI's current GitHub integration allows ChatGPT to retrieve permitted repository content—including code, README files and documentation—and use it for analysis, research and supported agent workflows. [OpenAI Help Center](https://help.openai.com/en/articles/11145903-connecting-github-to-chatgpt)

Conceptually:

```text
GitHub
   │
   │ authorized access
   ▼
ChatGPT
   │
   ├── Understand repository
   ├── Search code
   ├── Analyze architecture
   ├── Review documentation
   ├── Answer questions
   └── Research against code
```

### But there's an important distinction

GitHub integration isn't the same thing as putting your entire repository into a Project.

The current GitHub connection provides **live/on-demand repository access**; OpenAI says it does not create a synced GitHub index. [OpenAI Help Center](https://help.openai.com/en/articles/11145903-connecting-github-to-chatgpt)

So I'd think about it this way:

```text
PROJECT
  = persistent context / knowledge / instructions

GITHUB
  = live source-code repository

CODEX
  = modify / execute / test software

CHAT
  = understand / explain / research
```

That's a **much better architecture** than simply uploading a ZIP of your repository.

---

# 5. What About Ollama?

This is where your setup gets particularly interesting.

ChatGPT does **not** replace Ollama.

Think:

```text
                 YOUR AI STACK
                       │
            ┌──────────┴──────────┐
            │                     │
          CLOUD                 LOCAL
            │                     │
         ChatGPT                Ollama
         Codex                  LM Studio
         Work                   MLX/oMLX
         OpenAI API             Qwen/etc.
            │                     │
       Cloud intelligence     Private inference
       Agent infrastructure   Local experimentation
```

Ollama is your **local inference layer**.

ChatGPT is your **cloud intelligence/agent/product layer**.

There is enormous value in having both.

For example:

```text
ChatGPT
   │
   ├── Research latest Qwen models
   │
   ├── Compare benchmarks
   │
   ├── Design architecture
   │
   └── Generate Ollama configuration
                │
                ▼
             Ollama
                │
             Qwen
                │
                ▼
        Private inference
```

And this becomes even more interesting if you use ChatGPT/Codex to **develop the infrastructure around Ollama**, while Ollama actually runs your local models.

I would not try to make ChatGPT "replace" your local AI stack.

I'd make them **complementary**.

---

# 6. Connected Apps — The Secret Weapon

This is probably the area most casual ChatGPT users underutilize.

OpenAI now calls these **Apps**.

They connect ChatGPT to external services so it can retrieve information and, where supported, take actions. Availability depends on plan, region, workspace and the specific app. [OpenAI Help Center](https://help.openai.com/en/articles/11487775-connected-apps-in-chatgpt)

Examples include things like:

- Google Drive
- Google Docs
- Google Sheets
- Slack
- GitHub
- Expedia
- other supported services

The important thing isn't the individual app.

It's the architecture:

```text
                  CHATGPT
                     │
          ┌──────────┼──────────┐
          │          │          │
       GitHub     Google      Expedia
          │        Drive         │
          │          │           │
       Code       Documents    Travel
          │        Sheets        │
          └──────────┼───────────┘
                     │
                     ▼
                 AI AGENT
                     │
              Analyze / Search
              Summarize / Act
```

---

# 7. Google Drive / Sheets Example

This is already considerably more powerful than simply uploading a spreadsheet.

Connect Google Drive and ChatGPT can work with permitted:

- Google Docs
- Google Sheets
- Google Slides
- files
- folders

and supported actions can include updating documents where permissions allow it. [OpenAI Help Center](https://help.openai.com/en/articles/10929079-google-drive-app-and-setup-in-chatgpt)

Imagine:

> "Find my portfolio spreadsheet, calculate my current exposure, identify the five largest positions, and summarize the biggest concentration risks."

The architecture becomes:

```text
Google Drive
     │
     ▼
Google Sheet
     │
     ▼
ChatGPT
     │
     ├── Read
     ├── Calculate
     ├── Analyze
     └── Explain
```

That's dramatically more useful than:

> "Upload this spreadsheet every time."

---

# 8. Expedia / Travel Apps

This is another category where **actions** become more interesting than answers.

Instead of:

> "What hotels are in London?"

you can potentially have ChatGPT work with a connected travel service to:

```text
Trip goal
   ↓
Search flights
   ↓
Compare options
   ↓
Check hotels
   ↓
Compare dates
   ↓
Evaluate itinerary
   ↓
Present choices
   ↓
Take supported actions
```

And because apps have different capabilities, **don't assume every connected app can perform transactions**. OpenAI explicitly distinguishes apps that can search/reference information from apps that support interactive experiences or actions. [OpenAI Help Center](https://help.openai.com/en/articles/11487775-connected-apps-in-chatgpt)

---

# 9. The App Ecosystem Is Becoming an Agent Ecosystem

This is the bigger picture.

Old ChatGPT:

```text
YOU → QUESTION → CHATGPT → ANSWER
```

New ChatGPT:

```text
YOU
 │
 ▼
GOAL
 │
 ▼
CHATGPT
 │
 ├── Search web
 ├── Search GitHub
 ├── Read Drive
 ├── Browse websites
 ├── Open local files
 ├── Run tools
 ├── Analyze data
 ├── Write code
 ├── Execute code
 ├── Create artifacts
 └── Ask permission when necessary
       │
       ▼
    COMPLETED WORK
```

That's why I keep calling ChatGPT increasingly an **AI workbench** rather than a chatbot.

---

# 10. Things I'd Do Before Using ChatGPT Seriously

Here's the list I'd recommend **specifically for you**, rather than a generic "10 ChatGPT tips" list.

| # | Setup | Priority | Why |
|---:|---|:---:|---|
| **1** | Configure **Custom Instructions** | 🔴 | Establish your global behavior |
| **2** | Configure **Memory / personalization** | 🔴 | Let ChatGPT retain useful long-term context |
| **3** | Create **Projects** | 🔴 | Separate long-running domains and context |
| **4** | Add **Project Instructions** | 🔴 | Give each project its own operating rules |
| **5** | Connect **GitHub** | 🔴 | Let ChatGPT understand your actual repositories |
| **6** | Connect **Google Drive/Docs/Sheets** | 🟠 | Turn your documents/data into accessible context |
| **7** | Explore **Apps/integrations** | 🟠 | Connect useful external tools such as travel, productivity and research services |
| **8** | Learn **Chat vs Work vs Codex** | 🔴 | Choose the right execution environment |
| **9** | Set up the **ChatGPT desktop app** | 🔴 | Unlock local files, desktop integration, browser and full Codex workflow |
| **10** | Build a **local AI bridge** | 🟠 | Keep Ollama/LM Studio/MLX alongside ChatGPT |
| **11** | Learn **Deep Research** | 🔴 | Use it for serious research rather than ordinary search |
| **12** | Learn **Work/agentic workflows** | 🔴 | Delegate multi-step tasks |
| **13** | Establish **security/privacy boundaries** | 🔴 | Decide what gets connected and what stays local |
| **14** | Create reusable **prompt/workflow templates** | 🟠 | Stop reinventing common workflows |
| **15** | Learn **Codex + VS Code + CLI** | 🔴 | Turn ChatGPT into an actual development environment |

## Example of custom instructions

```
Use clean Markdown suitable for .md files. When sources are used, add a concise References section at the bottom.

Be concise and information-dense. Avoid filler, repetition, and unnecessary explanations. Expand technically when warranted.

Assume I am an experienced technical practitioner in infrastructure, DevOps, security, Linux, Microsoft systems, and local AI/LLMs. Don't explain basic concepts unless needed.

Verify current/time-sensitive information when practical. Technology, especially AI/ML, changes rapidly; check versions, releases, deprecations, benchmarks, and recent developments. Never fabricate. Clearly label uncertainty, inference, estimates, and speculation, and flag uncertain areas for further analysis.

For AI/ML, prioritize current models, architecture, benchmarks, inference performance, tooling, and practical deployment. Consider official claims but distinguish them from independent evidence.

Give clear recommendations with trade-offs, weaknesses, risks, and alternatives. Tailor recommendations to my hardware, local AI/LLM environment, privacy preferences, and projects.

Use concise feature-by-feature Markdown tables for comparisons.

Challenge incorrect, outdated, or questionable assumptions. Prioritize technical correctness over agreement.

For code/configuration, provide directly usable examples, preserve existing conventions, identify values requiring customization, and favor secure production-quality solutions.

For troubleshooting, diagnose before fixing. Use an OSI-style layered approach: validate fundamentals, isolate the failing layer/component, distinguish symptoms from root cause, then move upward. Use evidence, tests, logs, and verification commands. Prefer the smallest reliable change.

Answer the question asked while proactively identifying material constraints, risks, implications, or better approaches. Avoid tangents.
```


---

# 11. The Most Important Distinction: Global vs Project vs Chat

This is something I'd recommend learning early:

```text
                    CHATGPT
                       │
            ┌──────────┴──────────┐
            │                     │
       GLOBAL CONTEXT         PROJECT CONTEXT
            │                     │
    Custom Instructions      Instructions
    Memory                   Files
    Preferences              Chats
                            Connected sources
                                  │
                                  ▼
                              CHAT
                                  │
                            Current task
```

Think of them as three levels:

### Global

> "This is how I generally want ChatGPT to behave."

### Project

> "This is how I want ChatGPT to behave **for this particular body of work**."

### Chat

> "This is what we're doing **right now**."

That hierarchy is enormously powerful.

---

# 12. Your AI Guide Project Could Become the Perfect Example

For your **Machine Learning / AI Guide**, I'd create:

```text
📁 Machine Learning / AI Guide
│
├── Project Instructions
│
├── 📚 Reference
│   ├── AI papers
│   ├── Model documentation
│   ├── Architecture notes
│   └── Benchmarks
│
├── 💻 Local AI
│   ├── Ollama
│   ├── LM Studio
│   ├── MLX
│   ├── Docker
│   └── OpenWebUI
│
├── 🤖 Agents
│   ├── Codex
│   ├── Claude Code
│   ├── Hermes
│   ├── OpenClaw
│   └── Agent frameworks
│
├── 🖥 Hardware
│   ├── Apple Silicon
│   ├── NVIDIA
│   ├── Jetson
│   └── Workstations
│
└── 📝 Published Guides
```

Then connect your **GitHub repository**.

Now ChatGPT isn't merely answering:

> "What is Ollama?"

It can understand **your Ollama configuration, your repository structure, your documentation and your decisions**.

That's a much more capable system.

---

# 13. And Here's the Really Interesting Part

Your architecture could eventually look like:

```text
                         YOU
                          │
                          ▼
                     CHATGPT
                          │
              ┌───────────┼───────────┐
              │           │           │
             Chat        Work       Codex
              │           │           │
              │           │           ├── GitHub
              │           │           ├── VS Code
              │           │           └── Terminal
              │           │
              │           ├── Web
              │           ├── Files
              │           ├── Apps
              │           └── Browser
              │
              ▼
          RESEARCH / THINK
              │
              ▼
        ┌───────────────┐
        │ LOCAL AI LAB  │
        ├───────────────┤
        │ Ollama        │
        │ LM Studio     │
        │ MLX/oMLX      │
        │ Qwen          │
        │ OpenWebUI     │
        └───────────────┘
```

And **that is where I think ChatGPT becomes particularly valuable for you**.

You don't have to choose:

> **Cloud AI OR local AI**

You can build:

> **Cloud intelligence + local inference + agentic development + your own infrastructure.**

That's a much more powerful architecture.

---

## One important privacy point

Because you're privacy-first, I'd make **App Connections / permissions** a deliberate setup step rather than connecting everything blindly.

Connected apps can potentially expose whatever your authorized account permits, and some apps can take actions. OpenAI says ChatGPT may ask for approval before accessing information or completing actions. [OpenAI Help Center](https://help.openai.com/en/articles/11487775-connected-apps-in-chatgpt)

For your environment I'd use a simple rule:

```text
PUBLIC / LOW RISK
        │
        ▼
ChatGPT / Apps / Cloud

PRIVATE / SENSITIVE
        │
        ▼
Local AI / Ollama / MLX

CODE
        │
        ├── GitHub → ChatGPT analysis
        │
        └── Codex → controlled repository execution
```

That gives you the flexibility of ChatGPT without turning your entire local environment into an open book.

---

## My recommended next step

I think we should turn this into a **"ChatGPT Power User Setup Guide"** specifically for your environment, starting with:

1. **ChatGPT account/settings**
2. **Your 1,500-character Custom Instructions**
3. **Memory**
4. **Projects**
5. **GitHub integration**
6. **Apps/connectors**
7. **Chat vs Work vs Codex**
8. **macOS desktop setup**
9. **Ollama/local LLM integration**
10. **Security/privacy model**
11. **A set of reusable workflows/prompts**
12. **A recommended Project structure for your AI Guide**

That would essentially become your **ChatGPT operating manual**, rather than another generic list of ChatGPT tips. [OpenAI Help Center](https://help.openai.com/en/articles/10169521-projects-in-chatgpt)

### References

- [OpenAI — Projects in ChatGPT](https://help.openai.com/en/articles/10169521-projects-in-chatgpt) — Projects, project instructions, files, sources and project context.
- [OpenAI — ChatGPT Work and Codex](https://help.openai.com/en/articles/20001275-chatgpt-work-and-codex) — Current Chat/Work/Codex architecture and desktop vs cloud behavior.
- [OpenAI — New ChatGPT desktop app](https://help.openai.com/en/articles/20001276-moving-to-the-new-chatgpt-desktop-app) — Consolidation of Chat, Work and Codex into the current desktop app.
- [OpenAI — ChatGPT macOS app](https://help.openai.com/en/articles/9275200-downloading-the-chatgpt-macos-app) — Current macOS application and system requirements.
- [OpenAI — Connected apps](https://help.openai.com/en/articles/11487775-connected-apps-in-chatgpt) — Apps, permissions, information access and supported actions.
- [OpenAI — GitHub integration](https://help.openai.com/en/articles/11145903-connecting-github-to-chatgpt) — Live repository access for code analysis and research.
- [OpenAI — Google Drive integration](https://help.openai.com/en/articles/10929079-google-drive-app-and-setup-in-chatgpt) — Google Docs, Sheets, Slides and Drive access.
- [OpenAI — Desktop built-in browser](https://help.openai.com/en/articles/20001277-using-the-built-in-browser-in-the-chatgpt-desktop-app) — Browser, tabs, sign-in, downloads and computer-assisted web workflows.