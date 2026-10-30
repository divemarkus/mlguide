# oMLX + Hermes Agent on Apple Silicon: Local AI Deployment Guide

Designed for an always-on Mac mini, and local inference. [Visit oMLX](https://omlx.ai/)


<img width="1536" height="1024" alt="MacMini-Local-AI-Command-Center" src="https://github.com/user-attachments/assets/00e9d30e-29a2-4379-92ea-b9dad292f534" />


This guide assumes you already have Hermes Desktop installed and working, oMLX installed and running, and your M6 Mac mini configured. We'll concentrate on model selection, connecting the two applications, configuring Hermes Desktop, and building a reliable always-on setup.

> Update: oMLX now has an App, download and install that version. Dotfiles has been updated and oMLX removed.

My architectural recommendation is to make oMLX your dedicated inference server and Hermes Agent your always-on agent platform.

They have different jobs:
- oMLX: Loads and serves MLX-compatible models using Apple Silicon's Metal/GPU acceleration and unified memory.
- Hermes Agent: Uses those models to reason, search, interact with tools, manage memory, execute skills, and coordinate workflows.
- Home Assistant, your homelab, and market-data services: Supply the actual data and actions Hermes needs.

One important principle: a smaller model that reliably follows tool instructions is more useful for this deployment than a larger model that struggles with tool calling. We should optimize for tool use, instruction following, responsiveness, and memory efficiency, not benchmark scores alone.

## 1. Why oMLX is a good choice for this Mac

oMLX is more than a model launcher. It is an inference server designed around the characteristics of Apple Silicon.

Its important capabilities include:
- Native MLX inference using Apple's Metal framework.
- OpenAI-compatible API at <http://127.0.0.1:8000/v1>.
- Tool/function calling, including Gemma and Qwen-specific formats.
- Continuous batching for concurrent requests.
- Persistent, SSD-backed KV caching.
- Multiple model support, with memory-aware model eviction.
- A macOS menu-bar application and web administration interface.
- Model discovery from Hugging Face, LM Studio and custom model directories.

This is particularly relevant to agent workloads. Hermes can revisit earlier conversation context, invoke tools, receive results and continue reasoning. oMLX's persistent cache can reduce repeated computation when agent conversations reuse prompt prefixes.

### How the two applications fit together

| Component | Role |
| --- | --- |
| Hermes Desktop | Your interface, conversations, settings and agent sessions |
| OpenAI-compatible API | `localhost:8000/v1` |
| oMLX inference server | MLX, Metal, model serving and KV cache |
| Gemma 4 E4B | Primary model |
| Qwen 3 4B | Alternative model |

Both applications can run independently. Hermes sends inference requests to oMLX; oMLX does not replace Hermes' tools or agent logic.

The endpoint is local to your Mac. There is no reason to expose port 8000 to the public internet.

## 2. Model selection for 32GB unified memory

I would avoid running a 27B–35B model continuously on this Mac. Although some larger models can technically fit with aggressive quantization, they leave less memory for macOS, Hermes, oMLX caching, Discord, Home Assistant integrations and other always-on services.

Here is my shortlist, prioritizing small models and tool-capable formats.

## 3. Recommended models

These are the models I would actually test on your machine. Their MLX variants are available, and oMLX documents support for both Gemma and Qwen tool-call formats.

| Model | MLX quantization | Disk footprint | My assessment |
| --- | --- | --- | --- |
| Qwen3.5 4B | 4-bit | ~3.1GB | My first choice |
| Gemma 4 E4B | 4-bit | Check current model card | Strong alternative |
| Gemma 4 E2B | 4-bit | ~3.55GB | Lightweight option |
| Qwen3.5 9B | 4-bit | ~5GB | Higher-quality upgrade |

The disk figures are model-file sizes, not total runtime memory. KV cache, context, temporary allocations and other macOS applications increase actual memory consumption.

### My ranking for your workloads

1. **Qwen3.5 4B — primary recommendation**
   - Good candidate for structured instructions and tool-oriented tasks.
   - Small MLX checkpoint.
   - oMLX recognizes the Qwen3.5 function-call format.
   - Good starting point for Home Assistant, homelab queries, research and routine automation.

   Model: Qwen3.5 4B MLX 4-bit

2. **Gemma 4 E4B — alternative**
   - Instruction-tuned model.
   - oMLX recognizes Gemma's native function-call format.
   - Worth comparing against Qwen for HA tool selection and following multi-step instructions.

   Model: Gemma 4 E4B IT MLX 4-bit

3. **Qwen3.5 9B — quality upgrade**
   - More capacity for complex instructions and reasoning.
   - Larger memory footprint.
   - I'd keep it available for more demanding research or troubleshooting, rather than automatically pinning it in memory all day.

   Model: Qwen3.5 9B MLX 4-bit

4. **Gemma 4 E2B — lightweight alternative**
   - Useful for simpler questions and short operations.
   - Less capable than the larger candidates for complicated multi-step tasks.

   Model: Gemma 4 E2B IT MLX 4-bit

My advice is to begin with Qwen3.5 4B, test it properly, then compare Gemma 4 E4B. Don't download all four immediately.

## 4. Configure oMLX first

Hermes Desktop needs an API endpoint and a model identifier. It does not need to know how MLX works internally.

### Step 4.1: Check that oMLX is running

Open the oMLX menu-bar application and confirm that its server is running.

The default local endpoints are:

| Function | URL |
| --- | --- |
| Admin dashboard | <http://127.0.0.1:8000/admin> |
| Chat interface | <http://127.0.0.1:8000/admin/chat> |
| Model API | <http://127.0.0.1:8000/v1> |
| Model discovery | <http://127.0.0.1:8000/v1/models> |

These are the documented defaults.

Check connectivity from Terminal:

```bash
curl -s http://127.0.0.1:8000/v1/models | jq
```

You should receive a JSON response listing the models oMLX currently exposes.

### Step 4.2: Download your first model

Open <http://127.0.0.1:8000/admin>.

In the oMLX dashboard:
1. Open Model Management.
2. Use the Hugging Face model downloader.
3. Search for `mlx-community/Qwen3.5-4B-MLX-4bit`.
4. Download the model.
5. Wait for the download and verification to finish.
6. Load the model.

<img width="1728" height="1117" alt="omlx-model-downloader" src="https://github.com/user-attachments/assets/ef1413c2-1402-440d-816e-0c30497f3417" />

The default model directory is:

```text
~/.omlx/models/mlx-community
```

oMLX can discover models in its configured model directory, including supported nested model folders. You can also use models from your existing Hugging Face or LM Studio model directories.

<img width="1728" height="1117" alt="omlx-model-load" src="https://github.com/user-attachments/assets/935b6af8-bd12-4907-898a-06834732e5a2" />

### Step 4.3: Set sensible resource limits

This is particularly important because the Mac will remain powered on continuously.

Open the oMLX administration dashboard and inspect the model's individual settings.

My suggested starting configuration:

| Setting | Recommendation |
| --- | --- |
| Memory guard | Balanced |
| Model pinning | Pin Qwen3.5 4B only |
| Concurrent requests | 2 initially |
| Idle timeout | Disable for primary model, or use a long TTL |
| KV cache | Enable persistent SSD caching |
| Context | At least 64K for Hermes |
| Other models | Load on demand |

oMLX supports memory guards, model pinning, LRU eviction, per-model TTL and SSD-backed KV caching. Its default process memory ceiling is designed to leave headroom for the operating system.

#### Important context requirement

Hermes currently requires a minimum context length of 64,000 tokens for its agent workflows. This is not the same as the model's disk size or the number of tokens you normally use. Make sure the model and oMLX serving configuration can actually support this context.

For your 32GB system, start at 64K rather than immediately trying 128K or 256K. A large advertised context window doesn't mean you should allocate all of it.

## 5. Connect Hermes Desktop to oMLX


<img width="1728" height="1117" alt="hermes-local-gateway" src="https://github.com/user-attachments/assets/dd32abbe-e7cc-4ea3-8077-f11b4dfd3e12" />

This is the central part of the deployment.

You are not installing another model inside Hermes. You are connecting Hermes to the model server already running in oMLX.

### Step 5.1: Find the model's API identifier

Run:

```bash
curl -s http://127.0.0.1:8000/v1/models | jq -r '.data[].id'
```

You might see:

```text
mlx-community/Qwen3.5-4B-MLX-4bit
```

Use the exact ID returned by your server. If you've configured a model alias in oMLX, use the alias instead.


### Step 5.2: Configure Hermes Desktop

Open Hermes Desktop and go to its provider/model settings.

Choose the custom OpenAI-compatible endpoint option. Depending on the Desktop release, this may be presented under Settings → Providers or through the model-selection workflow.

<img width="1728" height="1117" alt="hermes-model-local" src="https://github.com/user-attachments/assets/5a4a75e3-7572-4167-994b-eb1758895793" />


Enter:

| Hermes setting | Value |
| --- | --- |
| Provider | Custom |
| Base URL | `http://127.0.0.1:8000/v1` |
| API key | Leave blank if oMLX is configured for keyless localhost access |
| Model | Exact ID returned by `/v1/models` |
| Context length | `65536` |

Hermes supports custom OpenAI-compatible endpoints, and the endpoint configuration is stored in its normal configuration file.

If the Desktop UI doesn't expose all the fields you need, use the Hermes CLI model configuration wizard:

```bash
hermes model
```

Select Custom endpoint, enter the values above and save. This changes the same Hermes configuration used by the application.

<img width="1728" height="1117" alt="hermes-model-selection" src="https://github.com/user-attachments/assets/cafcb10a-a46e-4cbe-96cd-dd4e6d0e2d15" />


### Step 5.3: Verify the Hermes configuration

The normal configuration file is:

```text
~/.hermes/config.yaml
```

The relevant configuration should resemble:

```yaml
model:
  provider: custom
  default: "mlx-community/Qwen3.5-4B-MLX-4bit"
  base_url: "http://127.0.0.1:8000/v1"
  context_length: 65536
```

Keep your secrets and tokens in:

```text
~/.hermes/.env
```

You should not need an API key for a localhost-only oMLX endpoint configured without authentication.

Important: Don't configure `OPENAI_BASE_URL` or `LLM_MODEL` as substitutes for this. Current Hermes documentation identifies `config.yaml` as the source of truth for custom provider configuration.

### Step 5.4: Test the connection

First, test the oMLX chat API directly:

```bash
curl -s http://127.0.0.1:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Qwen3.5-4B-MLX-4bit",
    "messages": [
      {
        "role": "user",
        "content": "Explain your role as a local assistant."
      }
    ],
    "max_tokens": 150
  }' | jq
```

Then open Hermes Desktop and start a new conversation.

Ask:

> Identify your current model provider, model name, and the tools you can access. Do not execute any actions yet.

If the connection works, Hermes should respond using your local model.

- Add an image and ask Hermes to describe them

<img width="1728" height="1117" alt="hermes-describe-image" src="https://github.com/user-attachments/assets/00e4784e-4293-4c9d-9542-b638aaf9f225" />


## 6. Configure Hermes for your actual use cases

The model is only one part of the system. The following capabilities come from Hermes tools, skills, plugins and integrations—not from Gemma or Qwen themselves.

### Home Assistant

Your HA VM remains the source of truth for devices, entities, automations and scripts.

Configure the Home Assistant integration in Hermes and give it a dedicated access token.

Suggested initial tests:
- List the Home Assistant entities you can access.
- What is the current temperature in the living room?
- Is the front door locked?
- Show me the status of my selected leak sensors.

Then test a low-risk action:
- Turn on the office light.

Only after the read-only tests work should you expand the action permissions.

Keep door locks, alarm controls, garage doors and safety-related operations behind explicit confirmation.

### Homelab and infrastructure

Hermes can use its terminal tools, configured MCP servers, and selected integrations to work with your infrastructure.

I would build these as separate, narrowly scoped capabilities:

| System | Useful Hermes tasks |
| --- | --- |
| Docker | Container status, restart diagnostics, logs |
| UnRAID | Storage status, share checks, system diagnostics |
| Ubuntu | Service status, disk space, logs, updates |
| Wazuh | Summarize alerts and investigate selected events |
| Prometheus/Grafana | Query metrics and explain anomalies |
| GitHub | Repository monitoring, release summaries, issue review |
| Network equipment | Read-only configuration and status analysis |

Start with read-only access. For commands that modify firewall rules, Docker deployments, storage or security settings, require approval.

### Stocks, crypto and finance

For finance, I would not rely on the model's internal knowledge for prices.

Use external data tools and finance skills:
- Hermes finance/stocks skill for supported market quotes and historical data.
- Web search for news and company announcements.
- A reliable market-data API for more dependable price feeds.
- Your own scripts for calculating portfolio exposure, returns and volatility.

Example requests:
- Get the latest BTC, ETH and SOL quotes.
- Compare NVDA, MU, WDC and SNDK.
- Find the most significant semiconductor news published in the last 24 hours.
- Summarize potential catalysts for Bitcoin and SOL. Separate confirmed events from speculation.

The model reasons about the data; the finance skill and external sources provide the data.

For actual investment decisions, verify quote timestamps and market status. Keep brokerage credentials and trade execution outside the initial Hermes setup.

### Web research and news

Enable Hermes' web search tools and configure a search backend.

For your privacy-first setup, I would consider self-hosted SearXNG. You can then ask Hermes to:
- Research new MLX and local LLM releases.
- Track upstream changes in Hermes Agent and oMLX.
- Monitor security vulnerabilities.
- Gather market news.
- Produce a daily Discord briefing.

Remember that self-hosting SearXNG does not make the upstream search engine requests private or offline. The search sources still receive queries.

## 7. Configure always-on operation

The intended architecture is:

| Component | Role |
| --- | --- |
| Hermes Desktop | Agent interface and configuration |
| Hermes Gateway | Discord, scheduling and agent sessions |
| oMLX background service | Local inference, model cache and API |
| Local Gemma/Qwen | MLX model |
| External integrations | Home Assistant, homelab, web and finance |

### oMLX service

If you installed the macOS app, use its background server controls. If you installed through Homebrew, the documented commands are:

```bash
omlx start
omlx status
```

The Homebrew service can also be managed through:

```bash
brew services info omlx
```

oMLX documents automatic crash recovery for its managed service and a native menu-bar application.

### Hermes Gateway

Since you're using Hermes Desktop, let the application manage the gateway initially. For persistent Discord and scheduled operation, verify that its background service is installed and starts after login.

Check:

```bash
hermes gateway status
```

### Verify after a reboot

I would test the following:
1. Restart the Mac.
2. Verify oMLX starts.
3. Verify the model is discoverable.
4. Verify Hermes Desktop can connect.
5. Verify the Discord bot responds.
6. Verify a scheduled task executes.
7. Verify Home Assistant can be queried.

This is the real test of an always-on deployment—not simply whether the applications run when you manually open them.

## 8. Why oMLX instead of Ollama or LM Studio?

For this particular deployment, I favor oMLX. But it isn't universally superior.

| Feature | oMLX | Ollama | LM Studio |
| --- | --- | --- | --- |
| Native MLX focus | Excellent | MLX-enabled variants | Yes |
| Model management | Excellent | Excellent | Excellent |
| Continuous batching | Yes | Different serving architecture | Depends on configuration |
| Persistent SSD KV cache | Yes | Not its equivalent feature | Not its equivalent feature |
| Multiple models | Yes, with eviction | Yes | Yes |
| GUI | Menu bar + web admin | Basic | Excellent |
| CLI automation | Excellent | Excellent | Available |
| Cross-platform consistency | macOS-focused | Excellent | Good |
| Best fit here | My choice | Best if sharing model infrastructure | Best for interactive experimentation |

oMLX's specific advantages are its tiered KV caching, continuous batching, MLX-native model serving, model pinning and eviction, and integrated monitoring.

Why I wouldn't choose Ollama here: You already have Ollama experience, and it remains a good choice for managing a common model ecosystem across Macs and Linux/RTX servers. But this particular Mac is an MLX-first machine, and oMLX gives you a more direct Apple Silicon inference architecture.

Why I wouldn't choose LM Studio here: It's excellent for browsing, testing and comparing models. However, you're building an always-on inference service rather than primarily an interactive model laboratory. oMLX is more closely aligned with that role.

I would keep LM Studio available for occasional model experimentation, but avoid running two inference servers simultaneously unless you have a specific reason.

## 9. My final 32GB configuration

M6 Mac mini — Always-on AI appliance

32GB unified memory · macOS · local-first

| Component | Configuration |
| --- | --- |
| Agent | Hermes Desktop + Gateway |
| Inference | oMLX |
| Primary model | Qwen3.5 4B MLX 4-bit |
| Alternative | Gemma 4 E4B MLX 4-bit |
| Larger model | Qwen3.5 9B MLX 4-bit, on demand |
| Context | 64K starting configuration |
| Model management | Pin primary, unload alternatives |
| Remote interface | Discord |
| Smart home | Home Assistant integration |
| Research | Web search + finance skill |
| Automation | Hermes scheduled tasks |
| Security | Localhost inference, least-privilege tools |

### Operating philosophy

Keep one compact model available for routine requests. Let Hermes use external tools for live information and actions. Avoid loading several large models simultaneously.

## 10. Validation checklist

Use this to establish whether the deployment is actually ready for everyday use.

- [ ] oMLX starts automatically and exposes port 8000 only locally.
- [ ] Qwen3.5 4B appears in `/v1/models`.
- [ ] Hermes Desktop connects to the oMLX endpoint.
- [ ] Hermes reports the expected model and provider.
- [ ] Hermes has at least 64K context configured and accepted.
- [ ] A normal conversation works without cloud inference.
- [ ] Hermes successfully invokes a tool through a test workflow.
- [ ] Home Assistant entity queries work.
- [ ] A harmless Home Assistant action works with the intended permissions.
- [ ] Web search returns current results with source links.
- [ ] Finance queries return dated data from an external source.
- [ ] Discord responds after a Mac reboot.
- [ ] Gateway scheduled tasks execute while Desktop is closed.

### Reference documentation

These are the primary references I used for this updated configuration:
- oMLX GitHub — features, configuration, APIs and integrations
- oMLX official website
- Hermes Agent — local models
- Hermes Agent — custom model providers
- Hermes Agent — running local LLMs on Mac
- Qwen3.5 4B MLX model
- Gemma 4 E4B MLX model

My final recommendation: Start with Qwen3.5 4B, oMLX, and Hermes Desktop. Get Discord and Home Assistant working before adding finance and homelab automation. Once the agent can reliably select and execute tools, compare Gemma 4 E4B and Qwen3.5 9B against the same tasks. That will tell you whether the larger model actually earns its additional memory consumption.

The most important thing is to test tool calling—not just conversational quality. Your Mac mini is becoming an always-on agent host, and reliable execution matters more than an impressive chat demonstration.
