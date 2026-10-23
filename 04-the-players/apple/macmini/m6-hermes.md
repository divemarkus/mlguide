# Hermes Agent on your M6 Mac mini: deployment plan

I'd build this as a privacy-first, always-on local AI appliance: Hermes Agent provides the agentic capabilities, a local MLX inference server provides the language model, Home Assistant runs separately in its VM, and Discord is your initial remote interface.

There are four separate decisions to make:

1. Install Hermes Agent Desktop — the graphical application and its CLI, with persistent background services.
2. Run Gemma locally using MLX — choose an inference server that actually serves MLX models, rather than assuming Ollama uses MLX.
3. Integrate Home Assistant — give Hermes controlled access to HA entities, scripts and automations.
4. Configure Discord — allow you to interact with Hermes remotely without exposing its administrative interfaces to the internet.

## Contents

- [1. Install Hermes Desktop](#1-installing-the-full-hermes-desktop-application)
- [2. Serve Gemma with MLX](#2-serving-the-latest-small-gemma-models-using-mlx)
- [3. Connect Home Assistant](#3-connect-hermes-to-your-home-assistant-vm)
- [4. Configure Discord](#4-discord-your-first-remote-interface)
- [5. Keep Hermes running](#5-make-hermes-run-247-on-macos)
- [6. Choose additional use cases](#6-other-hermes-use-cases-that-fit-your-environment)
- [7. Deployment sequence](#7-the-deployment-i-would-build-first)
- [Final recommendation](#final-recommendation)

One important detail: the M6 chip generation alone doesn't determine which Gemma model will fit comfortably. Unified-memory capacity, the precise Gemma release, quantization, context length and concurrent workloads all matter. I'll distinguish confirmed software capabilities from recommendations that depend on your Mac's exact memory configuration.

## 1. Installing the full Hermes Desktop application

Hermes officially supports Apple Silicon Macs. Its recommended desktop installation is the signed macOS application, while its shell installer is the alternative for a CLI-focused installation. The Desktop package includes the agent and its supported runtime dependencies; you don't need to clone the source repository just to use it.&#x20;

### My recommendation: install Desktop directly, manage the supporting tools with Homebrew

**Hermes Desktop: install from the official release**

Download the macOS DMG from the official [Hermes Agent website](https://hermes-agent.nousresearch.com/?utm_source=chatgpt.com), open it, and copy `Hermes.app` into `/Applications`.

This is the best starting point because you want the full graphical application, not merely a terminal agent.

**Homebrew: manage the supporting tools**

Manage Ollama, developer utilities, Git, `jq`, and other supporting command-line tools through your dotfiles. Keep Hermes Desktop's official updater responsible for updating Hermes itself.

### What about installing Hermes from source?

You can use the CLI installer:

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

Then reload your shell and verify:

```bash
source ~/.zshrc
hermes --help
hermes desktop
```

The installer sets up the CLI and its required runtime components. The `hermes desktop` command can launch or install the desktop experience after a CLI-only installation, according to the current installation documentation.

I wouldn't use a raw Git clone as your initial production installation. It makes more sense if you intend to contribute to Hermes, patch it, or deliberately track development branches.

### Adding the surrounding stack to your Brewfile

Here is a reasonable starting point for the parts that belong in Homebrew:

```ruby
# AI / local inference
cask "ollama"

# Developer and operations tools
brew "git"
brew "jq"
brew "yq"
brew "ripgrep"
brew "fd"
brew "gh"

# Useful for inspecting API responses
brew "httpie"
```

Apply it with:

```bash
brew bundle --file=~/dotfiles/Brewfile
```

Adjust the path to your actual dotfiles repository.

A few notes:

- Ollama: install via Homebrew if you want its MLX-enabled model server.
- LM Studio: install its official macOS application separately; it is not just a Homebrew CLI package.
- Hermes Desktop: install from the official signed DMG rather than assuming a Homebrew formula or cask exists.
- MLX: you do not need to install the Python `mlx` package manually just to serve models through Ollama's MLX engine.

For an MLX-only deployment, I'd start with Ollama and add LM Studio only if you want its model browser, GUI, and side-by-side experimentation.

## 2. Serving the latest small Gemma models using MLX

Here's an important update to our earlier discussion: Ollama now has an MLX inference engine for Apple Silicon. You can use MLX-tagged models without switching to LM Studio. Ollama's documentation describes its MLX engine as using Apple's MLX framework and unified memory; the engine has received performance improvements for agent workflows.&#x20;


The current Gemma family listing includes smaller `e2b` and `e4b` models, as well as larger 12B, 26B and 31B variants. Ollama publishes MLX-specific variants too.&#x20;


### Which Gemma sizes should you consider?

**Gemma 4 E2B: smallest starting point**

*Lightweight*

A sensible first model for basic assistant duties, short summaries, lightweight classification, and simple Home Assistant questions. It is the least demanding of these options, but it won't be my first choice for complex multi-step agent work.

**Gemma 4 E4B: practical small-model candidate**

*Start here*

A stronger starting candidate if you want local chat, short research tasks, summarization and basic tool-oriented workflows without committing to a much larger model.

**Gemma 4 12B: quality upgrade**

Consider this if your M6 has sufficient unified memory and you want more capability for reasoning and agent tasks. It will consume more memory, leaving less room for Hermes, macOS, HA-related tooling and other services.

The sizes above are model-family choices, not guarantees of memory use. The actual MLX quantization and context setting determine the working footprint. For Hermes, tool calling and following multi-step instructions are just as important as conversational quality.

### Option A — Ollama with its MLX Gemma model

This is the path I would try first.

Install or update Ollama, then pull a small MLX model:

```bash
ollama pull gemma4:e2b-mlx
```

Or try the larger small model:

```bash
ollama pull gemma4:e4b-mlx
```

These MLX variants are listed in the current Gemma catalog.&#x20;


Start an interactive test:

```bash
ollama run gemma4:e4b-mlx
```

Check that the model is available:

```bash
ollama list
```

Then test the local API:

```bash
curl http://127.0.0.1:11434/v1/models
```

If you want to keep the Mac dedicated to Hermes and automation, Ollama's command-line interface is convenient for model pulls, upgrades, and service checks.

### Option B — LM Studio with an MLX Gemma model

LM Studio supports MLX models on Apple Silicon and exposes an OpenAI-compatible API. It also has a model catalog, a graphical model loader, context controls, and a server mode.&#x20;


You can search specifically for MLX models from its CLI:

```bash
lms get --mlx
```

For example, search for a Gemma 4 E4B MLX build and select an available quantization. The exact publisher and model ID can vary by catalog entry. LM Studio's documentation confirms that `--mlx` filters the model search to MLX-format models.&#x20;


After loading a model, start its API server:

```bash
lms server start
```

The default port is normally `1234`; check your server status and settings if you've changed it.&#x20;


### Ollama vs LM Studio: my verdict

| Requirement                               | Ollama + MLX  | LM Studio + MLX     |
| ----------------------------------------- | ------------- | ------------------- |
| MLX inference on Apple Silicon            | Yes           | Yes                 |
| CLI-first workflow                        | Excellent     | Available           |
| GUI for exploring models                  | Basic         | Excellent           |
| Easy integration into scripts and agents  | Excellent     | Excellent           |
| Headless/always-on use                    | My preference | Possible            |
| Model experimentation and manual controls | Good          | My preference       |
| Fit with your existing Ollama setup       | Excellent     | Adds another server |

Recommendation: use Ollama's MLX engine first. It's the cleaner match for your existing local AI infrastructure and an always-on Mac. Choose LM Studio instead if its GUI and model-management features are worth the extra application.

One caveat: this is not a guarantee that every Ollama model tag uses MLX. For your MLX-only requirement, explicitly choose the `-mlx` variants and verify the actual model/backend rather than pulling a generic model name.

## 3. Connect Hermes to your Home Assistant VM

This is where Hermes becomes more than a chatbot.

Home Assistant remains your automation engine and source of truth. Hermes becomes a conversational interface and reasoning layer that can query HA, execute approved actions, and explain what's happening.

The official Hermes Home Assistant integration is a plugin, not part of Hermes core. It supports real-time state changes via WebSocket and smart-home tools via the HA REST API. ([Hermes Home Assistant integration](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/homeassistant?utm_source=chatgpt.com))

```text
Discord
	Remote command and query interface
					|
Hermes Agent on macOS
	Reasoning, tools, memory, skills, authorization
			 /                         \\
Ollama + MLX                 Home Assistant VM
Local Gemma inference        Entities, scripts, automations
```

Conceptual architecture. HA and Ollama are separate services; Hermes connects to them over their APIs.

### What can Hermes do with HA?

| Example request                                  | What Hermes could do                                                                                          |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| “What's the temperature in the living room?”     | Query the appropriate HA sensor                                                                               |
| “Turn off the lights downstairs.”                | Find matching light entities and call the HA service                                                          |
| “Is the front door locked?”                      | Read the lock state and report it                                                                             |
| “Why did the office temperature rise overnight?” | Inspect relevant sensor readings and available history, if exposed through an appropriate tool or integration |
| “Run my goodnight routine.”                      | Call an existing HA script or automation                                                                      |
| “Tell me if the server room gets too warm.”      | Combine sensor queries with a scheduled check or HA-triggered workflow                                        |

The documented plugin provides four core tools: list entities, get entity state, list services, and call a service. More sophisticated historical analysis may need additional HA integrations, exposed data, or a separate query mechanism. ([Official integration documentation](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/homeassistant?utm_source=chatgpt.com))

### Installation and configuration

Once Hermes is installed and working, install the plugin:

```bash
hermes plugins install homeassistant
```

In Home Assistant, create a Long-Lived Access Token under your user profile. Then configure the connection in `~/.hermes/.env`:

```dotenv
HASS_URL=http://YOUR_HA_VM_IP:8123
HASS_TOKEN=YOUR_LONG_LIVED_ACCESS_TOKEN
```

Replace the placeholders with your actual VM address and token. Keep this file private and never commit it to Git.

Start the gateway after configuring the plugin:

```bash
hermes gateway
```

The integration activates when the token is configured. Hermes can then use HA as a connected platform alongside Discord. ([Official setup instructions](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/homeassistant?utm_source=chatgpt.com))

### A security model I would use in your homelab

I would not give an LLM unrestricted authority over every smart-home device.

Start with read-only queries and a small allowlist of low-risk actions. Require confirmation for door locks, garage doors, security system changes, power control of critical equipment, or anything that could affect physical safety. Keep your HA token scoped to a dedicated account where practical, and restrict network access between the Mac and the HA VM.

Also, don't make Hermes responsible for time-critical automations. Keep essential rules, alarms, and safety behavior inside Home Assistant. Hermes can request actions and interpret information, but the home should continue to function if the Mac or LLM is offline.

## 4. Discord: your first remote interface

Discord is a good initial choice because Hermes has a documented bot integration. The bot processes messages through its normal agent pipeline, including tool use, memory and reasoning. It supports direct messages, server channels, file attachments, voice messages and slash commands. ([Official Discord guide](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/discord?utm_source=chatgpt.com))

### Setup sequence

1. Open the [Discord Developer Portal](https://discord.com/developers/applications?utm_source=chatgpt.com) and create an application.
2. Add a bot to the application and copy its token. Treat that token like a password.
3. Invite the bot to your private Discord server with only the permissions it needs to read and send messages.
4. Enable Developer Mode in Discord and copy your own Discord user ID.
5. Run Hermes' guided gateway setup:

```bash
hermes gateway setup
```

Select Discord and supply the bot token and your user ID when prompted. The official guide also supports configuring these manually in `~/.hermes/.env`:

```dotenv
DISCORD_BOT_TOKEN=YOUR_DISCORD_BOT_TOKEN
DISCORD_ALLOWED_USERS=YOUR_DISCORD_USER_ID
```

Keep `DISCORD_ALLOWED_USERS` configured. For a personal assistant, I would not leave the bot open to every member of a server. Hermes' Discord integration supports user allowlisting, and by default it responds to DMs while requiring an `@mention` in server channels. ([Discord setup and behavior](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/discord?utm_source=chatgpt.com))

Start it:

```bash
hermes gateway
```

Test with a simple DM first, then try a harmless read-only request.

### How I would use Discord

Create a private server with a few channels, for example:

- `#hermes` — everyday questions and commands
- `#homelab` — infrastructure status and diagnostic requests
- `#ai-research` — model and local-AI research
- `#alerts` — only if you later configure approved notification workflows

These are your proposed channel names, not channels Hermes creates automatically.

Important privacy distinction: Hermes may run its inference locally, but Discord itself is a hosted service. Messages sent through Discord are not entirely local or offline. If you later want a fully self-hosted messaging path, we can evaluate a local alternative.

## 5. Make Hermes run 24/7 on macOS

The key distinction is that Hermes Desktop is the graphical app; the Hermes Gateway is the long-running service that receives Discord messages and executes scheduled jobs.

You can close the desktop interface while keeping the gateway running, provided the service and its dependencies remain available.

### Install and manage the gateway

After Hermes works interactively, install its macOS `launchd` service:

```bash
hermes gateway install
hermes gateway start
hermes gateway status
```

Inspect logs:

```bash
tail -f ~/.hermes/logs/gateway.log
```

The installer creates a LaunchAgent at:

```text
~/Library/LaunchAgents/ai.hermes.gateway.plist
```

That lets macOS manage the gateway as a per-user background service. ([Hermes Gateway documentation](https://hermes-agent.nousresearch.com/docs/user-guide/messaging?utm_source=chatgpt.com))

For reliability, I would also:

- Configure macOS not to sleep the computer automatically.
- Enable restart after power failure if supported by your Mac and macOS settings.
- Use Ethernet where practical.
- Keep the Mac's local disk available for Hermes memory, model files and logs.
- Check the gateway and model server after macOS updates or reboots.
- Keep the Mac awake without requiring the display to stay on.

One important limitation: a `launchd` service isn't a guarantee that every dependency will recover perfectly after every update or crash. Test a full reboot, a model-server restart and a network outage before relying on it for notifications.

### Scheduled jobs

Hermes also has a scheduler for recurring and one-time work. Scheduled jobs run through the gateway, and results can be delivered to configured destinations. ([Hermes scheduled tasks](https://hermes-agent.nousresearch.com/docs/user-guide/features/cron/?utm_source=chatgpt.com))

For example, you could ask Hermes to:

- Check the status of your local model server every few hours.
- Summarize AI developments each morning and send the result to Discord.
- Check a GitHub repository for new releases.
- Generate a daily homelab health report.
- Alert you if a scheduled diagnostic fails.

A critical detail: scheduled agent jobs require the gateway to be running. Also, an LLM-based scheduled task is not the same as a simple deterministic script. Use ordinary scripts or HA automations for predictable, safety-critical checks.

## 6. Other Hermes use cases that fit your environment

Given your local AI, networking, infrastructure and automation interests, I would prioritize these use cases.

### 1. Homelab operations assistant

Ask Hermes to summarize Docker container status, check local endpoints, interpret service logs and guide troubleshooting. Start with read-only commands and explicitly approved diagnostic scripts.

### 2. GitHub and development assistant

Monitor your ML platform and infrastructure repositories, summarize upstream releases, review diffs and draft change notes. Keep repository write access restricted until you have validated the workflow.

### 3. Local AI research assistant

Track new Gemma, Qwen and MLX releases; compare model requirements; summarize technical documentation; and maintain a collection of tested deployment recipes.

### 4. Home Assistant conversational operator

Query sensors, explain device state changes and invoke existing HA scripts. Let HA retain ownership of automation logic and safety rules.

### 5. Security and network operations helper

Summarize Wazuh alerts, investigate selected logs, review firewall configuration changes and prepare incident timelines. Start with access to exported logs and read-only diagnostics, not unrestricted firewall administration.

### 6. Personal intelligence briefing

Schedule a daily report covering local AI, cybersecurity, infrastructure, markets and geopolitics. Deliver it to Discord, with source links and a clear distinction between verified facts and interpretation.

For your trading interests, Hermes could help gather information, summarize filings and news, or analyze locally stored data. I would keep trade execution and brokerage credentials outside the initial agent setup.

## 7. The deployment I would build first

### Phase 1 — Working local assistant

1. Install Hermes Desktop from its official macOS package.
2. Install or update Ollama and test `gemma4:e4b-mlx`.
3. Configure Hermes to use the Ollama OpenAI-compatible endpoint at `http://127.0.0.1:11434/v1`.
4. Validate ordinary chat, context handling and tool calls with harmless tasks.

### Phase 2 — Discord and persistence

1. Create the Discord bot, restrict access to your user ID, and test private messages.
2. Install the Hermes Gateway LaunchAgent and verify it survives a reboot.
3. Create one scheduled job that sends a harmless test message to Discord.

### Phase 3 — Home Assistant

1. Install the HA plugin and create a dedicated access token.
2. Start with read-only entity queries and a narrow event watchlist.
3. Enable a small number of low-risk service calls only after testing.

### Phase 4 — Homelab integrations

Add GitHub monitoring, selected infrastructure diagnostics, scheduled research and Discord reporting. Consider delegating heavier inference to your RTX workstation later.

## Final recommendation

For your M6 Mac mini, I would start with Hermes Desktop + Ollama's MLX-enabled Gemma 4 E4B + Discord, then add Home Assistant once the gateway is stable.

This gives you a useful local assistant without immediately introducing multiple inference servers or unnecessary infrastructure. LM Studio remains an excellent alternative for GUI-based model experimentation, but I wouldn't install both servers on day one.

One final consideration: Hermes Agent's local inference can be private, but Discord is still a hosted service. Keep secrets out of chat, restrict the bot's users and permissions, and treat every tool-enabled agent as a privileged system that needs a deliberate security boundary.