
# Brave Leo - Bring Your Own Model

Absolutely. **BYOM is the part of Brave Leo that I think is genuinely compelling for your setup.**

The key idea is:

> **Brave Leo becomes the browser/context interface, while your own LLM remains the inference engine.**

Brave explicitly supports connecting Leo to **local models, models on your own server, or third-party APIs**. The request goes directly from Brave to the endpoint you configure rather than passing through Brave's infrastructure. ([Brave][1])

## The architecture

For your environment, think of it like this:

```text
                    ┌──────────────────────┐
                    │     BRAVE BROWSER    │
                    │                      │
 Web page ─────────►│       Brave Leo      │
 PDF ──────────────►│          │           │
 YouTube ──────────►│          │           │
 Tabs ─────────────►│          │           │
                    └──────────┼───────────┘
                               │
                         OpenAI-compatible
                         chat endpoint
                               │
                               ▼
                    ┌──────────────────────┐
                    │       OLLAMA         │
                    │   localhost:11434     │
                    └──────────┬───────────┘
                               │
                  ┌────────────┼────────────┐
                  ▼            ▼            ▼
             Qwen 3       Gemma       Llama/etc.
```

This is **very different from using Leo's hosted models**.

Your browser is effectively saying:

> "Leo, understand this webpage and construct the request. Send the request to *my* model."

And Ollama says:

> "I'll perform the inference locally."

Brave's documentation specifically describes Ollama as an example and says BYOM works with local serving frameworks that expose an endpoint conforming to the **OpenAI chat protocol**. ([Brave][2])

---

# The really cool part: Leo provides the browser context

This is what makes BYOM much more interesting than simply pointing OpenWebUI at Ollama.

Suppose you're reading:

**NVIDIA's documentation on TensorRT-LLM**

You click Leo and say:

> "Explain this architecture and identify which parts would matter for my RTX 3090 Ti."

Leo has browser context.

Your local Qwen model performs the actual reasoning.

Conceptually:

```text
Web page
   │
   ▼
Brave Leo
   │
   │ page/context + your prompt
   ▼
localhost:11434
   │
   ▼
Qwen
   │
   ▼
response
   │
   ▼
Leo UI
```

So **Leo becomes the presentation/context layer** while **Ollama is your inference layer**.

That's a very nice separation of concerns.

---

# And it isn't limited to webpages

Brave currently describes Leo as being able to work with:

* webpages
* PDFs
* Google Docs
* Google Sheets
* YouTube
* multiple tabs
* images
* text
* coding tasks

and Brave has continued expanding its browser-context capabilities. ([Brave][1])

That creates a pretty interesting local-AI workflow:

### Example

You're looking at a 100-page NVIDIA PDF.

You ask:

> "Summarize the sections dealing with TensorRT optimization and tell me which techniques are applicable to Qwen models."

Instead of:

**Download PDF → upload to OpenWebUI → select model → ask question**

you can potentially do:

**Open PDF → Leo → ask**

while the underlying model is **your local Qwen**.

---

# Your Ollama setup is almost tailor-made for this

You've already built the important part.

Your stack is:

```text
OpenWebUI
     │
     ▼
  Ollama
     │
     ▼
 Local Models
```

and you've also got:

```text
Qdrant
Flowise
OpenCode
LiteLLM
Netdata
```

Your existing documentation explicitly describes Ollama as your local inference engine and OpenWebUI as the interface sitting above it. 

BYOM gives you another interface:

```text
                    ┌── OpenWebUI
                    │
                    ├── OpenCode
                    │
Ollama ◄────────────┼── Flowise
                    │
                    └── Brave Leo
```

That's actually a **very good architecture**.

Different clients, same inference infrastructure.

---

# One important technical detail

Brave's documented Ollama configuration uses:

```text
http://localhost:11434/v1/chat/completions
```

and you specify the Ollama model name separately. ([Brave][2])

For example, conceptually:

```text
Label:
Qwen Local

Model request name:
qwen3:...

Server endpoint:
http://localhost:11434/v1/chat/completions
```

The exact model name needs to match what your Ollama server exposes.

---

# But there's an important distinction for your Docker setup

This is where things get interesting.

If **Brave is running on Windows** and Ollama is running inside your Linux/Docker environment, then:

```text
Brave
   │
   │ localhost
   ▼
Windows
```

does **not necessarily equal**

```text
Docker container
```

Your existing Compose configuration exposes Ollama:

```yaml
ports:
  - "11434:11434"
```

so the host can potentially reach it. 

But we should verify your actual topology before configuring Leo.

For example:

### Scenario A — Ollama native Windows

```text
Brave
 ↓
127.0.0.1:11434
 ↓
Ollama
 ↓
GPU
```

Very easy.

### Scenario B — Ollama Docker on Linux

```text
Brave
 ↓
LAN IP:11434
 ↓
Ubuntu
 ↓
Docker
 ↓
Ollama
 ↓
GPU
```

Also easy, but firewall/network binding becomes important.

### Scenario C — Brave on Windows → WSL2 → Docker

```text
Brave
 ↓
Windows
 ↓
WSL2 networking
 ↓
Docker
 ↓
Ollama
 ↓
GPU
```

This is where we need to pay attention to routing/binding.

---

# Security gets VERY interesting

Because you're a network/security guy, here's the part I'd emphasize.

Brave says BYOM sends requests **directly from the browser to your configured endpoint**, with Brave not acting as an intermediary or having visibility into that traffic. ([Brave][2])

That's excellent.

But it means **you are responsible for securing the endpoint**.

For example, I would **not** do this:

```text
0.0.0.0:11434
        │
        ▼
Internet
```

Absolutely not.

I'd prefer:

```text
Brave
   │
   ▼
LAN
   │
   ▼
Firewall
   │
   ▼
Ollama :11434
```

or even:

```text
Brave
   │
   ▼
localhost
   │
   ▼
Ollama
```

if everything is on the same machine.

---

# BYOM isn't just Ollama

This is another major advantage.

Brave says BYOM can use **any serving framework that exposes an endpoint compatible with the OpenAI chat protocol**. ([Brave][2])

So you could potentially do:

```text
                 Brave Leo
                     │
                     ▼
              OpenAI-compatible
                  endpoint
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
      Ollama       LM Studio     vLLM
        │            │            │
      Qwen         Qwen          Qwen
```

Or:

```text
Brave Leo
    │
    ▼
LiteLLM
    │
    ├── Ollama
    ├── LM Studio
    ├── vLLM
    ├── OpenAI
    ├── Anthropic
    └── other providers
```

**This is where your existing LiteLLM idea becomes particularly interesting.**

Your existing stack already identifies LiteLLM as the optional routing layer for Ollama/vLLM/cloud models. 

You could potentially make:

```text
                     BRAVE LEO
                         │
                         ▼
                      LiteLLM
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
       Ollama         LM Studio       Cloud
          │              │
          ▼              ▼
        Qwen           Qwen
```

Then **Leo doesn't need to know where the model lives**.

---

# This is the architecture I'd investigate for you

Given your existing ML lab, I'd actually prefer:

```text
                  ┌───────────────────┐
                  │    BRAVE LEO      │
                  │                   │
                  │ Browser context   │
                  │ PDFs / tabs       │
                  │ Web research      │
                  └─────────┬─────────┘
                            │
                            ▼
                     ┌─────────────┐
                     │   LiteLLM   │
                     │   Gateway   │
                     └──────┬──────┘
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
          Ollama        LM Studio        vLLM
             │              │              │
             ▼              ▼              ▼
          Qwen 3        Qwen 3         Large MoE
```

That gives you **model abstraction**.

Leo talks to one endpoint.

You decide what happens behind it.

---

# And there's an even bigger possibility

Brave has been moving Leo toward more **agentic browser capabilities**, including multi-tab context and browser automation concepts. Brave's roadmap discusses agentic AI, permissions, activity/audit trails, rollback/undo, MCP interfaces, and deeper local-model support. ([Brave][3])

That's potentially much more interesting than "AI chatbot in a browser."

Imagine eventually:

```text
Leo
 │
 ├── Browser context
 ├── Search
 ├── Multiple tabs
 ├── Local model
 ├── MCP
 └── Agent actions
       │
       ▼
    Your local AI infrastructure
```

That starts looking like a **browser-native agent front end for your homelab AI infrastructure**.

---

## One caveat

There's a difference between:

**"Leo supports BYOM"**

and

**"every Leo feature works identically with BYOM."**

Brave has been progressively integrating BYOM with more Leo capabilities. Its 2025 documentation, for example, says BYOM works with Leo's conversation UX and browser-native context handling, while some features were still being integrated. ([Brave][4])

So I wouldn't assume that every hosted-Leo feature automatically works with every arbitrary local model.

---

# My take

**This changes my opinion of Brave considerably.**

I initially wouldn't recommend paying for Brave merely to get AI search.

But:

### Brave Browser

**+**

### Leo

**+**

### BYOM

**+**

### Ollama/Qwen

**+**

### your existing LiteLLM infrastructure**

= **a genuinely interesting local-AI architecture.**

And importantly, you don't need Leo Premium to experiment with the basic BYOM concept; Brave presents BYOM as part of Leo itself, while Premium primarily expands access/rate limits and hosted model choices. ([Brave][1])

### I would test this before spending a penny.

The next step I'd recommend is to **actually wire Brave Leo → your existing Ollama → Qwen3-Coder-Next**, starting with localhost/LAN-only access and no Internet exposure. We can then test **webpage context, PDF context, multi-tab context, model behavior, network traffic, and exactly what leaves the machine**.

That would be a much more useful experiment than simply trying Brave's hosted Leo.

[1]: https://brave.com/leo/ "Brave Leo AI | Brave"
[2]: https://brave.com/blog/byom-nightly/ "Bring Your Own Model (BYOM): using Brave Leo with your own LLMs | Brave"
[3]: https://brave.com/blog/leo-roadmap-2025-update/ "Building Browser AI: Leo’s Development Progress and Plans | Brave"
[4]: https://brave.com/blog/automatic-mode-leo/ "Leo’s New Automatic Mode: Smarter AI That Adapts to Your Workflow | Brave"
