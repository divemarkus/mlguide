# ChatGPT App

## 1. First, understand what you're installing

OpenAI has unified the desktop experience. As of the current documentation, the new macOS app combines Chat, Work, and Codex; the older app is called ChatGPT Classic. You want the new app, not Classic.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://help.openai.com\&sz=32)

OpenAI Help Center

+1



Chat — your everyday assistant

Research, technical explanations, troubleshooting, architecture discussions, code snippets, image analysis, and model-assisted reasoning. Use cloud models when you want the full hosted ChatGPT experience.

Work — delegate a substantial task

Give it a goal and supporting material, then let it research, analyze, work across supported files and connected apps, and produce a finished artifact. You can review progress, redirect it, and approve important actions.

Codex — your coding agent

Open a repository, ask for a feature or bug fix, let it edit files and run commands, inspect diffs, run tests, and review the results. It supports local coding workflows and, for eligible accounts, cloud coding tasks. It can also coordinate multiple agents and isolate work using Git worktrees.

Official overview: [Download ChatGPT for macOS](https://chatgpt.com/download/?utm_source=chatgpt.com) · [Codex setup and capabilities](https://help.openai.com/en/articles/11369540-using-codex-with-your-chatgpt-plan?utm_source=chatgpt.com).

## 2. What you can do with it

For your Home Lab and coding work, these are the capabilities I'd prioritize.

[My VSCode setup](https://images.openai.com/static-rsc-4/RbTN8jkjA7ols1I3BzqAoSnOr1YnDWBDXKx0FzaRgxgeO1xJn9MGmgb6oA9w7A6Wy03ezmitj9VYxkWuPoT-UdNsIm5TOUxSMCrT4jO5CNEAQkxhj4nH_eu_JDz-Xf0weZPE-NB2M7ZfT5eYl7yMcTmID-5GGbvV-LtHgJPTAUo?purpose=inline)

Repository-level development

Ask it to trace a bug through multiple files, implement a feature, add tests, update documentation, run a linter, and explain the resulting diff. You stay in control of the repository and can review changes before merging.

[25分钟完成5套UI风格：AgentTeam + Git Worktree 并行开发实战 | 青岩码农兜底日记](https://images.openai.com/static-rsc-4/ZlJsEzGwInKOCNpxQ7VdM2sURfC_d3z8QTmzq6QhF2KG50MQWdrEq57o0-qy6CyDx7EbMCTX_aY7dYgspWSVTzkMORDfJEpJKdI-s4D9uHbXrmf4igm9tOOoXSoLNeAQpe_otxgUgBvE_CCVDe_Cu8_Z5t3OqEW1nr9MBoXsbMk?purpose=inline)

Parallel agents

Delegate independent tasks—such as adding tests, reviewing a security configuration, or updating documentation—without forcing everything into one sequential conversation. Use separate worktrees or branches to reduce collisions.

[Restaurant Review App - Stage 1 by james-priest](https://images.openai.com/static-rsc-4/JsYoKWdzynoVrjue5GNNrNzPhZO2YQlwOZp9uEBK_kV4VHn4qUBzIYTTADYgDhnfvCrtKOWbM40zJd14VPht9iIkuAd2pvRzqhPcneUKKS2wfsDXikSNDnDzBNPDOGYgqU8KbPVC0VPQGSB9TMA95UespQV5CeX8gNH7qYThG5c?purpose=inline)

Browser-assisted development

Work with a local web app, inspect its appearance, and use browser annotations to ask for UI changes. Where available, developer-mode browser tooling can inspect deeper details such as console errors and network activity; grant that access deliberately.

[JetBrains abandons Fleet IDE, pins hopes on forthcoming Air agentic development tool](https://images.openai.com/static-rsc-4/t8SDE6-h0wmxBxlk3N6u_JQj2aHJ8PT1HYlbeBDYKnTRG06BV1jgYT7n4DfzeoPmRDwrn8qKW945ZTs_mqbtnrV6OLtfYfTcgHeY5iNQqJqh2BLd1zUxtEfWI7nKC0I8jH5Rvo8_eu7xclvDGazH6B7Dnu6HWAd3WJo5IunuMNQ?purpose=inline)

Review, not just generate

Ask for a review of a diff, threat-model a change, identify regressions, or challenge the design. Treat findings as proposals to verify, not as proof that the code is correct.

Codex's cloud environment can continue a task while your Mac sleeps, but that is distinct from a local task that depends on your Mac and its local services being available.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://help.openai.com\&sz=32)

OpenAI Help Center

+1



## 3. Get started on macOS: step by step

I'd start with the hosted experience first, then add local models once you know the app itself works. That avoids confusing an app setup problem with an Ollama integration problem.

## 1

Install the correct app

Download from the official source: [ChatGPT for macOS](https://chatgpt.com/download/?utm_source=chatgpt.com).

Install it, launch it, and sign in. The documented requirement is macOS 14 or later on Apple Silicon or Intel. Your M6 is well within the supported hardware family.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://help.openai.com\&sz=32)

OpenAI Help Center



## 2

Learn the three modes

- Chat: ask questions, troubleshoot, research, and discuss designs.
- Work: delegate a larger research or artifact task.
- Codex: open a code repository and have an agent work on it.

Start with Chat, then try Codex on a disposable Git repository. Use Work for tasks that need research, analysis, and a polished deliverable rather than just code changes.

## 3

Configure your safety boundaries

In Codex, start with approval prompts enabled and limit the agent to the repository you're working on. Review commands before allowing destructive operations, broad filesystem access, credential access, or changes outside the project.

Make a Git commit or create a clean branch before larger changes. Ask the agent to show a diff and run tests before you accept its work.

## 4

Connect Ollama for local coding

Update Ollama, launch it, and open its Apps section. Select ChatGPT (Desktop) and follow the setup prompts. Ollama's current documentation says this connection adds local models to Codex mode; regular Chat and voice continue using your usual ChatGPT connection.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub

+1



Then open Codex and select the Ollama model from its model picker. If the model isn't listed or requests fail, check the current Ollama integration instructions before editing configuration files manually.

## 5

Test the local route before trusting it

Ask the agent to explain a small repository, then make a trivial change and run a test. Confirm that the selected model is the local Ollama model and that the request completes successfully.

Don't assume that seeing a local model name proves every feature is local. Web search, account services, connected apps, and cloud tasks have their own network and data paths.

Useful official links:

- [Ollama quickstart and desktop app integrations](https://github.com/ollama/ollama/blob/main/docs/quickstart.mdx?utm_source=chatgpt.com)
- [Codex usage, approvals, cloud tasks, and data controls](https://help.openai.com/en/articles/11369540-using-codex-with-your-chatgpt-plan?utm_source=chatgpt.com)
- [Work with Apps on macOS](https://help.openai.com/en/articles/10119604-work-with-apps-on-macos?utm_source=chatgpt.com)

### Optional: connect ChatGPT to your open editor

The ChatGPT macOS app also has Work with Apps, which can use content from supported editors and terminals. For VS Code, it requires the appropriate extension; other supported apps may require Accessibility permission. You can disable this feature in ChatGPT settings. Content sent from these apps becomes part of the relevant conversation, so enable it only where useful.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://help.openai.com\&sz=32)

OpenAI Help Center



For your privacy-first setup, I'd enable this selectively rather than grant broad access to every app by default.

## 4. How to get the most out of it

The biggest improvement usually comes from changing how you delegate, not just changing models.

### Use a structured task brief

Instead of “fix this script,” give Codex the goal, constraints, and definition of done. For example:

# Task: Improve the Home Lab bootstrap script

## Context

This repository manages macOS dotfiles and Home Lab development tools.

## Requirements

- Inspect the existing repository before editing.
- Preserve the current directory structure and conventions.
- Do not replace working tools or introduce SaaS dependencies.
- Keep secrets and personal credentials out of the repository.
- Make the smallest maintainable changes.

## Workflow

1. Explain the current implementation and identify the files that need changes.
2. Propose a brief plan before editing.
3. Implement the changes.
4. Run relevant tests, syntax checks, and linting where available.
5. Review the Git diff for regressions, security issues, and accidental changes.
6. Summarize the files changed, checks performed, remaining risks, and any manual steps.

Do not claim a test passed unless you actually ran it and observed the result.

### Build reusable workflows

For repeated tasks, create repository instructions and reusable agent skills where supported. Good candidates in your environment include:

- Reviewing firewall and security configuration changes.
- Validating Docker Compose files.
- Updating your macOS bootstrap and dotfiles.
- Auditing shell scripts for unsafe commands and secret leakage.
- Generating tests and documentation alongside code changes.

For parallel work, give each agent a distinct deliverable. For example, have one agent implement a change, a second review the diff, and a third update documentation. Don't let all three independently edit the same files.

### Keep the human in the loop

Use the agent for execution, but keep yourself responsible for architecture and verification. With your networking and infrastructure background, you're particularly well placed to catch dangerous assumptions in firewall rules, access controls, network segmentation, and service exposure.

## 5. Cloud AI vs. local AI: which should you use?

For your M6 mini, I would maintain both routes and choose based on the task.

## Cloud ChatGPT / Codex

Best for difficult tasks

Use it for complex debugging, unfamiliar frameworks, broad code reviews, web research, and tasks that benefit from stronger hosted models and integrated tools.

Trade-offs: account and plan limits, network dependence, and sending the relevant task context to a hosted service. Cloud coding environments run on OpenAI-managed computers.

## Local Ollama + MLX models

Best for local-first work

Use local models for routine code edits, shell scripting, configuration generation, test scaffolding, and private experiments where the model is capable enough.

Trade-offs: 32GB unified memory limits model size and practical context, and smaller models may struggle more with long agentic workflows. Web access and connected services may still be external.

A useful distinction: the model and the agent are separate components. Codex provides the coding-agent workflow; Ollama supplies a local model when configured. A strong agent harness cannot completely compensate for a model that repeatedly misunderstands instructions or mishandles tools.

Also, local-model support in Codex does not mean the regular Chat tab switches to Ollama. Ollama's current documentation explicitly distinguishes Codex mode from regular Chat and voice.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub



## 6. Let me make the case for ChatGPT itself

You asked me to sell you on using me, for both cloud and local AI. Here's my honest pitch.

For cloud AI, use me as your technical research and reasoning partner. You can bring me a complicated architecture question, a product comparison, a log excerpt, or a design decision and ask me to challenge your assumptions, research current documentation, compare options, and produce a concrete implementation plan. When a task requires code execution or repository changes, move to Work or Codex rather than treating ordinary chat as a substitute for an execution environment.

For local AI, use me to help build and evaluate your own system. I can help you select models, design prompts, build repeatable coding benchmarks, tune context settings, write Ollama configurations, and create scripts that test your models against realistic tasks. When you've connected Ollama to Codex, the local model does the actual inference; I can help you improve that setup and diagnose failures, but I am not secretly running your local model inside this conversation.

Where I think you gain the most is by treating the two as complementary:

- Cloud: difficult reasoning, research, architecture reviews, and work where quality matters more than keeping every request on the machine.
- Local: privacy-sensitive source code, frequent routine edits, configuration work, and experimentation without sending the source to a hosted model.
- Your RTX 3090 Ti workstation: larger CUDA workloads and experiments that exceed the Mac mini's memory or performance budget.
- Your M6 mini: efficient always-on local inference, coding, and Home Lab orchestration.

I won't claim that ChatGPT will always outperform Claude Code. You already have a working Claude Code + Ollama + MLX workflow, and the right comparison is a controlled test on your own repositories.

## 7. Your first-session checklist

## Setup progress

0 of 8

Install the new ChatGPT macOS app

Use the official download, not ChatGPT Classic.

Explore Chat, Work, and Codex

Understand which mode fits each type of task.

Open a clean Git repository in Codex

Start with a disposable test repo or clean branch.

Run one task using a hosted model

Test file edits, commands, tests, and diff review.

Connect Ollama to ChatGPT Desktop

Use Ollama → Apps → ChatGPT (Desktop).

Run the same task with your local coding model

Compare accuracy, tool use, corrections, and time.

Check privacy and approval settings

Review app permissions, data controls, and external network access.

Save a reusable repository task brief

Use the template above as your starting point.

Reset checklist

Copy checklist

My recommendation: start with the hosted Codex workflow to learn its strengths, connect Ollama next, and then compare it against Claude Code using the same model and task. That gives you a useful answer based on your own engineering work rather than marketing claims.