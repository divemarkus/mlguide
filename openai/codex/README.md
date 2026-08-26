# OpenAI's Codex

Codex is OpenAI’s **software-engineering agent**, and the key difference from ordinary chat-based coding help is that Codex can work against a real codebase: inspect files, make changes, run commands/tests, and iterate on failures.

For your workflow, there are three especially relevant ways to use it:

1. **Inside VS Code** — interactive, local development.
2. **The standalone Codex application/CLI experience** — focused agentic coding directly from a project directory.
3. **Cloud Codex agents** — delegate longer tasks to OpenAI-managed compute.

The practical question is therefore not just *“Which plan gives me Codex?”* but **how much agent capacity, concurrency, and access to the strongest coding models each plan gives you**. I’ll break those down specifically and distinguish included usage from API billing, because those are separate concepts.


# Codex: How It Works, VS Code, Standalone App, and Plan Differences

## The short version

**Codex is OpenAI's agentic coding environment.** You can use the same Codex identity across:

```text
ChatGPT account
      │
 ┌────┼─────────────┬──────────────┐
 ▼    ▼             ▼              ▼
VS Code  Codex CLI  Codex desktop  Codex Cloud
         / Terminal       app        agents
```

OpenAI's current design is explicitly **“the same agent everywhere you code.”** ([OpenAI][1])

For your style of work, I see two primary modes:

* **VS Code + Codex** → best for actively working on code.
* **Standalone Codex desktop app** → best for supervising multiple agents and delegating larger tasks.

---

# 1. What Codex Actually Does

Codex is not just autocomplete.

A typical workflow can look like this:

```text
You:
"Add authentication to this Flask application."

        ↓

Codex:
✓ Inspects repository
✓ Understands existing architecture
✓ Identifies relevant files
✓ Proposes/implements changes
✓ Writes code
✓ Runs tests
✓ Sees failures
✓ Fixes failures
✓ Reports changes
```

OpenAI describes it as an agent that helps you **write, review, and ship code**. ([OpenAI Help Center][2])

This puts Codex in the same broad category as tools such as Claude Code, Cursor agents, GitHub Copilot coding agents, and local coding-agent stacks—but OpenAI's advantage is its integration with frontier OpenAI models and cloud-based delegated work.

---

# 2. Using Codex With VS Code

This is probably the best starting point for you.

OpenAI provides a **Codex IDE extension** that works with VS Code and compatible VS Code forks. ([OpenAI Help Center][3])

## The workflow

```text
VS Code
   │
   ├── Your open files
   ├── Selected code
   ├── Workspace
   │
   ▼
Codex IDE Extension
   │
   ▼
OpenAI Model / Codex Agent
   │
   ├── Read files
   ├── Modify code
   ├── Run commands
   ├── Test
   └── Review results
```

### Why the IDE integration is useful

The biggest advantage is **context**.

If you have this open:

```python
app.py
```

And highlight:

```python
def authenticate_user():
```

You can tell Codex:

> Improve this authentication flow, add proper error handling, and update any affected tests.

Because Codex has IDE and workspace context, you often do not need to manually paste large chunks of code into a chat window. OpenAI specifically notes that the extension can use context such as open files and selected code. ([OpenAI][4])

## A practical setup

My recommended workflow:

```text
VS Code
│
├── Codex Extension
│
├── Integrated Terminal
│      │
│      └── Codex CLI
│
└── Git
       │
       ├── Review changes
       ├── Commit
       └── Push
```

That gives you two ways to interact with the same coding agent.

### In the VS Code panel

Use it for:

* "Explain this code."
* "Fix this error."
* "Refactor this module."
* "Add this feature."
* "Review the currently selected code."

### In the terminal

Use Codex for larger instructions such as:

> Analyze this entire repository. Identify architectural problems, security issues, duplicated code, and missing tests. Create a prioritized improvement plan, then implement the top three improvements.

---

# 3. Codex CLI Inside VS Code

You do not necessarily have to rely entirely on the extension.

You can run the Codex CLI from VS Code's integrated terminal.

Conceptually:

```text
VS Code
  │
  └── Terminal
        │
        └── Codex CLI
              │
              ├── Reads repository
              ├── Makes edits
              ├── Runs tests
              └── Reports results
```

The CLI is particularly useful when you want a more autonomous workflow.

For example:

```text
codex

> Examine this repository.

> First understand the architecture.

> Then identify the most serious technical debt.

> Do not modify anything until you provide a plan.
```

Then:

```text
> Implement items 1 and 2.

> Run the complete test suite.

> Fix any failures introduced by your changes.
```

That style should feel familiar given your interest in Claude Code and local coding models.

---

# 4. Codex Desktop App — The Standalone Application

This is where Codex becomes more interesting.

The **Codex app is intended as a command center for agents**, rather than merely another code editor. ([OpenAI][5])

Think of VS Code as:

> **You and an agent working directly on code.**

Think of the Codex desktop app as:

> **You supervising multiple agents working on multiple tasks.**

Example:

```text
              YOU
               │
       ┌───────┼────────┐
       │       │        │
       ▼       ▼        ▼

    AGENT 1  AGENT 2  AGENT 3

    Backend  Frontend  Testing

       │       │        │
       └───────┼────────┘
               ▼

           REVIEW
```

OpenAI specifically positions the app around coordinating agents across larger software-development lifecycles. ([OpenAI][5])

## Good use cases for the Codex app

### Project-wide work

> Analyze this entire application and create a modernization plan.

### Parallel work

```text
Agent 1
→ Build authentication

Agent 2
→ Improve database layer

Agent 3
→ Write tests

Agent 4
→ Review security
```

### Long-running tasks

> Upgrade this project from Python 3.10 to Python 3.13 and update all dependencies, Docker configuration, CI workflows, and tests.

### Code review

> Review this branch against main and identify bugs, regressions, security issues, and backward compatibility problems.

Codex can also provide task evidence such as citations, terminal logs, and test results, though you should still review changes before production deployment. ([OpenAI][4])

---

# 5. Local vs Cloud Codex

This distinction is important.

## Codex Local

```text
Your PC
   │
   ▼
VS Code / CLI / Desktop
   │
   ▼
Local repository
```

The model still runs on OpenAI infrastructure, but the coding workflow is interacting with your local files and environment.

OpenAI refers to the CLI, IDE extension, and desktop workflows collectively as **Codex Local** in managed workspace controls. ([OpenAI Help Center][3])

## Codex Cloud

```text
You
 │
 ▼
"Fix this issue"
 │
 ▼
OpenAI Cloud Environment
 │
 ├── Clone/work on repository
 ├── Run agent
 ├── Execute tasks
 └── Return result
```

This is where Codex becomes more autonomous.

You delegate the task and let the agent work independently.

The IDE extension can also let you create, monitor, and review cloud tasks without leaving the editor. ([OpenAI][4])

---

# 6. How the Plans Work for Codex

This is the important part.

## The major distinction

Codex usage is **not identical to ordinary ChatGPT messaging limits**.

Your available Codex capacity depends on:

* ChatGPT plan
* Model selected
* Task complexity
* Context size
* Reasoning level
* Local vs cloud task
* Tools used
* Speed mode
* Concurrent or delegated agents

OpenAI now also treats several agentic capabilities as sharing a broader allowance or credit pool on eligible plans. Codex can share that capacity with features such as ChatGPT Work and other supported agentic features. ([OpenAI Help Center][6])

---

## Free

| Feature           | Codex        |
| ----------------- | ------------ |
| Access            | Yes          |
| Usage             | Limited      |
| Best for          | Trying Codex |
| Heavy development | No           |

OpenAI now includes Codex across ChatGPT plans, including Free and Go, although usage limits vary by plan. ([OpenAI Help Center][2])

I would view Free as:

> **Test the workflow, learn Codex, and occasionally use it.**

Not as a serious full-time coding-agent plan.

---

## Go

| Feature  | Codex                |
| -------- | -------------------- |
| Access   | Yes                  |
| Usage    | Limited              |
| Best for | Light/occasional use |

Go now includes Codex access as well, but with lower capacity than the higher tiers. ([OpenAI Help Center][2])

---

## Plus — roughly $20/month

This is where Codex starts becoming genuinely useful for an individual developer.

```text
PLUS

Good for:
✓ Regular coding
✓ Personal projects
✓ VS Code integration
✓ CLI use
✓ Moderate agent work
✓ Occasional cloud tasks
```

Historically, OpenAI characterized Plus-level capacity as supporting focused coding sessions rather than an unrestricted full-time agent workload, while higher tiers provide substantially more capacity. ([OpenAI][4])

A major recent improvement is that eligible Plus users can purchase **additional credits** after reaching included limits. ([OpenAI Help Center][6])

That means Plus is no longer simply:

```text
Hit limit → wait
```

It can become:

```text
Included usage
      ↓
Hit limit
      ↓
Add credits
      ↓
Continue
```

---

# 7. Pro — roughly $200/month

For a serious individual developer, **Pro is the Codex-heavy tier**.

```text
PRO

Designed for:

✓ Daily coding
✓ Multiple projects
✓ Larger repositories
✓ Longer agent sessions
✓ More intensive reasoning
✓ Greater Codex capacity
✓ More sustained agent use
```

OpenAI previously described Pro-level Codex capacity as supporting something closer to a **full workweek across multiple projects**, versus Plus covering more focused coding sessions. ([OpenAI][4])

Plus and Pro users can also access flexible credits for supported usage once included limits are exhausted. ([OpenAI Help Center][6])

There is also a Pro-only research-preview model tier noted in OpenAI's current rate documentation. ([OpenAI Help Center][7])

### My interpretation

If you are doing:

```text
Daily:
- VS Code
- Codex
- Multiple repos
- Python
- Docker
- Infrastructure
- Automation
- GitHub projects
```

Then Pro is the plan where you can realistically treat Codex as a primary engineering tool.

But $200/month is difficult to justify unless you are actually consuming that capacity.

---

# 8. Business

Business currently has some important 2026 changes.

Standard Business seats currently include ChatGPT and baseline Codex access:

| Billing |          Price |
| ------- | -------------: |
| Annual  | $20/user/month |
| Monthly | $25/user/month |

Standard seats include Codex usage, and workspace credits can extend eligible usage after included limits are reached. ([OpenAI Help Center][8])

There is an important exception involving older **usage-based Codex-only seats**: new Business workspaces generally cannot add those legacy-style Codex seats unless the workspace had already used that seat type before June 24, 2026. ([OpenAI Help Center][9])

So for a new Business workspace, think primarily:

```text
Business seat
    │
    ├── ChatGPT
    ├── Codex included usage
    │
    └── Optional workspace credits
             │
             ▼
        Additional usage
```

---

# 9. Enterprise and Edu

Enterprise is designed differently.

The organization can manage:

* Shared credit pools
* Spending controls
* RBAC
* Model defaults
* Reasoning levels
* Fast Mode
* Local Codex permissions
* Cloud Codex permissions

OpenAI's flexible-pricing model allows Enterprise and Edu environments to use shared credit pools and administrative spend controls rather than relying purely on simple per-user caps. ([OpenAI Help Center][9])

This matters when an organization has:

```text
100 engineers
      │
      ▼
Some use Codex occasionally
Some heavily
Some barely use it
```

Instead of buying every engineer the same maximum allowance, the organization can manage shared usage and spending.

---

# 10. What Happens When You Hit Your Codex Limit?

This is important because it is not simply a fixed "messages per day" system.

You may see:

* A usage warning
* A reset time
* Available credits
* Upgrade options
* An option to add credits

In the CLI, OpenAI says you can use:

```text
/status
```

to check the current allowance/status. ([OpenAI Help Center][3])

If a Codex task is already actively running when you hit a limit, OpenAI says the active turn can generally continue, subject to applicable fair-use restrictions; subsequent work depends on available allowance, credits, reset timing, or plan options. ([OpenAI Help Center][3])

---

# 11. API Billing Is Different

This is critical.

There are two ways to think about Codex:

### A. ChatGPT subscription

```text
ChatGPT Plus / Pro
       │
       ▼
Included Codex capacity
       │
       ▼
Optional credits where supported
```

### B. API usage

```text
Your application
      │
      ▼
OpenAI API
      │
      ▼
Pay based on API usage
```

Do **not** assume that a ChatGPT Pro subscription gives you unlimited OpenAI API usage.

These are separate billing mechanisms.

---

# 12. My Recommended Setup for You

Given your engineering background and the fact that you already experiment with:

* VS Code
* Claude Code
* Qwen coding models
* Ollama
* Docker
* local AI infrastructure
* larger coding projects

I would structure it like this:

```text
                    MARKUS'S CODING STACK

                         VS CODE
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼

          CODEX         LOCAL LLM      TERMINAL

         Frontier       Qwen Coder     Codex CLI
         reasoning      / Ollama       / Claude Code
             │              │              │
             └──────────────┼──────────────┘
                            ▼

                       GIT / GITHUB
```

## My recommendation

### Start with Codex in VS Code

Use it for:

```text
Small task
↓
"Fix this function"

Medium task
↓
"Implement this feature across the repository"

Large task
↓
"Analyze the architecture first.
Do not modify code until you give me a plan."
```

### Keep your local Qwen coding model

Your local setup remains extremely valuable for:

* Private code
* Offline experimentation
* Unlimited local inference
* Prompt testing
* Simple coding tasks
* Long exploratory conversations

Your existing Qwen3-Coder-Next experiment demonstrated that a capable local coding model can produce substantial applications while consuming large amounts of local GPU and system memory. 

### Use Codex for high-value work

I would reserve Codex for:

```text
Complex repository understanding
+
Hard debugging
+
Multi-file refactoring
+
Architecture work
+
Testing
+
Code review
+
Long autonomous tasks
```

That creates the ideal hybrid model:

```text
SIMPLE / PRIVATE / EXPERIMENTAL
          │
          ▼
      LOCAL QWEN
          │
          │
COMPLEX / HIGH-VALUE / AGENTIC
          │
          ▼
         CODEX
```

## My plan recommendation

For you personally:

| Plan       | My assessment                                      |
| ---------- | -------------------------------------------------- |
| Free/Go    | Good to test Codex                                 |
| Plus       | **Best starting point**                            |
| Pro        | Best if Codex becomes a daily primary coding agent |
| Business   | Only if you need a shared/team workspace           |
| Enterprise | Not relevant unless deploying organizationally     |

**I would start with the plan you already have access to, install Codex in VS Code, and deliberately stress-test it against one of your real repositories.** Then you can determine whether Plus-level usage is sufficient or whether you are genuinely consuming enough Codex capacity to justify Pro.

The best first test would be a real project such as one of your **Docker/AI infrastructure stacks**: have Codex analyze the repo, generate an architecture map, identify configuration and security issues, then implement one improvement at a time. Your current local AI stack provides a useful comparison point because it already combines Ollama, Open WebUI, Qdrant, Flowise, LiteLLM, and GPU-aware Docker deployment. 

One final point: **Codex usage limits are dynamic and depend heavily on model/task characteristics**, so I would not make a purchase decision based on a claimed fixed number of prompts. OpenAI directs users to the current pricing/usage dashboard for the live allowance applicable to their account. ([OpenAI Help Center][2])

You could also set up a recurring check for Codex plan, model, and usage-limit changes as OpenAI updates them frequently.

[1]: https://openai.com/codex/?utm_source=chatgpt.com "Codex in ChatGPT | AI Coding Agents for Software Engineering | OpenAI"
[2]: https://help.openai.com/en/articles/11369540?utm_source=chatgpt.com "Using Codex with your ChatGPT plan | OpenAI Help Center"
[3]: https://help-lb.openai.com/en/articles/11369540-using-codex-with-your-chatgpt-plan?utm_source=chatgpt.com "Using Codex with your ChatGPT plan | OpenAI Help Center"
[4]: https://openai.com/index/introducing-upgrades-to-codex/?utm_source=chatgpt.com "Introducing upgrades to Codex | OpenAI"
[5]: https://openai.com/index/introducing-the-codex-app/?utm_source=chatgpt.com "Introducing the Codex app | OpenAI"
[6]: https://help.openai.com/en/articles/12642688-using-credits-for-flexible-usage-in-chatgpt-free-go-plus-pro-sora?utm_source=chatgpt.com "Using Credits for Flexible Usage in ChatGPT (Free/Go/Plus/Pro) | OpenAI Help Center"
[7]: https://help.openai.com/en/articles/11481834?utm_source=chatgpt.com "ChatGPT Rate Card (Business, Enterprise/Edu credit-based pricing) | OpenAI Help Center"
[8]: https://help.openai.com/en/articles/8792536?utm_source=chatgpt.com "Managing billing and seats in ChatGPT Business | OpenAI Help Center"
[9]: https://help.openai.com/en/articles/11487671-flexible-pricing-for-the-enterprise-edu-and-team-plans?utm_source=chatgpt.com "Flexible pricing for the Enterprise, Edu, and Business plans | OpenAI Help Center"
