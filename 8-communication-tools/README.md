# AI Communication Channel

AI Guide communication, **“AI Communication Channels”** section. These are the interfaces people use to talk to an AI agent that may be hosted locally, on a server, or in the cloud.

| Platform               | What it is                            | Typical AI use case                                          | Local/self-hosted potential                           |
| ---------------------- | ------------------------------------- | ------------------------------------------------------------ | ----------------------------------------------------- |
| **Telegram**           | Messaging platform with bot API       | Personal AI assistant, alerts, commands, automation          | 🟢 Excellent                                          |
| **Discord**            | Community/chat platform with bots     | AI assistants, coding bots, team agents, gaming/community AI | 🟢 Excellent                                          |
| **WhatsApp**           | Mass-market messaging platform        | Talk to an AI assistant from your phone                      | 🟡 Possible, but more infrastructure/API restrictions |
| **Signal**             | Privacy-focused messenger             | Private AI assistant / notifications                         | 🟡 Possible, more technical                           |
| **Matrix**             | Decentralized/open messaging protocol | Private/self-hosted AI assistants                            | 🟢 Excellent                                          |
| **Slack**              | Work/team messaging                   | Company AI agents, knowledge bots, automation                | 🟡 Mostly cloud                                       |
| **Microsoft Teams**    | Enterprise collaboration              | Corporate AI agents and workflows                            | 🟡 Mostly cloud                                       |
| **IRC**                | Classic Internet chat                 | Lightweight bots/AI agents                                   | 🟢 Excellent                                          |
| **Web UI**             | Browser-based interface               | General AI chat, local LLMs, agents                          | 🟢 Excellent                                          |
| **CLI / Terminal**     | Command-line interface                | Developers, sysadmins, coding agents                         | 🟢 Excellent                                          |
| **Email**              | Asynchronous messaging                | AI reports, alerts, automated assistants                     | 🟢 Excellent                                          |
| **Voice**              | Phone/VoIP/voice interface            | Hands-free AI assistant                                      | 🟡 Depends on stack                                   |
| **Home Assistant**     | Home automation interface             | Local AI controlling smart home                              | 🟢 Excellent                                          |
| **Discord + Webhooks** | Event-driven messaging                | Monitoring, alerts, autonomous agents                        | 🟢 Excellent                                          |

### The interesting ones for local AI

For your **privacy-first/local LLM** direction, I'd particularly highlight:

**Telegram → easiest remote interface**

```text
Phone
  ↓
Telegram
  ↓
Bot
  ↓
OpenClaw / Hermes
  ↓
Ollama
  ↓
Qwen / Llama / etc.
  ↓
GPU
```

You can literally send your local AI a Telegram message while you're away from home.

**Discord → community / multi-user AI**

Good for:

* AI coding assistants
* gaming assistants
* server administration
* group research
* notifications
* multiple agents in different channels

**Matrix → maximum self-hosting**

This is particularly interesting for your philosophy because you can run the messaging infrastructure yourself:

```text
Matrix Server
     ↓
AI Agent
     ↓
Ollama
     ↓
Local LLM
```

No dependence on a proprietary messaging platform is required.

**CLI → serious engineering**

For someone with your Linux/networking background:

```text
SSH
 ↓
Agent CLI
 ↓
OpenClaw / Hermes / OpenCode
 ↓
Ollama
 ↓
Local model
```

This is arguably the most natural interface for infrastructure automation.

**Web UI → easiest for general users**

Examples include Open WebUI, LM Studio, Flowise, etc.

---

### One important distinction

The messaging platform **isn't the AI**.

Think of:

> **Telegram = telephone**

> **OpenClaw/Hermes = personal assistant**

> **Ollama = engine**

> **Qwen/Llama/etc. = brain**

So you can potentially have:

```text
                    ┌── Telegram
                    ├── Discord
USER ───────────────┼── WhatsApp
                    ├── Web UI
                    ├── CLI
                    └── Voice
                         │
                         ▼
                  AGENT HARNESS
              OpenClaw / Hermes / etc.
                         │
                         ▼
                   Ollama / etc.
                         │
                         ▼
                    LOCAL MODEL
                         │
                         ▼
                  GPU / CPU / NPU
```

That's a **very useful architecture to teach in your AI Guide**, because it demonstrates that the same local AI can potentially be accessed from a phone, browser, terminal, or messaging application without changing the underlying model.
