# Perplexity - Portable Computer (NVIDIA partnership)

Yes — **your RTX 3090 Ti is essentially the entry point Perplexity designed Portable Computer for**, because it has **24 GB of VRAM**. As of September 2026, Portable Computer is available on Windows PCs with NVIDIA GeForce RTX/RTX PRO GPUs with **at least 24 GB VRAM**, so your 3090 Ti qualifies on the hardware requirement. ([Perplexity AI][1])

The interesting part for your setup is that this is **not simply “Perplexity with a local model.”** It is much closer to a **local agent operating system** with Perplexity's web/cloud intelligence available as an escalation path.

## What Portable Computer actually is

Perplexity describes Portable Computer as a local version of Perplexity Computer where the following components run on your machine:

* Local LLM
* Agent harness
* Orchestrator
* Planner
* Tool router
* Scheduler
* Local search/index
* File handling
* Tool execution

The local model currently includes **Qwen 3.8 27B** and **PPLX 27B**, with NVIDIA Nemotron 3.5 Lightning 30B listed as forthcoming in Perplexity's launch material. ([Perplexity AI][2])

The key architecture is:

```text
                    ┌─────────────────────────┐
                    │   Perplexity Portable   │
                    │       Computer          │
                    └────────────┬────────────┘
                                 │
                     LOCAL-FIRST AGENT
                                 │
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
     Local Model             Local Files            Local Apps
     Qwen/PPLX                Documents              MCP
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
                         Local execution
                                 │
                         ┌───────┴───────┐
                         │               │
                     Stay Local      Escalate
                         │               │
                         │        Perplexity Search
                         │        Frontier Models
                         │        Web / Cloud
                         │
                    User permission
```

That **local-first → cloud escalation** model is the important innovation.

Perplexity explicitly says that when a task requires current web information, browser use, connected applications, or stronger frontier reasoning, the local orchestrator can escalate that portion to the cloud. It asks permission before sending information from the device. ([Perplexity AI][2])

---

# Your 3090 Ti is a very interesting match

Your machine:

| Component       | Your configuration |
| --------------- | -----------------: |
| GPU             |    **RTX 3090 Ti** |
| VRAM            |   **24 GB GDDR6X** |
| CPU             |    Ryzen 9 9900X3D |
| System RAM      |          **96 GB** |
| OS              |     Windows 11 Pro |
| Docker          |                Yes |
| Existing Ollama |                Yes |
| OpenWebUI       |                Yes |
| Qdrant          |                Yes |
| Flowise         |                Yes |
| OpenCode        |                Yes |

That's actually a **very good Portable Computer host**.

And there's an important distinction from the machine in your ML project.

Your existing architecture is already explicitly designed around local inference:

> OpenWebUI → Ollama → local LLM → Qdrant → Flowise

and your documentation describes the stack as zero-cloud-by-default.  fileciteturn0file11L208-L220

Portable Computer essentially gives you **another agent layer above this concept**.

---

# What I'd use it for on your machine

## 1. Local codebase agent

This is probably one of the most compelling applications for you.

Point Portable at:

```text
C:\Users\Markus\Projects\
```

or selected repositories.

Then ask:

> Examine this repository. Identify architectural problems, security issues, dead code and opportunities for automation. Do not modify anything yet.

Then:

> Create a remediation plan and identify which files would need to change.

Then:

> Implement the highest-priority changes and run the tests.

That's significantly different from simply asking Ollama a coding question.

The agent can actually work with files and tools rather than merely generating text.

Perplexity specifically describes workflows involving local codebases, files, GitHub and local applications. ([Perplexity AI][1])

And this complements your existing **OpenCode → Ollama** setup, which your own stack already defines as a local AI coding workspace. 

---

# 2. Your ML Guide repository

This is where I'd immediately experiment.

You already have a repository containing:

```text
Windows11/
Ubuntu22/
Docker/
Jetson/
LM Studio/
Ollama/
VSCode/
Sample Prompts/
```

Your repository is explicitly structured around local/on-prem AI workflows. 

Portable could operate as a **repository maintenance agent**.

For example:

> Scan the entire repository for inconsistent instructions, obsolete commands and broken links. Do not modify anything. Produce a report.

Then:

> Update the documentation to make the Ollama and LM Studio sections consistent. Preserve my privacy-first philosophy.

Then:

> Check all Docker Compose examples for deprecated syntax and configuration inconsistencies.

That's exactly the type of long-running agent workload where Portable makes sense.

---

# 3. Local document intelligence

This is probably the other killer use case.

Imagine:

```text
AI/
├── manuals/
├── network/
├── homelab/
├── trading/
├── tax/
├── projects/
└── research/
```

Portable can work against permitted local files and synthesize information.

For example:

> Read all of the documentation in this directory and create a technical architecture map.

Or:

> Compare these five vendor proposals and create a requirements matrix.

Or:

> Find every reference to NVIDIA GPU memory throughout these documents.

This is fundamentally different from uploading everything to a cloud AI.

The launch material specifically describes analyzing local files and keeping that work on-device. ([Perplexity AI][2])

---

# 4. Local + web research

**This is where Portable gets really interesting compared with Ollama.**

Your normal local LLM:

```text
Prompt
  ↓
Ollama
  ↓
Local model
  ↓
Answer
```

Portable:

```text
Prompt
   ↓
Local planner
   ↓
Can I solve this locally?
   │
   ├── YES → Local model/tools
   │
   └── NO
        ↓
Need current information?
        ↓
Perplexity Search
        ↓
Return sourced information
        ↓
Continue locally
```

For example:

> Analyze this local investment research folder and compare the companies discussed against current market information.

The confidential research can remain local while the **current market-data portion** is fetched externally.

Perplexity gives the example of keeping confidential deal information local while escalating only the current market-comparison portion to cloud research. ([Perplexity AI][2])

That's a very powerful architecture.

---

# 5. Scheduled local AI jobs

This is another major difference.

Portable Computer for Windows now supports **scheduled tasks**. ([Perplexity AI][1])

For example:

### Every morning

```text
07:00

Read:
    ~/AI/research/

Summarize:
    overnight changes

Save:
    daily-briefing.md
```

Or:

### GitHub maintenance

```text
Every morning:

Review:
    open PRs
    local repository
    recent bug reports

Produce:
    priority list
    affected components
    recommended actions
```

Perplexity explicitly gives examples of scheduled local workflows such as invoice reconciliation and GitHub issue/PR analysis. ([Perplexity AI][1])

---

# 6. MCP makes this particularly interesting

Portable supports **local MCP servers** on Windows.

That means you can potentially build:

```text
Portable
   │
   ├── Filesystem MCP
   ├── GitHub MCP
   ├── Docker MCP
   ├── Home Assistant MCP
   ├── Network tools MCP
   ├── VS Code MCP
   └── Your own MCP servers
```

Now you're approaching:

**local AI operations engineer.**

Given your engineering/homelab environment, this is much more interesting than using Portable merely as another chatbot.

---

# How it compares with your existing stack

This is the key part.

| Capability       | Ollama           | OpenWebUI     | Flowise      | OpenCode   | Portable Computer     |
| ---------------- | ---------------- | ------------- | ------------ | ---------- | --------------------- |
| Local LLM        | ✅                | via Ollama    | via Ollama   | via Ollama | ✅                     |
| Chat             | ❌/CLI            | ✅             | ✅            | ❌          | ✅                     |
| Local files      | Limited          | ✅             | ✅            | ✅          | **✅**                 |
| Coding           | Model-dependent  | Limited       | Agent        | **✅**      | **✅**                 |
| Agents           | Limited          | Some          | **✅**        | **✅**      | **✅**                 |
| RAG              | API              | ✅             | **✅**        | Limited    | **✅**                 |
| Qdrant           | External         | Can integrate | **✅**        | Possible   | Internal architecture |
| Scheduling       | External         | Limited       | Possible     | Possible   | **✅**                 |
| MCP              | Via integrations | Varies        | Integrations | **✅**      | **✅**                 |
| Web research     | External         | Tools         | Tools        | Tools      | **Perplexity native** |
| Frontier models  | ❌                | ❌             | Optional     | Optional   | **✅ escalation**      |
| Local-first      | **✅**            | **✅**         | **✅**        | **✅**      | **✅**                 |
| Cloud escalation | Optional         | Optional      | Optional     | Optional   | **Built-in**          |

Your existing stack is actually more **modular and controllable**.

Portable is more **integrated**.

---

# I would NOT replace Ollama

This is important.

I'd run them **side-by-side**.

Your architecture becomes:

```text
                         YOUR RTX 3090 Ti
                               │
                  ┌────────────┴────────────┐
                  │                         │
             Ollama                    Portable
                  │                         │
        ┌─────────┼─────────┐               │
        │         │         │               │
    OpenWebUI  OpenCode  Flowise       Local Agent
        │         │         │               │
        └─────────┼─────────┘               │
                  │                         │
                Qdrant                  Local files
                                            │
                                      MCP / tools
                                            │
                                            ▼
                                  Perplexity Search
                                  / Frontier Models
```

That gives you **two different AI layers**.

### Ollama

Your:

> **LLM infrastructure**

### Portable Computer

Your:

> **AI employee / agent**

That's the conceptual distinction I'd make.

---

# The 3090 Ti limitation

There's one thing I'd watch carefully.

Your GPU has exactly **24 GB VRAM**, which satisfies Portable's published minimum. ([Perplexity AI][1])

But **minimum supported hardware ≠ huge performance headroom**.

The local model is in the ~27B class, and Portable's current local model choices are considerably larger than the 7B–8B models your old 3070 Ti documentation recommends. Your existing guide recommends 7B–8B as optimal for the 3070 Ti and notes 13B as tight. 

Your 3090 Ti is dramatically better positioned than that 3070 Ti, but I'd expect the system to make meaningful use of your **96 GB system RAM** depending on model/runtime behavior.

That's actually a configuration I'd be comfortable experimenting with:

```text
RTX 3090 Ti
24 GB VRAM
      +
96 GB RAM
      ↓
large quantized local models
```

rather than trying to force everything entirely into VRAM.

---

# Recommended installation architecture

Since you're on Windows 11 Pro, I'd start with the **native Perplexity Windows application**, not Docker.

Perplexity's current Windows instructions are essentially:

1. Install Perplexity for Windows.
2. Sign in with a **Pro or Max** account.
3. Select Portable/local model from the model dropdown.
4. Download the local model.
5. Grant access only to directories/apps you actually want it to use. ([Perplexity AI][1])

I would **not initially give it access to your entire C:\ drive**.

Start with:

```text
D:\AI\Portable\
D:\AI\Projects\
D:\AI\Research\
```

Then expand permissions as you understand its behavior.

---

# Security architecture I'd use

Because you are security-minded, I'd treat Portable as an **agent with execution privileges**, not as a chatbot.

Something like:

```text
Windows 11
│
├── Portable Computer
│    │
│    ├── Local Model
│    ├── Agent
│    ├── Sandbox
│    └── MCP
│
├── Ollama
│    └── Local models
│
├── Docker
│    ├── OpenWebUI
│    ├── Qdrant
│    ├── Flowise
│    └── OpenCode
│
└── Controlled data directories
     ├── Projects
     ├── Research
     └── Documents
```

Your existing Docker security philosophy is already very appropriate here: read-only filesystems where possible, dropped capabilities, `no-new-privileges`, network isolation and explicit filesystem access.  fileciteturn0file9L66-L103

---

# One thing I particularly like about Portable

The **permission boundary around cloud escalation**.

Imagine:

> "Analyze this directory of private network diagrams and firewall configurations."

Portable works locally.

Then:

> "Now check whether these vendors released security advisories this week."

That second operation needs the Internet.

Instead of silently uploading everything, the architecture can escalate the relevant task to Perplexity Search/cloud and ask for permission when data needs to leave the device. ([Perplexity AI][2])

That is **much closer to the local-first architecture you've been pursuing** than a conventional cloud AI agent.

---

# My recommended first experiment

Don't start with something trivial.

Give Portable this:

```text
I want you to act as a local infrastructure engineer.

1. Inspect this project directory.
2. Inventory all files and directories.
3. Identify the applications, services and infrastructure represented.
4. Build an architecture map.
5. Identify duplicated or conflicting configuration.
6. Identify security weaknesses.
7. Do not modify anything.
8. Produce a remediation plan.
9. Ask before accessing anything outside this directory.
10. Do not send local files or their contents to cloud services unless I explicitly approve it.
```

Then give it your ML repository.

Your repository already has exactly the kind of mixed material that makes this useful: Ollama, LM Studio, Docker, Jetson, OpenWebUI, Flowise, OpenCode and sample prompts. 

**That would be my first real-world test.**

---

## Bottom line

I think Portable Computer is **much more interesting for you than “Perplexity running a local LLM.”**

The interesting product is:

> **Local model + local agent + local tools + local files + MCP + scheduler + Perplexity Search + optional frontier-model escalation.**

And your **3090 Ti/96 GB machine meets the current 24 GB NVIDIA VRAM requirement**, so you don't need to buy another GPU just to experiment with it. ([Perplexity AI][1])

More importantly, **I wouldn't replace your Ollama/OpenWebUI/Flowise/OpenCode stack.** I'd make Portable another agent sitting alongside it.

That gives you a potentially very powerful architecture:

**Ollama = your local model platform.**
**OpenWebUI = your local ChatGPT.**
**OpenCode = your local coding agent.**
**Flowise = your local workflow/agent builder.**
**Qdrant = your local memory/RAG layer.**
**Portable Computer = your local-first general-purpose agent with Perplexity's web/cloud escalation.**

That last piece is the one your current stack doesn't really have.

[1]: https://www.perplexity.ai/fr/hub/blog/portable-computer-for-windows-is-here "Portable Computer for Windows is here"
[2]: https://www.perplexity.ai/en-GB/hub/blog/introducing-portable-computer-for-local-first-ai "Introducing Portable Computer"
