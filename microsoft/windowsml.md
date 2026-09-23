# Windows AI APIs → Foundry Local → Windows ML

The Microsoft page linked is describing something **much more interesting than just “AI features in Windows.”** It is essentially Microsoft's emerging **local/on-device AI developer platform for Windows**.

The important thing is to separate three things:

> **Windows AI APIs → Foundry Local → Windows ML**

Together, Microsoft calls these **Microsoft Foundry on Windows**. ([Microsoft Learn][1])

![Image](https://images.openai.com/static-rsc-4/4X1k88sy2lbKRouHhZmKPoMAzsRfelr59JzJmrOwRpZTTQ62YFFkktbSUpJlzrn-9goTA_dFeH6roJcIbqbOyibv7INH0gmc2wE1GqQ9Q0RaRUkGnGPJJR_EtbZzDDcrRhmHjw2fzk1ejMMuiIa2SRSdkh_OxwUpQdSct0A1olNSo3d4Ha8vlwKNHz4vbJVv?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/RV2meg8zO0B_T-CPXuuZe87rhU8dm0f8B_WGFyvTLZQGpeVBZ-eUbWws3vPzlR0nzycQVR7r3C0OH1-6kOF2kfpMB3bHHfnoAWm5a4BR-FJY23fYvg0NvxO-RA0XZDOFLsrVLmZy9_LPa4ROzfH3A1igP6S6vYYCRzIWjWH6IyE6V1G5kCrZUCvI5fS2tTJh?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/jNSqChvqtz58Q6g27rERAw5tZhBg9_oDYSO5PTbGGBD5-IS6xShDJTgm-DWTEI2H945fJ3Nlm--HiTi9YQtn76T_cIYdGXeri9Ms93QadEMsqJEcvDFWmerjYKlYtFIwmt25HsKmmb5LWQsg2QN-hCL-xoMhQRjUog166mqrROwkI5pznUW8EZOkg8IhFZPD?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/z0Hos-494-HmR59HxJSXmUbAYk5WQwRdPLeMPUnbBzgI8WCt7f9JWsMXs2WQpmsPi3BZ9xpJPblCOwHbn9foNjHvfEUeWYu7BYI_Jdzk4nNnAD9c1B30ZlX_osL7aTwAGsKYJB8h6Nx8WlkwzI35js0c7tWrNHSobeS4ZtQJ3ub0QlJNJpKTmuq4WD1iToEa?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/osIOct-ZFcg9EbYixjxqbbz9qtSI41dWNej99fN0LxLs7RtZxxi1flc4FgCqo1zuEYuB4_dejjJNgAAlsooOmqiVjuE8hTZ97N6OoS6w5STmjYpQwCbnCn8RJZ66_ywP3QJ3XYXRcq6gRE91uJXTsN7owzlVIN4aZrjCetui0oBWXbe6xv9Se-MDizMujhTX?purpose=fullsize)

## 1. What exactly is Windows ML?

**Windows ML is Microsoft's hardware-accelerated local inference framework.**

Think of it roughly as:

```text
                 YOUR WINDOWS APP
                       │
                       ▼
                 ┌───────────┐
                 │ Windows ML│
                 └─────┬─────┘
                       │
                 ONNX Runtime
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
        CPU           GPU          NPU
          │            │            │
       Intel/AMD    NVIDIA/AMD    Qualcomm/
                                  Intel/AMD
```

You provide an **ONNX model**, and Windows ML handles getting that model running on the appropriate hardware. Microsoft describes Windows ML as a Windows-supported, maintained version of **ONNX Runtime**, with hardware-specific execution providers that Windows can acquire and keep updated. ([Microsoft Learn][2])

That makes it considerably more interesting than an ordinary Windows API.

---

# 2. The really important distinction

Microsoft now has **three different ways of doing local AI**:

| Technology          | Think of it as                  | You provide              | Best for                                   |
| ------------------- | ------------------------------- | ------------------------ | ------------------------------------------ |
| **Windows AI APIs** | AI functions built into Windows | Almost nothing           | OCR, image understanding, Phi Silica, etc. |
| **Foundry Local**   | Local LLM runtime               | Choose a supported model | Local LLMs                                 |
| **Windows ML**      | General ML inference engine     | Your own ONNX model      | Custom AI/ML                               |

Microsoft explicitly recommends this progression:

**Windows AI APIs → Foundry Local → Windows ML**, depending on how much control you need. ([Microsoft Learn][1])

---

# 3. Windows AI APIs

This is the easiest level.

Instead of worrying about:

* downloading models
* quantization
* inference engines
* GPU drivers
* NPU SDKs
* model optimization

you essentially call an API.

Microsoft supplies the underlying models/runtime.

Examples include:

### Vision

* Image description
* Image foreground extraction
* Object extraction
* Object removal
* Image generation
* Super resolution

### Language

* LLM capabilities
* semantic search
* text processing

### Speech

* speech recognition

### Computer vision

* OCR
* image understanding

### Video

* Video Super Resolution

Many of these are designed around **Copilot+ PCs**, although Microsoft is expanding support for additional hardware for particular APIs. ([Microsoft Learn][1])

---

# 4. Foundry Local

This is probably the part **you'll find most interesting**.

Foundry Local is Microsoft's local model runtime.

Microsoft describes it as a way to run **open-source LLMs locally on Windows**, with no cloud inference dependency. It supports Windows 10+ and provides an OpenAI-compatible API. ([Microsoft Learn][3])

Conceptually:

```text
                 Your Application
                       │
                 OpenAI API format
                       │
                       ▼
                ┌──────────────┐
                │ Foundry Local│
                └───────┬──────┘
                        │
              ┌─────────┼─────────┐
              ▼         ▼         ▼
             NPU       GPU       CPU
              │         │         │
              └─────────┼─────────┘
                        ▼
                  Local LLM
```

Microsoft currently advertises **20+ models** through Foundry Local. ([Microsoft Learn][1])

This is much closer to what you've been doing with **Ollama/LM Studio**.

---

# 5. And then there's Windows ML

This is the **developer/ML-engineer level**.

Suppose you don't want Microsoft's model.

You have:

```text
Hugging Face model
       ↓
PyTorch
       ↓
convert/optimize
       ↓
ONNX
       ↓
Windows ML
       ↓
GPU / NPU / CPU
```

Microsoft explicitly says you can use models from:

* PyTorch
* TensorFlow/Keras
* TFLite
* scikit-learn
* Hugging Face
* other frameworks

by bringing them into ONNX-compatible workflows. ([Microsoft Learn][2])

And you can even **train your own model** and deploy it through Windows ML. ([Microsoft Learn][1])

---

# 6. Why ONNX matters

This is the piece that makes Microsoft's strategy much clearer.

ONNX is effectively a **model interchange format**.

Instead of:

```text
PyTorch model
     ↓
NVIDIA-specific runtime
```

you can do:

```text
             ONNX
               │
       ┌───────┼────────┐
       ▼       ▼        ▼
     CPU      GPU      NPU
```

Windows ML can select an appropriate **Execution Provider (EP)** for the hardware.

Microsoft says these can include vendor-specific providers for hardware such as NVIDIA, Qualcomm, Intel, AMD and others. ([Microsoft Learn][2])

That's a major architectural advantage.

---

# 7. This is where Windows ML becomes interesting for your RTX 3090 Ti

Your **RTX 3090 Ti** is not a Copilot+ NPU machine.

That does **not** mean you're excluded.

Windows ML supports CPU, GPU and NPU inference, and Microsoft specifically says Windows ML can run on Windows PCs with x64/ARM64 and essentially any hardware configuration, with performance dependent on the available hardware. ([Microsoft Learn][2])

So your machine can theoretically look like:

```text
Ryzen 9 9900X3D
       │
       ├── CPU
       │
       └── RTX 3090 Ti
               │
               ▼
          Windows ML
               │
               ▼
           ONNX Model
```

That's different from your current:

```text
LM Studio
      ↓
GGUF
      ↓
llama.cpp
      ↓
RTX 3090 Ti
```

or:

```text
Ollama
   ↓
GGUF / model
   ↓
Ollama runtime
   ↓
RTX 3090 Ti
```

---

# 8. Windows ML vs Ollama vs LM Studio

This is where I think this becomes particularly relevant to your ML lab.

|                       | **Ollama**          | **LM Studio**         | **Foundry Local**           | **Windows ML**       |
| --------------------- | ------------------- | --------------------- | --------------------------- | -------------------- |
| Primary purpose       | Local LLM runtime   | Local LLM development | Microsoft local LLM runtime | General ML inference |
| LLMs                  | ✅                   | ✅                     | ✅                           | Possible             |
| Custom ML models      | Limited             | Limited               | Limited                     | **✅**                |
| ONNX                  | Not primary         | Not primary           | Underlying ecosystem        | **Core**             |
| GPU                   | ✅                   | ✅                     | ✅                           | **✅**                |
| NPU                   | Hardware-dependent  | Hardware-dependent    | **✅**                       | **✅**                |
| CPU                   | ✅                   | ✅                     | ✅                           | **✅**                |
| OpenAI API            | Common integrations | ✅                     | **✅**                       | Not its primary role |
| RAG                   | External tooling    | Some                  | Application-level           | Application-level    |
| Agent runtime         | External            | Some                  | Application-level           | Application-level    |
| Windows integration   | Good                | Good                  | **Excellent**               | **Excellent**        |
| Model control         | High                | High                  | Medium                      | **Very high**        |
| Enterprise deployment | Moderate            | Moderate              | **High**                    | **Very high**        |

The important distinction is:

**Ollama/LM Studio are primarily model runtimes.**

**Windows ML is an ML inference platform.**

---

# 9. Microsoft's larger architecture

This is the part that I think is easy to miss if you only read the individual Microsoft pages.

Microsoft is building something like:

```text
                 MICROSOFT FOUNDRY
                        │
          ┌─────────────┴──────────────┐
          │                            │
     CLOUD AI                      WINDOWS AI
          │                            │
   Azure Foundry              Microsoft Foundry
                                      │
                     ┌────────────────┼────────────────┐
                     │                │                │
              Windows AI APIs   Foundry Local     Windows ML
                     │                │                │
               Microsoft models   Local LLMs       Custom models
                     │                │                │
                     └────────────────┼────────────────┘
                                      │
                              Local Hardware
                                      │
                         ┌────────────┼────────────┐
                         ▼            ▼            ▼
                        CPU          GPU          NPU
```

That architecture is explicitly reflected in Microsoft's current documentation. ([Microsoft Learn][1])

---

# 10. And here's the really interesting part for you

Microsoft is moving toward **local + cloud AI**, rather than cloud-only AI.

For example:

```text
                   APPLICATION
                        │
             ┌──────────┴──────────┐
             │                     │
        LOCAL AI                CLOUD AI
             │                     │
      ┌──────┼──────┐              │
      ▼      ▼      ▼              ▼
     NPU    GPU    CPU           Azure
      │      │      │
      └──────┼──────┘
             │
       Windows AI
```

An application can potentially decide:

> "This task is small/private → run locally."

and:

> "This task requires a frontier model → send to Azure."

That's becoming a major architectural pattern.

---

# 11. Microsoft is also trying to eliminate hardware-specific pain

This is arguably one of Windows ML's biggest purposes.

Historically:

```text
NVIDIA → CUDA/TensorRT
AMD    → ROCm
Intel  → OpenVINO
Qualcomm → QNN
Windows → DirectML
```

Developers had to understand all of this.

Windows ML is attempting to create:

```text
              YOUR APP
                 │
            Windows ML
                 │
       ┌─────────┴─────────┐
       │                   │
 Execution Provider    Windows
       │               manages it
       ▼
  Hardware-specific
     acceleration
```

Microsoft says Windows can dynamically acquire hardware-specific execution providers and keep them updated, reducing the need for applications to bundle vendor-specific runtime components. ([Microsoft Learn][2])

That is **very significant**.

---

# 12. One terminology trap to be aware of

Microsoft's naming has changed repeatedly.

If you search older documentation, you'll encounter:

| Old terminology         | Current terminology                                     |
| ----------------------- | ------------------------------------------------------- |
| Windows AI Foundry      | **Microsoft Foundry on Windows**                        |
| Windows Copilot Runtime | **Microsoft Foundry on Windows**                        |
| Copilot Runtime APIs    | **Windows AI APIs**                                     |
| Windows ML              | There is an **old** Windows ML and a **new** Windows ML |
| DirectML                | Still exists, but is now in sustained engineering       |

Microsoft explicitly calls out this terminology evolution. ([Microsoft Learn][4])

**This is important when researching Microsoft's AI documentation.**

The **new Windows ML** is the one you want to pay attention to.

---

# 13. What I would watch

For your particular interest in local AI, I would watch these four Microsoft technologies:

### 🥇 Windows ML

The underlying inference infrastructure.

### 🥈 Foundry Local

Microsoft's answer to:

**"What if I want Ollama-like local models, but integrated into Windows?"**

### 🥉 Windows AI APIs

This is where Microsoft turns local AI into normal Windows application capabilities.

### ⭐ AI Dev Gallery / Foundry Toolkit

These make experimentation with local models considerably easier for developers. Microsoft's current Windows AI platform includes both developer tooling and examples. ([Microsoft Learn][1])

---

# And this connects directly to your local AI lab

You currently have an architecture roughly like:

```text
             YOU
              │
       ┌──────┴──────┐
       │             │
    LM Studio      Ollama
       │             │
     GGUF          Models
       │             │
       └──────┬──────┘
              │
          RTX 3090 Ti
              │
       OpenWebUI / Agents
```

Microsoft is essentially building a **Windows-native alternative layer**:

```text
             YOU
              │
          Windows App
              │
       Microsoft Foundry
              │
     ┌────────┼────────┐
     │        │        │
 Windows   Foundry   Windows
 AI APIs    Local      ML
     │        │        │
     │       LLMs     ONNX
     │        │        │
     └────────┼────────┘
              │
       ┌──────┼──────┐
       ▼      ▼      ▼
      CPU    GPU     NPU
```

And **that's why I think Windows ML deserves a place on your radar**.

It's not Microsoft's attempt to replace ChatGPT.

It's Microsoft's attempt to make **AI inference a native capability of Windows itself**.

For someone building the kind of local/private AI environment you're building, **Windows ML + Foundry Local are worth experimenting with alongside Ollama and LM Studio rather than replacing them**. Your existing privacy-first stack already follows the same basic local-inference philosophy. 

[Microsoft's Windows AI overview you linked](https://learn.microsoft.com/en-us/windows/ai/overview)

> This needs more investigation

[1]: https://learn.microsoft.com/en-us/windows/ai/overview "Use local AI with Microsoft Foundry on Windows | Microsoft Learn"
[2]: https://learn.microsoft.com/windows/ai/new-windows-ml/overview "What is Windows ML? | Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/windows/ai/ "Windows AI | Microsoft Learn"
[4]: https://learn.microsoft.com/en-us/windows/ai/windows-ai-comparison "Choose your Windows AI solution | Microsoft Learn"
