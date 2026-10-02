# Omarchy — Linux, but with someone else's extremely strong opinions

[Omarchy official site](https://omarchy.org/?utm_source=chatgpt.com) · [Omarchy source on GitHub](https://github.com/basecamp/omarchy?utm_source=chatgpt.com)

For someone who has been around Linux since the early days, the simplest explanation is:

> **Omarchy is what happens when an experienced Linux power user says: “I am tired of rebuilding my perfect desktop every time. Here is the exact setup. Use it.”**

And the person behind those opinions is David Heinemeier Hansson — best known as the creator of Ruby on Rails and co-founder of 37signals/Basecamp.

It is **not a new kernel, package ecosystem, or revolutionary operating system architecture**.

Underneath, Omarchy is primarily:

```text
Linux
 └── Arch Linux
      └── Wayland
           └── Hyprland
                └── Quickshell
                     └── Omarchy defaults, tooling, themes and workflow
```

The interesting part is **how aggressively integrated the experience is**.

---

# 1. Think back to the old Linux days

You've probably lived through something like this:

```text
Install Slackware / Red Hat / Debian
        ↓
Figure out XFree86
        ↓
Edit xorg.conf
        ↓
Install window manager
        ↓
Configure .xinitrc
        ↓
Choose terminal
        ↓
Configure shell
        ↓
Find a panel
        ↓
Configure themes
        ↓
Install editors
        ↓
Fix audio
        ↓
Fix fonts
        ↓
Fix suspend
        ↓
Fix Wi-Fi
        ↓
Spend the weekend tweaking
        ↓
"Finally, my Linux desktop is perfect"
```

Then six months later:

```text
Reinstall Linux

Repeat everything.
```

Modern Linux solved a lot of the painful hardware problems, but power users still frequently rebuild their environment:

```text
Arch install
→ pacman
→ yay
→ Hyprland
→ Waybar
→ terminal
→ shell
→ Neovim
→ fonts
→ themes
→ screenshots
→ clipboard
→ notifications
→ lockscreen
→ Docker
→ development environment
→ AI tools
→ 500 lines of dotfiles
```

**Omarchy basically says: screw that.**

The Omarchy project describes itself as an "omakase" Linux distribution built around Arch, Hyprland, and Quickshell, shipping a complete preconfigured desktop and developer environment rather than merely a collection of packages. ([GitHub][1])

---

# 2. What "opinionated" really means

This is probably the most important concept.

Most mainstream Linux distributions try to give you choices.

Omarchy gives you **decisions already made**.

For example:

| Category          | Traditional Linux approach | Omarchy approach             |
| ----------------- | -------------------------- | ---------------------------- |
| Distribution      | Pick one                   | Arch                         |
| Display stack     | X11 or Wayland             | Wayland                      |
| Desktop           | GNOME/KDE/XFCE/etc.        | Hyprland ecosystem           |
| Window management | Floating or tiling         | Tiling-first                 |
| Shell workflow    | Your choice                | Prebuilt workflow            |
| Editor            | Vim/Emacs/VS Code/etc.     | Neovim-centric tooling       |
| Themes            | Go find some               | Integrated themes            |
| Config            | Build your own             | Start with curated defaults  |
| Recovery          | Figure it out              | Integrated tooling/snapshots |
| Developer setup   | Install everything         | Comes prepared               |

This is where Omarchy becomes interesting.

It isn't trying to be:

> "The Linux distribution for everyone."

It is more like:

> **"This is how DHH thinks a modern Linux workstation should work."**

You can absolutely change things, but the starting point is deliberately opinionated.

---

# 3. The technology underneath

## Arch Linux

This is probably the part that makes you feel at home.

Omarchy uses Arch as its foundation.

So conceptually:

```bash
pacman
```

is still part of your life.

You still have the Arch ecosystem, current packages, the Arch Wiki, systemd, and the rolling-release model.

Omarchy is therefore fundamentally different from something like Ubuntu, Fedora Workstation, or Linux Mint.

It isn't hiding Linux from you.

In fact, Omarchy's own documentation explicitly embraces a terminal-heavy and configuration-oriented workflow rather than attempting to mimic Windows or macOS. ([GitHub][1])

For an experienced Linux user, this is important.

**You are not entering a walled garden.**

You're essentially getting:

```text
Arch Linux
+
a highly curated desktop environment
+
integrated tooling
+
preconfigured workflows
```

---

# 4. Hyprland: this is where the personality begins

Omarchy uses **Hyprland**.

If you've spent years using:

```text
GNOME
KDE
XFCE
Cinnamon
```

then Hyprland will feel very different.

Think more along the evolutionary line of:

```text
i3
bspwm
dwm
awesome
xmonad
```

except modernized for:

```text
Wayland
animations
gestures
dynamic tiling
modern graphics
high DPI
multi-monitor workflows
```

Instead of this:

```text
┌───────────────────────────────┐
│                               │
│         Browser               │
│                               │
└───────────────────────────────┘

       ┌───────────────┐
       │   Terminal    │
       └───────────────┘
```

You think in terms of layout:

```text
┌──────────────────┬──────────────────┐
│                  │                  │
│                  │    Terminal      │
│     Browser      │                  │
│                  ├──────────────────┤
│                  │      Editor      │
└──────────────────┴──────────────────┘
```

The window manager becomes part of your muscle memory.

For a network engineer, systems person, or developer, that can be extremely efficient.

---

# 5. Quickshell gives Omarchy its desktop identity

Modern Omarchy also uses **Quickshell** as part of its desktop construction.

This handles much of the integrated desktop experience around things like the shell, launcher, widgets, notifications, and other desktop components. Omarchy documents its shell configuration separately from the Hyprland configuration. ([GitHub][2])

Conceptually:

```text
Hyprland
    ↓
Window management

Quickshell
    ↓
Desktop shell experience
    ├── bar
    ├── launcher
    ├── widgets
    ├── notifications
    └── desktop interaction
```

This matters because Omarchy isn't simply:

```bash
pacman -S hyprland
```

It's a complete curated environment.

---

# 6. The thing I think you'll appreciate: the configs are understandable

Omarchy doesn't appear to be trying to hide everything behind some opaque desktop database.

The configuration structure is visible and approachable.

For example, its documentation identifies user-facing configuration files for:

```text
~/.config/hypr/
```

including files controlling:

```text
bindings.lua
monitors.lua
input.lua
looknfeel.lua
autostart.lua
```

along with Omarchy shell configuration under:

```text
~/.config/omarchy/shell.json
```

This is documented directly in the Omarchy manual. ([GitHub][3])

That gives me a very old-school positive feeling.

You can inspect what the system is doing.

```bash
cd ~/.config
grep -R "whatever" .
vim bindings.lua
```

That is much closer to:

> "Linux is mine and I can understand it."

than:

> "Click Settings → Advanced → Experimental → Desktop Behavior."

---

# 7. Omarchy is essentially a workstation image

This is the best way I would describe it to you.

Imagine if you maintained a personal Git repository containing:

```text
dotfiles/
├── zsh
├── neovim
├── tmux
├── git
├── hyprland
├── themes
├── terminal
├── screenshots
├── clipboard
├── docker
├── development
└── scripts
```

Then every time you installed Arch, you ran:

```bash
bootstrap-my-workstation.sh
```

And after an hour:

```text
Your Perfect Workstation™
```

Omarchy is essentially **DHH's version of that idea**, but developed into a distribution with an installer, update mechanisms, documentation, desktop integration, and recovery tooling.

---

# 8. The developer workstation philosophy

Omarchy ships with a broad set of tools intended to make a modern workstation usable immediately, including software such as Neovim, Chromium, Obsidian, LibreOffice, Kdenlive, and OBS Studio. ([GitHub][1])

The philosophy is roughly:

```text
Install once
     ↓
Boot
     ↓
Open terminal
     ↓
Start working
```

Instead of:

```text
Fresh Linux
     ↓
Spend three days recreating dotfiles
     ↓
Install 200 packages
     ↓
Search Reddit for the correct Wayland clipboard manager
     ↓
Discover your lock screen doesn't work
     ↓
Fix suspend
     ↓
Start working
```

---

# 9. AI integration is part of the modern philosophy

This part is especially relevant to your ML/AI work.

Omarchy's current manual explicitly includes sections for AI alongside development tools and shell tooling, indicating that AI workflows are treated as part of the desktop rather than as an afterthought. ([Omarchy][4])

That does **not** mean Omarchy replaces your existing local AI infrastructure.

I would think of it more like this:

```text
Omarchy Workstation
        │
        ├── Development
        │     ├── terminal
        │     ├── Neovim
        │     └── Git
        │
        ├── AI tooling
        │
        └── Your infrastructure
              │
              ├── Ollama
              ├── LM Studio
              ├── OpenWebUI
              ├── Qdrant
              ├── Flowise
              ├── Docker
              └── GPU servers
```

This fits very well with the kind of local-first architecture you've already been building. Your existing Ollama stack is already structured around local inference, OpenWebUI, Qdrant, Flowise, optional LiteLLM routing, and monitoring. 

So I would **not** replace that architecture with Omarchy.

I would use Omarchy as the **desktop/workstation layer**.

---

# 10. Installation philosophy: surprisingly serious about encryption

The current installer documentation describes two main installation paths:

```text
Full disk
```

or:

```text
Free space / dual boot
```

The installer defaults to encryption, and the documentation specifically warns that the full-disk option wipes the selected drive. It also supports installation into unallocated space for dual-boot scenarios. ([GitHub][5])

That means Omarchy is not just:

```bash
curl random-script.sh | bash
```

Although historically it has supported installation approaches layered onto Arch, the current official workflow is more distro-like and ISO-oriented.

For an experienced Linux user, I'd still treat it like any other installer:

```text
Backup
↓
Understand partition layout
↓
Know your EFI situation
↓
Know which drive you're selecting
↓
Then install
```

---

# 11. Recovery is better thought out than many "rice" projects

One thing I like is that Omarchy has integrated mechanisms around:

```text
updates
rollback
snapshots
debugging
configuration reset
```

The project documents recovery options including rollback after problematic updates, debugging, and reinstalling default configurations/packages. ([Omarchy][6])

This is important.

A lot of beautiful Linux setups on GitHub are essentially:

```text
Install my dotfiles.

Good luck.
```

Omarchy is trying to become something more maintainable.

The architecture includes explicit configuration resynchronization and snapshot/recovery concepts rather than treating the desktop purely as a pile of dotfiles. ([GitHub][7])

---

# 12. The biggest potential downside: DHH's opinions

This is where I would give you the honest veteran-Linux-user warning.

With Omarchy:

### You gain

```text
Consistency
Speed
Polish
Integrated tooling
Good defaults
A cohesive experience
```

### You give up some

```text
Blank canvas freedom
Distribution neutrality
The joy of building everything yourself
```

If you immediately start doing:

```text
Replace Hyprland
Install GNOME
Replace shell
Replace terminal
Replace Neovim
Replace all themes
Replace launcher
Rewrite keybindings
```

Then I would ask:

> Why are you running Omarchy?

At that point, install Arch.

Omarchy makes the most sense if you look at the default system and say:

> "Yeah, I mostly agree with this."

---

# 13. How I would compare it to older Linux philosophies

| Era / system | Philosophy                                               |
| ------------ | -------------------------------------------------------- |
| Slackware    | You build it yourself                                    |
| Gentoo       | You compile and optimize it yourself                     |
| Debian       | Stable, conservative foundation                          |
| Ubuntu       | Linux made easier                                        |
| Fedora       | Modern upstream Linux                                    |
| Arch         | Build your own modern Linux                              |
| NixOS        | Describe your desired system                             |
| **Omarchy**  | **Here's my finished Linux workstation. Start working.** |

That last one is the key.

---

# 14. Is Omarchy a "real distro"?

I would say:

**Yes, functionally — but philosophically it's closer to a highly integrated Arch workstation distribution.**

It has enough of its own:

* installer
* defaults
* desktop architecture
* package selection
* themes
* configuration management
* update tooling
* recovery workflows
* documentation

that calling it merely a "Hyprland config" undersells it.

But underneath, the experienced Linux user should remember:

```text
You are still fundamentally living in Archland.
```

That is a feature, not a criticism.

---

# 15. My take specifically for you

Given your background, I think you are almost the ideal audience.

Not because Omarchy is "easy Linux."

Actually, the opposite.

You've already lived through enough Linux history to appreciate the value of someone else doing this:

```text
Arch
+ modern Wayland
+ tiling workflow
+ sensible defaults
+ developer tools
+ terminal-first workflow
+ visual polish
```

I would **not** recommend Omarchy as:

```text
Your infrastructure server
Your Proxmox host
Your NAS
Your primary Docker server
Your always-on AI inference server
```

I **would** recommend evaluating it as:

```text
PERSONAL WORKSTATION

┌──────────────────────────────────┐
│            Omarchy               │
│                                  │
│  Hyprland + Quickshell           │
│  Terminal + Neovim               │
│  Coding                          │
│  AI-assisted development         │
│  Browsing                        │
│  Network engineering             │
│  Homelab administration          │
│  SSH                             │
│  Containers                      │
└──────────────┬───────────────────┘
               │
               ▼
        Your existing infrastructure

        ┌──────────────────┐
        │ Ollama servers   │
        │ GPU workstation  │
        │ OpenWebUI        │
        │ Qdrant           │
        │ Flowise          │
        │ Docker           │
        │ Homelab          │
        └──────────────────┘
```

Your current AI stack already follows a strong local-first philosophy—local Ollama inference, OpenWebUI, Qdrant-backed retrieval, Flowise workflows, and optional routing rather than mandatory cloud dependency. 

**Omarchy could be an excellent front-end workstation for that world.**

---

# 16. My recommendation

### If I were setting this up for you, I would start with:

```text
Phase 1
───────
Install Omarchy on spare hardware or a secondary partition

Phase 2
───────
Learn the default workflow

Super + terminal
Super + launcher
workspace navigation
window movement
tiling behavior

Do NOT customize much yet.

Phase 3
───────
Install your engineering essentials

Git
SSH
VPN
network tools
Docker/Podman as needed
Python
Go
Node
kubectl
Terraform/OpenTofu

Phase 4
───────
Connect to your existing AI infrastructure

Omarchy workstation
        ↓
SSH / API
        ↓
RTX workstation / Ollama
        ↓
Local models

Phase 5
───────
Only then start modifying:

Hyprland
keybindings
monitors
terminal
themes
automation
```

The reason is simple:

> **You need to learn which parts of Omarchy are actually worth keeping before you start ripping them apart.**

---

# My bottom line

**Omarchy is one of the more interesting Linux desktop projects I've seen in years—not because it invented new Linux technology, but because it packages a modern power-user workflow into a coherent whole.**

For someone who has used Linux since the early days, it may feel like:

> **"Finally, a modern Linux desktop that assumes I know what a terminal is."**

It's Arch underneath.

It's Wayland-native.

It's heavily keyboard and tiling oriented.

It's visually polished.

It's opinionated.

And that last part is either the entire reason you'll love it—or the reason you'll eventually go back to plain Arch.

### My rating for your use case

| Category                                        | Rating |
| ----------------------------------------------- | ------ |
| Experienced Linux user                          | ⭐⭐⭐⭐⭐  |
| Network/system engineering                      | ⭐⭐⭐⭐⭐  |
| Developer workstation                           | ⭐⭐⭐⭐⭐  |
| Local AI workstation                            | ⭐⭐⭐⭐½  |
| Homelab administration                          | ⭐⭐⭐⭐⭐  |
| Gaming                                          | ⭐⭐⭐⭐   |
| Beginner Linux user                             | ⭐⭐⭐    |
| Maximum customization without fighting defaults | ⭐⭐⭐    |

One particularly relevant point for your Apple/Asahi interests: the official Omarchy manual now explicitly mentions running Omarchy on Apple M1/M2 through the Asahi ecosystem, though it describes this as requiring extra effort and points to a user-driven guide. ([Omarchy][8])

That makes your **macOS + Asahi + privacy-focused Linux workstation** idea particularly interesting: Omarchy may be worth evaluating as an additional candidate alongside a more conventional Asahi/Fedora setup.

I can also help you build a **"Veteran Linux User's Omarchy Evaluation & Setup Guide"** next: architecture, installation strategy, security hardening, Docker/Podman, SSH/network engineering tools, local AI integration, gaming, dotfiles, backup/snapshots, and a comparison against Fedora, vanilla Arch, and Asahi Linux.

[1]: https://github.com/basecamp/omarchy/blob/quattro/manual/01-welcome-to-omarchy.md?utm_source=chatgpt.com "omarchy/manual/01-welcome-to-omarchy.md at quattro · basecamp/omarchy · GitHub"
[2]: https://github.com/basecamp/omarchy/blob/quattro/default/omarchy-skill/SKILL.md?utm_source=chatgpt.com "omarchy/default/omarchy-skill/SKILL.md at quattro · basecamp/omarchy · GitHub"
[3]: https://github.com/basecamp/omarchy/blob/quattro/manual/31-dotfiles.md?utm_source=chatgpt.com "omarchy/manual/31-dotfiles.md at quattro · basecamp/omarchy · GitHub"
[4]: https://omarchy.org/manual/?utm_source=chatgpt.com "Welcome to Omarchy! — The Omarchy Manual"
[5]: https://github.com/basecamp/omarchy/blob/quattro/manual/02-getting-started.md?utm_source=chatgpt.com "omarchy/manual/02-getting-started.md at quattro · basecamp/omarchy · GitHub"
[6]: https://omarchy.org/manual/troubleshooting/?utm_source=chatgpt.com "Troubleshooting — The Omarchy Manual"
[7]: https://github.com/basecamp/omarchy/blob/quattro/docs/file-layout.md?utm_source=chatgpt.com "omarchy/docs/file-layout.md at quattro · basecamp/omarchy · GitHub"
[8]: https://omarchy.org/manual/omarchy-on/?utm_source=chatgpt.com "Omarchy on... — The Omarchy Manual"
