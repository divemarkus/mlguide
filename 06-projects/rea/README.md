
# REA — Reverse Engineer Anything

Project review · Local AI agents · Reverse engineering · Security research

[ferylounge - Blog](https://images.openai.com/static-rsc-4/Gn82rIXvVmuj68pJZ5P3ku-dry6TF8GbhBokFDGA2RbncT0pJ516u5h1yDl2oooUzGvuwSooEeeUiRm2Rm8i_SgagSwdZR8U8o4R9SrrkhfwXAyw8MTiKtUtKg3YbQTI6JyWmj6_LQAbZ8yFgYlXzmgeNyhaxamxqxdEbgOlb8A?purpose=inline)

[ferylounge.weebly.com](https://ferylounge.weebly.com/)

REA is a bridge between AI coding agents and professional reverse-engineering tools. Rather than asking an AI model to guess how an application works, REA gives it structured ways to inspect the application's files, binaries, code relationships, browser behavior, and runtime observations.

Repository: [morluto/rea on GitHub](https://github.com/morluto/rea)

My initial assessment: this is an interesting project because it goes beyond ordinary AI-assisted coding. It attempts to give an agent access to evidence about how software actually works, including software for which you don't have the original source code. The important distinction is that REA supplies investigative tools and evidence; the AI agent interprets that evidence and helps reconstruct the behavior.&#x20;

## 1. What problem does it solve?

Imagine you use an application that has an excellent search feature. You want to implement something similar in your own application, but you have no idea how the original search works internally.

Traditional approaches include manually examining the application, inspecting network requests, looking through JavaScript bundles, or using a disassembler to analyze machine code.

REA brings many of these approaches into an AI agent's workflow.

1\. You ask a question

“How does this application's search feature work?”

2\. Your AI agent calls REA through MCP

The agent chooses investigative tools based on the task.

3\. REA examines the target

Modules, functions, call references, scripts, browser observations, or native code.

4\. Evidence comes back to the agent

The agent explains the behavior, identifies unknowns, and proposes an implementation.

The practical benefit is that the agent can investigate the actual target rather than relying entirely on its training data or assumptions.

## 2. What can REA reverse engineer?

This is where the project gets interesting. According to its README and technical documentation, it supports substantially more than conventional executable decompilation.

[Intro to reverse engineering with Ghidra – Cyberbit](https://images.openai.com/static-rsc-4/ocbQRIQaHdGU8j_M5OLykU19IGEdaakIE_lL7i8M4NLtEoYi9gUkH9ZtfQb0bTofCKqqbu2iR5rB5IgjTWIpHnVGY-dFYryZA2dARz7h6IYtjuBR-e9lh_NEcR-ULR0ghKfbUK_GLjBhzSDl-nawv2wJQi4kmhi5GNSCT30lAdE?purpose=inline)

Native binaries and executable code

Inspect functions, assembly instructions, decompiled pseudocode, strings, symbols, cross-references, and call relationships. Useful for native Windows applications, macOS applications, and Linux executables.

Requires a suitable analysis provider, such as Ghidra, Hopper, or IDA, for deep native analysis.

[Approaches To Decompile Electron JS Application | by Muhammad Lutfi Rahmawan | Medium](https://images.openai.com/static-rsc-4/CKj4sucvxsMPk8cw9sYPhqHJwOv06FjJLBIX2aFVl41MNXHWn3ylXQUffDlD6_I8d8drQa-9H9bvWZBaa-1WLASVglHXsE8qHamHxAi8f60dCCt6uDxuVTRQlhdRUvbVLiKkYLnl0y7ahWTebo0E3dhA3LjduRkIzxtr-J2y-wc?purpose=inline)

JavaScript and Electron applications

Map application modules, imports, routes, source maps, inter-process communication (IPC), and native add-on relationships. This is particularly useful for desktop applications packaged with Electron.

Static JavaScript analysis can work without installing a native decompiler.

[Acronis Support Portal](https://images.openai.com/static-rsc-4/cobi8AeZ0AD1qGOBa1d6FngmvUVIQp-0B8daRF1IibkgiT_coRN_d7QzSCmrC6eQ9aBmJtXT_0lyUWv70fDuoZHripuWannWe8s5nodudt_CpjZiSGUqg8oEF_1mhryFAhZCyu2hoUKal35TPrZT4GPoTcwE3HfbVFpQKizHuj0?purpose=inline)

Websites and browser behavior

Inspect page structure and scripts, capture browser observations, analyze network activity, and take requested screenshots. This helps investigate how a website behaves, not just what its source files contain.

Requires a compatible Chrome-family browser for browser-analysis workflows.

[M9: Reverse Engineering - Kotlin SCP](https://images.openai.com/static-rsc-4/CnCwntbBuWUPxw2Thenf9BXDuF8c81_0xCy5fTT65q3-ZIw2e5wJxAXdkQWbNVBl4tKbyFaqNpVhAem9EzMDhr_sEJf1gTKoY0aALW05UTCBJMmHNi5I7bCzmzSctOkm_ORqmBxEJyYwoShGG4cRku-IChRrG2v_PGCuFDsLyOw?purpose=inline)

Android applications and devices

Inspect APK manifests, decompiled methods, application resources, device packages, logs, processes, and screen captures. Some operations require additional tools such as JADX, a JDK, or ADB.

[Installar Ghidra sus Linux | Flathub](https://images.openai.com/static-rsc-4/nvN2oc_GDBAENi4kxQgOOG9PMwEyFHl3jqrZiiF3Muofu8qmfdLzJtnPBmcLkJKG9zH81G7Fm3QpjTI-ZMes9CQl8Q8ASGhUG-dBLjeSopfRfZiml0wnnHiyOEdhJjkNLg4eGmd-uHBVCEsXCjP3M4gBiiib07uagGv_69y0BEs?purpose=inline)

Firmware, managed code and other artifacts

Analyze firmware extraction results, .NET assemblies and intermediate language, WebAssembly, EVM bytecode, Go and Rust build metadata, SQLite databases, packet captures, and saved crash records. Individual formats have different prerequisites and coverage limits.

These are documented capability categories, not a claim that every feature works on every operating system without dependencies. REA's [README and supported-target matrix](https://github.com/morluto/rea#what-you-can-analyze) explain the distinctions.

## 3. Why MCP matters

REA isn't itself the AI model. It's an MCP (Model Context Protocol) server and a command-line toolkit that lets compatible agents invoke its analysis functions.

AI agent

Codex, Claude Code, Cursor, or another supported client

MCP requests and structured results

REA

Investigation workflows, analysis providers, evidence records and CLI

Static inspection

Files, modules, symbols

Deep analysis

Decompilers and debuggers

Browser capture

Pages and runtime behavior

Evidence

Results, caveats and unknowns

The key advantage is that the workflow becomes repeatable. An agent can inspect a function, follow the functions it calls, gather more evidence, and compare what it observes instead of relying on a single decompilation result.

REA's documentation also distinguishes observed absence from unknown information. For example, an empty call list does not prove that a function calls nothing if the selected analysis provider could not inspect all of its references. That is a valuable property for security analysis.

You can also use the CLI directly without an AI agent, which makes REA useful for scripting and repeatable investigation pipelines.

## 4. What makes it different from a normal AI coding agent?

| Capability                          | Normal coding agent                       | Agent with REA                                          |
| ----------------------------------- | ----------------------------------------- | ------------------------------------------------------- |
| Read source code                    | Yes                                       | Yes, with additional analysis                           |
| Understand packaged JavaScript      | Often limited by bundles and minification | Can map modules, imports, source maps and relationships |
| Decompile native executables        | Usually requires external tools           | Can orchestrate supported native-analysis providers     |
| Trace function calls and references | Depends on language tools                 | Dedicated investigation workflows                       |
| Inspect browser behavior            | Depends on available tools                | Browser-analysis and capture workflows                  |
| Show evidence and uncertainty       | Depends on the agent                      | Structured evidence and explicit coverage limitations   |
| Reconstruct and implement a feature | Yes                                       | Yes, using findings collected during investigation      |

The difference is not that REA makes the AI inherently smarter. It's that REA gives the agent access to analysis capabilities it otherwise might not have.

A good coding model with REA may produce a better reconstruction because it can inspect the target directly. A weak model may still misunderstand the evidence, and a decompiler can itself produce imperfect pseudocode.

## 5. A practical example: clone a feature from a desktop application

Suppose you wanted to understand how an Electron application handles clipboard operations.

1. Inventory the application.

   REA can analyze its extracted application directory or ASAR package, identify modules, and map imports and relationships.
2. Trace the implementation.

   Investigate the renderer-side API, preload bridge, IPC messages and main-process handler, where available.
3. Collect evidence.

   Examine the relevant modules and links between them. Note missing code, unknown relationships or other analysis limitations.
4. Ask your coding agent to reproduce the feature.

   Use the findings to build an equivalent implementation for your own application, then run tests against your expected behavior.

The repository's [Notion clipboard-bridge showcase](https://rea.tools/showcase/notion/) documents this kind of investigation. It's a more compelling demonstration than simply asking an LLM to copy an interface from a screenshot.

Another example is the [DX-Ball sound-pan reconstruction](https://rea.tools/showcase/dx-ball/), where the project describes validating a reconstructed calculation against thousands of original-input cases and the compiled function bytes. Those are project-reported results, not an independent benchmark of REA's overall accuracy.

## 6. Can you use it with local LLMs?

Yes, with an important qualification: REA's analysis can run locally, but the model powering your agent must be configured separately. REA does not require you to use a cloud model simply because it uses MCP.

The project lists clients including Codex, Claude Code, Cursor and Gemini CLI, along with other supported agents. Any particular local model/client combination needs to support the necessary MCP interactions and have sufficient reasoning and tool-use ability.

## Potential local-AI architecture

AI coding client

A compatible MCP-enabled coding agent

REA CLI / MCP server

Investigation workflows and evidence handling

Local analysis

Static parsers, Ghidra, supported local tools

Model inference

Local model through a compatible agent runtime

For your environment, I'd consider three configurations:

| Configuration                               | Assessment                                                                                                                      |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| Local model + compatible coding agent + REA | Best fit for a privacy-first workflow, provided the model handles multi-step tool use reliably                                  |
| Cloud coding agent + REA                    | Potentially stronger reasoning on complex investigations, but target details and tool results may be sent to the model provider |
| REA CLI + no AI agent                       | Useful for scripted inspections, collecting JSON evidence, and repeatable analysis                                              |

The local-model route has an additional advantage: you can keep proprietary application artifacts on your own workstation, provided you also control network access and any other tools used in the pipeline.

However, REA is not the same thing as a sandbox. Its security documentation explicitly warns that an untrusted binary may be processed by the selected analysis provider with your OS user's permissions. And an AI agent connected to tools has whatever additional authority those tools grant it. Keep unknown samples in an isolated VM when appropriate.

## 7. Installation and dependencies

The current package metadata identifies the package as `rea-agents`, version `6.4.0`, with an MIT license and a Node.js requirement of 22.19+ on the 22.x line, 24.11+ on the 24.x line, or 26+. This is the repository's current package metadata, not a guarantee that every GitHub change is already published to npm.

The documented setup command is:

```
npx rea-agents@latest setup
```

The setup wizard lets you select supported agent clients, review the planned configuration changes, and approve them. It also installs matching workflow instructions unless you opt out. Restart the configured agent after setup.

For the first test, I recommend a disposable development environment instead of your main workstation configuration.

### What needs to be installed?

| Component                            | Purpose                               | Required?                            |
| ------------------------------------ | ------------------------------------- | ------------------------------------ |
| Node.js and npm                      | Run REA and install its package       | Yes                                  |
| Compatible MCP client                | Let an AI agent invoke REA            | Only for agent-driven use            |
| Ghidra, Hopper or IDA                | Deep native binary analysis           | Only for the corresponding workflows |
| Browser tooling                      | Analyze websites and browser behavior | Only for those workflows             |
| JADX, JDK, ADB or other format tools | Specialized analysis                  | Only for relevant targets            |

REA also has built-in static analysis for several formats, so you can experiment without setting up every reverse-engineering engine first.

Before installation, inspect the package and its requested changes. The project documents explicit setup approval, configuration backups, and diagnostic commands. Those are useful safeguards, but they do not remove the usual risks of installing third-party developer tools.

Documentation: [Installation and setup](https://github.com/morluto/rea/blob/main/docs/installation.md).

## 8. Security and privacy: what I'd pay attention to

For a network and security engineer, I would focus on the following boundaries.

Local analysis is a real benefit

REA says analysis runs locally. For the privacy boundary to hold end to end, the model provider, agent runtime and any external integrations must also be configured appropriately.

MCP access is privileged integration

An agent can invoke tools that inspect files and, in some workflows, interact with applications, devices or runtime endpoints. Grant access only to the intended targets and directories.

Untrusted binaries remain a risk

REA uses controls around its provider bridges and temporary workspaces, but its own security policy explicitly states that this does not constitute a sandbox. Use VM isolation and snapshots for suspicious samples.

Licensing still matters

REA is MIT-licensed; external analysis tools and the software being examined retain their own terms. Use it for software you own or are authorized to analyze. REA does not grant licenses for commercial decompilers.

References: [REA Security Policy](https://github.com/morluto/rea/blob/main/SECURITY.md) · [REA Disclaimer](https://github.com/morluto/rea/blob/main/DISCLAIMER.md).

## 9. My recommendation for your setup

Given your Windows 11 workstation with the RTX 3090 Ti and 96 GB RAM, plus your local-LLM interests, I'd test REA as a local software investigation and AI-assisted reconstruction tool, not immediately as a general-purpose autonomous agent.

Start with something low risk, such as a small Electron application's extracted JavaScript files or an application you developed yourself. That lets you evaluate REA's evidence quality without first setting up a full native reverse-engineering environment.

I would use this progression:

1. Start with static analysis. Install REA in a development environment, connect a compatible MCP client, and analyze a JavaScript/Electron target.
2. Evaluate the agent. Can it trace one specific feature, cite the relevant modules and relationships, and distinguish facts from assumptions?
3. Add native analysis. Install or configure Ghidra if you want to investigate Windows executables or compiled native code.
4. Test reconstruction. Have the agent create an equivalent feature in a separate project, then verify behavior with tests.
5. Harden the environment. Use a VM for untrusted software, restrict filesystem access, and review any runtime interactions or network-capture permissions.

One caution: your GPU and system RAM help run the local model, but REA's native analysis work is primarily determined by its analysis provider and target format. A larger LLM is not automatically better at reverse engineering; tool-use reliability and the ability to reason from evidence matter more.

## 10. Is REA worth exploring?

Strong use case

Understanding unfamiliar applications, investigating complex code paths, analyzing compiled software, and reproducing features with evidence rather than guesswork.

Main trade-off

Setup complexity, dependencies on external analysis tools, potentially enormous evidence outputs, and the need to validate what the AI concludes.

Main risk

Giving an AI agent access to potentially untrusted files and runtime operations without an adequate isolation boundary.

Verdict: REA is worth exploring if you want to move beyond AI that merely reads source code and generates new code. Its strongest proposition is combining agentic workflows with established reverse-engineering tools and explicit evidence tracking.

The best first experiment is to ask an agent to reconstruct one identifiable feature from a target you control, then check whether REA helps it produce a more accurate result than the same agent working without REA.

### References

- [REA GitHub repository and README](https://github.com/morluto/rea)
- [Installation and setup](https://github.com/morluto/rea/blob/main/docs/installation.md)
- [CLI and Evidence documentation](https://github.com/morluto/rea/blob/main/docs/cli.md)
- [MCP contracts](https://github.com/morluto/rea/blob/main/docs/mcp-contracts.md)
- [Security Policy](https://github.com/morluto/rea/blob/main/SECURITY.md)
- [REA showcases](https://rea.tools/showcase/)