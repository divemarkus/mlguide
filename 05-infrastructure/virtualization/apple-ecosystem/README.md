# macOS Virtualization on the Mac mini M6

For your home lab, approach this as a small virtualization platform that happens to run on macOS: reproducible VM builds, command-line provisioning, isolated networks, snapshots, and an AI agent capable of deploying and configuring guests.

The key distinction is that the virtualization engine, VM management interface, and guest provisioning system are separate layers. You can use a graphical application to create a VM, then automate its entire lifecycle through CLI tools and configuration files.

Your likely requirements include Linux servers, security and infrastructure labs, Docker workloads, and potentially local AI agents that orchestrate deployments through an Ollama backend.

---

## The Main Options

### UTM

**Best free starting point.**

Built on Apple's Virtualization framework and QEMU. Supports native ARM virtualization and QEMU emulation for other architectures. Has a GUI, configuration-based VM definitions, and CLI automation options.

- **Strengths:** Free, flexible, suitable for Linux labs, easy to experiment with.
- **Weaknesses:** Less polished management and fleet automation than commercial hypervisors; some operations require scripting around its CLI or configuration.

Reference: [UTM Scripting Documentation](https://docs.getutm.app/scripting/scripting/)

---

### VMware Fusion Pro

Mature desktop virtualization with a GUI, virtual networking, snapshots, and support for Apple Silicon guests.

- **Strengths:** Familiar enterprise-style VM workflow, good interactive management, useful networking features.
- **Weaknesses:** Apple Silicon generally means ARM guests, not native x86 virtualization. CLI automation and unattended provisioning are less unified than a dedicated infrastructure-as-code workflow.

Reference: [VMware Fusion Documentation](https://techdocs.broadcom.com/)

---

### Parallels Desktop

A polished commercial VM application, particularly attractive for Windows on ARM and desktop-oriented workloads.

- **Strengths:** Excellent user experience, streamlined setup, integration with macOS, automation interfaces.
- **Weaknesses:** Paid licensing; less attractive if your priority is a fully open, portable VM infrastructure definition.

Reference: [Parallels CLI Documentation](https://kb.parallels.com/en/128842)

---

### QEMU

The low-level engine for emulation and virtualization, rather than a turnkey Mac VM manager.

- **Strengths:** Highly scriptable, supports many guest architectures, detailed control of virtual hardware and disk images.
- **Weaknesses:** More manual setup; Apple's Hypervisor framework is used for hardware acceleration where compatible, while cross-architecture emulation can be much slower.

Reference: [QEMU Documentation](https://www.qemu.org/docs/master/)

---

### Tart

A CLI-first VM tool built around Apple's native virtualization capabilities, especially useful for repeatable macOS and Linux VM workflows.

- **Strengths:** Image-based workflows, scripting, reproducibility, and CI-oriented management.
- **Weaknesses:** More opinionated than QEMU; not a general-purpose x86 emulation solution or a complete replacement for a desktop hypervisor.

Reference: [Tart GitHub](https://github.com/cirruslabs/tart)

---

### OrbStack

A lightweight macOS-oriented Linux machine and container environment.

- **Strengths:** Convenient Linux development environments, fast workflow, good integration with Docker-style workloads.
- **Weaknesses:** Not the first choice for a general-purpose, multi-OS lab with highly customized virtual hardware and complex network topologies.

---

## Feature Comparison

| Platform          | Cost Model                                           | Automation                                     | Best Fit                                       |
|-------------------|------------------------------------------------------|------------------------------------------------|------------------------------------------------|
| UTM               | Free; optional paid Mac App Store version            | `utmctl`, AppleScript, Shortcuts               | General-purpose lab                            |
| VMware Fusion Pro | Personal-use licensing offered free; verify terms    | CLI tooling; `vmcli` in Fusion 13 docs         | Desktop VMs, familiar hypervisor               |
| Parallels Desktop | Paid; features vary by edition                       | `prlctl`, configuration and CLI                | Windows ARM, polished desktop VMs              |
| QEMU              | Open source                                          | QEMU CLI, scripts, libvirt where supported     | Custom hardware, emulation, advanced control   |
| Tart              | Open source                                          | `tart` CLI, Packer, CI pipelines               | Reproducible, image-based VM deployments       |
| OrbStack          | Free and paid offerings; verify current terms        | CLI and developer tooling                      | Linux development environments, containers     |

---

### Important Apple Silicon Limitation

Your Mac mini M6 uses Apple Silicon, so plan around ARM64 guests for native performance.

- **ARM64 Linux:** Excellent fit for Ubuntu Server, Debian, container hosts, monitoring stacks, and most modern infrastructure tools.
- **ARM64 Windows:** Supported by appropriate hypervisors, but check application and driver compatibility.
- **x86-64 Linux/Windows:** QEMU can emulate these architectures, but emulation is materially slower than native virtualization.
- **Nested virtualization, specialized hardware, low-level networking:** Verify per product and macOS release; don't assume features available under Linux/KVM translate directly to macOS.

A virtual machine is not a full substitute for your existing Proxmox or bare-metal lab when you need arbitrary PCI passthrough, physical NIC access, or enterprise hypervisor networking behavior.

---

## Scripted VM Deployment

Narrow your choices to Tart, UTM, and QEMU, with Parallels as a commercial alternative.

### Option A — Tart: Infrastructure-as-Code Style

Tart treats VMs as named, reusable images and integrates with OCI-compatible registries. Its ecosystem includes Packer support and CI automation.

```bash
brew install cirruslabs/cli/tart

# Create a Linux VM
tart create --linux ubuntu-lab

# Inspect available options before configuring
tart set --help

# Start the VM
tart run ubuntu-lab

# Find its IP, once running
tart ip ubuntu-lab
```

A production repository could look like:

```
homelab/
├── vm/
│   ├── ubuntu-server/
│   ├── debian-server/
│   └── security-lab/
├── packer/
├── ansible/
│   ├── inventories/
│   └── playbooks/
├── scripts/
│   ├── create-vm.sh
│   ├── start-vm.sh
│   └── destroy-vm.sh
└── README.md
```

Use Tart for VM lifecycle management, Packer for image construction, and Ansible for OS configuration. This separates the machine image from the configuration applied after boot.

**Trade-off:** Tart is excellent for repeatability, but if your goal is a complex network lab with custom virtual hardware, evaluate its networking and device support before committing.

---

### Option B — UTM: GUI Plus Scripting

UTM has a real automation interface rather than merely a collection of GUI shortcuts. Its documented tooling includes `utmctl`, AppleScript, Shortcuts, VM start/stop operations, and — where the guest integration is configured — command execution inside VMs.

```bash
# Locate UTM's CLI
UTMCTL="/Applications/UTM.app/Contents/MacOS/utmctl"

# Inspect supported commands on your installed version
"$UTMCTL" help

# Inspect the specific command syntax
"$UTMCTL" help start
```

UTM is attractive if you want to create a VM interactively, validate its hardware configuration, and subsequently automate routine operations.

**Trade-off:** Its scripting API does not expose every VM configuration feature. For unattended builds, test VM creation and guest provisioning end-to-end before choosing UTM as your sole automation layer.

---

### Option C — QEMU: Maximum Control

QEMU is the best option when you need detailed control over virtual hardware or must emulate an architecture other than ARM64.

A simplified ARM64 Linux invocation:

```bash
qemu-system-aarch64 \
  -machine virt,accel=hvf \
  -cpu host \
  -smp 4 \
  -m 4096 \
  -drive file=ubuntu-arm64.qcow2,if=virtio \
  -nographic
```

This is a starting point, not a complete bootable Ubuntu definition. The kernel, firmware, disk image, network backend and boot parameters must match the guest image. `hvf` relies on macOS's Hypervisor framework; it does not accelerate arbitrary x86-64 guests on ARM hardware.

**Trade-off:** Maximum flexibility, but you own more of the configuration, lifecycle management, networking, and provisioning logic.

---

## Local Agentic AI to Deploy and Manage VMs

You can run a local agent with Ollama as the inference backend and have it manage VM lifecycle operations, configure guests over SSH, and validate deployments.

The important design decision: give the agent tools that invoke your own controlled automation scripts, rather than unrestricted shell access to the Mac.

### Stack Overview

```text
Local Agent
    │
    ├── Claude Code or Hermes Agent
    │     └── interprets requests, plans tasks, checks results
    │
    ├── Ollama (local inference)
    │     └── local model, subject to tool-calling support
    │
    ├── Controlled Tool Interface
    │     └── MCP server, structured API, or allowlisted CLI wrappers
    │
    ├── VM Lifecycle
    │     └── Tart / UTM / QEMU
    │
    ├── Guest Configuration
    │     └── SSH / Ansible / cloud-init
    │
    └── Validation and Audit
          └── VM status, health checks, logs, deployment report
```

### Claude Code versus Hermes Agent

| Capability         | Claude Code                                              | Hermes Agent                                                           |
|--------------------|----------------------------------------------------------|------------------------------------------------------------------------|
| Main role          | Coding and repository-oriented agent                     | General-purpose agent with tool execution and persistent workflows     |
| Local Ollama       | Check provider config and endpoint compatibility         | Verify current Ollama integration and model support                    |
| Best VM workflow   | Build scripts, edit Ansible, review infrastructure       | Execute approved workflows, inspect state, multi-step operations       |
| Recommended role   | Infrastructure development and maintenance               | Operational orchestration (verify tool support in your version)        |

**Key caveat:** Claude Code is associated with Anthropic's models and services. Running it against a local Ollama model is not automatically supported merely because both speak an OpenAI-compatible API. Check the specific version's provider configuration and authentication requirements before making it part of a privacy-sensitive design.

Similarly, Hermes Agent's local inference compatibility and tool-calling reliability should be tested with your actual model. A model that generates shell commands well may still perform poorly at structured tool calls, error recovery, and multi-step orchestration.

**Recommendation:** Keep the hypervisor automation independent of the AI agent. Then you can change models, inference servers, or agent frameworks without rewriting your VM deployment system.

---

### Example Agent Workflow

You tell the agent:

> Deploy an Ubuntu Server VM named `wazuh-lab`, with 4 vCPUs, 8 GB RAM and a 100 GB disk. Provision SSH, apply the baseline Ansible role, and verify connectivity. Do not modify existing VMs.

The agent should:

1. Parse the request into a structured deployment specification.
2. Validate resource limits and the VM name.
3. Generate or select the approved VM definition.
4. Request confirmation before destructive or privileged operations.
5. Create and start the VM.
6. Provision the guest with SSH and Ansible.
7. Validate OS, network reachability, disk, and services.
8. Return a deployment report, including failures and rollback options.

The scripts should reject duplicate names, cap CPU and RAM allocations, and require explicit approval for deleting VMs or changing network isolation. Log every action.

---

## Recommended Implementation for Your Home Lab

| Layer | Choice |
|---|---|
| **VM Layer** | Tart or UTM (CLI-driven; UTM if GUI-first) |
| **Infrastructure** | Git + Ansible |
| **AI Control Plane** | Ollama + Hermes or Claude Code |
| **Security** | Least privilege, dedicated service account, isolated networks |

A practical first deployment — three ARM64 Linux VMs:

| VM            | vCPU | RAM  | Disk   | Purpose                          |
|---|---:|---|---|---|
| `ubuntu-mgmt` | 2    | 4 GB | 40 GB  | Ansible and management tools     |
| `debian-lab`  | 2    | 4 GB | 40 GB  | General-purpose Linux lab        |
| `ubuntu-sec`  | 4    | 8 GB | 100 GB | Security tooling and experiments |

These are illustrative allocations. Adjust them to your actual hardware configuration, and leave enough memory for macOS, Ollama, and other host workloads.

---

## Networking: Design This Early

For a serious infrastructure lab, don't treat VM networking as an afterthought.

- **NAT:** Best for ordinary guest internet access.
- **Host-only / isolated virtual network:** Best for testing firewall rules, vulnerable services, and security tooling without exposing them to your physical LAN.
- **Bridged networking:** Useful when guests need first-class LAN connectivity, but increases exposure and may require additional network controls.
- **Multi-segment lab:** If you want to emulate firewall zones, VLANs, routing, and IDS/IPS behavior, validate whether your chosen macOS hypervisor provides the virtual switches and NIC behavior you need.

For advanced network experiments, keep your existing physical or Proxmox lab available. A Mac VM environment is excellent for portable workloads and automation, but it is not automatically a replacement for a dedicated network virtualization host.

---

## Final Recommendation

**Tart + Ansible + Ollama + Hermes Agent**, with UTM installed as a convenient GUI alternative.

Why:

1. VM lifecycle management is CLI-driven and reproducible.
2. Guest configuration is separate from the hypervisor.
3. The AI agent operates through a narrow, testable tool interface.
4. The workflow remains usable without an AI model running.
5. You can version-control the deployment logic and reproduce a VM from a clean image.

**Note on privacy:** Ollama running locally does not by itself guarantee privacy. Models, agent tools, integrations, and fallback providers must all be configured to avoid sending data to external services. Read the project's [[privacy]](../../../privacy.md) document for the local-first philosophy.

---

## References

- [UTM Scripting and CLI](https://docs.getutm.app/scripting/scripting/)
- [Tart VM Management](https://github.com/cirruslabs/tart)
- [QEMU Documentation](https://www.qemu.org/docs/master/)
- [Ollama Tool Calling](https://github.com/ollama/ollama/blob/main/docs/capabilities/tool-calling.mdx)
- [Hermes Agent Model Providers](https://hermes-agent.nousresearch.com/docs/integrations/providers)
- [Claude Code with Ollama](https://github.com/ollama/ollama/blob/main/docs/integrations/claude-code.mdx)
