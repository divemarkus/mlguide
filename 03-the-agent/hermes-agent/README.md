# Hermes Agent on Apple Silicon macOS

**Hermes Desktop • Local LLMs • Autonomous Agents • Always-On AI**

> A GUI-first guide to running Hermes Agent on an Apple Silicon Mac as a personal AI workstation or always-on homelab control plane. The Desktop application is the primary installation and management interface. CLI commands are retained only for optional administration, diagnostics, and automation.

**Documentation baseline:** October 30, 2026  
**Latest stable release checked:** Hermes Agent v0.22.5 (October 22, 2026)

---

## Table of Contents

1. [Overview](#overview)
2. [What Hermes Is](#what-hermes-is)
3. [Hermes Desktop: The Primary Interface](#hermes-desktop-the-primary-interface)
4. [Architecture](#architecture)
5. [Why Apple Silicon](#why-apple-silicon)
6. [Install Hermes Desktop](#install-hermes-desktop)
7. [First-Run Setup](#first-run-setup)
8. [Local Models Through the GUI](#local-models-through-the-gui)
9. [External and Remote Model Providers](#external-and-remote-model-providers)
10. [The Gateway and 24/7 Operation](#the-gateway-and-247-operation)
11. [Desktop Features and Agent Capabilities](#desktop-features-and-agent-capabilities)
12. [Skills, Plugins, Connectors, and MCP](#skills-plugins-connectors-and-mcp)
13. [Memory and Persistent State](#memory-and-persistent-state)
14. [Always-On Use Cases](#always-on-use-cases)
15. [Recommended Mac mini Architecture](#recommended-mac-mini-architecture)
16. [Hybrid Mac mini + RTX Workstation](#hybrid-mac-mini--rtx-workstation)
17. [Security Model](#security-model)
18. [Resource Planning](#resource-planning)
19. [Operations and Optional CLI](#operations-and-optional-cli)
20. [Deployment Scenarios](#deployment-scenarios)
21. [Troubleshooting](#troubleshooting)
22. [Recommended Configuration](#recommended-configuration)
23. [Summary](#summary)
24. [References](#references)

---

## Overview

[Hermes Agent](https://github.com/NousResearch/hermes-agent) is an autonomous AI agent developed by **Nous Research**. It is designed to do more than generate responses: it can plan multi-step work, use tools, work with files, interact with APIs, browse, run scheduled tasks, maintain memory, and communicate through supported messaging platforms.

Hermes is best understood as an **agent runtime**, with a model provider supplying the reasoning and language-generation capability.

Hermes Desktop makes that runtime accessible through a graphical application. It is not a separate chatbot implementation: Desktop, the Gateway, and the terminal interfaces use the same underlying agent state.

For an Apple Silicon deployment, a useful division of responsibilities is:

- **Hermes Desktop:** interactive GUI for chat, configuration, sessions, and management.
- **Hermes Gateway:** persistent backend for sessions, scheduled work, and messaging integrations.
- **Local or remote model server:** performs inference.
- **Tools, skills, plugins, and connectors:** give the agent controlled access to systems and workflows.

The Mac mini can therefore act as an always-available agent host, while a more powerful RTX workstation can provide larger-model inference when needed.

## What Hermes Is

A useful mental model:

```text
                         USER
                           |
                           v
                 +-------------------+
                 |   Hermes Agent    |
                 |                   |
                 | Reasoning         |
                 | Planning          |
                 | Context           |
                 | Memory            |
                 | Tool selection    |
                 | Skills            |
                 | Delegation        |
                 +---------+---------+
                           |
              +------------+------------+
              |            |            |
              v            v            v
          Model API      Tools        State
              |            |            |
              |       Shell / Files    |
              |       Browser / API   |
              |       MCP / Plugins   |
              |       Git / Docker    |
              |                       |
              +------------+----------+
                           |
                           v
                     ACTION / RESULT
```

The model is the reasoning engine. Hermes provides the surrounding agent loop: it selects tools, executes actions, observes results, manages context, and continues until the task is complete or requires user input.

Hermes can work with local models and supported hosted providers. It is not tied to one model family or inference engine.

## Hermes Desktop: The Primary Interface

Hermes Desktop is the recommended way to install and manage Hermes on an Apple Silicon Mac.

The important architectural point is that Desktop is a GUI for the **same Hermes Agent core** used by the Gateway and terminal interfaces. It shares configuration, API keys, sessions, skills, and memory. Work started in Desktop can be continued through another supported interface, and vice versa.

### Desktop versus other interfaces

| Interface | Intended use |
|---|---|
| **Hermes Desktop** | Primary GUI for chat, configuration, model selection, sessions, and agent management |
| Gateway | Persistent backend for sessions, scheduled jobs, and messaging |
| CLI | Optional terminal-based administration, diagnostics, scripting, and automation |
| TUI | Terminal chat interface |
| Webapp | Browser-based workspace served by the Gateway; distinct from the older admin dashboard |

For this guide, Desktop is the normal day-to-day interface. The CLI is not required for the standard macOS installation or ordinary GUI-based model setup.

### What Desktop changes

The Desktop application provides a more accessible workflow for:

- Chatting with Hermes and managing conversations.
- Selecting model providers and models.
- Installing and managing supported local models.
- Managing profiles and sessions.
- Configuring plugins, connectors, and integrations.
- Reviewing agent activity and tool execution.
- Working with files and project context.
- Managing Gateway-related functionality.

The precise layout and available controls can evolve between releases. Use the current in-app Settings and navigation labels rather than relying on screenshots from older builds.

## Architecture

Hermes is made up of several cooperating layers.

### 1. Desktop client

The GUI is the interactive control surface. It connects to the Gateway and presents the agent's sessions, configuration, and capabilities.

### 2. Agent core and Gateway

The Gateway is the persistent backend. It coordinates sessions and provides the runtime used by Desktop and supported messaging integrations. It can continue running after the Desktop window is closed.

### 3. Model provider

Hermes sends inference requests to a configured provider. Options include:

- Hermes-managed local llama.cpp runtime.
- An existing local llama.cpp server.
- Ollama through a compatible provider configuration.
- MLX-based servers such as oMLX through an OpenAI-compatible endpoint.
- Remote OpenAI-compatible endpoints.
- Supported hosted providers and model aggregators.

### 4. Tool system

Tools let Hermes interact with systems beyond the model API:

```text
Shell and command execution
Filesystem
Git and source repositories
Browser
HTTP and APIs
Computer use
MCP servers
Docker and sandbox backends
Plugins and custom integrations
```

Tool availability depends on the configured environment, permissions, plugins, and platform.

### 5. Skills

Skills package reusable instructions and workflows. A skill can describe how to perform a repeatable task, which tools to use, what checks to perform, and how to report the result.

Example:

```text
Skill: Docker Health Review

1. Check Docker daemon availability.
2. List running and stopped containers.
3. Identify unhealthy or restarting containers.
4. Inspect relevant logs.
5. Check resource utilization.
6. Summarize likely causes.
7. Recommend remediation.
8. Restart a service only when explicitly authorized.
```

### 6. Memory and session state

Hermes stores local configuration and agent state in its Hermes home directory. The exact directory layout can change, so use the current documentation before scripting against internal files.

A typical installation uses:

```text
~/.hermes/
```

Treat this directory as sensitive. It may contain configuration, session data, credentials or credential references, logs, skills, scheduled-job definitions, and other state.

---

## Why Apple Silicon

Apple Silicon is attractive for local inference because CPU and GPU share unified memory. This allows model weights and inference buffers to use a common memory pool rather than requiring all model data to fit in a discrete GPU's VRAM.

```text
             Apple Silicon SoC
        +--------------------------+
        |                          |
        |       Unified Memory     |
        |                          |
        |    CPU           GPU     |
        |     |             |      |
        |     +------┬------+      |
        |            |             |
        +------------+-------------+
                     |
               macOS / Hermes
```

The trade-off is that macOS, the agent, model weights, KV cache, runtime buffers, and other applications all compete for the same memory.

For local LLM workloads, unified memory capacity is usually more important than a small difference in CPU clock speed.

### Why a Mac mini works well

- Low idle power relative to a discrete-GPU workstation.
- Small footprint and quiet operation.
- Apple Silicon GPU acceleration through Metal.
- Unified-memory configurations suitable for local models.
- Fast internal storage.
- Wired Ethernet.
- Native macOS background-service support.
- Good fit for a continuously available agent host.

The Mac mini does not need to be the fastest inference machine in the lab. It can provide the agent, scheduling, memory, integrations, and control plane while another system handles larger inference jobs.

## Install Hermes Desktop

### Recommended installation path

1. Open the official [Hermes Desktop download page](https://hermes-agent.nousresearch.com/desktop).
2. Download the macOS installer for Apple Silicon.
3. Open the downloaded disk image.
4. Drag Hermes into Applications if prompted.
5. Launch Hermes Desktop from Applications.
6. Approve the normal macOS first-launch prompt if shown.
7. Complete the guided setup inside the app.

**Do not install Hermes through a terminal installer for this GUI-first deployment.** The Desktop installer is the primary installation method in this guide.

### Platform note

The official macOS Desktop build targets Apple Silicon. Intel Macs are not a supported macOS Desktop target. Check the official platform-support page before attempting deployment on other architectures.

### Version baseline

As checked on October 30, 2026, the latest stable GitHub release is **v0.22.5**, dated October 22, 2026. Release cadence is rapid; check the [official releases page](https://github.com/NousResearch/hermes-agent/releases) before updating this guide or pinning a production deployment.

## First-Run Setup

The exact onboarding sequence may change, but the general GUI workflow is:

1. Launch Hermes Desktop.
2. Follow the guided setup conversation.
3. Choose a provider.
4. If using a hosted provider, authenticate or enter the required API credentials through the app.
5. If using a local model, choose the local-model path.
6. Select a model that fits the Mac's memory.
7. Start a test conversation and confirm that the model responds.
8. Review the active profile, permissions, and available tools before enabling automation.

### Start with a working chat

Do not begin by configuring every integration. First confirm that a normal conversation works with one provider and one model.

Then add capabilities incrementally:

1. Model and provider.
2. Basic chat.
3. Files and workspace access.
4. Skills and plugins.
5. Connectors and MCP.
6. Gateway and messaging.
7. Scheduled jobs.
8. More powerful tools and automation.

This order makes troubleshooting much easier.

## Local Models Through the GUI

One of the most important changes in current Hermes Desktop is the managed local-model workflow.

Hermes can download and manage a supported llama.cpp runtime, select an appropriate build for the machine, and choose model variants based on hardware. This removes the need to manually install llama.cpp, download a GGUF file separately, or tune GPU layers and context settings for the standard managed path.

### GUI workflow

In Hermes Desktop:

1. Open **Settings**.
2. Open **Providers**.
3. Select **Local Models**.
4. Click **Install runtime**.
5. Wait for the runtime download, verification, and installation to complete.
6. Browse the model catalog.
7. Review the model's memory-fit and context information.
8. Select **Download**.
9. When the model is ready, select **Use**.
10. Start a new chat and confirm the local model is selected.

The local server is managed by Hermes. It starts and stops with Hermes as documented, and the Desktop UI provides the supported update path for the managed runtime.

### Model selection and memory fit

The model catalog evaluates models against the machine before download. Depending on the model and hardware, the UI can show whether it fits in GPU/unified memory, whether it requires system RAM spill, its context window, and the selected download size.

Prefer a model that fits comfortably in unified memory. Do not select a model solely because its weight file appears to fit: context state, runtime buffers, vision components, and concurrent workloads also consume memory.

### Finding additional models

The Local Models page includes a way to find models beyond the curated catalog. The app can search Hugging Face and evaluate candidate files against the machine. Community models may not carry the same validation status as curated models.

You can also add an existing GGUF model file through the model-management interface where supported. This links the file into the library rather than requiring a second full copy.

### What runs locally?

The managed local-model feature uses llama.cpp with Metal or CPU on macOS. It does not mean Hermes automatically uses Apple's Neural Engine.

After a model has been downloaded, local inference can run without sending prompts to a hosted model provider. Other features—such as web browsing, external APIs, messaging platforms, and remote tools—may still require network access.

### Manual inference servers remain optional

The managed runtime is the easiest starting point, not a restriction.

If you already operate Ollama, oMLX, or a separately managed llama.cpp server, configure it as a custom provider using its OpenAI-compatible endpoint. This is useful when you want to manage model lifecycle independently of Hermes.

Examples:

| Backend | Typical endpoint | Model format |
|---|---|---|
| llama.cpp server | `http://127.0.0.1:8080/v1` | GGUF |
| Ollama | `http://127.0.0.1:11434/v1` where compatible | Ollama-managed |
| oMLX | `http://127.0.0.1:8000/v1` | MLX |
| Remote local server | Your LAN endpoint | Depends on server |

Use the provider configuration in Desktop and test the endpoint. Avoid exposing inference APIs to the LAN unless authentication and firewall restrictions are in place.

### llama.cpp versus MLX/oMLX

| Backend | Strengths | Considerations |
|---|---|---|
| Hermes-managed llama.cpp | Simplest GUI setup; model/runtime management; GGUF ecosystem | Less manual control over runtime flags |
| Self-managed llama.cpp | Fine-grained control over context, KV cache, parallelism, and server settings | More operational work |
| Ollama | Convenient model lifecycle and broad ecosystem | Performance and feature behavior depend on model/runtime |
| oMLX | Apple Silicon-native MLX serving; OpenAI-compatible API | Requires separate setup and model compatibility checks |

For a first deployment, start with Hermes-managed local models. Add oMLX or another custom endpoint only when you have a specific performance, model-format, or operational reason.

## External and Remote Model Providers

Hermes can use hosted providers as well as local models. This is useful when a task benefits from a model that is too large or slow for the Mac.

Typical choices include:

- Nous Portal and supported Nous model access.
- OpenRouter and supported model aggregators.
- OpenAI-compatible providers.
- Other providers listed in the current Hermes provider catalog.

Configure providers in the Desktop application's provider/model settings. Use the app's authentication flow where available, and do not paste credentials into chat messages.

### Hybrid provider strategy

A practical approach is to use a local model for routine, private, and low-cost tasks, then switch to a stronger hosted or LAN-hosted model for complex reasoning or coding.

Be aware that switching providers changes where prompts and context are processed. A local agent interface does not make a cloud provider local.

## The Gateway and 24/7 Operation

The Gateway is the persistent backend that makes Hermes more than an app that only works while a chat window is open.

It supports the runtime used by Desktop, sessions, scheduled jobs, and messaging integrations. Current Desktop architecture can attach to a running Gateway or start one when needed. The Gateway is not inherently tied to the lifetime of the Desktop window; it can remain running after the app is closed.

### Desktop-first Gateway management

Use the Gateway controls and status information exposed in Hermes Desktop Settings. The app is the preferred place to inspect and manage the local runtime.

For an always-on deployment:

1. Complete a working Desktop setup first.
2. Confirm that the Gateway is running.
3. Use the app's Gateway controls to enable or install persistent background operation where offered.
4. Confirm the Gateway reports a healthy state.
5. Configure messaging integrations and scheduled jobs only after the base Gateway works.
6. Reboot the Mac and verify that the Gateway returns.
7. Close the Desktop window and verify that scheduled and messaging functions remain available.

The precise labels can vary by release. The important distinction is between the **Desktop window** and the **persistent Gateway service**.

### macOS launchd

On macOS, a persistent Hermes Gateway can be supervised by `launchd`. The service definition is normally stored under the user's LaunchAgents directory.

Typical service path:

```text
~/Library/LaunchAgents/ai.hermes.gateway.plist
```

The Desktop app should be the normal management interface. The optional CLI commands below are useful when diagnosing service state or working remotely.

### 24/7 Mac configuration

Recommended macOS settings and operational practices:

- Prevent automatic system sleep while connected to power.
- Keep Ethernet connected.
- Configure automatic restart after power failure where supported.
- Use a UPS if the Mac hosts important automations.
- Keep macOS updates deliberate and schedule reboots.
- Maintain free SSD space for models, logs, and agent state.
- Monitor memory pressure and model-server health.
- Review Gateway logs after upgrades or unexpected restarts.
- Test the service after a full reboot, not only after logging out and back in.

A persistent Gateway does not guarantee that every model provider or external integration is always available. Monitor each dependency independently.

## Desktop Features and Agent Capabilities

Hermes Desktop is the control surface; the agent's actual capabilities depend on enabled tools, permissions, provider support, and platform.

### Chat and sessions

- Maintain multiple conversations.
- Resume previous sessions.
- Work across supported profiles.
- Continue work through another Hermes interface because the state is shared.

### Files and workspaces

Hermes can work with files and project directories when the relevant access is configured. Keep the working directory scoped to the task. Avoid giving the agent unrestricted access to personal files or system locations.

### Browser and computer use

Where supported and enabled, Hermes can use browser and computer-interaction tools. These capabilities should be treated as privileged access: a task that can click buttons or operate a logged-in browser may be able to change real account data.

### Scheduled jobs

Hermes supports scheduled tasks through its Gateway runtime. Examples include periodic research, repository checks, and homelab health reports.

### Messaging

Supported messaging integrations can provide a remote interface to the agent. The Gateway must remain available for these workflows.

### Delegation and subagents

Hermes can delegate work to subagents where configured. Delegation may use different models or profiles. Review permissions and provider routing before allowing subagents to execute tools.

## Skills, Plugins, Connectors, and MCP

These mechanisms extend Hermes, but they serve different purposes.

| Mechanism | Purpose |
|---|---|
| Skills | Reusable instructions and workflows |
| Plugins | Installable extensions that can add tools, hooks, themes, and integrations |
| Connectors | Connect Hermes to external services and accounts |
| MCP | Protocol for exposing tools and resources from external servers |
| Custom tools | User-defined integrations and operations |

Use the Desktop interface and plugin catalog where possible to discover, install, configure, and update extensions. Review the permissions and dependencies requested by a plugin before approving installation.

### Example integrations

- GitHub repository review.
- Home Assistant.
- Docker and container monitoring.
- Local filesystem and project workflows.
- Browser automation.
- External APIs.
- Messaging platforms.

A connector or MCP server may require credentials and network access. Keep those permissions scoped to the minimum needed.

## Memory and Persistent State

Hermes can retain information across sessions through its memory and session systems. It also supports skills that can be created and refined over time.

This is useful for an always-on assistant, but persistent state should be treated as operational data:

- Back up the Hermes home directory using a method that protects secrets.
- Do not commit `.env`, API keys, session databases, or private logs to Git.
- Review what information the agent is asked to retain.
- Keep separate profiles for materially different trust boundaries.
- Test restore procedures before relying on the system.

Do not build external scripts around undocumented internal file names or database schemas. Use supported UI or documented interfaces wherever possible.

## Always-On Use Cases

The Mac mini can continue working while the user is away, provided the Gateway, provider, tools, and network dependencies remain available.

### 1. Daily AI and technology research

Example scheduled task:

```text
Every morning at 07:00:

Research important developments in:
- Local LLMs and inference
- AI agents and agent frameworks
- Apple Silicon AI
- Model releases and benchmarks
- Security and infrastructure

Prioritize primary sources and release notes.
Separate confirmed facts from speculation.
Produce a concise briefing with links and why each item matters.
```

### 2. GitHub repository monitoring

```text
Every morning:

Review selected repositories for:
- New issues
- Pull requests
- Failed CI workflows
- Security advisories
- Dependency updates
- Significant upstream releases

Summarize only actionable changes.
Do not merge, close, or modify issues without approval.
```

### 3. Homelab monitoring

```text
Every 6 hours:

Check approved homelab systems for:
- Host availability
- Docker container health
- Disk utilization
- Memory pressure
- Network reachability
- Selected service health

Collect relevant logs for abnormal conditions.
Report likely causes and recommended actions.
Do not restart services without approval.
```

### 4. Docker operations assistant

Hermes can be given access to Docker through an appropriately restricted tool environment.

Potential tasks:

- List containers and health states.
- Inspect container logs.
- Identify restart loops.
- Summarize resource consumption.
- Compare deployed image tags with approved update sources.

Avoid unrestricted Docker socket access. Control of the Docker daemon is effectively powerful host-level access.

### 5. Home Assistant

A possible architecture:

```text
Home Assistant
      ^
      | API / MCP / approved integration
      |
Hermes Gateway
      |
Hermes Agent
      |
Configured model provider
```

Potential tasks:

- Summarize home status.
- Explain sensor anomalies.
- Identify unavailable devices.
- Propose automations.
- Execute approved actions.

Start with read-only access. Add control actions only after testing and defining approval boundaries.

### 6. Personal assistant through messaging

Hermes can be reachable through supported messaging integrations, such as Telegram, Discord, or Slack, depending on the current connector/plugin support and configuration.

This is useful when the Mac mini is unattended. Protect bot accounts and restrict who can interact with the agent.

## Recommended Mac mini Architecture

For an always-on Apple Silicon host:

```text
                         LAN
                          |
                 +------------------+
                 |     Mac mini     |
                 |     macOS        |
                 +--------+---------+
                          |
                 +--------v---------+
                 | Hermes Desktop   |
                 | GUI / Settings   |
                 +--------+---------+
                          |
                 +--------v---------+
                 | Hermes Gateway   |
                 | Persistent agent |
                 +---+----------+---+
                     |          |
                     v          v
               Model Provider  Tools
                     |          |
              +------+----+     +----------------+
              |           |                      |
              v           v                      v
         Local model   Remote model          Integrations
         llama.cpp     LAN / hosted          GitHub / HA
         Metal GPU     API                   Docker / APIs
```

Recommended responsibilities:

- Desktop for interactive configuration and management.
- Gateway for persistent sessions, scheduled jobs, and messaging.
- Local model for private and routine inference.
- RTX workstation for larger models or higher-throughput inference.
- Restricted tool environments for shell, Docker, filesystem, and network actions.

## Hybrid Mac mini + RTX Workstation

A hybrid design is particularly useful when the Mac mini is the always-on control plane and an NVIDIA workstation supplies heavier inference.

```text
                         YOUR LAN
                            |
              +-------------+-------------+
              |                           |
              v                           v
       +--------------+           +------------------+
       |   Mac mini   |           | RTX Workstation  |
       |    macOS     |           | Ubuntu           |
       |              |           |                  |
       | Hermes       |  OpenAI   | Ollama / vLLM /  |
       | Desktop      |  API      | other model API  |
       | Gateway      +---------->+                  |
       |              |           | Larger models    |
       | Small local  |           | Heavy inference  |
       | models       |           |                  |
       +------+-------+           +------------------+
              |
       +------+---------+
       |        |       |
       v        v       v
     GitHub   Home    Homelab
              Assistant
```

The Mac mini remains available even when the RTX workstation is powered down. When the workstation is online, Hermes can use its model endpoint for tasks that benefit from larger models.

Keep the model endpoint private to the LAN or VPN. Use authentication and firewall rules; do not expose an unauthenticated inference API to the internet.

## Security Model

An autonomous agent should be treated as a privileged automation system, not simply a chatbot.

Hermes may be granted access to:

- Files and directories.
- Shell commands.
- Git repositories.
- Docker.
- Browsers and logged-in sessions.
- Network services.
- API credentials.
- Messaging systems.
- Home automation.

The agent's permissions should be **smaller than the permissions of the human administrator**.

### Recommended controls

1. Use a dedicated macOS account for the always-on agent where practical.
2. Restrict filesystem access to explicit workspaces.
3. Prefer read-only access for monitoring tasks.
4. Use separate API credentials with minimum required scopes.
5. Keep secrets out of prompts, Git repositories, and logs.
6. Require approval for destructive or externally visible actions.
7. Restrict inbound messaging to known users.
8. Keep the Gateway and model APIs off public interfaces unless protected.
9. Use a Docker sandbox or other isolation backend for higher-risk command execution.
10. Review plugin dependencies and requested permissions.

### Docker sandbox

A sandboxed terminal backend can reduce the impact of command execution:

```text
Hermes Agent
     |
     v
Restricted terminal backend
     |
     v
Sandbox container
     |
     +-- CPU / memory limits
     +-- Restricted filesystem
     +-- Restricted network
     +-- No unnecessary credentials
```

A sandbox is not automatically secure merely because it uses Docker. Avoid mounting the host filesystem or Docker socket into the sandbox unless absolutely necessary.

### Privacy boundaries

A local model keeps inference on the local machine after the model has been downloaded. However, Hermes can still access the internet for browser searches, APIs, messaging, and remote providers.

For a privacy-sensitive deployment, explicitly decide which data may be sent to:

- Hosted model providers.
- Web search providers.
- Messaging platforms.
- Third-party APIs.
- Plugin and MCP services.

## Resource Planning

The main hardware constraint for local inference is memory.

Memory is shared by:

- macOS.
- Hermes Desktop and Gateway.
- Model weights.
- KV cache.
- Inference runtime buffers.
- Other applications and services.

The model file size alone is not a reliable measure of whether a model will run well. Context length, cache precision, runtime buffers, and concurrent sessions all matter.

### Practical memory tiers

| Unified memory | Practical role |
|---:|---|
| 16 GB | Small local models and light single-user workloads |
| 24 GB | More comfortable small-model agent host |
| 32 GB | Strong general-purpose local agent; 9B–14B class models depending on context and quantization |
| 48 GB | More headroom for larger models, longer context, and concurrent workloads |
| 64 GB+ | Larger local models and more simultaneous workloads |

These are planning guidelines, not guarantees. Use the model-fit information shown by Hermes Desktop for the exact model/runtime combination.

### Suggested hardware

| Component | Recommendation |
|---|---|
| Memory | 32 GB minimum for a capable local agent host; more is preferable |
| Storage | 1 TB recommended if keeping several models locally |
| Network | Wired Ethernet |
| Power | UPS for important always-on workflows |
| Cooling | Ensure adequate ventilation |
| OS | Supported macOS version for the current Desktop release |

### Storage layout

A practical arrangement:

```text
Mac mini internal SSD
|
+-- Hermes application
+-- Hermes state and configuration
+-- Active local models
+-- Runtime files
+-- Logs and session data

External Thunderbolt / USB4 storage
|
+-- Model archive
+-- Backups
+-- Large datasets
```

Keep frequently used models on fast storage. Back up agent state and configuration, but ensure backups are encrypted and access-controlled.

## Operations and Optional CLI

The GUI is the primary management path. The following commands are **not installation instructions**. They are optional tools for an administrator who wants to inspect or troubleshoot an already-installed Hermes environment.

Open Terminal only when a GUI status page does not provide enough information or when automating an administrative check.

### Basic diagnostics

```bash
# Show available Hermes commands
hermes --help

# Show Gateway status
hermes gateway status

# List configured profiles and Gateway state
hermes gateway list

# Follow Gateway logs
tail -f ~/.hermes/logs/gateway.log
```

### Gateway lifecycle

```bash
# Start the installed background service
hermes gateway start

# Stop it
hermes gateway stop

# Restart it
hermes gateway restart

# Inspect status
hermes gateway status
```

Use the Desktop Gateway controls for normal operation. These commands are useful for remote administration, scripts, and troubleshooting.

### Scheduled jobs

```bash
# List scheduled jobs
hermes cron list
```

Create and manage scheduled work through the supported Hermes interface for the installed release. Verify the job's schedule, timezone, provider, permissions, and destination before enabling it.

### Configuration and logs

The Hermes home directory is typically:

```text
~/.hermes/
```

Do not edit internal configuration files casually when the same setting is exposed in Desktop. Prefer the GUI so that validation and supported defaults are applied.

When troubleshooting, collect:

- Hermes Desktop version.
- Gateway status.
- Relevant Gateway log entries.
- Provider and model name.
- macOS version and hardware.
- Whether the failure affects local inference, remote inference, or only a specific tool.

Redact API keys, tokens, session identifiers, and personal data before sharing logs.

## Deployment Scenarios

### Scenario 1 — Desktop-only personal assistant

```text
macOS
  |
Hermes Desktop
  |
Cloud provider or local model
```

Best for:

- Learning Hermes.
- Interactive personal assistant use.
- Testing models and plugins.
- Minimal administration.

### Scenario 2 — Always-on Mac mini

```text
macOS
  |
Hermes Desktop (management)
  |
Hermes Gateway (persistent)
  |
Local model and integrations
```

Best for:

- Scheduled research.
- GitHub monitoring.
- Messaging integrations.
- Home Assistant.
- Homelab monitoring.

### Scenario 3 — Mac mini with oMLX

```text
Hermes Desktop / Gateway
          |
          v
OpenAI-compatible endpoint
          |
          v
         oMLX
          |
          v
       MLX / Metal
          |
          v
    Apple Silicon GPU
```

Best for:

- MLX model experimentation.
- A separately managed inference server.
- Testing Apple Silicon inference performance.

This is an advanced alternative to the managed llama.cpp runtime, not a prerequisite for Hermes.

### Scenario 4 — Mac mini + RTX workstation

Use the Mac mini as the always-on agent/control plane and the RTX workstation as an optional inference server for larger models.

Best for:

- Keeping agent services available at low idle power.
- Running larger models only when required.
- Separating automation from heavy inference.
- Keeping inference traffic inside the LAN.

## Troubleshooting

| Symptom | Checks |
|---|---|
| Desktop opens but chat fails | Confirm provider authentication, selected model, and Gateway health |
| Local model does not appear | Check Local Models page and runtime installation status |
| Model download stalls | Check network, disk space, and the download job's pause/resume state |
| Model is too large | Select a smaller model/quantization or reduce competing memory use |
| First response is slow | Allow for model loading and prompt prefill; check memory pressure |
| Gateway is offline | Inspect Gateway status and logs; verify background service state |
| Scheduled jobs do not run | Confirm Gateway remains running, job schedule/timezone, and provider availability |
| Messaging bot is unavailable | Check Gateway, bot credentials, pairing/authorization, and platform status |
| Remote model cannot connect | Check endpoint URL, API path, authentication, DNS, and firewall rules |
| Tool execution fails | Review tool permissions, sandbox configuration, working directory, and logs |

### Upgrade discipline

Hermes releases frequently. Before upgrading an always-on host:

1. Review the official release notes.
2. Back up Hermes state and configuration.
3. Check provider and plugin compatibility.
4. Upgrade during a maintenance window.
5. Verify Desktop launch and a normal chat.
6. Verify Gateway health.
7. Test one scheduled task and one messaging integration.
8. Confirm local inference still works.

Do not assume that the Desktop installer, CLI package, Docker image, and other distribution channels always publish at exactly the same time. Follow the update mechanism for the installation channel actually in use.

## Recommended Configuration

For an always-on Apple Silicon deployment:

| Component | Recommendation |
|---|---|
| Hardware | Apple Silicon Mac mini |
| Memory | 32 GB minimum; 48–64 GB preferred if available |
| Storage | 1 TB recommended |
| Network | Wired Ethernet |
| Interface | Hermes Desktop |
| Agent runtime | Hermes Agent |
| Persistent backend | Hermes Gateway |
| Gateway supervision | macOS `launchd` through the supported Hermes service workflow |
| Initial inference | Hermes-managed local llama.cpp runtime |
| Alternative inference | oMLX, Ollama, or another OpenAI-compatible endpoint |
| Starting model | Choose a model marked as fitting the Mac in Local Models |
| Larger inference | RTX Ubuntu workstation over the LAN |
| Extensions | Skills, plugins, connectors, and MCP as required |
| Automation | Gateway scheduled jobs |
| Remote interaction | Supported messaging integrations |
| Security | Least privilege, restricted tools, approval for destructive actions |

### Recommended rollout

1. Install Hermes Desktop.
2. Complete onboarding and verify one working chat.
3. Install the managed local runtime from **Settings → Providers → Local Models**.
4. Download and select a model that fits the Mac.
5. Test a few ordinary agent tasks.
6. Configure the Gateway for persistent operation.
7. Add one integration at a time.
8. Add scheduled jobs after confirming Gateway reliability.
9. Add remote RTX inference only when a larger model is needed.
10. Apply least-privilege controls before granting access to Docker, shell, home automation, or external accounts.

## Summary

Hermes has moved beyond its earlier CLI-first identity. **Hermes Desktop is now the recommended GUI entry point**, while the Gateway supplies the persistent backend and the CLI remains available for advanced administration.

For an Apple Silicon Mac mini, the simplest starting point is:

- Install Hermes Desktop from the official site.
- Configure a provider through the GUI.
- Use the managed Local Models page for local llama.cpp inference.
- Verify the Gateway.
- Enable persistent operation for scheduled tasks and messaging.
- Add skills, plugins, connectors, and tools gradually.
- Keep privileged actions behind explicit approval.

The most useful long-term architecture is to treat the Mac mini as a private AI control plane: it hosts Hermes, persistent state, scheduling, and integrations, while local or LAN-connected inference backends provide the model capacity.

---

## References

- [Hermes Desktop — official documentation](https://hermes-agent.nousresearch.com/docs/user-guide/desktop)
- [Hermes Desktop — download page](https://hermes-agent.nousresearch.com/desktop)
- [Hermes Agent — official GitHub repository](https://github.com/NousResearch/hermes-agent)
- [Hermes Agent — releases](https://github.com/NousResearch/hermes-agent/releases)
- [Local Models — official documentation](https://hermes-agent.nousresearch.com/docs/user-guide/local-models)
- [Run Local LLMs on Mac](https://hermes-agent.nousresearch.com/docs/guides/local-llm-on-mac)
- [Run Hermes Locally with Ollama](https://hermes-agent.nousresearch.com/docs/guides/local-ollama-setup)
- [Platform Support](https://hermes-agent.nousresearch.com/docs/getting-started/platform-support)
- [Messaging Gateway](https://hermes-agent.nousresearch.com/docs/user-guide/messaging)
- [CLI Commands Reference](https://hermes-agent.nousresearch.com/docs/reference/cli-commands)

*Version note: This guide was checked on October 30, 2026. Hermes is actively developed; verify the official documentation and release notes before applying version-specific procedures.*
