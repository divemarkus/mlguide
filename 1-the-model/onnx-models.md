# ONNX models

Yes. **ONNX models are a very important piece of the Windows ML story**, and they are somewhat different from the GGUF models you're accustomed to using with Ollama/LM Studio.

## 1. What exactly is an ONNX model?

**ONNX = Open Neural Network Exchange.**

It is an **open model representation/interchange format** designed so that a model trained in one ML framework can be deployed through many different inference runtimes and hardware backends.

Think of it this way:

| Ecosystem          | Typical model format          | Primary use                 |
| ------------------ | ----------------------------- | --------------------------- |
| Ollama / llama.cpp | GGUF                          | Local LLM inference         |
| PyTorch            | `.safetensors`, `.pt`, `.pth` | Training/research/inference |
| TensorFlow         | SavedModel / `.pb`            | Training/inference          |
| **ONNX**           | **`.onnx`**                   | **Portable inference**      |
| TensorRT           | Engine/plan                   | NVIDIA optimized inference  |
| Core ML            | `.mlpackage`                  | Apple hardware              |
| TFLite             | `.tflite`                     | Mobile/edge                 |

An ONNX model essentially describes a **computation graph**:

```text
Input
  │
  ▼
┌──────────┐
│ Operator │
└────┬─────┘
     ▼
┌──────────┐
│ Operator │
└────┬─────┘
     ▼
┌──────────┐
│ Operator │
└────┬─────┘
     ▼
   Output
```

The ONNX specification defines the operators, tensors, data types, graph structure, etc. The actual execution is handled by something such as **ONNX Runtime / Windows ML**. ([GitHub][1])

That separation is extremely useful.

---

# 2. Why ONNX matters to Windows ML

This is the important connection to your previous question.

Your Windows machine can theoretically do:

```text
                Your application
                      │
                      ▼
                 Windows ML
                      │
                ONNX Runtime
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
         CPU         GPU         NPU
```

Windows ML can select an appropriate **Execution Provider (EP)** for the hardware.

For example:

```text
ONNX model
    │
    ▼
ONNX Runtime
    │
    ├── CPU
    │
    ├── NVIDIA GPU
    │     └── TensorRT / CUDA-related EPs
    │
    ├── AMD GPU
    │
    └── NPU
          └── vendor-specific EP
```

That's one of Microsoft's major reasons for pushing Windows ML: the application developer doesn't necessarily have to build an entirely different inference implementation for every hardware platform.

---

# 3. Where do you get ONNX models?

There are **three places I'd concentrate on**.

## A. Hugging Face — the big one today

[Hugging Face ONNX models](https://huggingface.co/models?library=onnx)

This is probably the **most important place to look today**.

The ONNX Model Zoo itself now explicitly says that much of the newer model sharing has moved to Hugging Face, and the original ONNX Model Zoo repository is being preserved primarily for historical purposes. ([GitHub][2])

Hugging Face currently has **tens of thousands of models tagged/compatible with ONNX**. ([Hugging Face][3])

You'll find things like:

* BERT
* GPT-2
* T5
* RoBERTa
* Whisper
* embedding models
* rerankers
* object detection
* image classification
* image segmentation
* speech recognition
* text-to-speech
* computer vision
* multimodal models

For example, the current ONNX listing includes models such as:

```text
all-MiniLM-L6-v2
BGE
BERT
T5
Whisper-derived models
Kokoro
Stable Diffusion
RMBG
ModernBERT
```

and many others. ([Hugging Face][3])

---

# 4. The old ONNX Model Zoo

The original repository is:

[ONNX Model Zoo — GitHub](https://github.com/onnx/models)

It contains classic models such as:

* MobileNet
* ResNet
* SqueezeNet
* VGG
* AlexNet
* BERT
* GPT-2
* T5
* RoBERTa
* object detection models
* image segmentation
* speech/audio models

However, **don't treat this as the primary modern model repository anymore**.

The ONNX project explicitly marks the Model Zoo as historical and directs users toward Hugging Face. ([GitHub][2])

---

# 5. You can also convert models to ONNX

This is actually one of the most interesting parts.

You don't necessarily have to find an ONNX version.

You can start with:

```text
PyTorch
TensorFlow
Keras
scikit-learn
Hugging Face Transformers
```

and convert/export the model to:

```text
             ONNX
              │
       ┌──────┼──────┐
       ▼      ▼      ▼
     CPU     GPU     NPU
```

The ONNX project itself provides tutorials for obtaining pretrained models and converting models from other frameworks. ([GitHub][4])

For example:

```text
PyTorch model
     │
     │ export
     ▼
model.onnx
     │
     ▼
ONNX Runtime
     │
     ▼
Windows ML
     │
     ├── CPU
     ├── GPU
     └── NPU
```

This is fundamentally different from Ollama's model workflow.

---

# 6. ONNX isn't synonymous with LLMs

This is an important distinction.

When you hear:

> "ONNX model"

don't automatically think:

> "LLM."

ONNX is much broader.

### Computer vision

```text
Camera
  ↓
YOLO / object detector
  ↓
ONNX
  ↓
GPU/NPU
  ↓
"Car detected"
```

### OCR

```text
Image
  ↓
OCR model
  ↓
ONNX
  ↓
NPU
  ↓
Text
```

### Speech

```text
Microphone
  ↓
Speech model
  ↓
ONNX
  ↓
NPU
  ↓
Text
```

### Embeddings

```text
Text
 ↓
Embedding model
 ↓
ONNX
 ↓
Vector
 ↓
Qdrant
```

### LLM

```text
Prompt
 ↓
Transformer
 ↓
ONNX
 ↓
GPU/NPU
 ↓
Tokens
```

So ONNX is really a **deployment/interoperability format for ML models**, rather than a particular class of AI.

---

# 7. This is where your Qdrant setup gets interesting

Your existing local architecture has a natural ONNX use case.

You could have:

```text
                 YOUR LOCAL AI LAB
                       │
                       ▼
                  OpenWebUI
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
           Ollama             Windows ML
             │                   │
          GGUF LLMs          ONNX models
                                 │
                    ┌────────────┼────────────┐
                    ▼            ▼            ▼
                  RTX         CPU/NPU       Edge
                    │
                    ▼
                Embeddings
                    │
                    ▼
                  Qdrant
```

For example, instead of using a GPU-heavy embedding model through Ollama, you could potentially run a relatively small ONNX embedding model directly through ONNX Runtime/Windows ML.

That can be **very efficient**.

---

# 8. ONNX vs GGUF — particularly relevant to you

This is probably the most useful comparison for your lab.

|                     | **GGUF**            | **ONNX**                 |
| ------------------- | ------------------- | ------------------------ |
| Origin              | llama.cpp ecosystem | Microsoft/ONNX ecosystem |
| Primary target      | LLMs                | General ML               |
| LLM support         | Excellent           | Good/increasing          |
| Vision              | Limited             | Excellent                |
| Speech              | Limited             | Excellent                |
| Embeddings          | Good                | Excellent                |
| NPU                 | Not primary focus   | **Major focus**          |
| CPU                 | Excellent           | Excellent                |
| NVIDIA GPU          | Excellent           | Excellent                |
| AMD GPU             | Good                | Good                     |
| Windows integration | Good                | **Excellent**            |
| Quantization        | Excellent           | Excellent                |
| Model portability   | Good                | **Excellent**            |
| Ollama              | Native              | Not its native format    |
| Windows ML          | Not native          | **Native**               |

So I wouldn't replace your GGUF ecosystem with ONNX.

I'd use **both**.

---

# 9. Your RTX 3090 Ti is particularly interesting

Your 3090 Ti gives you a very good experimental platform because you can compare:

### Stack A — your current LLM stack

```text
Qwen / other LLM
       ↓
      GGUF
       ↓
    Ollama
       ↓
 RTX 3090 Ti
```

versus:

### Stack B — Microsoft/Windows ML

```text
ONNX model
       ↓
 Windows ML
       ↓
 ONNX Runtime
       ↓
 RTX 3090 Ti
```

And potentially:

### Stack C — Foundry Local

```text
Local LLM
    ↓
Foundry Local
    ↓
Windows hardware
    ↓
RTX 3090 Ti
```

That would make a **very interesting three-way benchmark** on your Ryzen 9900X3D/3090 Ti system.

---

# 10. One thing I would NOT do

Don't just search Hugging Face for:

> `ONNX`

and download the first model you see.

You need to check:

**1. Model architecture**

```text
BERT
Whisper
YOLO
Llama
Phi
etc.
```

**2. Task**

```text
text generation
embedding
classification
object detection
speech recognition
etc.
```

**3. Quantization**

```text
FP32
FP16
INT8
INT4
```

**4. Hardware target**

```text
CPU
CUDA
TensorRT
DirectML
NPU
AMD
Intel
Qualcomm
```

**5. ONNX opset**

The model's ONNX opset needs to be supported by the runtime/EP you're using.

**6. Execution Provider compatibility**

This becomes particularly important with Windows ML.

---

# 11. A particularly useful repository for you

I'd bookmark these:

[ONNX project on GitHub](https://github.com/onnx/onnx)

[ONNX Model Zoo](https://github.com/onnx/models)

[Hugging Face ONNX model catalog](https://huggingface.co/models?library=onnx)

And **Netron** is excellent for inspecting an ONNX model's actual computational graph. The ONNX Model Zoo itself recommends it for visualizing model architectures. ([GitHub][2])

---

## The bigger picture

Given the direction you're taking with your **local AI/ML lab**, I would think about the ecosystems this way:

```text
                         LOCAL AI
                            │
             ┌──────────────┼──────────────┐
             │              │              │
           GGUF            ONNX          MLX
             │              │              │
          Ollama       Windows ML       Apple
             │        ONNX Runtime         │
         OpenWebUI          │            Mac
             │              │
             ▼              ▼
          RTX 3090 Ti    CPU/GPU/NPU
```

**GGUF is currently your LLM workhorse.**

**ONNX is the interesting "universal ML deployment" layer**, particularly as Windows starts treating the NPU, GPU and CPU as interchangeable AI compute resources.

And this is why I think **Windows ML is worth adding to your lab rather than viewing it as another competitor to Ollama**: it opens up a completely different class of workloads—vision, speech, embeddings, OCR, detection, small transformers, and NPU-accelerated applications—that your Ollama-centric architecture isn't designed around.

[1]: https://github.com/onnx/onnx "GitHub - onnx/onnx: Open standard for machine learning interoperability · GitHub"
[2]: https://github.com/onnx/models/blob/main/README.md "models/README.md at main · onnx/models · GitHub"
[3]: https://huggingface.co/models?library=onnx "Models compatible with the ONNX library – Hugging Face"
[4]: https://github.com/onnx/tutorials "GitHub - onnx/tutorials: Tutorials for creating and using ONNX models · GitHub"
