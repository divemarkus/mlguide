# Apple Virtualization Framework

Apple's approach is fundamentally different from installing a third-party hypervisor such as VMware Fusion or UTM. You can use Apple's Virtualization framework directly from application code to create, configure, boot, and manage a Linux virtual machine.

For your Mac mini M6 home lab, this is an important option because you can build your own lightweight VM management system without depending on a commercial VM application's GUI.

## Architecture

```text
Your VM Management Application
    │
    ├── Swift/SwiftUI application or custom management service
    │
    ▼
Apple Virtualization Framework
    │
    ├── VZVirtualMachine · VZVirtualMachineConfiguration
    │
    ▼
macOS Virtualization Infrastructure
    │
    ├── Apple Silicon hardware-assisted virtualization
    │
    ▼
Linux ARM64 Guest
    │
    └── Linux kernel, root filesystem, SSH, workloads
```

Unlike QEMU's general-purpose emulation capabilities, Apple's framework is primarily designed for efficiently virtualizing supported guest operating systems using the underlying hardware. It is not a general-purpose x86 emulator.

---

## Apple's Deployment Process

Apple's sample is a small Swift command-line application. It does not download an Ubuntu ISO, create a VM through a GUI, or invoke a Docker-style deployment engine.

Instead, it demonstrates a kernel-and-initramfs boot workflow. You supply the Linux kernel and initial RAM disk as files, and the sample configures the virtual hardware and launches Linux directly.

1. **Obtain Linux boot artifacts.** Download a kernel and corresponding initramfs for the Mac's architecture. On Apple Silicon, use ARM64/AArch64 artifacts.
2. **Define the VM.** Create a `VZVirtualMachineConfiguration` and allocate virtual CPUs, RAM, a bootloader, and a serial console.
3. **Configure the bootloader.** Create `VZLinuxBootLoader`, assign the kernel and initramfs paths, and supply kernel command-line arguments.
4. **Validate the configuration.** Call `validate()` to check whether the requested VM configuration is supported.
5. **Instantiate and start the VM.** Create `VZVirtualMachine`, attach a delegate for lifecycle events, and invoke `start(completionHandler:)`.
6. **Interact through the console.** The sample connects the guest's serial console to the controlling process's standard input and output. When the guest shuts down, the sample exits.

Apple's example allocates 2 virtual CPUs and 2 GiB of RAM. Those are demonstration values, not fixed framework limits.

---

## Swift Code Example

The core configuration pattern in Apple's example, simplified to highlight the essential operations:

```swift
import Foundation
import Virtualization

func createLinuxVM(
    kernelURL: URL,
    initramfsURL: URL
) throws -> VZVirtualMachine {
    let config = VZVirtualMachineConfiguration()

    config.cpuCount = 2
    config.memorySize = 2 * 1024 * 1024 * 1024

    let bootloader = VZLinuxBootLoader(kernelURL: kernelURL)
    bootloader.initialRamdiskURL = initramfsURL
    bootloader.commandLine = "console=hvc0"
    config.bootLoader = bootloader

    // The complete sample also configures a serial console.
    // Add the serial-port configuration before validating.
    try config.validate()

    return VZVirtualMachine(configuration: config)
}
```

This illustrates the configuration API, not a complete drop-in executable. A runnable version must configure the serial port, start the VM, handle asynchronous errors, and keep the process alive while the guest runs. The kernel and initramfs must also be compatible with the selected boot configuration.

### Key API Objects

| API                                | Responsibility                                       |
|------------------------------------|------------------------------------------------------|
| `VZVirtualMachineConfiguration`    | Defines CPU, memory, bootloader, and virtual devices |
| `VZLinuxBootLoader`                | Loads the Linux kernel and initramfs                 |
| `VZVirtualMachine`                 | Controls the VM lifecycle                            |
| `VZVirtioBlockDeviceConfiguration` | Attaches virtual storage, when required              |
| `VZVirtualMachineDelegate`         | Receives lifecycle events and state changes          |

Reference: [Apple Virtualization Framework](https://developer.apple.com/documentation/virtualization)

---

## Important Distinction: Kernel Boot vs Persistent VM

Apple documents two related approaches. This distinction matters if you want persistent VMs.

### A. Kernel + Initramfs (Direct Boot)

- Loads a kernel and initial RAM disk directly.
- Demonstrates the framework and console interaction.
- Does not provide a conventional installed Linux system with a persistent root disk.
- Useful for custom appliances, boot experiments, and minimal environments.

### B. GUI Linux VM (Persistent Disk)

- Boots an installer ISO using EFI.
- Creates a virtual disk for the Linux installation.
- Persists machine identity and EFI variables between launches.
- Reopens the installed guest rather than reinstalling on every run.

Reference: [Running GUI Linux in a VM on Mac](https://developer.apple.com/documentation/virtualization/running-gui-linux-in-a-virtual-machine-on-a-mac)

For an Ubuntu Server VM hosting Docker, Wazuh, or other home lab services, use the **persistent-disk approach**, then automate guest provisioning after installation.

---

## Apple Framework vs Hypervisor Applications

| Capability                   | Apple Framework Directly                      | UTM / VMware / Parallels              |
|------------------------------|-----------------------------------------------|---------------------------------------|
| VM creation                  | Implement in your own code                    | GUI workflows already provided        |
| CPU and RAM allocation       | Native API                                    | UI and/or product-specific APIs       |
| Virtual disk management      | Implement attachments and disk lifecycle      | Built-in management                   |
| Linux installation           | Implement installer boot and persistent store | Streamlined installation workflows    |
| Start/stop and state mgmt    | Framework API + your lifecycle logic          | Built-in controls and automation      |
| Fleet management             | Build it yourself                             | Varies by product                     |
| AI integration               | Your own API or tool layer                    | CLI, API, or scripts where supported  |

Apple's framework also has application entitlement requirements. The `com.apple.security.virtualization` entitlement must be available to the application using the framework. Read the [Virtualization Entitlement documentation](https://developer.apple.com/documentation/virtualization/adding-the-virtualization-entitlement-to-your-project) before designing a standalone VM manager.

---

## Applying This to an AI-Managed Home Lab

Separate the project into three modules:

```
mac-vm-platform/
├── vm-manager/       # Swift + Virtualization.framework
├── vm-definitions/  # Versioned VM specifications
├── provisioning/    # Ansible roles and playbooks
└── agent-tools/     # Restricted VM-management interface
```

The Swift manager would expose operations such as:

```bash
vm list
vm create ubuntu-sec --cpu 4 --memory 8G --disk 100G
vm start ubuntu-sec
vm stop ubuntu-sec
vm status ubuntu-sec
vm delete ubuntu-sec
```

These are proposed commands for your own manager, not commands built into macOS.

Your local agent can then call this interface, provision the guest over SSH, and report whether the deployment succeeded. The agent does not need direct access to the hypervisor's internal implementation.

---

## Verdict

**Apple's framework** is the right foundation if your goal is to build a custom, Apple-native virtualization platform and learn exactly how VM deployment works.

**UTM** is simpler for getting your first Linux VMs running quickly.

**Swift + Virtualization.framework** is a credible long-term design for an AI-driven deployment platform that you want to own and customize.

The main trade-off is engineering effort: Apple supplies the virtualization primitives, not the complete VM lifecycle, image management, provisioning, and orchestration system.

---

## Cross-References

- [macOS Virtualization Overview](./README.md) — hypervisor comparison and deployment strategies
- [Mac mini M6](../../../04-the-players/apple/macmini/m6-mini.md) — hardware architecture
- [Home Assistant](../../../04-the-players/apple/macmini/home-assistant.md) — HA deployment on Mac mini
- [Hermes Agent](../../../03-the-agent/hermes-agent/README.md) — AI agent for VM orchestration
