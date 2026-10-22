
# Apple Mac mini M6 — Home Lab Setup

A reproducible macOS setup for an Apple Silicon Mac mini used as an always-on home server, local AI workstation, virtualization host, development environment, and entertainment system.

## Table of Contents

- [1. Hardware and Architecture](#1-hardware-and-architecture)
- [2. macOS Initial Configuration](#2-macos-initial-configuration)
- [3. Always-On Operation](#3-always-on-operation)
- [4. Remote Administration](#4-remote-administration)
- [5. 55-Inch OLED TV Setup](#5-55-inch-oled-tv-setup)
- [6. Install Developer Tools](#6-install-developer-tools)
- [7. Deploy Dotfiles](#7-deploy-dotfiles)
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
| Memory | 32 GB unified memory |
| Internal storage | 1 TB SSD |
| Network | Wired Ethernet; 10 GbE if configured |
| Display | 55-inch OLED TV over HDMI |
| External storage | Thunderbolt/USB-C DAS or NAS |
| Primary OS | macOS |
| Virtualization | UTM |
| Containers | Docker Desktop |
| Local AI | Ollama, MLX-compatible tooling, LM Studio, oMLX |
| Smart home | Home Assistant OS in a VM |
| Video surveillance | Frigate NVR on Jetson |
| Development | Homebrew, Git, Zsh, Oh My Zsh, Powerlevel10k, VS Code |

Verify the actual hardware, port capabilities, and macOS version against the machine's system information before applying model-specific settings.

### Intended architecture

```text
                         HOME LAN
                            |
                    +-------+-------+
                    |               |
              Mac mini M6       Other clients
                    |
          +---------+----------+
          |                    |
     macOS host           External storage
          |                Thunderbolt/USB
    +-----+----------+
    |                |
  UTM VM         Docker Desktop
    |                |
 Home Assistant   Local services
 OS               AI / databases /
                  development tools
    |
 Smart-home devices
    |
 MQTT / automations

 Frigate NVR remains on Jetson
 and communicates with Home Assistant
 over the LAN.
```

### Design principles

- Keep macOS as the primary host OS.
- Run Home Assistant OS as a dedicated VM to retain its Supervisor and add-on functionality.
- Use Docker Desktop for general Linux containers and development workloads.
- Keep Frigate on the Jetson; do not duplicate its video processing on the Mac mini.
- Use native Apple Silicon software wherever available.
- Keep persistent application data, VM disks, model storage, and backups organized separately.
- Maintain a recovery path that does not depend on the Mac mini itself.

## 2. macOS Initial Configuration

Complete the initial macOS Setup Assistant and create a dedicated administrator account.

### 2.1 Update macOS

Open **System Settings → General → Software Update**.

Install available stable updates, restart, and verify the installed version:

```bash
sw_vers
uname -m
system_profiler SPHardwareDataType
```

On Apple Silicon, `uname -m` should normally report `arm64`.

Install updates deliberately on this always-on host. Avoid installing a major macOS upgrade without first checking compatibility with Docker Desktop, UTM, local AI runtimes, and any required extensions.

### 2.2 Set the hostname

Choose a stable hostname that is distinct from the MacBook.

Example:

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
hostname
```

Reserve a DHCP address for the Mac mini on the router. Use the reserved address for administration and service configuration rather than relying exclusively on multicast DNS.

### 2.3 Configure accounts and permissions

- Use a standard daily account for normal work where practical.
- Keep a separate administrator account for privileged maintenance.
- Use a strong password and enable FileVault.
- Store FileVault recovery information securely outside the Mac mini.
- Use separate credentials for services and applications.
- Do not put passwords, API keys, private SSH keys, or recovery codes in the dotfiles repository.

**FileVault and unattended reboot behavior:** after a restart, FileVault may require an interactive unlock before the normal user session and its services can start. Test the complete recovery workflow before treating the machine as a fully unattended server.

### 2.4 Install Apple command-line tools

Install Apple's Command Line Tools if they are not already present:

```bash
xcode-select --install
```

Verify the developer tools path:

```bash
xcode-select -p
clang --version
git --version
```

---

## 3. Always-On Operation

The Mac mini must remain available when the OLED display is switched off or asleep.

### 3.1 Configure Energy settings

Open **System Settings → Energy**. The exact controls depend on the macOS release.

Configure the available options to:

- Prevent automatic sleeping when the display is off.
- Enable waking for network access if offered.
- Configure automatic startup after power failure if supported.
- Allow the display to turn off independently of the Mac.

Do not disable display sleep simply to keep server services running.

### 3.2 Validate host availability

After applying the settings:

1. Leave a long-running test process or service active.
2. Allow the display to sleep.
3. Connect from another machine over SSH.
4. Confirm Home Assistant and other required services remain reachable.

Check power and sleep-related settings:

```bash
pmset -g
pmset -g custom
```

`pmset` output varies by hardware and macOS version. Use System Settings for supported changes, and verify any command-line power-management changes against the installed OS.

### 3.3 Restart and recovery

Test the following before production use:

- Normal reboot.
- Power interruption and recovery, where safely testable.
- Network interruption and reconnection.
- Docker Desktop restart and container recovery.
- UTM restart and Home Assistant VM recovery.
- Recovery after a user logout.
- Recovery after the OLED TV is turned off.

A service that runs only inside a logged-in GUI session is not automatically a reliable system service.

---

## 4. Remote Administration

The Mac mini should be manageable from the MacBook or another trusted workstation without requiring the TV, keyboard, or mouse.

### 4.1 Enable SSH

Open:

**System Settings → General → Sharing → Remote Login**

Enable Remote Login and restrict access to the required user accounts.

Verify from the Mac mini:

```bash
sudo systemsetup -getremotelogin
```

From the MacBook:

```bash
ssh <username>@<mac-mini-ip>
```

Replace the placeholders with the actual account and reserved IP address.

### 4.2 Configure SSH keys

Use the existing SSH configuration and public keys from the dotfiles workflow. Provision private keys securely rather than copying them through Git.

Check permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

Only run the private-key command if that key exists. Do not overwrite an existing key accidentally.

Test:

```bash
ssh -T <configured-host-alias>
```

Use a separate key or account for the Mac mini if the security boundary warrants it.

### 4.3 Enable Screen Sharing

Open:

**System Settings → General → Sharing → Screen Sharing**

Enable access for authorized users only.

Use macOS Screen Sharing from the MacBook for GUI administration, troubleshooting the OLED display, and interacting with applications such as UTM.

Do not expose SSH or VNC/Screen Sharing directly to the public internet. Use the trusted LAN or an appropriately configured VPN.

### 4.4 Remote management model

| Method | Purpose |
|---|---|
| SSH | Shell, diagnostics, Git, and service management |
| Screen Sharing | GUI applications and local troubleshooting |
| Browser | Home Assistant and web-based service interfaces |
| Git | Configuration management and reproducible changes |
| Local console | Recovery when networking or remote access fails |

---

## 5. 55-Inch OLED TV Setup

The OLED is both the Mac mini's display and a primary entertainment screen. Configure it for excellent viewing without leaving static content on the panel unnecessarily.

### 5.1 Physical connection

Connect the Mac mini's HDMI output directly to a suitable HDMI input on the TV.

Use a certified cable capable of the intended resolution, refresh rate, HDR, and chroma format. Avoid unnecessary adapters.

### 5.2 Configure macOS display settings

Open **System Settings → Displays**.

- Select the TV's native resolution, typically 4K if supported.
- Choose a refresh rate supported by both devices.
- Enable HDR when supported and useful for the content.
- Adjust scaling for readable desktop text at normal viewing distance.
- Configure audio output to the TV or the intended audio system.
- Verify that the TV is operating in its appropriate PC or low-latency mode if desired.

Available modes depend on the exact TV model, HDMI input, cable, and macOS release.

### 5.3 OLED protection

Configure a short display-off timer and an appropriate screen saver.

- Let the display turn off when idle.
- Avoid leaving static terminal windows, dashboards, taskbars, or application interfaces visible for hours.
- Use a moving screen saver when the display is on but idle.
- Use the TV's built-in OLED maintenance features as directed by its manufacturer.
- Do not disable panel-protection features to preserve a permanently visible desktop.

The Mac mini can continue running while the TV is off.

### 5.4 Entertainment use

Install and configure the desired media applications using the GUI Brewfile.

Use the TV as a normal macOS display for browsing, streaming, music, media playback, and occasional development. Keep remote administration and server availability independent of the TV's power state.

Do not assume the Mac mini will always turn the TV on or off automatically. HDMI-CEC behavior varies by TV and connection.

---

## 6. Install Developer Tools

This lab intentionally installs the full toolchain. Package selection can be narrowed after the environment is established and tested.

Install Homebrew using its official instructions:

https://brew.sh/

On Apple Silicon, the expected prefix is normally `/opt/homebrew`.

Verify:

```bash
brew --prefix
brew doctor
```

### 6.1 Install all Brewfiles

From the root of the dotfiles repository:

```bash
brew bundle --file=Brewfiles/Brewfile.core
brew bundle --file=Brewfiles/Brewfile.gui
brew bundle --file=Brewfiles/Brewfile.ai
brew bundle --file=Brewfiles/Brewfile.lab
brew bundle --file=Brewfiles/Brewfile.security
```

Review the Brewfiles first for obsolete package names, incompatible casks, duplicate applications, and architecture-specific dependencies. The security Brewfile may currently be a placeholder.

A failed package should be diagnosed individually rather than hiding the error and assuming the whole installation succeeded.

### 6.2 Verify the toolchain

```bash
brew list
git --version
python3 --version
node --version
docker --version
docker compose version
```

Some commands will not exist until their respective packages have installed successfully.

---

## 7. Deploy Dotfiles

Use the existing dotfiles repository as the canonical source for shell, Git, SSH, editor, and macOS configuration.

### 7.1 Clone the repository

Replace the placeholder URL with the real repository URL.

```bash
mkdir -p ~/repos/personal
cd ~/repos/personal

git clone <YOUR_DOTFILES_REPO_URL> dotfiles
cd dotfiles

git status
```

### 7.2 Review the bootstrap script

Inspect the script and the macOS defaults before execution:

```bash
sed -n '1,240p' bootstrap.sh
sed -n '1,240p' macos/defaults.sh
```

Check for destructive file operations, overwriting existing files, credential assumptions, hard-coded paths, and commands that require administrator privileges.

The bootstrap script should be safe to rerun and should not replace existing user configuration without an explicit backup or documented policy.

### 7.3 Execute the bootstrap

After reviewing the script:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

The bootstrap should install the defined packages, set up Oh My Zsh and Powerlevel10k, configure plugins, create symlinks, restore VS Code extensions, and apply the intended macOS defaults.

### 7.4 Validate the shell

Open a new terminal session:

```bash
echo "$SHELL"
command -v brew
command -v git
command -v zsh

ls -l ~/.zprofile ~/.zshrc ~/.gitconfig
```

Confirm the symlinks resolve to the intended repository files.

Run:

```bash
p10k configure
```

Verify Git identity, SSH aliases, and environment variables. Ensure `.zprofile` initializes the Apple Silicon Homebrew environment correctly.

### 7.5 Machine-specific configuration

Shared configuration should remain consistent, but host-specific settings must not be blindly shared.

Keep machine-specific differences for:

- Hostname and network configuration.
- Local paths and mounted storage.
- Workstation-only applications.
- Environment variables and credentials.
- Server power-management preferences.
- GUI and display preferences.
- Service-specific ports and bind addresses.

Do not commit machine secrets to Git.

---

## 8. Virtualization and Home Assistant

### 8.1 Virtualization platform: UTM

Use [UTM](https://mac.getutm.app/) for a native Apple Silicon VM workflow.

UTM supports ARM64 virtualization and QEMU-based emulation. It is a reasonable free starting point for a Home Assistant OS virtual machine on this host.

Install through Homebrew:

```bash
brew install --cask utm
```

Home Assistant's official macOS instructions describe VM installation and note that UTM can be used where the standard VirtualBox path is unsuitable.

Official guide:

https://www.home-assistant.io/installation/macos/

### 8.2 Deploy Home Assistant OS

Use a dedicated Home Assistant OS VM rather than a Home Assistant Core container. This preserves the normal Home Assistant OS/Supervisor experience.

Download the current ARM64-compatible Home Assistant OS image from the official installation documentation:

https://www.home-assistant.io/installation/alternative/

Use the image format and VM configuration supported by the selected UTM backend and the current Home Assistant release. Do not assume every generic ARM image can boot with every virtualization backend.

Suggested starting resources:

| Setting | Initial value |
|---|---:|
| Architecture | ARM64 / AArch64 |
| vCPU | 2–4 |
| Memory | 4 GB |
| Virtual disk | 32 GB or larger |
| Network | LAN-reachable; bridged where supported |
| Firmware | UEFI when required by the image |

Increase memory, CPU, and disk as integrations, history, add-ons, and recorder data grow.

### 8.3 Network requirements

Home Assistant must be reachable from other devices on the LAN.

- Prefer a stable IP address or DHCP reservation.
- Confirm access to the web UI on TCP port `8123`.
- Test discovery protocols required by integrations.
- Verify multicast, mDNS, and broadcast-dependent integrations separately.
- Ensure firewall and VLAN rules permit required device-to-Home-Assistant traffic.

NAT networking can complicate device discovery. Use a bridged or otherwise suitable LAN networking mode when supported and validated.

### 8.4 VM startup and recovery

Configure the VM to start automatically after the Mac boots and the VM runtime is available, where supported.

UTM is a desktop application; do not assume a VM will start reliably at boot without testing the actual login and application lifecycle.

Test:

1. Home Assistant boots successfully.
2. It receives a stable LAN address.
3. Integrations and automations work.
4. The VM restarts cleanly.
5. The Mac restarts and Home Assistant returns.
6. Home Assistant backups can be restored.

Keep Home Assistant backups outside the VM and preferably on separate storage.

### 8.5 Frigate integration

Frigate NVR remains on the Jetson. The Mac mini is not responsible for camera decoding or object detection.

Configure Home Assistant to communicate with Frigate and MQTT over the LAN as appropriate. Validate firewall rules, credentials, event delivery, and service discovery independently.

---

## 9. Docker and Container Services

### 9.1 Install Docker Desktop

Install Docker Desktop for macOS:

```bash
brew install --cask docker
```

Launch Docker Desktop from Applications, complete its initial setup, and wait until the Docker engine is running.

Docker Desktop runs Linux containers inside a Linux VM. This differs from running Docker natively on an Ubuntu host.

### 9.2 Verify the installation

```bash
docker version
docker info
docker compose version

docker run --rm hello-world
```

The client and server portions of `docker version` should both be available when Docker Desktop is running.

### 9.3 Container architecture

Prefer multi-architecture images or images explicitly supporting `linux/arm64`.

```bash
docker image inspect <IMAGE_NAME>
```

Check vendor documentation before deploying images that require:

- NVIDIA Container Toolkit or CUDA.
- Linux kernel modules.
- Direct access to PCIe hardware.
- Host-specific networking.
- Unsupported privileged device mappings.

NVIDIA-specific containers designed for the old Ubuntu host will not automatically work on macOS.

### 9.4 Persistent data and service recovery

Keep Compose definitions and non-secret configuration in Git. Keep persistent application data outside ephemeral container layers.

Example project structure:

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

Use a separate directory or external storage volume for large datasets and model files.

Add restart policies to appropriate services, but remember that container restart policies only take effect when the Docker engine itself is running.

### 9.5 Home Assistant and Docker

Home Assistant OS runs in UTM, not inside Docker Desktop.

Use Docker for complementary services such as development environments, AI interfaces, databases, vector stores, and monitoring. Avoid deploying duplicate services without a clear reason.

---

## 10. Local AI and LLMs

The M6 serves as a low-power Apple Silicon inference and agent node. The separate NVIDIA workstation remains available for workloads that specifically require CUDA or higher GPU throughput.

### 10.1 Tooling

The AI Brewfile includes:

- Ollama
- LM Studio
- oMLX
- Claude Code
- CMake
- LLVM
- Draw Things

Use native Apple Silicon builds wherever available.

### 10.2 Ollama

After installation, verify the CLI and service:

```bash
ollama --version
ollama list
```

If the service is running, test a model that fits the available memory and intended workload:

```bash
ollama run <MODEL_NAME>
```

Replace `<MODEL_NAME>` with a model supported by the installed Ollama version.

The Ollama HTTP API commonly listens on port `11434`. Keep it bound to localhost unless LAN access is required. If LAN access is enabled, restrict it with appropriate firewall and network controls.

### 10.3 Unified memory

The M6's 32 GB unified memory is shared by macOS, applications, and AI workloads. It is not 32 GB exclusively available to the model.

Model size, quantization, context length, KV cache, and concurrent applications affect the actual memory requirement. Start with smaller models and measure memory pressure before increasing model size or context length.

### 10.4 Model storage

Keep active models on fast local storage when practical. Move archival models and datasets to external storage as appropriate.

Avoid placing active model files on a slow or intermittently connected network share without testing load times and runtime behavior.

### 10.5 Local AI service integration

Expose the model endpoint only to intended clients. If Open WebUI, agents, or other applications use Ollama, configure the service URL explicitly and test access from the appropriate container or host network.

Container-local `localhost` refers to that container, not automatically to the macOS host.

---

## 11. Storage and NAS

The Mac mini can serve files over the LAN while using a directly attached storage enclosure or a separate NAS.

### 11.1 Storage roles

| Storage | Intended use |
|---|---|
| Internal SSD | macOS, applications, VM disks, databases, active models |
| External DAS | Bulk data, media, archives, Frigate exports, backups |
| Separate NAS or backup target | Independent backup copies and shared files |

### 11.2 File sharing

For macOS SMB sharing, open:

**System Settings → General → Sharing → File Sharing**

Enable SMB as needed and grant access only to the required users.

Test access from another machine using:

```text
smb://mac-mini-lab
```

Use separate accounts and permissions for shared data. Do not expose SMB directly to the public internet.

### 11.3 RAID and backup

RAID provides availability against some drive failures; it is not a backup.

Maintain independent copies of important files, Home Assistant backups, VM data, and configuration. Test restoration rather than relying solely on successful backup jobs.

---

## 12. Networking and Security

### 12.1 Network configuration

- Use wired Ethernet for the always-on host.
- Reserve a stable address through DHCP.
- Document VLANs, DNS, gateways, and service ports.
- Validate service reachability from the intended client networks.
- Enable only the firewall rules required for each service.

### 12.2 Service exposure

| Service | Typical port | Exposure |
|---|---:|---|
| SSH | TCP 22 | Trusted administration network |
| Screen Sharing | TCP 5900 | Trusted administration network |
| Home Assistant | TCP 8123 | Trusted LAN/VLANs |
| Ollama API | TCP 11434 | Localhost unless deliberately shared |
| SMB | TCP 445 | Trusted file-sharing networks |
| Open WebUI | TCP 3000, if configured | Trusted LAN/VLANs |

Actual ports depend on application configuration. Confirm the effective bind address and firewall policy; a port number alone does not guarantee a service is private.

### 12.3 Secrets and Git hygiene

- Keep API keys, passwords, private keys, and tokens out of Git.
- Use `.gitignore` for local secrets, data, logs, and generated model files.
- Use environment files or a suitable secrets mechanism for local deployments.
- Restrict file permissions.
- Review container privileges and mounted host paths.
- Do not expose administrative interfaces through unauthenticated reverse proxies.

### 12.4 Updates

Keep macOS, Homebrew packages, Docker Desktop, UTM, VM images, and application containers updated deliberately.

Back up persistent data and configuration before disruptive upgrades. Record changes that affect VM compatibility, networking, and service startup.

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

Check that the machine is running the expected macOS release, using ARM64, and has sufficient free storage.

### 13.2 Remote access validation

From the MacBook or another trusted host:

```bash
ssh <username>@<mac-mini-ip>
```

Confirm Screen Sharing works and remains available with the TV switched off.

### 13.3 Service validation

- [ ] Home Assistant UI loads from another LAN device.
- [ ] Home Assistant integrations and automations work.
- [ ] Frigate on the Jetson remains reachable.
- [ ] Docker containers start and recover as intended.
- [ ] Ollama loads a local model and responds to requests.
- [ ] External storage mounts reliably.
- [ ] SMB permissions are correct.
- [ ] Backup jobs complete and a restoration has been tested.
- [ ] OLED display sleep does not interrupt host services.
- [ ] Reboot recovery has been tested.
- [ ] Power consumption is measured at idle and under representative workloads.

### 13.4 Operational principle

Treat the Mac mini as a host that combines a desktop OS, virtual machines, containers, local inference, and shared storage. Each layer has its own startup, networking, storage, and recovery requirements.

Keep configuration version-controlled, keep secrets outside Git, and maintain independent backups before migrating critical services.

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

