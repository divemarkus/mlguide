# Hermes Agent

**Open-source autonomous AI agent platform by Nous Research**

> Hermes combines an agent runtime, model providers, tools, persistent memory, reusable skills, automation, and multiple interfaces. Its native Desktop application includes managed local-model inference through llama.cpp. Official Hermes Mobile is in beta; a separate third-party Android app named Hermes Agent is available on Google Play and is identified below to avoid confusion.

**Research date:** November 10, 2026  
**Latest stable core release verified:** `v0.23.1` — November 9, 2026  
**Official repository:** https://github.com/NousResearch/hermes-agent  
**Official website:** https://hermes-agent.nousresearch.com/

---

## Contents

- [Overview](#overview)
- [Current release status](#current-release-status)
- [Architecture](#architecture)
- [Hermes Desktop](#hermes-desktop)
- [Native local model management](#native-local-model-management)
- [Model providers and inference](#model-providers-and-inference)
- [Agent capabilities](#agent-capabilities)
- [Memory and learning](#memory-and-learning)
- [Skills, plugins, and MCP](#skills-plugins-and-mcp)
- [Bots, group chats, and delegation](#bots-group-chats-and-delegation)
- [Gateway and Webapp](#gateway-and-webapp)
- [Mobile applications: iOS and Android](#mobile-applications-ios-and-android)
- [Platform support](#platform-support)
- [Security and privacy](#security-and-privacy)
- [Configuration and persistent data](#configuration-and-persistent-data)
- [Release channels and updates](#release-channels-and-updates)
- [Known limitations and distinctions](#known-limitations-and-distinctions)
- [References](#references)

---

## Overview

Hermes Agent is an open-source autonomous AI agent developed by **Nous Research**. It is designed to plan and execute multi-step tasks, use tools, inspect results, maintain context, and improve reusable workflows over time.

Hermes is more than a chat interface or inference server. It provides the agent loop and the surrounding infrastructure:

- Reasoning, planning, and tool selection.
- Tool execution and result handling.
- Persistent sessions and memory.
- Reusable skills and a learning loop.
- Local and hosted model providers.
- Native Desktop applications.
- Managed local inference through llama.cpp.
- Plugins and Model Context Protocol (MCP).
- Specialist bots, group chats, and subagent delegation.
- Scheduled jobs and persistent Gateway operation.
- A browser-accessible workspace.
- Official Hermes Mobile beta for iOS and Android.

The model supplies inference. Hermes supplies the agent runtime, tools, state, memory, and execution workflow.

## Current release status

### Latest stable core release

| Item | Status |
|---|---|
| Latest stable release checked | `v0.23.1` |
| Release date | November 9, 2026 |
| Previous major release | `v0.23.0 — The Hearth Release` |
| Desktop | Native application for macOS, Windows, and Linux |
| Local inference | Managed llama.cpp runtime |
| Official mobile app | iOS and Android beta |
| License | MIT |
| Repository | [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) |

`v0.23.1` is a stable patch release. Its primary published fix addresses the plugin catalog exceeding the 2 MiB limit accepted by older clients. Those clients could silently fall back to a bundled, stale catalog. The limit was raised to 16 MiB so the live catalog can be used again.

The release notes report approximately 618 merged PRs since `v0.23.0`. The full curated changelog for that development window is deferred to `v0.24.0`.

**Version distinction:** the core Agent release, standalone Desktop package, Microsoft Store build, and mobile beta have separate packaging and update schedules. A new core release does not necessarily mean every Desktop installer or mobile build has changed on the same day.

Source: [Hermes Agent releases](https://github.com/NousResearch/hermes-agent/releases)

### v0.23.0 — The Hearth Release

The November 5, 2026 release introduced a major consolidation of the agent architecture:

- The Desktop workspace can be served in a browser through the Gateway.
- A single Gateway owns each conversation/session.
- Desktop, Webapp, CLI, TUI, editors, bots, and scheduled work attach to the shared session architecture.
- Desktop can maintain connections to multiple Hermes instances.
- Group Chats route their own conversations.
- Plugin catalog and plugin update behavior were expanded.
- Delegation became more configurable.
- The plugin catalog grew from approximately 600 to more than 1,050 entries.
- Memory and long-lived Gateway performance received further work.

The central change is a unified agent environment with multiple interfaces, rather than separate agent processes and independent conversation histories for each interface.

Source: [v0.23.0 release](https://github.com/NousResearch/hermes-agent/releases/tag/v0.23.0)

---

## Architecture

```text
                         USER
                           |
          +----------------+----------------+
          |                |                |
          v                v                v
       Desktop           Webapp          Mobile
          |                |                |
          +----------------+----------------+
                           |
                           v
                    HERMES GATEWAY
                           |
                           v
                    HERMES AGENT CORE
          +----------------+----------------+
          |                |                |
          v                v                v
       Reasoning         Memory           Skills
       Planning          Sessions         Learning
       Delegation        Profiles         Context
          |                |                |
          +----------------+----------------+
                           |
                           v
                     TOOL EXECUTION
          +----------------+----------------+
          |                |                |
          v                v                v
       Built-in          Plugins           MCP
        Tools           Extensions        Servers
          |                |                |
          +----------------+----------------+
                           |
                           v
                    MODEL PROVIDERS
                           |
              +------------+------------+
              |                         |
              v                         v
        Local inference            Hosted APIs
        llama.cpp                  Supported providers
```

| Component | Responsibility |
|---|---|
| Agent core | Reasoning, planning, context, tool selection, execution |
| Model provider | Language and multimodal inference |
| Gateway | Persistent runtime, sessions, scheduling, shared state |
| Desktop | Native graphical interface and configuration |
| Webapp | Browser-accessible workspace |
| Mobile | Official mobile client for a Hermes environment |
| Memory | Persistent contextual information |
| Skills | Reusable procedural knowledge |
| Plugins | Extensible tools, hooks, interfaces, and integrations |
| MCP | Standardized access to external tools and resources |

---

## Hermes Desktop

Hermes Desktop is the native graphical application for Hermes Agent. It uses the same agent core and configuration as the Gateway and terminal interfaces. It is not a separate lightweight chatbot.

### Desktop capabilities

- Conversations and session management.
- Provider and model configuration.
- Native local model management.
- Profiles and agent configuration.
- Skills and capabilities.
- Plugins and MCP servers.
- Gateway settings and status.
- Scheduled jobs.
- Files, artifacts, and previews.
- Git review and development workflows.
- Tool execution and approval workflows.
- Group Chats and specialist bots.
- Security review workflows exposed by installed plugins.

### Shared state

Desktop, Gateway, and other supported interfaces use the same underlying Hermes state, including configuration, provider credentials, sessions, skills, memory, profiles, and tool settings.

A conversation can be continued through another supported interface because the Gateway owns the session.

### Desktop platforms

The official Desktop documentation lists:

- macOS — Apple Silicon.
- Windows — native application.
- Linux — supported distributions.

The macOS Desktop package is Apple Silicon-only; Intel macOS is not listed as a supported Desktop target.

Official documentation: [Hermes Desktop](https://hermes-agent.nousresearch.com/docs/user-guide/desktop)

---

## Native local model management

Hermes Desktop includes a managed local-model workflow built around **llama.cpp**.

Hermes can install or activate its pinned inference runtime, evaluate models against the machine's hardware, select a compatible build and quantization, and manage the local inference server.

**A separately installed inference runner is not required for the standard local-model workflow.**

### GUI workflow

1. Open **Settings → Providers → Local Models**, or select **Run models locally** during onboarding.
2. Select **Install runtime**.
3. Hermes installs or activates the pinned llama.cpp runtime appropriate to the detected hardware.
4. Browse the model catalog.
5. Select **Download**.
6. Select **Use** to make the model available to new chats.

The runtime is managed by Hermes. It starts and stops with the application, and its configuration persists across application restarts. A hosted provider can be selected again through the model picker.

### What Hermes manages

| Feature | Behavior |
|---|---|
| Runtime installation | Activates a bundled runtime when available or installs managed components |
| Runtime selection | Chooses a supported build for the detected platform and hardware |
| Runtime integrity | Uses pinned components and SHA-256 verification |
| Model catalog | Displays curated models and hardware-specific fit information |
| Quantization | Selects a suitable quality/size build for the available hardware |
| Memory estimation | Accounts for weights, context, runtime buffers, vision projector, and MTP |
| Context sizing | Starts with a context window that fits and can grow toward the model's native maximum |
| Idle unloading | Unloads idle models after 15 minutes |
| Downloads | Supports pause/resume for supported engine and model downloads |
| Model discovery | Curated catalog plus Hugging Face search |
| Existing GGUF files | Can link an existing local GGUF file into the model library |
| Activation | Starts the managed server and selects the model for new chats |

### Hardware-aware model selection

The model catalog presents information such as:

- Estimated memory fit.
- Initial and maximum context window.
- Hardware-specific download size.
- Quantization/build selection.
- Whether the model fits in GPU memory or requires system RAM spill.

The documented fit indicators are:

- **Green:** fits in GPU memory.
- **Amber:** uses system RAM and may run more slowly.
- **Red:** too large for the current machine.

Hermes recommends a high-quality model that fits in GPU or unified memory and targets a predicted performance floor where possible. This is an estimate, not a benchmark guarantee.

### Memory management

Hermes estimates more than model-file size. Its calculations include:

- Model weights.
- Context/KV state.
- Runtime buffers.
- Vision projector.
- Multi-token prediction (MTP) buffers.
- Other launch-time allocations.

Models start with a context window that fits the available memory. Context can grow as the conversation requires, subject to the model's native maximum and available resources.

When a model exceeds GPU memory, Hermes may place some weights in system RAM. This can preserve functionality but reduce performance. If a larger context cannot fit, generation becomes too slow, or the model reaches its native context maximum, conversation compression is used rather than assuming the server accepted an unsupported context.

Idle models are unloaded after 15 minutes and reloaded when needed.

### Runtime and download integrity

The Local Models documentation describes a pinned runtime-component process:

- Engine components are downloaded from URLs and SHA-256 pins in `pm/lock.json`.
- Model weights, split GGUF parts, vision projectors, and draft models use the managed downloader.
- Partial downloads are retained in a writable cache.
- Range-capable hosts allow missing byte ranges to resume.
- Completed files are reused.
- Engine archives are verified before activation.

### Hardware backends

The managed runtime supports backend families where the platform/device combination is supported:

| Backend | Hardware / platform |
|---|---|
| Metal | macOS / Apple Silicon |
| CUDA | Supported NVIDIA GPUs |
| Vulkan | Supported x64 GPU targets and Linux ARM64 configurations |
| HIP / ROCm | Explicitly selected supported x64 configurations |
| CPU | Fallback where supported |

Automatic backend selection prefers CUDA for NVIDIA and Vulkan for supported AMD/Intel GPU configurations, then falls back to an available supported backend. Driver and platform requirements apply.

### External inference servers

The integrated runtime is the standard Desktop workflow, not an exclusive restriction.

Hermes can detect an already-running `llama-server` and use it instead of starting its own. It can also connect to a custom OpenAI-compatible endpoint. These are optional advanced configurations; they are not prerequisites for local inference in Hermes Desktop.

### Local inference and privacy

After the runtime and model have been downloaded, local inference can run without a hosted model account, API key, or network access for inference.

This applies to local model inference. Web retrieval, hosted providers, external APIs, and other network-dependent features still require connectivity.

Official documentation: [Local Models](https://hermes-agent.nousresearch.com/docs/user-guide/local-models)

---

## Model providers and inference

Hermes separates the agent runtime from the model provider.

### Local inference

The managed local-model path uses llama.cpp and GGUF model builds, selecting a supported acceleration backend for the detected hardware.

### Hosted and API-based inference

Hermes also supports hosted providers and compatible API endpoints. Available providers and model catalogs evolve over time.

The Desktop provider interface manages provider credentials, model selection, and custom endpoints. Custom endpoints support API-mode selection, including automatic detection, Chat Completions, Responses API, and Anthropic Messages.

### Provider flexibility

Changing the model provider does not replace the Hermes agent system. Memory, skills, tools, and sessions remain part of Hermes and are not tied to one inference engine.

---

## Agent capabilities

Hermes operates through an iterative agent loop:

```text
Goal
 |
 v
Understand request
 |
 v
Plan work
 |
 v
Select tools
 |
 v
Execute action
 |
 v
Observe output
 |
 v
Evaluate result
 |
 +------> Continue / delegate
 |
 v
Complete or request approval
```

### Reasoning and planning

Hermes can decompose complex requests into steps, maintain task context, decide when tools are needed, and continue based on tool results.

### Tool execution

Depending on platform, profile, permissions, and installed extensions, tools can include:

- Shell and command execution.
- Filesystem operations.
- Git and repository operations.
- Browser interaction.
- Web search and extraction.
- Computer use.
- Image and document handling.
- HTTP and API calls.
- MCP-provided tools.
- Plugin-defined tools.
- Sandboxed terminal execution.

### Browser and computer use

Hermes supports browser and computer-use workflows where the corresponding capability is available and configured. These tools can interact with websites and supported desktop environments.

Computer-use access should be treated as privileged because it may operate inside authenticated user sessions.

### Scheduled automation

Scheduled jobs are managed through the Gateway. They can execute recurring or one-time workflows, retain results, and deliver outputs to configured destinations. The scheduler is part of the persistent runtime, not dependent on keeping a chat window open.

### Files and artifacts

Hermes can work with files, project workspaces, and generated artifacts where the relevant tools and permissions are enabled. The Desktop/Webapp workspace includes file browsing, previews, and related workflows.

### Multimodal capabilities

Image input, audio, document handling, and other multimodal features depend on the selected model and enabled tools/providers. Not every local model supports every modality.

---

## Memory and learning

Hermes emphasizes persistent memory and a learning loop.

### Persistent memory

- **Sessions** preserve interaction history.
- **Memory** stores selected contextual knowledge for future use.
- **Skills** preserve reusable procedures.

### Learning loop

Hermes can create skills from experience, improve skills during use, and persist knowledge that may be useful later.

```text
Perform task
    |
    v
Observe outcome
    |
    v
Identify reusable knowledge
    |
    v
Create or update skill
    |
    v
Persist knowledge
    |
    v
Reuse in future tasks
```

This is a procedural learning system. It does not mean Hermes automatically changes the underlying model weights during normal use.

Session management and conversation compression help maintain context during long-running interactions.

---

## Skills, plugins, and MCP

### Skills

Skills are reusable procedures that teach Hermes how to perform a workflow. They can contain instructions, decision rules, tool guidance, validation steps, expected outputs, and supporting files.

Example:

```text
Skill: Infrastructure Health Review

1. Check approved hosts and services.
2. Collect service and resource status.
3. Identify abnormal conditions.
4. Inspect relevant logs.
5. Determine likely causes.
6. Separate confirmed findings from hypotheses.
7. Produce an actionable report.
8. Require approval before making changes.
```

Hermes can create and improve skills as part of its learning workflow. The project documents compatibility with the Agent Skills open standard.

### Plugins

Plugins extend or modify Hermes without requiring changes to the agent core. They can provide:

- Tools and integrations.
- Hooks and workflows.
- Themes and interfaces.
- Memory backends.
- Terminal backends.
- Additional capabilities.

The Hermes Marketplace unifies discovery of plugins, connectors, and skills. The v0.23 development cycle expanded the catalog to more than 1,050 entries.

The v0.23.1 patch fixed a catalog-size limit that caused older clients to use a stale bundled catalog.

### MCP

Model Context Protocol support lets Hermes connect to external servers that expose tools and resources. MCP servers can provide access to databases, files, internal services, and specialized tools.

MCP is an extension mechanism, not a requirement for the core agent.

Resources: [Hermes Marketplace](https://hermes-agent.nousresearch.com/marketplace) · [Official documentation](https://hermes-agent.nousresearch.com/docs)

---

## Bots, group chats, and delegation

### Specialist bots

Bot Mode supports named specialist agents with distinct instructions and configuration, including model/provider, memory/profile, skills, tools, and MCP servers.

### Group Chats

Group Chat capabilities include multiple bots in one conversation, mentions and routing, lead-bot routing options, shared room context, room purpose and notes, per-member activity state, and scheduled jobs that can post into group rooms.

### Subagents and delegation

Hermes can delegate work to isolated subagents for parallel workstreams. Delegation can be configured to use different models, providers, or profiles.

```text
                    Coordinator
                         |
             +-----------+-----------+
             |           |           |
             v           v           v
          Research    Code review  Security
             |           |           |
             +-----------+-----------+
                         |
                         v
                 Consolidated result
```

Delegation is an orchestration capability, not a guarantee that individual subagent results are correct. The coordinating agent must evaluate and synthesize the results.

---

## Gateway and Webapp

The Gateway is the persistent runtime that coordinates Hermes sessions and background work.

It provides:

- Shared session ownership.
- Persistent agent operation.
- Scheduled jobs.
- Webapp serving.
- Configured integration support.
- Shared state across supported interfaces.

### Shared session model

```text
             Hermes Gateway
                    |
       +------------+------------+
       |            |            |
       v            v            v
    Desktop       Webapp       Other clients
       |            |            |
       +------------+------------+
                    |
              Shared sessions
                    |
                 Agent core
                    |
               Model provider
```

### Webapp

The Webapp serves the Desktop workspace through a browser. It is distinct from the older Web Dashboard.

The workspace includes sessions, profiles, capabilities, artifacts, scheduled jobs, host file tree, Git review, previews, and a terminal interface.

The Webapp is served by the Gateway. The documented default port is `9120`, although the configured port may differ.

### Webapp security

The Webapp can expose powerful host capabilities. Authentication and network exposure must be treated as security-sensitive.

- Plain HTTP does not encrypt traffic.
- HTTPS is strongly recommended for remote access.
- Do not expose the Webapp directly to the public internet without appropriate authentication and access controls.
- A Webapp user can invoke tools with the permissions of the Hermes host account.

Official documentation: [Hermes Desktop and Web Access](https://hermes-agent.nousresearch.com/docs/user-guide/desktop)

---

## Mobile applications: iOS and Android

There are **two distinct products that must not be confused**:

1. **Hermes Mobile by Nous Research** — the official first-party mobile companion application, currently in beta.
2. **Hermes Agent - Android by Hen Works** — a separate third-party Android application available on Google Play.

The Google Play link supplied for this README is the Hen Works application, not the official Nous Research mobile beta.

### Official Hermes Mobile — Nous Research

Nous Research released the official Hermes Mobile beta around NousCon 2026 (October 31 / November 1).

Official beta page: [Hermes Mobile Beta](https://hermes-agent.nousresearch.com/mobile)

The official page currently asks users to select a platform and join the beta waitlist. Nous Research announced on November 3 that the first beta filled quickly and that it was working to expand capacity and prepare the app for wider release.

#### iOS

- Official beta distribution: Apple TestFlight.
- Public beta capacity was limited.
- The official mobile page is the authoritative source for current enrollment.
- No general public App Store release was verified as of November 10, 2026.

#### Android

- Official beta distribution: Firebase App Distribution.
- Public beta capacity was limited.
- The official mobile page is the authoritative source for current enrollment.
- No general public Google Play release by Nous Research was verified as of November 10, 2026.

#### Official mobile beta update

A November 3 beta update announcement reported iOS Build 41 and Android Build 22.

Reported improvements included:

**Both platforms**
- More accurate bot activity state.
- Upload fixes.
- Bot screen-viewer fixes.
- Better distinction between models with similar names from the same provider.

**iOS**
- Smoother scrolling during streamed responses.
- Improved keyboard and message layout behavior.
- Better image sizing.
- Thinking-level selection for new chats.
- Improved bot activity updates.
- Connection fixes for certain local dashboards.

**Android**
- Chat transcript and scrolling fixes.
- Voice input support on Android 11 and later.
- Live voice history fixes.
- Improved menu behavior.
- Corrected subagent progress display.
- Notification pairing fixes.
- Connection fixes for certain local dashboards.

These are beta-build notes, not a guarantee that every feature is available in every tester build.

#### Official mobile architecture

Hermes Mobile is a companion client for a Hermes Agent environment. The agent runtime, model provider, tools, memory, and persistent state remain part of the Hermes environment. The mobile app provides the mobile interface.

The official mobile application is not documented as a replacement for the Desktop local inference runtime or as an independent on-device llama.cpp host.

### Third-party Android app — Hen Works

The supplied Google Play listing is:

[Hermes Agent - Android — Google Play](https://play.google.com/store/apps/details?id=com.hermesagent.android&hl=en_US)

**Developer:** Hen Works  
**Package ID:** `com.hermesagent.android`  
**Latest listing update observed:** October 26, 2026  
**Rating observed:** 4.6 / 5, approximately 4.3K reviews  
**Downloads observed:** 50K+

This application is published by **Hen Works**, not Nous Research. Its Google Play listing says it is built on the open-source `hermes-agent` framework. It should therefore be described as a third-party Android implementation, not as the official Nous Research mobile app.

#### Features listed by Hen Works

- Android AI assistant interface.
- Multiple provider support: OpenAI, Anthropic, Google, OpenRouter.
- Local model support through LiteRT-LM.
- Built-in terminal with Bash, Python, and Git.
- On-device code execution.
- Persistent memory and session management.
- Web search and extraction.
- Image generation through Fal.ai integration.
- Text-to-speech through Edge TTS.
- Web-based monitoring dashboard.
- Pairing with a Hermes Desktop installation.

The app's local inference path is listed as **LiteRT-LM**, which is distinct from the llama.cpp runtime managed by Hermes Desktop.

The Play listing says approximately 200 MB of initial storage is required and that hosted AI API calls require an internet connection and user-supplied API keys.

#### Latest Google Play update observed

The current listing shows an October 26, 2026 update. Its published notes include:

- Editing Hermes personality and standing instructions through Settings → Personality (`SOUL.md`).
- Additional terminal appearance options and JetBrains Mono font.
- Fixes for `nano`, `less`, and `clear`.
- Keyboard/API-key input fixes.
- Better handling of missing API keys.
- Long-text paste crash fix.
- Terminal/Web Hermes updates blocked in favor of the app's Settings update path.

The listing also advertises file attachments for PDF, Word, slides, and text in earlier 3.1 release notes.

The app's Data Safety disclosure says it may collect and share financial information, app activity, and device or other IDs. Review the current listing and its privacy policy before use.

**Important distinction:** the Hen Works application is a separate third-party product. Its feature set, release schedule, local inference implementation, data handling, and support are controlled by Hen Works. It is not the official Nous Research Hermes Mobile beta.

### Mobile app comparison

| Attribute | Official Hermes Mobile | Hen Works Hermes Agent Android |
|---|---|---|
| Publisher | Nous Research | Hen Works |
| iOS | Official beta | No iOS counterpart verified here |
| Android | Official beta | Google Play release |
| Distribution | TestFlight / Firebase beta | Google Play |
| Status on Nov. 10, 2026 | Limited beta / waitlist | Public Play Store listing |
| Relationship to Hermes | First-party companion app | Third-party app built on the open-source framework |
| Local inference engine | Not documented as on-device model hosting | LiteRT-LM listed |
| Desktop pairing | Companion to Hermes environment | Listing advertises Desktop pairing |
| Update cadence | Separate mobile beta builds | Hen Works Play Store updates |

**Authenticity warning:** Nous Research previously warned about look-alike applications using Hermes branding. The official mobile beta is linked from the Nous Research Hermes website. The Hen Works app is a distinct third-party application; it should not be represented as the official Nous mobile app.

---

## Platform support

Support varies by platform, distribution channel, and feature.

| Platform | Application / interface | Local model management |
|---|---|---|
| macOS Apple Silicon | Native Hermes Desktop | Yes — managed llama.cpp / Metal or CPU |
| Windows x64 | Native Hermes Desktop | Yes — supported CUDA, Vulkan, or CPU backends |
| Linux x64 | Supported Hermes interfaces | Yes — supported CUDA, Vulkan, HIP, or CPU backends |
| Linux ARM64 | Supported Hermes interfaces | Supported backend combinations, subject to hardware and driver support |
| iOS | Official Hermes Mobile beta | Not documented as an on-device Desktop model manager |
| Android | Official Hermes Mobile beta | Not documented as an on-device Desktop model manager |
| Android | Hen Works third-party app | LiteRT-LM local models listed by the developer |

Do not assume that a backend is supported on every hardware/OS combination. Consult the Local Models documentation for current driver and platform requirements.

---

## Security and privacy

Hermes can be granted access to powerful tools and should be treated as an automation system with permissions, not simply as a chatbot.

Potentially sensitive capabilities include shell execution, filesystem access, browser sessions, Git repositories, API credentials, computer-use operations, container management, and external tools.

### Security principles

1. Apply least privilege to the operating-system account running Hermes.
2. Limit filesystem access to required workspaces.
3. Prefer read-only permissions for monitoring tasks.
4. Use scoped credentials and minimum required API permissions.
5. Require approval for destructive or externally visible actions.
6. Review plugin dependencies and requested permissions.
7. Protect Gateway and Webapp authentication.
8. Restrict network exposure.
9. Use sandboxing for higher-risk command execution.
10. Keep credentials and private session data out of source control.

### Local inference versus external services

Local model inference can remain on the host after the model and runtime are downloaded. This does not mean every Hermes feature is offline. Hosted providers, external APIs, web retrieval, and network-dependent plugins still require connectivity and may process data outside the local machine.

### Sandboxing

Hermes supports configurable terminal execution backends, including container-oriented isolation options where supported. A container is not automatically a secure sandbox: host mounts, privileged mode, Docker socket access, credentials, and network permissions determine the effective boundary.

### Mobile privacy

The official Nous mobile beta and the Hen Works Android application are separate products with separate data handling and privacy policies. Do not assume that their permissions, telemetry, credential storage, or network behavior are identical.

---

## Configuration and persistent data

Hermes maintains configuration and persistent agent data. The user data directory commonly resides under:

```text
~/.hermes/
```

The exact location can vary by installation scope, profile, and platform.

The Hermes home may contain:

- Configuration.
- Provider credentials or credential references.
- Sessions and conversation history.
- Memory.
- Skills.
- Profiles.
- Scheduled jobs.
- Logs.
- Plugin state.
- Model/runtime metadata.

Treat this directory as sensitive operational data.

### Backup considerations

A backup plan should account for configuration, profile state, sessions, memory, custom skills, plugin configuration, scheduled-job definitions, credential storage, and any model files that are not easily reproducible.

Do not commit API keys, tokens, private sessions, or secrets to Git. Prefer supported configuration and management interfaces rather than relying on undocumented internal database schemas or file names.

---

## Release channels and updates

Hermes releases, Desktop packages, plugins, and mobile beta builds can follow separate schedules.

### Core Agent

The GitHub release page is the authoritative source for stable Agent version tags and release notes:

[Hermes Agent Releases](https://github.com/NousResearch/hermes-agent/releases)

### Desktop

Desktop distribution channels include:

- macOS signed DMG/ZIP.
- Windows Microsoft Store.
- Windows standalone installer.
- Linux installation methods.

The release notes identify which channels receive each patch. Do not assume that a new Agent tag means every standalone Desktop package has been rebuilt.

### Local inference runtime

Hermes manages pinned llama.cpp runtime components through its runtime/package management system. The Local Models interface exposes runtime installation and management.

### Mobile

Official Hermes Mobile builds are distributed through beta channels while the app is under development. Their build numbers and release cadence are separate from the core Agent version.

The Hen Works Android application has its own independent Google Play version and release history.

---

## Known limitations and distinctions

- The official Nous Research mobile application is in beta, not a general public store release as of November 10, 2026.
- The Hen Works Android application is a third-party implementation, not the official Nous Research mobile app.
- The official mobile beta and the Hen Works app have different architectures, local inference support, publishers, and privacy policies.
- Hermes Desktop manages local inference with llama.cpp on supported desktop operating systems.
- External inference servers remain optional advanced configurations.
- Not every local model supports vision or other multimodal features.
- Hosted providers and network-dependent tools do not become local merely because Hermes is installed locally.
- Desktop package versions can lag behind the latest Agent patch.
- Plugin compatibility and catalog visibility depend on the installed Hermes version and plugin requirements.

---

## References

### Official Nous Research

- [Hermes Agent website](https://hermes-agent.nousresearch.com/)
- [Hermes Agent GitHub repository](https://github.com/NousResearch/hermes-agent)
- [GitHub releases](https://github.com/NousResearch/hermes-agent/releases)
- [Official documentation](https://hermes-agent.nousresearch.com/docs)
- [Hermes Desktop](https://hermes-agent.nousresearch.com/docs/user-guide/desktop)
- [Local Models](https://hermes-agent.nousresearch.com/docs/user-guide/local-models)
- [Installation](https://hermes-agent.nousresearch.com/docs/getting-started/installation)
- [Hermes Marketplace](https://hermes-agent.nousresearch.com/marketplace)
- [Official Hermes Mobile beta / waitlist](https://hermes-agent.nousresearch.com/mobile)
- [Nous Research Hermes announcements](https://hermes-ai.net/news/hermes-agent/)

### Android — Hen Works third-party app

- [Hermes Agent - Android on Google Play](https://play.google.com/store/apps/details?id=com.hermesagent.android&hl=en_US)
- [Hen Works developer page](https://play.google.com/store/apps/developer?id=Hen+Works)

---

*This README reflects information checked on November 10, 2026. Hermes is actively developed. Verify the official release notes, Desktop documentation, Local Models documentation, mobile beta page, and the separate Google Play listing for changes after this date.*
