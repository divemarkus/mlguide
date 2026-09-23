# NVIDIA

NVIDIA is arguably the most important company to understand if you want to understand **why modern AI works the way it does technically**.

And there is a much more interesting story than simply *“NVIDIA makes GPUs.”*

The deeper story is:

> **NVIDIA spent ~20 years turning a graphics processor into a programmable accelerated-computing platform, then spent another decade turning that platform into the infrastructure on which modern AI is built.**

Today, NVIDIA isn't really just a GPU company. Its own 2026 filing describes it as a **“data center scale AI infrastructure company”**, with GPUs, CPUs, networking, CUDA, libraries, systems, models and software all designed together. ([SEC][1])

For your Machine Learning Guide, I would structure NVIDIA differently from Google/Microsoft/Apple because **NVIDIA's moat is fundamentally architectural and infrastructural**.

---

# NVIDIA + AI/ML: The Deep Dive

![Image](https://images.openai.com/static-rsc-4/WqywN9leLzwybuUyj80BmrRdRzbNCfGS3Hnb8JSbeyu3quJA_xxWMxJ0OJdx1-xWsqzDX3wkQ5QZe8PkNEhlm0Z4zmqf77CRcIfEtg-ObkeQf9gtwNlUwZnPCdzqQ2P7Ng8Ze8232vvstBOhX0BSGc7TrPjjMs17ZPwnIvnSm2fW2yQHbAG5e4IhfFjZgl94?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/ZmG9cf15sU6evpffF7_T2swis2xXJJtsj7gjSQNnqk0SNierpRI5BwK3lB404n2pU-bh6mSbovVHohpAQi7yuEieEmPi4H8wwvva4b8Y7nVAYhe4OZS1y1_pdTM9GEgvF_9GujkepJZzZ-qA2xY0zGYajdvzD-Zyd67aozgapo6AP0qidJJV6T2xILSyslyt?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/22BH3Ao9gRBAh8JiHTE--zJ_Wg7xWhDG4X8oHL9-n6hkzP7rqCAfP0X1tRW6uwEDfUVzUe2cQQ7hZBxR_dwHYpBWEEuLGYHAVabJn2sJlJOOTn9NGYRdW_2DbJU1tbKkWaA53tQ1rT_wX5BmUqUjW8P-PeVux0EoDXWRC-ZsTcH_ZPoMu12oImXssWQMH2wg?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/y_pv_d4g9c7RFxyItir6DIiNlDLK6qVWtkXJ_6ZC8jIvqvLoG82JizSEAsbEzRT6bteZDqjEtbB29KVYFMfjT_0qE_MqIWOouRRFO-Gl1BhW21BU5yIxV_dnDRWiVXWWsY0iAnSVk8qm8ww87aQLP790k1-9mxypW_tMeIqkvBOAEWUYgASiDUFoopZyMzoc?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/XJI2j7kp-L_cJq4ZY0lnnvZ_XaPBk1E0_qp5CNgYa9WDDAyZLBo2s09lU6DPC1wxRJohp8xfG9vSfaS2MaGvtqmUZU1OVVq38EJQHxT4ecdIoP9Wm5vAycf-csk9pGwNq-tnZ3P98W6WMz7SbZmmJT7nnbdy2z0l_iKtVUFyL4vsjf9UsUoNS2ZbSmayHFDB?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/ah29R_v1XvQvcpVInCyH51PSzuzU5av9FYI2YqtDmA7EEFip9XV4SI3cbndkpFYjNp-2y6fU7Pxirt5Ntd_53I1Dxs1OBt6xynJhHiXZsn-SOsxNSR4pb2xycm85mbCXnNoC6RFJfQPcng6jvluRuDDilYsqE06q92ZduFI_qAHMgG4cYHhxwHVVmUPkbeNE?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/bkfbQw2yDCcf12iVZioza4c_q8YLm0ZESqIwA9SUYNoWpUqCdIM8uE8VgxsnW2i1S9-8I5VNyMpvxisPDXI04GYnauGCJ_fdOF_vjsoOd0OrBXL_gA8zekAR_BMfW30O0h7ZVwTGRTsEnj0yxdiBxbT7XqDuukwZvcSDktU-r4akeBDNhbdRRPog1lMBWjsp?purpose=fullsize)

## The NVIDIA AI story in one diagram

```text
1993
  │
  ▼
NVIDIA founded
Graphics / gaming
  │
  ▼
1999
GPU invented
  │
  ▼
2006
CUDA
"GPU = programmable parallel computer"
  │
  ▼
2012
AlexNet
Deep Learning explodes
  │
  ▼
2017
Tensor Cores
GPU becomes AI-specific hardware
  │
  ▼
2020
Mellanox
Networking becomes part of AI compute
  │
  ▼
2023
Grace CPU
NVIDIA enters CPU/data-center architecture
  │
  ▼
2024–25
Blackwell
GPU → AI Superchip → AI Factory
  │
  ▼
2026
Blackwell Ultra
Reasoning / Agentic / Physical AI
  │
  ▼
2026
Rubin
Rack-scale AI infrastructure
  │
  ▼
Future
AI Factory
      ↓
┌─────────────────────────────┐
│ GPU                         │
│ CPU                         │
│ HBM                         │
│ NVLink                      │
│ Networking                  │
│ Storage                     │
│ CUDA                        │
│ TensorRT                    │
│ AI frameworks               │
│ Models                      │
│ Agents                      │
└─────────────────────────────┘
```

That progression is the key to understanding NVIDIA.

NVIDIA's own historical timeline identifies 1999 as the GPU invention, 2006 as CUDA, and 2012 as the AlexNet breakthrough. ([NVIDIA][2])

---

# 1. The beginning: NVIDIA wasn't an AI company

NVIDIA was founded in **1993** by Jensen Huang, Chris Malachowsky and Curtis Priem.

The original thesis was essentially:

> **3D graphics are going to require enormous amounts of parallel computation.**

This was the era of PC graphics and gaming.

The important technological insight was that graphics workloads are **massively parallel**.

Imagine calculating:

```text
Pixel 1 → calculation
Pixel 2 → calculation
Pixel 3 → calculation
Pixel 4 → calculation
...
Pixel 2,000,000 → calculation
```

You don't necessarily want one extremely sophisticated processor doing these sequentially.

You want:

```text
GPU
 ├── processor
 ├── processor
 ├── processor
 ├── processor
 ├── ...
 └── thousands of parallel operations
```

And that architecture turned out to be incredibly useful for something NVIDIA didn't initially build the GPU for:

**neural networks.**

---

# 2. 1999 — the GPU changes computing

NVIDIA introduced the GeForce 256 in 1999 and popularized the concept of the **GPU — Graphics Processing Unit**.

The important concept wasn't simply graphics.

It was:

### Massive parallel computation

A neural network performs enormous numbers of operations like:

$$
Y = XW + b
$$

That means multiplying huge matrices.

And GPUs are extraordinarily good at matrix/vector operations.

This became one of the most important accidents in computing history:

> **The hardware NVIDIA built to render video games turned out to be extraordinarily good at training neural networks.**

---

# 3. 2006 — CUDA is the real beginning of NVIDIA's AI empire

This is arguably the most important NVIDIA technology after the GPU itself.

## CUDA

**Compute Unified Device Architecture**

Before CUDA, GPUs were primarily graphics processors.

CUDA changed the programming model.

Instead of:

```text
Application
    ↓
CPU
    ↓
Graphics API
    ↓
GPU
```

developers could effectively do:

```text
Application
    ↓
CUDA
    ↓
GPU
```

Now the GPU could become a **general-purpose parallel accelerator**.

NVIDIA says CUDA opened GPU parallel processing to broad compute-intensive workloads and helped pave the way for modern AI. ([SEC][1])

And this is where NVIDIA's moat begins becoming much more interesting.

---

# 4. CUDA created the ecosystem

Imagine you buy an NVIDIA GPU.

You aren't merely buying:

```text
GPU silicon
```

You're buying access to:

```text
CUDA
CUDA-X
cuBLAS
cuDNN
TensorRT
NCCL
CUDA Toolkit
PyTorch acceleration
TensorFlow acceleration
JAX acceleration
Triton
NeMo
NVIDIA drivers
NVIDIA container ecosystem
NVIDIA networking
...
```

This is extraordinarily important.

The GPU is the **hardware**.

CUDA is the **software layer that makes the hardware useful**.

And then NVIDIA built hundreds of optimized libraries and SDKs on top.

NVIDIA's 2026 filing explicitly describes CUDA plus hundreds of domain-specific libraries, frameworks, algorithms, SDKs and APIs as the foundation of its accelerated-computing platform. ([SEC][1])

---

# 5. Then came the AI event that changed everything: AlexNet

## 2012

This is the moment I would put a giant red circle around in your AI timeline.

A neural network called **AlexNet** won the ImageNet competition.

And it was trained using NVIDIA GPUs.

NVIDIA itself calls this the **“Big Bang” moment of AI**. ([SEC][1])

Why?

Because researchers suddenly demonstrated that:

```text
Deep neural networks
        +
Large datasets
        +
GPU acceleration
        =
dramatically better AI
```

The significance wasn't simply that NVIDIA hardware won a competition.

It demonstrated that **GPU accelerated neural-network computation could fundamentally change machine learning**.

And NVIDIA was already sitting underneath it.

---

# 6. NVIDIA then made the GPU specifically good at AI

This is where NVIDIA gets extremely clever.

Instead of continuing to make general-purpose GPUs and hoping AI workloads would use them, NVIDIA started designing hardware **specifically for neural networks**.

## Tensor Cores

Introduced in **2017**.

Think of a Tensor Core as specialized machinery for the mathematical operations that dominate deep learning.

Instead of:

```text
GPU
  ↓
general computation
```

you get:

```text
GPU
 ├── CUDA cores
 │
 └── Tensor cores
       ↓
     matrix math
       ↓
      AI
```

NVIDIA's first Tensor Core GPU appeared in 2017 and was explicitly designed for the AI era. ([SEC][1])

This is a major evolutionary step.

---

# 7. Why Tensor Cores matter

Modern neural networks are dominated by operations like:

```text
Matrix × Matrix
Matrix × Vector
Tensor operations
Attention
Convolution
```

For example:

```text
         weights
           ↓
Input → [ MATRIX ] → activation
           ↑
        Tensor Core
```

Tensor Cores accelerate these operations dramatically.

And NVIDIA kept adding:

```text
FP32
FP16
BF16
TF32
FP8
FP4
NVFP4
```

This is incredibly important.

AI doesn't always need 32-bit floating point precision.

If you can represent the model accurately enough using fewer bits:

```text
32-bit
  ↓
16-bit
  ↓
8-bit
  ↓
4-bit
```

you can potentially get:

**more computation + less memory + less bandwidth + lower energy per token.**

That's one of the major themes of modern NVIDIA architecture.

---

# 8. NVIDIA realized something else

There was a problem.

A giant AI model doesn't necessarily fit onto one GPU.

For example:

```text
GPU 1
GPU 2
GPU 3
GPU 4
GPU 5
...
GPU 72
```

Now you have another problem:

### How do you make 72 GPUs behave like one computer?

That's where NVIDIA's networking strategy becomes critical.

---

# 9. 2020 — Mellanox was a massive strategic move

NVIDIA acquired **Mellanox** in 2020.

This gave NVIDIA major networking technology:

* InfiniBand
* Ethernet
* NICs
* switches
* high-speed interconnects

Why does that matter for AI?

Because eventually:

> **The bottleneck isn't necessarily computation. It's moving data.**

Imagine:

```text
GPU A
  │
  │ huge amount of data
  ▼
GPU B
```

If communication is slow:

```text
GPU utilization ↓
AI performance ↓
cost/token ↑
```

So NVIDIA began building:

```text
GPU
 +
CPU
 +
memory
 +
NVLink
 +
NIC
 +
switch
 +
network
 +
software
```

That was the beginning of NVIDIA becoming a **system company**.

---

# 10. NVIDIA's real product eventually became the system

This is one of the biggest things to understand.

The evolution looks like:

```text
GPU
 ↓
GPU + CUDA
 ↓
GPU + CUDA + Tensor Cores
 ↓
Multiple GPUs
 ↓
GPU + NVLink
 ↓
GPU + CPU + NVLink
 ↓
GPU + CPU + networking
 ↓
Rack-scale AI system
 ↓
AI factory
```

That's a completely different company.

---

# 11. Grace CPU

In 2023 NVIDIA introduced **Grace**, its data-center CPU.

Why build a CPU?

Because NVIDIA didn't want the CPU to be somebody else's bottleneck.

Now:

```text
CPU
 ↓
Grace
 │
 ├──── GPU
 │
 ├──── HBM
 │
 └──── NVLink
```

NVIDIA could optimize the CPU/GPU relationship itself.

This became especially important with:

## Grace Hopper

and later:

## Grace Blackwell

---

# 12. Blackwell — NVIDIA's major transition

![Image](https://images.openai.com/static-rsc-4/7p6jPHGtVsAdAJnK57vewuZ5E_UI4D1Tee0Zgb9NUj-_aCbfvDCIM2naszXzKkvr0XbuIGF72Q-6vehH1A2vABKclKHz761e7zJ0_nrglJqEwiuBBSx6FwnXgRt4XCF4t0VpwkvF7vBAxMnPWOGWBIRhDuOsfWLn5aRUYQc3D6JTYOKQEreetoNROHBVksuQ?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/fyZe-Jd8-SBpIjzgDiRy5wPZTI1iO9-swQVLHFKCoog-SXGJhIOC2o91L1eysuntYaCMUTPumMMS649-8j96OaM_t0UFYIGSgRAtlbaqjEPpZ3vpDaid8PQNXZU0395CXwQZzy7r3pLkgJqWhEh15-ljT_e_-8OJu58NUf3q9pSJP2yz4vBKdxXMnCSJ1dWg?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/iS95qi7Vl8MWzL3oPog_EQB8HVujfPed-o07sd0WqEHK5nG11uyQQy_apXs20hm_VgCnVyzE_qQ38pIiIoS4SRJaSKp6zkrITuTiWvrk-AyM4NdOTbDcZ-LY89AVsMn8v8LZBABWbkCr8QLGIYKmUc80HrZG-l_9Svb0SJosGlO1p0HDlztldNF57aC69-_x?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/RiS_F3z3M-JTfwShGc36JFOtSmRw0a88HU7ggvL21iJ7h8_4Y7kvHFlp6L5jnvk5GowCM6-tHdMnd23hlYHeRykIvE6BUH5ZxQx1EP6RLkl6f1s7UXfHTXZVZyHRELLcTH6xIAeWL_NCL1_xjzlCxVlVqAo5ylqiFquUXcN0w0k3tNWGxv1-A2sh8TSyZMa9?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/v-Hz8uQraN969E0SToSGy-QRG2ge5UNZEskAaedDFvUEaeRdMJo0mXvkRPBvSlGRJ0Ihz8_Sl4of8lrFv8adw9d6D3au9nYaAA5dbkDW6rrnm25GqxNAA7pjUmkMMndDGtYaopgbikdPOflpa0HnX5vY3XrkjWNbxdn54dZU28ANmkAhUYsHcAPj3QwZ6A8a?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/VFXjP0P-4jWnuZbqW37FztmjqMvGihHxA_CynY4DuRu4bgyr6nLPqarqo2IiHemh9epwycnI2wTlcYPfZKll8kOBHDcH_00oyZyiEn19RDCJoUNtkupddbFtt4VC-yMa-aSSDgBH1KBkYcrbiLoKnALPTK7f3E7tpjelH4hSjjhpf98VjYFgeGEXVhmYXYFv?purpose=fullsize)

Blackwell is where NVIDIA's strategy becomes extremely obvious.

Blackwell isn't simply:

> "Here's our new GPU."

It is:

> **Here's an entire AI computing architecture.**

The Blackwell GPU contains approximately **208 billion transistors** and uses two dies connected by a high-speed interconnect. ([NVIDIA][3])

Then NVIDIA builds:

```text
Blackwell GPU
      ↓
Grace Blackwell Superchip
      ↓
NVLink
      ↓
72 GPUs
      ↓
NVL72
      ↓
AI supercomputer
```

The GB200 NVL72 connects 72 Blackwell GPUs through an NVLink domain, effectively creating a tightly coupled massive accelerator system. ([NVIDIA][3])

---

# 13. This is where the "AI factory" concept comes from

This is one of my favorite ways to understand NVIDIA.

Traditional computing:

```text
Data center
     ↓
computers
     ↓
applications
```

NVIDIA's emerging model:

```text
                    DATA
                     ↓
              ┌──────────────┐
              │   AI FACTORY │
              └──────────────┘
                     ↓
             Training / inference
                     ↓
              Tokens / reasoning
                     ↓
             AI applications
```

The "product" isn't necessarily the GPU anymore.

The product is:

> **The infrastructure that transforms electricity + data into intelligence/tokens.**

That's a profound change.

NVIDIA's 2026 filing explicitly describes the data center becoming the **new unit of computing**, with networking integral to it. ([SEC][1])

---

# 14. Then AI itself changed

Initially the big workload was:

```text
TRAINING
```

You train:

```text
GPT
Llama
Claude
Gemini
etc.
```

But now another workload is becoming enormous:

# INFERENCE

Meaning:

```text
User
 ↓
prompt
 ↓
model
 ↓
tokens
 ↓
answer
```

And then:

# REASONING

The model may generate:

```text
thought
 ↓
tool call
 ↓
result
 ↓
reasoning
 ↓
tool call
 ↓
result
 ↓
answer
```

And then:

# AGENTS

```text
Goal
 ↓
Reason
 ↓
Plan
 ↓
Tool
 ↓
Observe
 ↓
Reason
 ↓
Tool
 ↓
Observe
 ↓
...
```

This changes the hardware requirements dramatically.

---

# 15. NVIDIA is now optimizing for the agentic era

This is why **Blackwell Ultra and Rubin** are so important.

NVIDIA's FY2026 materials describe Blackwell Ultra as optimized for **agentic, reasoning and physical AI**. ([SEC][1])

The hardware is increasingly being optimized around:

```text
tokens / second
tokens / watt
tokens / dollar
latency
memory bandwidth
KV cache
GPU-to-GPU communication
networking
```

rather than simply:

```text
TFLOPS
```

That's a very important distinction.

---

# 16. Rubin — where NVIDIA is going next

And this is where the story gets really interesting in **2026**.

![Image](https://images.openai.com/static-rsc-4/toYbExtxDFia9Vp87UYTvoMwBT0xvQah81gdDnGXNjWFgFTienennPnTvJp1GaYl7OSCotCojweAxn0BlGFN_MtepsLhlY3SLeEqehmbh-4mwYS_NU0HcA4QcMI466Or1CaUsQdGNZbUYwfCGvuNQ_Ms_n1UiqWN3qqUxr2wHv-g5Dh93ln0_MNBxuJUFV89?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/1VIWRwyYg9SHtnS0QR0lADCbpBFOQ27eruIqPSQIN1drnvsTl5p_TC5DpiLReZPEiLgaJI9G6vU04hNq2V84egQmx0A-uulJL9a0Vr11F05fapcvYtcG4U0dDMoaVL35SvnQhDmokr6nBujgA_Q02mKnAXLSQRe5NvJ_5-z8NQt-b4AIB4RJZZzfGiNvwrIx?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/y_pv_d4g9c7RFxyItir6DIiNlDLK6qVWtkXJ_6ZC8jIvqvLoG82JizSEAsbEzRT6bteZDqjEtbB29KVYFMfjT_0qE_MqIWOouRRFO-Gl1BhW21BU5yIxV_dnDRWiVXWWsY0iAnSVk8qm8ww87aQLP790k1-9mxypW_tMeIqkvBOAEWUYgASiDUFoopZyMzoc?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/U506b3k-EdHnuTHsgKE3Dtmu1nOEhqQR26E19E3UNyCXZLCLtPmWUa0YxciR8QC0xWSUlRNfP-P066ELgGfWLhmS01c6qu9F8qQirwgutV1TDp9zQ3b9ZVlKcxMijIMCD58RaAC9Zarp5AF9836BHuX59N7GnbrkuuyqzrgD2W42zsZ92JfisX0y8DEipGNI?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/YmhpTmdhoSVAp2gnwF-wBaMZKY3a6Hafsgbwa_zSWfhRRBUO8T8pvH1bbWCqVEOG1Dkh5-dxe1izlxdFFHKDEateXElovsXMfWAtdRAzq53hR_sr_8GF9_E5fajC5GtqQ3sVmsT8FzY9033YM-PCd2U_aqDNwZls4P6VLG_4p4803Fx_ttE_5JGo6W3EPg_N?purpose=fullsize)

The **Vera Rubin platform** is NVIDIA's next major architectural step.

NVIDIA describes Rubin as a platform designed specifically for:

* agentic AI
* reasoning
* long-context workloads
* massive MoE models
* inference efficiency

The Rubin GPU has:

**336 billion transistors**

**896 Tensor Cores**

**288 GB HBM4**

and up to:

**22 TB/s memory bandwidth** per GPU. ([NVIDIA Developer][4])

Compare the fundamental idea:

```text
Old AI:

GPU → calculate

Modern AI:

GPU → calculate
       ↓
memory
       ↓
NVLink
       ↓
GPU
       ↓
network
       ↓
storage
       ↓
CPU
       ↓
GPU
```

The **entire system** matters.

---

# 17. NVLink 6

This is another huge part of the story.

Rubin's NVLink 6 provides enormous GPU-to-GPU bandwidth.

NVIDIA reports:

**3.6 TB/s per GPU**

and approximately:

**260 TB/s across the NVL72 rack.** ([NVIDIA Newsroom][5])

That means the GPUs can communicate so quickly that the rack begins behaving much more like a single computational system.

This is the direction NVIDIA is pushing:

```text
             AI MODEL
                │
        ┌───────┴───────┐
        │               │
      GPU 1            GPU 2
        │               │
        └───────┬───────┘
                │
             NVLink
                │
        ┌───────┴───────┐
        │               │
      GPU 3            GPU 4
        │
       ...
        │
      GPU 72
```

---

# 18. HBM4 is another critical piece

This is something people often overlook.

AI isn't only about compute.

It's also:

> **How quickly can you feed the compute engine with data?**

Rubin uses HBM4.

NVIDIA reports:

```text
288 GB HBM4 / GPU
22 TB/s bandwidth
```

and says the architecture is designed to support multitrillion-parameter models and huge KV caches. ([NVIDIA Developer][4])

This matters enormously for inference.

---

# 19. Why memory is becoming more important

Consider an LLM.

You have:

```text
Model weights
+
activations
+
KV cache
+
context
+
batch
+
multiple users
```

As context gets larger:

```text
8K
 ↓
32K
 ↓
128K
 ↓
1M
 ↓
???
```

memory requirements explode.

Agentic systems make it worse because the model may maintain long sequences of interactions.

Therefore:

```text
AI performance
≠ just FLOPS
```

Increasingly:

```text
AI performance
=
compute
+
memory
+
bandwidth
+
interconnect
+
software
+
networking
```

This is precisely the type of problem NVIDIA is designing around.

---

# 20. NVIDIA's software moat

This may actually be more important than the silicon.

Think about your own machine.

You have used:

```text
RTX 3090 Ti
      ↓
NVIDIA driver
      ↓
CUDA
      ↓
Ollama
      ↓
LLM
```

Your local AI stack literally depends on NVIDIA's ecosystem.

Your own Docker configuration reflects this: Ollama is given access to all NVIDIA GPUs, while Open WebUI talks to Ollama as the local inference server. 

And your broader ML guide describes the same architecture:

```text
OpenWebUI
    ↓
Ollama
    ↓
GPU
```

with Qdrant for memory and Flowise for agent workflows. 

That is essentially a miniature version of the same conceptual stack NVIDIA is building at hyperscale.

---

# 21. Your RTX 3090 Ti is part of this story

This is actually why your 3090 Ti remains interesting for local AI.

You aren't merely benefiting from:

```text
24 GB VRAM
```

You're benefiting from:

```text
NVIDIA GPU
      ↓
CUDA
      ↓
PyTorch / llama.cpp / Ollama / etc.
      ↓
optimized kernels
      ↓
LLM
```

And this is exactly the ecosystem NVIDIA has spent decades building.

Your local AI environment can therefore look conceptually like:

```text
             YOUR HOMELAB
                  │
        ┌─────────┴─────────┐
        │                   │
     OpenWebUI            Agents
        │                   │
      Ollama              Flowise
        │                   │
        └─────────┬─────────┘
                  │
                CUDA
                  │
             RTX 3090 Ti
                  │
             LLM weights
```

Your own guide explicitly emphasizes the separation:

**Model = brain**

**Runner = body**

**Agent framework = nervous system**. 

NVIDIA essentially owns a huge portion of the **body** underneath that architecture.

---

# 22. NVIDIA's next major battlefield: inference

This is where I think the NVIDIA story gets particularly interesting technically.

Training:

```text
Huge investment
 ↓
train model
 ↓
model exists
```

Inference:

```text
millions/billions of users
 ↓
every request
 ↓
every token
 ↓
every agent step
```

Inference becomes a recurring compute workload.

And agentic AI could multiply inference demand.

One traditional chatbot request might be:

```text
Prompt
 ↓
Answer
```

An agent might do:

```text
Prompt
 ↓
reason
 ↓
search
 ↓
read document
 ↓
reason
 ↓
call API
 ↓
reason
 ↓
write code
 ↓
test
 ↓
fix
 ↓
test
 ↓
answer
```

That's **many more inference operations**.

NVIDIA is explicitly targeting this.

Rubin is designed around agentic workloads and NVIDIA claims up to **10× lower inference token cost versus Blackwell**. ([NVIDIA Newsroom][5])

---

# 23. Physical AI is another huge future direction

NVIDIA isn't stopping at language.

It is building infrastructure for:

```text
Robotics
Autonomous vehicles
Industrial automation
Digital twins
Simulation
Humanoid robots
Vision
Healthcare
Scientific computing
```

NVIDIA's software stack includes things such as:

* DRIVE
* Isaac
* Omniverse
* Cosmos
* Nemotron
* AI Enterprise

Its 2026 filing describes these domain-specific stacks as part of its strategy to bring AI into major industries. ([SEC][1])

This creates another fascinating loop:

```text
Simulation
     ↓
Synthetic data
     ↓
Training
     ↓
AI model
     ↓
Robot
     ↓
Real-world data
     ↓
Simulation
     ↓
Improved model
```

NVIDIA wants to own the computing infrastructure underneath that loop.

---

# 24. NVIDIA's ultimate vision

I would describe NVIDIA's long-term architecture as:

```text
                  NVIDIA
                     │
       ┌─────────────┼──────────────┐
       │             │              │
     Compute       Network        Software
       │             │              │
     GPU/CPU       NVLink         CUDA
       │          InfiniBand      CUDA-X
     HBM          Ethernet        TensorRT
       │             │             NeMo
       └─────────────┼──────────────┘
                     │
               AI FACTORY
                     │
        ┌────────────┼─────────────┐
        │            │             │
      Training    Inference      Agents
        │            │             │
        └────────────┼─────────────┘
                     │
              Intelligence
                     │
        ┌────────────┼─────────────┐
        │            │             │
       LLMs       Robotics      Science
        │            │             │
     Search       Vehicles      Discovery
     Coding       Factories     Simulation
```

That's a much bigger proposition than selling GPUs.

---

# 25. And NVIDIA has created an interesting feedback loop

This is perhaps the most important strategic concept.

```text
More AI adoption
       ↓
More NVIDIA GPUs
       ↓
More CUDA developers
       ↓
More CUDA software
       ↓
More optimized AI workloads
       ↓
More reasons to use NVIDIA
       ↓
More AI adoption
```

And now:

```text
More GPUs
 ↓
more networking
 ↓
more NVIDIA systems
 ↓
more CUDA
 ↓
more developers
 ↓
stronger ecosystem
```

That's a **platform flywheel**.

---

# 26. Why competitors have such a difficult problem

The competition isn't simply:

```text
NVIDIA GPU vs AMD GPU
```

It's:

```text
NVIDIA
│
├── GPU
├── CPU
├── HBM integration
├── CUDA
├── TensorRT
├── NCCL
├── NVLink
├── InfiniBand
├── Ethernet
├── DPUs
├── networking
├── DGX
├── HGX
├── NVL72
├── AI Enterprise
├── NeMo
├── Cosmos
├── models
├── developer ecosystem
└── enormous installed base
```

So a competitor has to ask:

> Can I build a faster GPU?

But that's not enough.

They need:

```text
GPU
+
compiler
+
libraries
+
framework support
+
distributed computing
+
networking
+
systems
+
developers
+
cloud support
+
enterprise support
```

That's vastly harder.

---

# 27. But NVIDIA isn't invincible

This is important.

There are several technical threats.

### 1. Custom AI ASICs

Google:

**TPU**

Amazon:

**Trainium / Inferentia**

Microsoft:

**Maia**

Meta:

**MTIA**

These companies are trying to build specialized silicon for their own workloads.

---

### 2. AMD

AMD's Instinct accelerators and ROCm are the obvious direct alternative.

The battle is increasingly:

```text
CUDA
vs
ROCm
```

not merely:

```text
GPU
vs
GPU
```

---

### 3. Inference-specific accelerators

Companies are building chips specifically around:

```text
low latency
high token throughput
long context
low power
```

This is particularly interesting as inference becomes a larger percentage of AI compute.

---

### 4. Model efficiency

This is a huge wildcard.

If models become dramatically more efficient:

```text
same intelligence
 ↓
10× less compute
```

then the amount of hardware required per unit of intelligence could fall.

But there is another possibility:

```text
AI becomes 10× cheaper
 ↓
AI usage becomes 100× larger
```

which could actually increase total compute demand.

---

# 28. The energy problem

This is probably one of NVIDIA's biggest long-term technical constraints.

AI infrastructure requires:

```text
GPU
 ↓
electricity
 ↓
heat
 ↓
cooling
```

At sufficient scale:

```text
AI factory
   ↓
hundreds of MW
   ↓
possibly GW-scale infrastructure
```

NVIDIA itself identifies data-center availability, energy and capital as important constraints on future AI infrastructure deployment. ([SEC][1])

This means the future of NVIDIA isn't just:

> "How fast can the GPU become?"

It's also:

> **How much intelligence can we produce per watt?**

That's why:

```text
tokens / watt
```

is becoming an increasingly important metric.

---

# 29. And this explains Rubin

Rubin isn't merely:

> "Blackwell but faster."

The design target is increasingly:

```text
Intelligence
      ↓
per dollar
      ↓
per watt
      ↓
per rack
```

NVIDIA's technical materials say Rubin's architecture targets much higher agentic throughput per unit of energy and significantly higher memory bandwidth than Blackwell. ([NVIDIA Developer][4])

That's exactly what an AI infrastructure company should be optimizing.

---

# 30. NVIDIA's roadmap is becoming annual

This is another huge change.

Historically:

```text
GPU generation
      ↓
years
```

NVIDIA has been moving toward:

```text
Hopper
  ↓
Blackwell
  ↓
Blackwell Ultra
  ↓
Rubin
  ↓
future Rubin variants
  ↓
next architecture
```

NVIDIA says it is pursuing an annual cadence of new AI supercomputers. ([NVIDIA Newsroom][5])

That's extremely important because AI itself is evolving incredibly rapidly.

---

# 31. The NVIDIA architecture in one sentence

If I had to compress everything we've discussed into one sentence:

> **NVIDIA transformed the GPU from a graphics accelerator into a programmable computing platform, then transformed that platform into a tightly integrated CPU/GPU/memory/network/software system designed to manufacture intelligence at data-center scale.**

That's why NVIDIA is so important to AI.

---

# 32. The really fascinating part for you

Given the local-AI work we've been doing, I think we should take this one step further.

You have essentially been building a **miniature version of NVIDIA's AI stack**:

```text
                     YOUR AI LAB
                         │
                 ┌───────┴───────┐
                 │               │
             OpenWebUI         Flowise
                 │               │
                 └───────┬───────┘
                         │
                       Ollama
                         │
                       CUDA
                         │
                    RTX 3090 Ti
                         │
                    LLM weights
                         │
                 ┌───────┴───────┐
                 │               │
               Qdrant          Agents
                 │               │
              RAG/memory      Tools/APIs
```

Your own local stack explicitly uses NVIDIA GPU acceleration through Docker and NVIDIA Container Toolkit, while Ollama provides the local model-serving layer. 

And your Jetson Orin Nano is another piece of the NVIDIA strategy:

```text
Data center AI
      ↓
Workstation AI
      ↓
Edge AI
      ↓
Robotics / physical AI
```

Your Jetson documentation specifically positions the Orin Nano as an edge ML/AI platform with CUDA/TensorRT-oriented deployment.  

---

# The NVIDIA story in 7 generations

| Era           | NVIDIA's identity             | Critical technology                      |
| ------------- | ----------------------------- | ---------------------------------------- |
| **1993–1999** | Graphics company              | 3D GPU                                   |
| **1999–2006** | GPU computing company         | Programmable GPU                         |
| **2006–2012** | Accelerated computing company | **CUDA**                                 |
| **2012–2017** | AI acceleration company       | Deep learning + CUDA                     |
| **2017–2020** | AI hardware company           | **Tensor Cores**                         |
| **2020–2025** | AI infrastructure company     | Networking + Grace + NVLink + Blackwell  |
| **2026→**     | **AI factory company**        | Rubin + agents + reasoning + physical AI |

And NVIDIA's FY2026 numbers show just how dramatic the transition has been: total revenue reached **$215.9B**, with **$193.7B from Data Center**, up 68% year-over-year. ([SEC][1])

---

# My mental model of NVIDIA

Don't think:

> **NVIDIA = GPU company**

Think:

> **NVIDIA = accelerated-computing platform**

And increasingly:

> **NVIDIA = intelligence infrastructure company**

The hierarchy is:

```text
                    AI
                     │
                  Models
                     │
                  Agents
                     │
                Inference
                     │
               AI Factory
                     │
        ┌────────────┼────────────┐
       GPU          CPU        Networking
        │             │            │
       HBM          Grace       NVLink/NIC
        └────────────┼────────────┘
                     │
                  CUDA
                     │
              NVIDIA Platform
```

And **that** is why NVIDIA's future is much more interesting technically than simply asking whether the next GeForce GPU will be faster.

---

## Where I would take this deep-dive next

For your ML Guide, I'd make the **next chapter extremely technical**:

### **NVIDIA Architecture Deep Dive: From CUDA → Tensor Cores → Hopper → Blackwell → Rubin**

We can actually take a **single LLM inference request** and follow the data through the NVIDIA stack:

```text
Prompt
  ↓
CPU
  ↓
CUDA
  ↓
TensorRT-LLM
  ↓
GPU scheduling
  ↓
Tensor Cores
  ↓
HBM
  ↓
KV Cache
  ↓
NVLink
  ↓
multiple GPUs
  ↓
network fabric
  ↓
tokens
  ↓
user
```

Then we can compare **RTX 3090 Ti vs H100 vs H200 vs B200/GB200 vs Blackwell Ultra vs Rubin** at the architectural level—**SMs, Tensor Cores, FP8/FP4/NVFP4, VRAM/HBM, memory bandwidth, NVLink, TDP, tokens/sec and tokens/watt**.

That would connect directly to your own **3090 Ti → local LLM → Ollama → CUDA** setup and make the NVIDIA story much more concrete.

[1]: https://www.sec.gov/Archives/edgar/data/1045810/000104581026000021/nvda-20260125.htm "nvda-20260125"
[2]: https://www.nvidia.com/en-us/about-nvidia/corporate-timeline/ "Our History: Innovations Over the Years | NVIDIA"
[3]: https://www.nvidia.com/en-us/data-center/technologies/blackwell-architecture/ "The Engine Behind AI Factories | NVIDIA Blackwell Architecture"
[4]: https://developer.nvidia.com/blog/inside-nvidia-rubin-gpu-architecture-powering-the-era-of-agentic-ai/ "Inside NVIDIA Rubin GPU Architecture: Powering the Era of Agentic AI | NVIDIA Technical Blog"
[5]: https://nvidianews.nvidia.com/news/rubin-platform-ai-supercomputer "NVIDIA Kicks Off the Next Generation of AI With Rubin — Six New Chips, One Incredible AI Supercomputer | NVIDIA Newsroom"
