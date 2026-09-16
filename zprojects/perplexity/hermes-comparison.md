# Perplexity Portable Computer vs Hermes

Yes — and there is an important distinction here:

**Portable Computer is not primarily a model-training platform. It is an agent runtime/harness built around models that have already been trained/post-trained.** However, Perplexity has actually **post-trained its own local model specifically for Portable Computer**, which makes it much more interesting than simply putting Qwen into an agent framework.

### The architecture

Think of it as:

**Base model → post-training → agent harness → tools → local computer**

For Portable Computer:

**Qwen 3.8 27B → Perplexity post-training → PPLX 27B → Portable Computer harness**

Perplexity explicitly says that **PPLX 27B is a post-trained version of Qwen 3.8 27B**, optimized for the kind of local knowledge-work/agent tasks Portable performs. ([Perplexity AI][1])

So there are actually **two things worth separating**:

| Component         | What it is                                    |
| ----------------- | --------------------------------------------- |
| Qwen 3.8 27B      | Pre-existing open model                       |
| PPLX 27B          | **Perplexity's post-trained Qwen derivative** |
| Portable Computer | Agent harness/orchestrator                    |
| Perplexity Search | Cloud/web capability                          |
| Frontier models   | Optional cloud escalation                     |

## How good is the post-training?

This is where Portable gets interesting.

Perplexity tested **Computer + Qwen 3.8 27B**, **Hermes + Qwen 3.8 27B**, and **Pi + Qwen 3.8 27B** on its internal **Local Knowledge Work Bench**, consisting of 53 tasks.

Their reported results were:

| Agent framework + model |     Score | Avg tokens/task | Avg time/task |
| ----------------------- | --------: | --------------: | ------------: |
| Pi + Qwen 3.8 27B       |     77.6% |            681K |   **176 sec** |
| Hermes + Qwen 3.8 27B   |     74.0% |            634K |       292 sec |
| Computer + Qwen 3.8 27B |     82.6% |        **520K** |       218 sec |
| **Computer + PPLX 27B** | **85.4%** |            678K |      ~250 sec |

Those are **Perplexity's own benchmark results**, so I would not treat them as an independent industry ranking. But the result is still technically interesting: **the same general Qwen-class model improves when Perplexity post-trains it for its particular agent harness.** ([Perplexity AI][1])

And that answers your original question:

> **Portable Computer isn't training your model. Perplexity trained/post-trained the model that Portable uses.**

---

# Portable vs Hermes

This is where I think your question gets particularly interesting.

They are actually much closer competitors than it initially appears.

### Portable Computer

Think:

> **"An AI computer employee optimized around Perplexity's local model + agent system."**

It controls:

* local files
* applications
* tools
* scheduling
* local search/indexing
* agent execution
* orchestration
* web search
* optional cloud escalation
* frontier-model escalation

Perplexity designed the **harness and model together**.

That's an important advantage.

### Hermes

Think:

> **"An open, model-agnostic agent operating system."**

Hermes can use:

* Ollama
* llama.cpp
* vLLM
* SGLang
* OpenAI-compatible endpoints
* OpenRouter
* Nous Portal
* Claude
* GPT
* Gemini
* Qwen
* DeepSeek
* etc.

And importantly, Hermes can run **completely locally**. Its local-model system currently uses llama.cpp and can automatically manage quantization, GPU/RAM placement and context sizing. ([Hermes Agent][2])

Hermes also has something Portable doesn't appear to expose as a first-class user feature:

### **RL training**

Nous explicitly provides an RL training pipeline through **Atropos**. ([Hermes Agent][3])

That's a very different proposition.

---

# The really interesting distinction

I'd categorize them this way:

|                               | Portable Computer   | Hermes                |
| ----------------------------- | ------------------- | --------------------- |
| Local inference               | **Yes**             | **Yes**               |
| Local files                   | **Yes**             | **Yes**               |
| Agent                         | **Yes**             | **Yes**               |
| Scheduling                    | **Yes**             | **Yes**               |
| MCP                           | Yes                 | **Yes**               |
| Web                           | Perplexity Search   | Gateway / providers   |
| Cloud escalation              | **Excellent**       | Yes                   |
| Model freedom                 | Limited             | **Excellent**         |
| Bring your own Ollama         | Not the core design | **Yes**               |
| Custom models                 | Limited             | **Yes**               |
| Model training                | No                  | **Yes / RL pipeline** |
| Post-trained dedicated model  | **PPLX 27B**        | Hermes family         |
| Agent/model co-design         | **Yes**             | Less tightly coupled  |
| Open source                   | No                  | **Yes**               |
| Privacy-first local operation | **Yes**             | **Yes**               |
| Local 27–35B models           | **Yes**             | **Yes**               |
| Frontier cloud models         | **Yes**             | **Yes**               |

Hermes is therefore much closer to **your existing philosophy**:

> model agnostic + local inference + interchangeable runtimes + agents + MCP + tools.

Portable is more vertically integrated.

---

# And Hermes itself is an interesting case

There's a subtle point here.

**Hermes-4 is itself a post-trained model.**

Nous reports that Hermes 4 used approximately **5 million synthesized reasoning/non-reasoning samples and 19 billion tokens** during post-training. ([Nous Research][4])

But there's an important distinction between:

**Hermes model**

and

**Hermes Agent**

The model is the trained neural network.

The Agent is the software harness surrounding it.

That's essentially the same distinction we're seeing with:

**PPLX 27B**

versus

**Portable Computer.**

---

# For your RTX 3090 Ti

This gets particularly interesting.

Your **3090 Ti has exactly 24 GB VRAM**, which is the current published minimum for Portable Computer on Windows. Perplexity explicitly says Windows on-device inference requires an NVIDIA GeForce RTX/RTX PRO GPU with **at least 24 GB VRAM**. ([Perplexity AI][5])

So your machine is basically sitting at the Portable threshold:

**3090 Ti 24GB + Ryzen 9900X3D + 96GB RAM**

That's actually a very nice experimental platform.

And I would **not** abandon your Ollama stack.

I'd run:

```text
                    YOUR MACHINE
                         │
             ┌───────────┴───────────┐
             │                       │
       Portable Computer         Hermes Agent
             │                       │
       PPLX / Qwen             Your model choice
             │                       │
       Perplexity tools        Ollama / llama.cpp
             │                       │
             └───────────┬───────────┘
                         │
                    Local files
                    GitHub
                    MCP
                    Docker
                    Projects
```

That gives you something considerably more powerful than choosing one.

---

# Where I think Portable has a real advantage

**The model + harness co-design.**

Perplexity didn't simply say:

> "Here's Qwen. Good luck."

They apparently optimized the model and runtime together.

Their research explicitly describes designing the local agent with **the harness and models optimized for each other**. ([Perplexity AI][1])

That's probably why you see:

**Qwen 3.8 + Computer = 82.6%**

versus

**Qwen 3.8 + Hermes = 74.0%**

on their benchmark.

The model isn't necessarily inherently better.

The **combination** is.

---

# Where Hermes gets very interesting for you

Hermes is much closer to what you're already building with your ML Guide.

You could have:

```text
                 Hermes Agent
                      │
              ┌───────┴────────┐
              │                │
           Ollama          llama.cpp
              │                │
       Qwen / DeepSeek     GGUF models
              │
        ┌─────┴─────┐
        │           │
     Qdrant      Local files
        │
      RAG
```

And Hermes supports local models through Ollama, vLLM, llama.cpp, SGLang or other OpenAI-compatible servers. ([Hermes Agent][6])

That means you can experiment with:

* Qwen
* Qwen-Coder
* DeepSeek
* your existing Qwen3-Coder-Next experiments
* Hermes models
* whatever new open model comes along

without rebuilding the agent architecture.

---

# But there's an even bigger reason I'd test Hermes

**Training.**

You are interested in moving beyond:

> "How do I run somebody else's model?"

toward:

> **"How do I make my own local AI better at my specific workflows?"**

Hermes is much more interesting there.

Its documentation explicitly includes:

**experience → trajectories → RL training → improved behavior**

through Atropos. ([Hermes Agent][3])

That's a completely different level of experimentation from Portable.

You could theoretically create an environment around something like:

```text
Your ML Guide tasks
        ↓
Hermes Agent
        ↓
Tool calls
        ↓
Successful / failed trajectories
        ↓
Reward
        ↓
RL training
        ↓
Improved local agent
```

That starts moving you toward **actually training an agent for your environment**, rather than simply deploying one.

---

# One important surprise about Hermes

Nous themselves currently warn that **Hermes-4-70B and Hermes-4-405B aren't the models they recommend for Hermes Agent tool loops**. Hermes-4 is tuned more toward chat/reasoning, while Hermes Agent needs models optimized for rapid tool calling. ([Hermes Agent][7])

That's an excellent example of why:

**model quality ≠ agent quality.**

A brilliant reasoning model isn't automatically a great agent.

The model needs to understand:

```text
Think
 ↓
call tool
 ↓
inspect result
 ↓
call another tool
 ↓
verify
 ↓
modify
 ↓
verify again
 ↓
finish
```

That's precisely the area where Perplexity's **PPLX + Portable** co-design is interesting.

---

# My take for your ML Guide

I'd actually put these into **three different categories**, rather than calling them competitors:

### 1. Portable Computer

**Closed vertical local-first AI computer**

Best experiment:

> "How good can a tightly integrated local agent become when the model and harness are designed together?"

### 2. Hermes

**Open agent platform + model ecosystem + training framework**

Best experiment:

> "How far can I customize and train an agent around my own workflows?"

### 3. Your Ollama/OpenWebUI/OpenCode/Flowise stack

**Composable local AI infrastructure**

Best experiment:

> "How do I build my own AI platform where every component can be replaced?"

And honestly, **#3 is the most aligned with your ML Guide project.**

But Portable is worth installing precisely because it gives you a **reference implementation** of what a polished local-first agent looks like.

---

## And this leads to a very cool experiment

With your 3090 Ti, I'd benchmark:

**Portable/PPLX 27B vs Hermes + Qwen vs OpenCode + Qwen**

against the *same five real tasks from your ML Guide repository*:

1. Understand the entire repo.
2. Find architectural inconsistencies.
3. Audit Docker security.
4. Modify a Docker Compose stack.
5. Research a current AI technology and update the documentation.

Then measure:

**task completion → tool-call accuracy → hallucinations → files modified correctly → verification quality → tokens → time → GPU/RAM usage.**


[1]: https://www.perplexity.ai/pl/hub/blog/a-local-first-agent-for-private-and-cost-effective-knowledge-work "Agent local-first do prywatnej pracy koncepcyjnej"
[2]: https://hermes-agent.nousresearch.com/docs/user-guide/local-models "Local Models | Hermes Agent"
[3]: https://hermes-agent.nousresearch.com/docs/getting-started/learning-path "Learning Path | Hermes Agent"
[4]: https://nousresearch.com/wp-content/uploads/2025/08/Hermes_4_Technical_Report.pdf "Hermes 4 Technical Report"
[5]: https://www.perplexity.ai/fr/hub/blog/portable-computer-for-windows-is-here "Portable Computer for Windows is here"
[6]: https://hermes-agent.nousresearch.com/docs/reference/faq "FAQ & Troubleshooting | Hermes Agent"
[7]: https://hermes-agent.nousresearch.com/docs/guides/run-hermes-with-nous-portal "Run Hermes Agent with Nous Portal | Hermes Agent"
