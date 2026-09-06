
# Dual-boot macOS & Asahi Linux

Yes — this is a **very interesting split-personality setup**, and I think it fits your goal extremely well:

* **macOS = maximum capability workstation**: Apple-native development, local LLMs, MLX, LM Studio/Ollama, Docker, commercial AI subscriptions such as Codex, and anything where Apple Silicon support is strongest.
* **Asahi Fedora Linux = privacy-first engineering workstation + experimental Linux platform + gaming environment**.

The key is **not** to treat Asahi as a replacement for macOS. Treat the M1/M2 machine as one physical computer hosting two specialized environments.

I would scope it as a **70/30 or 80/20 split in favor of macOS**, with Linux becoming your clean, privacy-oriented environment.

Before locking down the exact architecture, I’m going to verify the newly released M2 support and current Asahi feature status, because the practical answer depends heavily on exactly what is supported today—GPU, gaming stack, suspend, external displays, hardware acceleration, and partitioning behavior.


# My recommended architecture: **macOS as the powerhouse, Asahi as the sovereign workstation**

The current state of Fedora Asahi Remix makes this much more compelling than it was a couple of years ago. The project now officially supports the M1 and M2 families broadly, and the current Fedora Asahi Remix page lists Fedora Linux 44 with Apple Silicon-specific integration upstreamed into Fedora. It also advertises conformant **OpenGL 4.6, OpenGL ES 3.2, OpenCL 3.0, and Vulkan 1.4** support on Apple Silicon. ([Asahi Linux][1])

For you, I would **not** build a "Linux replacement for macOS."

I would build this:

```text
                    Apple Silicon MacBook
                           │
             ┌─────────────┴─────────────┐
             │                           │
             ▼                           ▼
     ┌───────────────┐           ┌─────────────────┐
     │    macOS      │           │ Fedora Asahi    │
     │   PRIMARY     │           │    SECONDARY    │
     └───────────────┘           └─────────────────┘
             │                           │
             │                           │
     ┌───────▼────────┐          ┌──────▼─────────┐
     │ AI / ML        │          │ Privacy        │
     │ Apple dev      │          │ Security       │
     │ Local LLM      │          │ Linux tools    │
     │ MLX            │          │ Networking     │
     │ LM Studio      │          │ Containers     │
     │ Ollama         │          │ Gaming         │
     │ Codex / Cloud  │          │ Experimentation│
     └────────────────┘          └────────────────┘
```

## 1. Which Mac would I use?

### My preference: **M2 MacBook Air with 16GB or 24GB+ RAM**

For this particular project, the M2 Air is actually a fascinating machine.

You get:

* Excellent battery life.
* Silent operation.
* A mature M2 Asahi support matrix.
* A machine that remains excellent for macOS development.
* Apple GPU support under Linux.
* A portable Fedora workstation that is radically different from a typical x86 Linux laptop.

The current Asahi M2 matrix shows support for the primary display, keyboard, keyboard backlight, trackpad, brightness, Wi-Fi, Bluetooth, speakers, microphone, camera, suspend, and the Apple GPU across supported M2 laptops. ([Asahi Linux][2])

### Memory recommendation

| RAM       | My opinion                                             |
| --------- | ------------------------------------------------------ |
| **8GB**   | Experimental / lightweight Linux only                  |
| **16GB**  | Minimum I would recommend for your use                 |
| **24GB**  | Sweet spot for M2 Air                                  |
| **32GB+** | Excellent if using an M1 Pro/Max or M2 Pro/Max machine |

For gaming through the x86 emulation stack, Asahi itself notes that many games need **16GB of RAM or more** because of the emulation overhead. ([Asahi Linux][3])

So I would **not choose an 8GB model** for this project unless you already own it.

---

# 2. Disk architecture

This is where I would be conservative.

I would **not** give Linux half of the machine automatically.

My starting allocation:

## 1TB SSD

| Environment          |         Allocation |
| -------------------- | -----------------: |
| macOS + applications |          350–450GB |
| macOS AI models/data |          200–300GB |
| Fedora Asahi         |          150–250GB |
| Shared/exchange data | Remaining capacity |

For a 512GB machine:

```text
macOS        300–340GB
Asahi        120–160GB
Reserve       remaining
```

### Why?

Your macOS side will accumulate:

* LM Studio models
* Ollama models
* MLX models
* Python environments
* Docker images
* Xcode
* AI development projects
* caches

That storage disappears surprisingly quickly.

Your Asahi installation, on the other hand, should stay intentionally **clean and disciplined**.

My philosophy would be:

> **macOS stores horsepower. Asahi stores sovereignty.**

The Asahi installer handles Apple Silicon's unusual boot arrangement rather than behaving like a conventional PC dual-boot installer. The project documents that Asahi uses Apple's boot infrastructure and a small APFS-based boot environment to integrate with the Mac's boot picker. ([Asahi Linux][4])

---

# 3. macOS: your unrestricted AI and development environment

I would make macOS your **maximum-capability environment**.

No ideological restrictions.

Use whatever gives you the best result.

## Core development

```text
Homebrew
Git
GitHub CLI
Python
uv
Node.js
Rust
Go
Docker
VS Code
JetBrains tools if desired
Xcode
```

### AI coding

This is where I would go all-in.

Potential stack:

* [OpenAI Codex](https://openai.com/codex/?utm_source=chatgpt.com)
* Claude Code
* GitHub Copilot
* VS Code AI tooling
* local models when privacy or experimentation matters

Since you specifically said **"no holding back, even cloud subscription"**, I would not artificially force everything local.

Instead:

```text
                    TASK ROUTING
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
   Fast local       Complex coding      Private data
   inference         / reasoning         / offline
        │                │                │
        ▼                ▼                ▼
      MLX            Codex/Cloud       Local LLM
   Ollama/LM          Claude/etc.      Ollama/MLX
```

### macOS local AI stack

I would install and maintain:

```text
LM Studio
Ollama
MLX / mlx-lm
PyTorch MPS
Jupyter
uv
Docker Desktop or alternative container runtime
ComfyUI / image tools as needed
```

You already have experience with local models, Ollama, LM Studio, MLX, Docker, and GPU experimentation, so macOS should become your **Apple Silicon AI laboratory**, not merely a laptop OS.

I would keep the heavier experimentation here because Apple Silicon ML support is strongest in macOS through:

* Metal
* MPS
* MLX
* Core ML

---

# 4. Fedora Asahi: build a different machine

This is where things get interesting.

I would make Asahi intentionally different from your macOS environment.

Not a duplicate.

## Fedora Asahi identity

```text
FEDORA ASAHI
│
├── Privacy
├── Security
├── Networking
├── Linux engineering
├── Open-source AI experimentation
├── ARM64 development
├── Containers
├── Gaming
└── Experimental hardware/software
```

Since you have been using Fedora essentially since its early days, I would lean into that.

### Desktop environment

My recommendation:

## **KDE Plasma as primary**

Why?

* Excellent Wayland experience.
* Very configurable.
* Good multi-monitor workflow.
* Strong gaming integration.
* Familiar power-user desktop model.
* Easy to create a very efficient workstation.

GNOME is perfectly viable, but for **your engineering + networking + gaming use case**, I think KDE is the better fit.

---

# 5. Privacy-focused architecture

I would make privacy a structural part of the Linux install.

## Browser separation

Install multiple browsers with separate purposes.

### Browser 1 — normal

```text
Firefox
```

General browsing.

### Browser 2 — hardened

```text
LibreWolf
or
hardened Firefox profile
```

Use for:

* research
* sensitive browsing
* reduced telemetry

### Browser 3 — disposable

A separate browser profile or containerized browser.

Use for:

* random sites
* downloads
* temporary sessions

The important thing is **compartmentalization**, not simply installing one "privacy browser."

---

# 6. DNS and network privacy

This is where I think your networking background can make the Asahi machine particularly interesting.

I would build the following layers:

```text
Applications
     │
     ▼
Browser / OS
     │
     ▼
Local DNS Resolver
     │
     ├── DNSSEC
     ├── Encrypted upstream DNS
     └── Blocklists
     │
     ▼
VPN / Privacy network when required
     │
     ▼
Internet
```

Potential local stack:

```text
Unbound
dnscrypt-proxy
or
Technitium / Pi-hole elsewhere on your network
```

For the laptop itself, I prefer **local resolver + NetworkManager integration** rather than making the laptop dependent on an external SaaS privacy service.

You could also build several NetworkManager profiles:

```text
Home
Work
Public Wi-Fi
VPN
Travel
Lab
```

Each profile could have:

* different DNS
* firewall behavior
* VPN auto-connect rules
* different network discovery settings

---

# 7. Security stack

This is where I would make Fedora Asahi a true engineering workstation.

## Layer 1: SELinux

Keep it:

```text
SELinux = Enforcing
```

Do not disable it just because something is inconvenient.

Instead learn and troubleshoot around it.

For a privacy/security workstation, SELinux is part of the value proposition.

---

## Layer 2: Firewall

Use:

```text
firewalld
```

Create explicit zones:

```text
home
work
public
vpn
lab
```

Example philosophy:

### Home

```text
Normal outbound access
Limited LAN discovery
SSH only when explicitly enabled
```

### Public Wi-Fi

```text
No inbound services
No LAN discovery
No SMB discovery
No mDNS unless required
VPN preferred
```

### Lab

```text
Specific development ports
Container access
Kubernetes / Docker experimentation
```

---

## Layer 3: SSH

```text
PasswordAuthentication no
PermitRootLogin no
AllowUsers <your-user>
```

Use:

* FIDO2 security keys
* SSH agent
* hardware-backed keys where practical

---

## Layer 4: secrets

I would separate secrets from your code environment.

Potential tools:

```text
KeePassXC
age
sops
GPG where required
SSH hardware-backed keys
```

---

# 8. Development environment on Asahi

I would intentionally build for **ARM64-native development**.

This gives you something macOS alone does not.

## Base toolchain

```bash
sudo dnf install \
  git \
  git-lfs \
  gcc \
  gcc-c++ \
  clang \
  cmake \
  ninja-build \
  make \
  pkg-config \
  rust \
  cargo \
  golang \
  python3 \
  python3-pip \
  podman \
  buildah \
  skopeo
```

I would strongly favor:

```text
Podman
Toolbox / Distrobox
systemd services
```

over immediately installing Docker Desktop-style infrastructure.

### My preferred architecture

```text
HOST: Fedora Asahi
│
├── Native development
│
├── Toolbox
│     ├── Python
│     ├── Go
│     ├── Rust
│     └── Build environments
│
├── Podman
│     ├── Local services
│     ├── Testing
│     └── Containers
│
└── Flatpak
      └── Desktop applications
```

This keeps the host cleaner.

---

# 9. ARM64 is one of the reasons to do this

Your Asahi installation should become an ARM-native test platform.

I would specifically experiment with:

```text
ARM64 containers
ARM64 Kubernetes
ARM64 Python wheels
Cross-platform builds
Rust
Go
Edge AI software
Embedded/IoT stacks
```

This is especially useful because the industry is increasingly heterogeneous:

```text
x86_64
ARM64
Apple Silicon
NVIDIA CUDA
AMD ROCm
Apple Metal / MLX
```

You can use the same laptop to understand where software breaks when assumptions about x86 disappear.

---

# 10. Local AI on Asahi: experimental, not primary

This is an important distinction.

I would **not** position Fedora Asahi as your primary local LLM environment.

macOS wins that role.

But Asahi Linux should still have an AI lab.

## On Asahi

Experiment with:

```text
llama.cpp
Ollama ARM64
Python inference
ONNX Runtime
OpenCL
Vulkan compute
Mesa
```

Fedora Asahi now advertises OpenCL 3.0 and Vulkan 1.4 support alongside modern OpenGL support, making it a genuinely interesting open graphics/compute platform rather than simply a framebuffer-based Linux port. ([Asahi Linux][1])

### The purpose isn't:

> "Can I beat MLX?"

The purpose is:

> "How far can an open Linux graphics and compute stack push Apple Silicon?"

That is much more interesting.

---

# 11. Gaming: absolutely worth doing

This is one of the biggest improvements to the Asahi story.

The Asahi project released an x86 gaming stack combining:

```text
Windows game
      │
      ▼
Proton / Wine
      │
      ▼
FEX x86/x86-64 emulation
      │
      ▼
muvm
      │
      ▼
Vulkan
      │
      ▼
Apple GPU
```

Asahi's own gaming announcement described the stack as integrating Vulkan, x86 emulation, and Windows compatibility, and demonstrated **Control** running on Apple Silicon. It also notes that this remains an evolving environment and that memory requirements can be significant. ([Asahi Linux][3])

The later muvm work also expanded the architecture beyond games, enabling more general x86/x86-64 application support with graphics integration. ([Asahi Linux][5])

## What I would install

```bash
sudo dnf install steam
```

Then experiment with:

```text
Steam
Proton
Proton Experimental
FEX
muvm
```

### Expectations

I would divide gaming into three categories:

| Category                      | Expectation                                |
| ----------------------------- | ------------------------------------------ |
| Native ARM Linux              | Excellent potential                        |
| Older/lighter x86 Linux games | Often very promising                       |
| Proton / Windows games        | Experimental but increasingly interesting  |
| Modern AAA titles             | Selective compatibility; test individually |

Do **not** buy this machine expecting it to replace an RTX gaming PC.

Instead, think:

> **"Can this silent fanless or near-silent Apple laptop play games that have no business running on an ARM Linux laptop?"**

That is the fun part.

---

# 12. The biggest current caveats

Despite how impressive the progress is, this is still not identical to running Linux on a ThinkPad.

For M2 systems, Asahi's detailed feature matrix still lists some functionality as incomplete or in progress. In particular, Thunderbolt and DisplayPort Alt Mode are marked as WIP at the platform level, while video encoding and Touch ID remain unsupported/TBA in the matrix. Some machine-specific ports and features also vary by model. ([Asahi Linux][2])

So before purchasing or dedicating a particular Mac to this project, I would verify **that exact model** against the M1 or M2 support matrix.

### My practical rule

```text
Laptop display
keyboard
trackpad
Wi-Fi
Bluetooth
audio
camera
suspend
GPU
USB-C

= core workstation requirements

External display edge cases
Thunderbolt edge cases
Touch ID
special hardware functions

= bonus / verify before depending on them
```

---

# 13. My exact proposed build

## Phase 1 — macOS

```text
macOS
├── Homebrew
├── Xcode
├── VS Code
├── Codex
├── Claude Code
├── GitHub CLI
├── Python + uv
├── Node.js
├── Rust
├── Go
├── LM Studio
├── Ollama
├── MLX
├── Docker
└── Local AI workspace
```

---

## Phase 2 — Fedora Asahi base

```text
Fedora Asahi Remix
├── KDE Plasma
├── Wayland
├── SELinux Enforcing
├── firewalld
├── LUKS where supported by chosen layout
├── automatic security updates
└── system snapshots / backup strategy
```

---

## Phase 3 — engineering

```text
Engineering
├── Git
├── Neovim
├── VS Code
├── Rust
├── Go
├── Python
├── Podman
├── Toolbox
├── Distrobox
├── Wireshark
├── nmap
├── tcpdump
├── mtr
├── nftables tools
└── network namespaces
```

---

## Phase 4 — privacy

```text
Privacy
├── Firefox
├── Hardened browser profile
├── KeePassXC
├── age
├── sops
├── Local DNS strategy
├── VPN profiles
└── NetworkManager compartmentalization
```

---

## Phase 5 — AI experimentation

```text
AI Lab
├── Ollama ARM64
├── llama.cpp
├── Python
├── ONNX Runtime
├── Vulkan experiments
├── OpenCL experiments
└── ARM64 containers
```

---

## Phase 6 — gaming

```text
Gaming
├── Steam
├── Proton
├── Proton Experimental
├── FEX
├── muvm
└── Game compatibility test list
```

---

# My strongest recommendation

If you are doing this on an existing M1 or M2 machine, **don't immediately build everything**.

Do it in this order:

### Weekend 1

```text
Install Fedora Asahi
↓
Verify every piece of hardware
↓
Update everything
↓
Test suspend
↓
Test Wi-Fi/Bluetooth
↓
Test audio
↓
Test external displays
↓
Test USB-C devices
```

### Weekend 2

```text
KDE tuning
SELinux
firewalld
SSH
privacy browser architecture
DNS strategy
backup strategy
```

### Weekend 3

```text
Podman
Toolbox
ARM64 development
Python
Rust
Go
network engineering toolkit
```

### Weekend 4

```text
Steam
Proton
FEX
muvm
benchmark games
document compatibility
```

### Later

```text
OpenCL
Vulkan compute
local AI experiments
ARM64 container development
cross-platform builds
```

# Bottom line

I think this is an **excellent project for you**.

Not because Asahi will replace macOS.

Quite the opposite.

The strength of this setup is that the same Apple Silicon hardware becomes **two fundamentally different computing environments**:

> **macOS is where you exploit Apple's ecosystem to the absolute maximum.**

> **Fedora Asahi is where you reclaim the machine as an open, privacy-focused, ARM64 Linux workstation.**

And the really exciting part is that this is no longer the old "Linux boots, but half the hardware doesn't work" experiment. Fedora Asahi Remix now has a serious graphics stack, broad M1/M2 support, modern Vulkan/OpenGL/OpenCL capabilities, and an increasingly sophisticated x86 compatibility layer. ([Asahi Linux][1])

My next recommendation would be to turn this into a **complete "Apple Silicon Dual-OS Engineering Workstation" blueprint** with:

1. **Exact partition sizing for your specific M1/M2 model and SSD size**
2. **Step-by-step Asahi installation**
3. **Fedora KDE power-user configuration**
4. **Privacy and security hardening checklist**
5. **Network engineer toolkit**
6. **Podman/Toolbox/Distrobox architecture**
7. **ARM64 development environment**
8. **Steam/FEX/muvm gaming configuration**
9. **macOS ↔ Linux shared workflow**
10. **A benchmark and test matrix for the entire machine**

I can also structure that as a **GitHub-ready project README**, with copy-paste commands and an architecture diagram, so it becomes something you can actually build and maintain.

[1]: https://asahilinux.org/fedora/?utm_source=chatgpt.com "Fedora Asahi Remix - Asahi Linux"
[2]: https://asahilinux.org/docs/platform/feature-support/m2/?utm_source=chatgpt.com "M2 Series Feature Support - Asahi Linux Documentation"
[3]: https://asahilinux.org/2024/10/aaa-gaming-on-asahi-linux/?utm_source=chatgpt.com "AAA gaming on Asahi Linux - Asahi Linux"
[4]: https://asahilinux.org/2026/06/progress-report-7-1/?utm_source=chatgpt.com "Progress Report: Linux 7.1 - Asahi Linux"
[5]: https://asahilinux.org/2024/12/muvm-x11-bridging/?utm_source=chatgpt.com "Beyond Gaming: X11 bridging in muvm - Asahi Linux"
