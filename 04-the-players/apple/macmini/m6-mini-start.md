# Apple Mac mini M6 — Home Lab Setup

Configure an Apple Silicon Mac mini as an always-on home server, local AI/LLM node, virtualization host, development environment, NAS, and entertainment system.

This guide uses the existing macOS dotfiles repository as the single entry point for installing Homebrew applications, CLI tools, shell configuration, Git settings, and development tooling.

## Table of Contents

- [1. Hardware and Architecture](#1-hardware-and-architecture)
- [2. macOS Initial Configuration](#2-macos-initial-configuration)
- [3. Always-On Operation](#3-always-on-operation)
- [4. Remote Administration](#4-remote-administration)
- [5. 55-Inch OLED TV Setup](#5-55-inch-oled-tv-setup)
- [6. Deploy Dotfiles](#6-deploy-dotfiles)
- [7. Verify the Development Environment](#7-verify-the-development-environment)
- [8. Virtualization and Home Assistant](#8-virtualization-and-home-assistant)
- [9. Docker and Container Services](#9-docker-and-container-services)
- [10. Local AI and LLMs](#10-local-ai-and-llms)
- [11. Storage and NAS](#11-storage-and-nas)
- [12. Networking and Security](#12-networking-and-security)
- [13. Validation and Operations](#13-validation-and-operations)
- [References](#references)

---

## 1. Hardware and Architecture

### Hardware profile

| Component | Configuration |
|---|---|
| Host | Apple Mac mini M6 |
| Unified memory | 32 GB |
| Internal storage | 1 TB SSD |
| Network | Wired Ethernet; 10 GbE if configured |
| Display | 55-inch OLED TV |
| External storage | Thunderbolt/USB-C DAS or separate NAS |
| Operating system | macOS |
| Virtualization | UTM |
| Container runtime | Docker Desktop |
| Local AI | Ollama, MLX-compatible tools, LM Studio, oMLX |
| Smart home | Home Assistant OS in a VM |
| Video surveillance | Frigate NVR on Jetson |
| Configuration management | Git and the existing dotfiles repository |

Confirm the actual Mac model, available ports, Ethernet configuration, and installed macOS version before applying model-specific settings.

### Intended architecture

```text
                       HOME NETWORK
                            |
              +-------------+-------------+
              |                           |
        Mac mini M6                   Other clients
              |
       +------+-------------------+
       |                          |
    macOS host               External storage
       |                     DAS / NAS
       |
  +----+-------------+
  |                  |
 UTM VM          Docker Desktop
  |                  |
 Home Assistant   Local services
 OS               AI / databases /
                  development tools

 Frigate NVR remains on Jetson
          |
          +---- MQTT / events ---- Home Assistant
```

### Design principles

- macOS remains the primary host operating system.
- Home Assistant OS runs in a dedicated VM.
- Docker Desktop hosts complementary Linux container workloads.
- Frigate remains on the Jetson, avoiding unnecessary video-processing duplication.
- Apple Silicon-native applications are preferred.
- External storage holds bulk files, recordings, datasets, and backups.
- Configuration is version-controlled; credentials and secrets are not.
- Essential services must recover after reboot without requiring the OLED TV to remain on.

---

## 2. macOS Initial Configuration

Complete macOS Setup Assistant and create the required administrator and daily-use accounts.

### 2.1 Update macOS

Open **System Settings → General → Software Update** and install available stable updates.

Avoid major macOS upgrades until compatibility with UTM, Docker Desktop, AI runtimes, and required services has been checked.

### 2.2 Set the hostname

Use a distinct hostname for the always-on server.

```bash
sudo scutil --set ComputerName "mac-mini-lab"
sudo scutil --set LocalHostName "mac-mini-lab"
sudo scutil --set HostName "mac-mini-lab"
```

Verify:

```bash
scutil --get ComputerName
scutil --get LocalHostName
scutil --get HostName
```

Reserve a DHCP address for the Mac mini on the router. Document the hostname, IP address, VLAN, gateway, and DNS configuration.

### 2.3 Accounts and security

- Enable FileVault.
- Store the recovery key securely outside the Mac mini.
- Use strong account credentials.
- Restrict administrator privileges.
- Keep API keys, SSH private keys, and passwords out of Git.
- Enable only the remote-access services required by the lab.

**Important:** FileVault may require an interactive unlock after a cold reboot. Test the full recovery workflow before relying on unattended recovery after power loss.

---

## 3. Always-On Operation

The Mac mini must remain available when the OLED TV is off or asleep.

### 3.1 Configure Energy settings

Open **System Settings → Energy**. Available settings vary by macOS release.

Configure the available options to:

- Prevent automatic computer sleep when the display is off.
- Enable network wake where supported.
- Enable automatic startup after power failure if available.
- Allow the display to sleep independently of the host.

Inspect the current power-management configuration:

```bash
pmset -g
pmset -g custom
```

Do not assume that a running Mac automatically starts every VM and container after a reboot.

### 3.2 Validate always-on operation

1. Start the services being tested.
2. Allow the TV/display to turn off.
3. Connect to the Mac mini over SSH from another device.
4. Verify that Home Assistant and other services remain reachable.
5. Reboot the Mac and validate service recovery.
6. Test the behavior after logout and after a power interruption where safely possible.

A service that depends on an interactive user session may not be available immediately after reboot.

---

## 4. Remote Administration

The Mac mini should be manageable from the MacBook or another trusted workstation.

### 4.1 Enable SSH

Open:

**System Settings → General → Sharing → Remote Login**

Enable Remote Login and restrict access to authorized users.

From the Mac mini, verify:

```bash
sudo systemsetup -getremotelogin
```

From the MacBook:

```bash
ssh <username>@<mac-mini-ip>
```

Replace the placeholders with the actual account and reserved address.

### 4.2 SSH keys

Reuse the SSH configuration and public keys managed by the dotfiles repository. Provision private keys securely; never commit them to Git.

Check existing key permissions where applicable:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
```

Test the configured host alias:

```bash
ssh <configured-host-alias>
```

Do not overwrite existing keys during setup.

### 4.3 Screen Sharing

Open:

**System Settings → General → Sharing → Screen Sharing**

Enable access for authorized users only.

Use macOS Screen Sharing for GUI administration, UTM management, and troubleshooting the OLED display.

Keep SSH and Screen Sharing on trusted networks. Do not expose either directly to the public internet.

---

## 5. 55-Inch OLED TV Setup (Optional - Skip)

The OLED is both the Mac mini's primary display and an entertainment screen.

### 5.1 Connection

Connect the Mac mini's HDMI output directly to a suitable HDMI input on the TV.

Use a cable certified for the intended resolution, refresh rate, HDR, and chroma format.

### 5.2 macOS display configuration

Open **System Settings → Displays**.

- Select the TV's native resolution, typically 4K if supported.
- Choose a supported refresh rate.
- Enable HDR where supported and appropriate.
- Set scaling for readable text at the intended viewing distance.
- Configure audio output to the TV or the intended audio system.
- Enable the TV's appropriate PC or low-latency mode when desired.

Available options depend on the TV, HDMI input, cable, and macOS version.

### 5.3 OLED protection

Configure a reasonable display-off timer and screen saver.

- Let the TV turn off when idle.
- Avoid leaving static terminal windows, dashboards, or application interfaces visible for long periods.
- Use the TV manufacturer's recommended panel-maintenance features.
- Keep OLED protection features enabled.
- Do not disable display sleep simply to keep server services running.

The Mac mini must continue running with the TV off.

### 5.4 Entertainment

Install GUI applications through the dotfiles-managed Homebrew setup.

Use the TV for browsing, streaming, music, media playback, and development. HDMI-CEC behavior varies by TV, so do not assume macOS will always control the TV's power state automatically.

---

## 6. Deploy Dotfiles

The existing dotfiles repository is the canonical source for installing applications and configuring the development environment.

### 6.1 Clone the repository

Replace the placeholder URL with the actual repository URL.

```bash
mkdir -p ~/repos
cd ~/repos

git clone <YOUR_DOTFILES_REPO_URL> dotfiles
cd dotfiles

git status
```

### 6.2 Review the bootstrap script

Open README.md file. Inspect the bootstrap script and macOS defaults before running them:

```bash
sed -n '1,260p' bootstrap.sh
sed -n '1,260p' macos/defaults.sh
```

Verify that the script:

- Installs Homebrew if missing.
- Installs packages from all defined Brewfiles.
- Installs Oh My Zsh, Powerlevel10k, and configured plugins.
- Creates shell and Git configuration symlinks.
- Restores VS Code extensions.
- Applies the intended macOS defaults.
- Handles existing files and symlinks safely.
- Can be rerun without destructive side effects.

Check for hard-coded paths, credentials, commands requiring elevated privileges, and assumptions inherited from the MacBook.

### 6.3 Run the bootstrap

Once reviewed:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

**This is the single application-installation and dotfiles-configuration entry point.**

Do not manually install applications already managed by the Brewfiles. If the bootstrap encounters a failed package, inspect the error and fix the underlying issue rather than assuming installation completed successfully.

The bootstrap installs the software and applies the configuration defined by the repository. It does not replace the macOS, remote-access, VM, or service configuration steps documented elsewhere in this guide.

### 6.4 Validate shell and Git configuration

Open a new terminal session:

```bash
echo "$SHELL"
command -v brew git zsh

ls -l ~/.zprofile ~/.zshrc ~/.gitconfig

git config --list --show-origin
```

Confirm that the symlinks point to the intended repository files and that `.zprofile` initializes the Apple Silicon Homebrew environment correctly.

Run:

```bash
p10k configure
```

>If the p10k configure command doesn't work, just open a new shell tab & follow instructions. Don't stress if the screen image is not what's being defined.

Verify SSH aliases, Git identity, environment variables, and configured shell plugins.

### 6.5 Shared versus machine-specific settings

Reuse shared configuration while keeping host-specific values separate.

Examples include:

- Hostname and network settings.
- Machine-specific paths and mounted volumes.
- Server power-management settings.
- GUI and display preferences.
- Local service endpoints and ports.
- Credentials and environment-specific secrets.

Do not commit secrets to the repository.

---

## 7. Verify the Development Environment

The bootstrap should install the full toolchain defined by the repository's modular Brewfiles.

Verify the results:

```bash
brew --prefix
brew doctor
brew list

git --version
python3 --version
node --version
docker --version
docker compose version
```

Some commands may not be available if their package installation failed.

The expected Apple Silicon Homebrew prefix is normally `/opt/homebrew`.

If an application is missing, inspect the relevant Brewfile and bootstrap output before installing it manually.

---

## 8. Virtualization and Home Assistant

### 8.1 Virtualization platform: UTM

Use [UTM](https://mac.getutm.app/) as the initial VM platform.

UTM supports Apple Silicon virtualization and QEMU-based emulation. It is a suitable starting point for a Home Assistant OS VM, provided the selected image, network mode, and startup behavior are validated.

The dotfiles Brewfile should manage the UTM application installation.

### 8.2 Deploy Home Assistant OS

Use a dedicated Home Assistant OS VM rather than Home Assistant Core in a container. This retains the standard Home Assistant OS/Supervisor experience.

Official documentation:

- [Home Assistant installation on macOS](https://www.home-assistant.io/installation/macos/)
- [Alternative installation methods](https://www.home-assistant.io/installation/alternative/)

Download the appropriate ARM64-compatible Home Assistant OS image and follow the current UTM-specific instructions. Confirm the required image format and firmware configuration for the chosen VM backend.

Suggested starting resources:

| Setting | Initial value |
|---|---:|
| Architecture | ARM64 / AArch64 |
| vCPU | 2–4 |
| Memory | 4 GB |
| Virtual disk | 32 GB or larger |
| Network | LAN-reachable |
| Firmware | As required by the image |

Increase resources as integrations, history, add-ons, and recorder data grow.

### 8.3 Network configuration

Home Assistant must be accessible from the rest of the LAN.

- Reserve a stable address where appropriate.
- Verify TCP port `8123`.
- Test multicast DNS, broadcast, and discovery-dependent integrations separately.
- Confirm VLAN and firewall rules.
- Use bridged networking where supported and validated if integrations require direct LAN access.

NAT can complicate device discovery. Do not assume the VM will behave identically to a bare-metal Linux host.

### 8.4 VM startup and recovery

Configure automatic VM startup where supported by the selected UTM version and macOS configuration.

UTM is a desktop application; do not assume unattended startup works merely because the VM starts correctly when launched manually.

Test:

1. Home Assistant boots and receives its intended address.
2. The web UI is reachable from another LAN device.
3. Integrations and automations work.
4. The VM can restart cleanly.
5. Home Assistant returns after a Mac reboot.
6. Backups can be restored.

Keep backups outside the VM, preferably on independent storage.

### 8.5 Frigate integration

Frigate remains on the Jetson. The Mac mini does not duplicate its camera processing.

Configure Home Assistant to reach Frigate and MQTT over the LAN as appropriate. Validate credentials, event delivery, network discovery, and firewall rules.

---

## 9. Docker and Container Services

### 9.1 Docker Desktop

Docker Desktop is installed through the dotfiles Brewfile and bootstrap process.

Launch Docker Desktop, complete its initial setup, and wait for the engine to start.

Docker Desktop runs Linux containers inside a Linux VM; it is not the same environment as Docker running natively on Ubuntu.

### 9.2 Verify Docker

```bash
docker version
docker info
docker compose version

docker run --rm hello-world
```

Confirm both the client and server components are available.

### 9.3 Container architecture

Prefer multi-architecture images or images explicitly supporting `linux/arm64`.

Check image metadata:

```bash
docker image inspect <IMAGE_NAME>
```

Verify vendor support before using containers requiring NVIDIA CUDA, TensorRT, kernel modules, direct PCIe access, or unsupported device mappings.

NVIDIA-specific containers from the retired Ubuntu host will not automatically work on macOS.

### 9.4 Persistent data

Keep Compose files and non-secret configuration in Git. Store persistent application data outside ephemeral container layers.

Example:

```text
~/lab/
├── compose/
│   ├── open-webui/
│   ├── qdrant/
│   ├── postgres/
│   └── monitoring/
├── data/
├── models/
├── backups/
└── secrets/       # excluded from Git
```

Use a separate volume or directory for large model files and datasets.

Appropriate container restart policies help recover services, but they do not start Docker Desktop itself if its engine is unavailable.

### 9.5 Home Assistant and Docker

Home Assistant OS runs in UTM, not Docker Desktop.

Use Docker for complementary workloads such as development environments, AI interfaces, databases, vector stores, and monitoring. Avoid deploying duplicate services without a defined purpose.

---

## 10. Local AI and LLMs

The Mac mini is intended as an efficient Apple Silicon inference and agent node. Keep the NVIDIA workstation available for CUDA-dependent and high-throughput workloads.

### 10.1 AI toolchain

The dotfiles AI Brewfile includes:

- Ollama
- LM Studio
- oMLX
- Claude Code
- CMake
- LLVM
- Draw Things

Use native Apple Silicon builds wherever available.

### 10.2 Ollama

After installation, verify the CLI:

```bash
ollama --version
ollama list
```

Run a model supported by the installed version:

```bash
ollama run <MODEL_NAME>
```

The Ollama HTTP API commonly uses port `11434`. Keep it bound to localhost unless LAN access is explicitly required. If exposing it to the LAN, restrict access through network and firewall controls.

### 10.3 Unified memory

The M6's 32 GB unified memory is shared by macOS, applications, and AI workloads. It is not 32 GB exclusively available to model weights.

Actual model capacity depends on:

- Model architecture and parameter count.
- Quantization.
- Context length and KV cache.
- macOS and application memory use.
- Number of concurrent models and services.

Start with a suitable local model, monitor memory pressure, and increase context or model size based on measured results.

### 10.4 Model storage

Keep active models on fast local storage where practical. Move archival models and datasets to external storage as appropriate.

Avoid placing active model files on slow or intermittently connected network shares without testing load and inference behavior.

### 10.5 AI service integration

Configure the model endpoint explicitly for Open WebUI, agents, or other clients.

Remember that `localhost` inside a container refers to the container itself, not automatically to the macOS host.

Expose inference APIs only to intended clients.

---

## 11. Storage and NAS

The Mac mini can share files over the LAN while using direct-attached storage or a separate NAS.

### 11.1 Storage roles

| Storage | Intended use |
|---|---|
| Internal SSD | macOS, applications, VM disks, databases, active models |
| External DAS | Bulk files, media, archives, recordings, datasets |
| Separate NAS or backup target | Shared data and independent backup copies |

### 11.2 Configure SMB sharing

Open:

**System Settings → General → Sharing → File Sharing**

Enable SMB as required and grant access only to authorized users.

Test from another device:

```text
smb://mac-mini-lab
```

Use separate accounts and permissions for shared data. Do not expose SMB directly to the public internet.

### 11.3 RAID and backups

RAID improves availability against some drive failures; it does not replace backups.

Maintain independent copies of important files, Home Assistant backups, VM data, and configuration. Test restoration periodically.

---

## 12. Networking and Security

### 12.1 Network baseline

- Use wired Ethernet for the always-on host.
- Reserve a stable address through DHCP.
- Document VLANs, DNS, gateways, and service ports.
- Validate connectivity from intended client networks.
- Enable only the firewall rules each service requires.

### 12.2 Service exposure

| Service | Typical port | Intended exposure |
|---|---:|---|
| SSH | TCP 22 | Trusted administration network |
| Screen Sharing | TCP 5900 | Trusted administration network |
| Home Assistant | TCP 8123 | Trusted LAN/VLANs |
| Ollama API | TCP 11434 | Localhost unless explicitly shared |
| SMB | TCP 445 | Trusted file-sharing networks |
| Open WebUI | TCP 3000, if configured | Trusted LAN/VLANs |

Actual ports and bind addresses depend on configuration. Verify the effective firewall policy and service listeners.

### 12.3 Secrets and Git hygiene

- Keep passwords, API keys, tokens, and private keys out of Git.
- Exclude secrets, logs, model files, and generated data from version control.
- Use environment files or a suitable secrets mechanism for local deployments.
- Restrict file permissions and container privileges.
- Avoid unauthenticated public reverse proxies.
- Review mounted host paths and service bind addresses.

### 12.4 Updates

Keep macOS, Homebrew packages, Docker Desktop, UTM, VM images, and application containers updated deliberately.

Back up persistent data and configuration before disruptive upgrades. Record changes affecting VM compatibility, networking, and service startup.

---

## 13. Validation and Operations

### 13.1 Host validation

```bash
sw_vers
uname -m
brew --prefix
pmset -g
df -h
```

Confirm the expected macOS version, ARM64 architecture, power settings, and available storage.

### 13.2 Remote access

From the MacBook or another trusted client:

```bash
ssh <username>@<mac-mini-ip>
```

Verify Screen Sharing and SSH remain available with the OLED switched off.

### 13.3 Service validation

- [ ] Dotfiles bootstrap completes successfully.
- [ ] Homebrew packages and shell configuration are present.
- [ ] Remote SSH and Screen Sharing work.
- [ ] Home Assistant UI is reachable from the LAN.
- [ ] Home Assistant integrations and automations work.
- [ ] Frigate on the Jetson remains reachable.
- [ ] Docker containers start and recover as intended.
- [ ] Ollama loads a local model and responds.
- [ ] External storage mounts reliably.
- [ ] SMB permissions are correct.
- [ ] Backups complete and restoration has been tested.
- [ ] Display sleep does not interrupt server availability.
- [ ] Reboot recovery has been tested.
- [ ] Idle and representative-load power consumption have been measured.

### Operational principle

The Mac mini combines a desktop OS, VM workloads, containers, local inference, and file sharing. Each layer has its own networking, storage, startup, and recovery requirements.

Use the dotfiles repository as the single source of truth for software installation and configuration wherever practical. Keep credentials outside Git and maintain independent backups before migrating critical services.

---

## References

- [Apple Mac mini](https://www.apple.com/mac-mini/)
- [Apple Platform User Guide](https://support.apple.com/guide/mac-help/welcome/mac)
- [Homebrew](https://brew.sh/)
- [Home Assistant — Installation on macOS](https://www.home-assistant.io/installation/macos/)
- [Home Assistant — Alternative Installation](https://www.home-assistant.io/installation/alternative/)
- [UTM — Official Website](https://mac.getutm.app/)
- [UTM Documentation](https://docs.getutm.app/)
- [Docker Desktop for Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Docker Desktop Settings](https://docs.docker.com/desktop/settings-and-maintenance/settings/)
- [Ollama](https://ollama.com/)
- [Apple — Share the screen of another Mac](https://support.apple.com/guide/mac-help/share-the-screen-of-another-mac-mh14066/mac)
