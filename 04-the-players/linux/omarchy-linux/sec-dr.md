
# Omarchy Security & Disaster Recovery — What You Get by Default

The two biggest protections to understand are:

1. **Encryption at rest** — protection if the machine or drive is lost or stolen.
2. **Snapshots / rollback** — protection if an update, package change, or configuration change breaks the system.

The short version is:

> **A default current Omarchy installation gives you a strong laptop/workstation security baseline: LUKS full-disk encryption, a restrictive firewall, SSH disabled by default, separate encryption and user credentials, and Btrfs/Limine snapshot-based recovery.**

However, there is an important 2026 caveat: **I found a currently open August 24, 2026 issue reporting that the default `btrfs-overlayfs` configuration can interfere with actual snapshot restoration on Omarchy 4.x.** So I would not blindly trust snapshots until testing them on your specific installation. More on that below. ([GitHub][1])

---

## 1. Default security architecture

A typical encrypted Omarchy install looks conceptually like this:

```text
┌─────────────────────────────────────┐
│            Your Laptop              │
│                                     │
│  UEFI / Firmware                    │
│        │                            │
│        ▼                            │
│  Limine Bootloader                  │
│        │                            │
│        ▼                            │
│  LUKS Encrypted Linux Storage       │
│        │                            │
│        ▼                            │
│  Btrfs                              │
│   ├── @       Root filesystem       │
│   ├── @home   User data             │
│   ├── snapshots                     │
│   ├── @log                           │
│   └── other system subvolumes       │
│                                     │
└─────────────────────────────────────┘
```

The official installer currently defaults to encryption, and Omarchy explicitly describes full-disk encryption as mandatory in its security model. ([GitHub][2])

---

# 2. LUKS encryption — your primary physical security layer

## What is protected?

The important feature is **LUKS encryption**.

If someone steals your laptop and removes the SSD:

```text
Stolen Laptop
      │
      ▼
Remove NVMe drive
      │
      ▼
Plug into another computer
      │
      ▼
┌──────────────────────────┐
│ Encrypted LUKS container │
│                          │
│ Data is not directly     │
│ readable                 │
└──────────────────────────┘
```

That is very different from an unencrypted Linux installation.

Without encryption, someone can simply boot another Linux distribution and mount your disk:

```bash
mount /dev/nvme0n1pX /mnt
```

Then potentially access:

```text
/home
SSH keys
browser profiles
saved sessions
documents
source code
API tokens
configuration files
```

With properly configured LUKS encryption, offline access to the encrypted data requires the encryption credential.

Omarchy's security documentation specifically states that full-disk encryption is intended to protect data if the computer is lost or stolen and uses standard LUKS. ([GitHub][2])

---

## Two different passwords

Omarchy documents two credentials on an encrypted installation:

| Password                      | Purpose                                   |
| ----------------------------- | ----------------------------------------- |
| **Drive encryption password** | Unlocks the encrypted storage during boot |
| **User password**             | Login and `sudo` authentication           |

This separation is important.

Your boot process is conceptually:

```text
POWER ON
   │
   ▼
Firmware
   │
   ▼
Bootloader
   │
   ▼
🔐 Enter LUKS encryption password
   │
   ▼
Encrypted storage unlocked
   │
   ▼
Linux boots
   │
   ▼
User session
```

Omarchy allows these passwords to be changed through its Update → Password functionality. ([GitHub][2])

### My recommendation

For a serious privacy-focused workstation:

```text
Encryption password
        ≠
User password
        ≠
Password manager master password
```

Don't reuse them.

---

# 3. Firewall is enabled by default

This is a major positive.

Omarchy states that its firewall is enabled by default and incoming traffic is blocked by default, with the documented exception of port **53317 for LocalSend**. SSH is disabled until explicitly enabled. ([GitHub][2])

Conceptually:

```text
Internet / LAN
       │
       ▼
┌────────────────────────────┐
│        Omarchy             │
│                            │
│ Firewall                   │
│                            │
│  SSH       ❌              │
│  Random service ❌         │
│  Random ports ❌           │
│                            │
│  LocalSend 53317 allowed   │
└────────────────────────────┘
```

This is exactly what I want from a desktop operating system.

A fresh workstation should not be advertising:

```text
22/tcp SSH
3000/tcp Web UI
8080/tcp Dashboard
11434/tcp Ollama
```

to your LAN unless **you deliberately chose to expose them**.

---

# 4. SSH is OFF by default

Omarchy specifically keeps SSH disabled until you enable it through:

```text
Setup
  └── Security
       └── SSHD
```

When enabled, Omarchy documents that port 22 is opened with brute-force rate limiting. ([GitHub][2])

For your use case, I would leave SSH disabled unless you have a real reason to SSH *into* the Omarchy workstation.

You can still use the workstation as an SSH client:

```bash
ssh server
ssh gpu-box
ssh firewall
ssh homelab
```

That does **not** require exposing SSH on Omarchy.

This is an excellent default for a personal workstation.

---

# 5. Snapshot architecture — this is the disaster recovery layer

This is where Omarchy gets interesting.

The default design uses:

```text
Btrfs
   +
Snapper
   +
Limine bootloader
```

The official documentation says Omarchy automatically creates a system snapshot on every Omarchy update. You can also manually create one:

```bash
omarchy-snapshot create
```

Snapshots are then exposed through the Limine bootloader. ([GitHub][3])

---

## Example: a bad update

Imagine:

```text
Monday
Omarchy works perfectly
```

You update:

```text
Omarchy Update
       │
       ├── Create snapshot automatically
       │
       ▼
Upgrade packages
       │
       ▼
New kernel
New Mesa
New firmware
New Hyprland component
       │
       ▼
💥 System broken
```

Normally, recovery is supposed to look like:

```text
REBOOT
   │
   ▼
Limine Bootloader
   │
   ▼
Snapshots
   │
   ├── Snapshot
   │      Aug 26
   │      Omarchy version X
   │
   ├── Snapshot
   │      Aug 20
   │
   └── Snapshot
          Aug 10
   │
   ▼
Boot known-good snapshot
   │
   ▼
Restore snapshot
   │
   ▼
System restored
```

That is the basic disaster recovery model Omarchy documents. ([GitHub][3])

---

# 6. What exactly gets restored?

This is **extremely important**.

When you restore an Omarchy snapshot:

### Restored

```text
/
Root filesystem

System packages
System libraries
System configuration
Kernel-related system state
Omarchy system changes
```

### NOT restored

```text
/home
```

Omarchy explicitly states that snapshot restoration restores the root filesystem but **not `/home`**. ([GitHub][3])

So:

```text
BEFORE SNAPSHOT

/
├── etc/
├── usr/
├── var/
└── home/
      └── markus/
           ├── Documents
           ├── Downloads
           ├── Projects
           └── .config
```

After restoring the system:

```text
/              ← rolled back
├── etc/
├── usr/
└── var/

home/          ← NOT rolled back
└── markus/
     ├── Documents
     ├── Downloads
     ├── Projects
     └── .config
```

---

## This has a subtle consequence

Suppose:

```text
Version 1:
Application uses config format A
```

You upgrade:

```text
Version 2:
Application converts config to format B
```

Then you roll the system back:

```text
Application → Version 1
Config      → Still Format B
```

Now:

```text
Old application
       +
New configuration
       =
Possible problem
```

Omarchy explicitly warns about this situation, including `~/.config` remaining as-is after rollback. ([GitHub][3])

As an experienced Linux user, you will immediately understand why that matters.

**System rollback is not the same thing as complete workstation rollback.**

---

# 7. Snapshots are NOT backups

This is the most important disaster-recovery lesson.

Do not think:

> "I have Btrfs snapshots. My data is safe."

No.

Think:

> "I have Btrfs snapshots. I can potentially recover from system breakage."

Snapshots and backups solve different problems.

| Failure               | Snapshot                                          | Backup                     |
| --------------------- | ------------------------------------------------- | -------------------------- |
| Bad package update    | ✅ Excellent                                       | ⚠️ Overkill                |
| Broken kernel         | ✅                                                 | ⚠️                         |
| Bad system config     | ✅                                                 | ⚠️                         |
| Deleted `/home` files | ❌ Omarchy system restore does not restore `/home` | ✅                          |
| SSD dies              | ❌                                                 | ✅                          |
| Laptop stolen         | ❌ Recovery unavailable if disk is gone            | ✅                          |
| Ransomware/corruption | Maybe                                             | ✅ Offline/versioned backup |
| Fire/flood            | ❌                                                 | ✅ Off-site backup          |

So I would consider Omarchy's snapshots **Layer 1 recovery**, not your complete disaster recovery strategy.

---

# 8. Baseline snapshot and "Reset Computer"

Omarchy has another very interesting recovery feature.

The installer creates a **baseline snapshot**.

This enables:

```text
Setup
  └── Reset Computer
```

The documented behavior is effectively:

```text
Current Machine
       │
       ▼
Delete user accounts
       │
       ▼
Wipe /home
       │
       ▼
Discard installed packages
and system changes
       │
       ▼
Clear machine identity
       │
       ├── Network connections
       ├── Host keys
       └── Other machine identity
       │
       ▼
Restore baseline snapshot
       │
       ▼
First boot setup wizard
```

Omarchy says this functionality is available on systems installed from the Omarchy ISO because it relies on that installer-created baseline snapshot. ([GitHub][2])

This is particularly useful if you:

```text
Sell laptop
Give laptop to someone
Repurpose workstation
Move hardware to another user
```

Instead of:

```bash
dd if=/dev/zero ...
reinstall everything
```

you can return the system to its baseline state.

### Important:

This is a **factory reset**, not a backup.

Do not press it unless you intend to destroy your user environment.

---

# 9. Direct Boot vs recovery access

Omarchy offers a convenience feature called **Direct Boot**.

Normally:

```text
Firmware
   ↓
Limine
   ↓
Choose Omarchy / Snapshot
```

With Direct Boot:

```text
Firmware
   ↓
Omarchy decryption screen
```

This is faster and cleaner for daily use.

However, if you need to access snapshots:

```text
Reboot
   ↓
BIOS / UEFI boot menu
   ↓
Select Limine
   ↓
Select Snapshot
```

So for a machine where recovery convenience matters more than shaving a few seconds off boot time, **I would personally leave the normal Limine boot path available**. ([GitHub][3])

---

# 10. The big current caveat: test snapshot recovery

Here is the part where I would be careful before calling Omarchy's DR system bulletproof.

A GitHub issue opened **August 24, 2026** reports that Omarchy 4.x's default `btrfs-overlayfs` configuration conflicts with `limine-snapper-sync`, potentially preventing `omarchy-snapshot restore` from functioning correctly after booting a snapshot. The issue includes a technical reproduction and is currently open. ([GitHub][1])

There have also been recent reports of update/boot regressions involving encrypted LUKS systems and kernel/boot tooling. ([GitHub][4])

That does **not** mean:

> Omarchy snapshots are useless.

It means:

> **As of August 27, 2026, you should verify rollback yourself before trusting it as your only recovery mechanism.**

This is particularly important because Omarchy is:

```text
Arch rolling release
+
rapidly evolving desktop stack
+
kernel updates
+
Wayland ecosystem
```

That combination benefits enormously from snapshots—but also means the recovery chain must actually be tested.

---

# 11. My recommended "Day 1 DR test"

After installing Omarchy, I would immediately do this:

### Step 1 — Confirm filesystem

```bash
findmnt /
findmnt /home
```

Confirm the expected Btrfs/subvolume layout.

### Step 2 — Create a manual snapshot

```bash
omarchy-snapshot create
```

### Step 3 — Create a deliberate harmless change

For example:

```bash
sudo touch /etc/omarchy-recovery-test
```

Or change something trivial in `/etc`.

### Step 4 — Reboot

Go into:

```text
Limine
   ↓
Snapshots
   ↓
Select the test snapshot
```

### Step 5 — Verify

Confirm you're actually booted into the snapshot.

### Step 6 — Attempt the documented restore

```bash
omarchy-snapshot restore
```

### Step 7 — Reboot and verify

Check whether the deliberate system change disappeared.

### Step 8 — Verify `/home`

Create a test file in `/home` before restoring:

```bash
touch ~/snapshot-home-test
```

Confirm that it remains.

That gives you a real-world understanding of:

```text
SYSTEM DATA
        vs
USER DATA
```

---

# 12. Secure Boot: important distinction

One thing you should know before installation is that the current Omarchy documentation says you must disable **Secure Boot and/or TPM** to install it. ([GitHub][5])

Therefore, I would not describe the default Omarchy installation as:

```text
LUKS
+
Secure Boot
+
TPM measured boot
+
verified boot
```

Instead, the practical default security model is closer to:

```text
Physical protection
      ↓
LUKS encryption

Network protection
      ↓
Firewall default-deny inbound

Remote access
      ↓
SSH off by default

System recovery
      ↓
Btrfs snapshots + Limine
```

That is still a strong desktop baseline, but **LUKS encryption does not replace verified boot**.

---

# 13. My security assessment

## Default Omarchy security

| Layer                                   | Default                          | My assessment |
| --------------------------------------- | -------------------------------- | ------------- |
| Full-disk encryption                    | LUKS                             | ⭐⭐⭐⭐⭐         |
| Separate encryption/user credentials    | Yes                              | ⭐⭐⭐⭐⭐         |
| Firewall                                | Enabled                          | ⭐⭐⭐⭐⭐         |
| Default inbound exposure                | Very limited                     | ⭐⭐⭐⭐⭐         |
| SSH                                     | Disabled by default              | ⭐⭐⭐⭐⭐         |
| Brute-force protection when SSH enabled | Documented rate limiting         | ⭐⭐⭐⭐          |
| Secure Boot                             | Not part of default install path | ⭐⭐            |
| TPM-based unlock                        | Not default                      | ⭐⭐            |
| Mandatory access control                | Not a defining default layer     | ⭐⭐½           |
| Snapshot recovery                       | Built in                         | ⭐⭐⭐⭐*         |
| Disaster recovery of `/home`            | Not provided by system rollback  | ⭐⭐            |
| Factory reset                           | Built in for ISO installs        | ⭐⭐⭐⭐⭐         |

* **Currently verify snapshot restore on your installation because of the open Omarchy 4.x issue noted above.**

---

# 14. How I would harden Omarchy for you

I would build on the defaults rather than replace them.

## Layer 1 — Keep default LUKS

```text
LUKS encryption
```

Use a strong, unique encryption passphrase.

---

## Layer 2 — Keep the firewall restrictive

Do not casually open ports.

For example, if you run local AI:

```text
Ollama
11434
```

I would avoid exposing it to:

```text
0.0.0.0
```

unless you deliberately want LAN access.

Your existing local AI architecture already separates the workstation from dedicated inference services and is designed around local-first inference and private infrastructure. 

I would preserve that philosophy:

```text
Omarchy workstation
       │
       │ SSH / authenticated API
       ▼
Dedicated AI server
       │
       ├── Ollama
       ├── OpenWebUI
       ├── Qdrant
       └── Flowise
```

---

## Layer 3 — Back up `/home`

This is the missing piece that snapshots do not solve.

I would use something like:

```text
Btrfs snapshots
       │
       │ protects
       ▼
SYSTEM ROLLBACK


Restic / Borg / Kopia
       │
       │ protects
       ▼
USER DATA
       │
       ▼
NAS
       +
encrypted external drive
```

The ideal model:

```text
                 ┌─────────────────┐
                 │    Omarchy      │
                 └────────┬────────┘
                          │
          ┌───────────────┼──────────────┐
          │               │              │
          ▼               ▼              ▼
      LUKS             Snapshot       Backup
          │               │              │
          ▼               ▼              ▼
      Stolen          Bad Update      SSD Failure
      Laptop          Bad Config      Deleted Files
```

---

# My recommended disaster recovery architecture

For a serious engineering/privacy workstation, I would configure:

```text
┌──────────────────────────────────────┐
│           OMARCHY WORKSTATION        │
│                                      │
│  🔐 LUKS Encryption                  │
│                                      │
│  🧱 Firewall                         │
│                                      │
│  🚫 SSH Disabled by Default          │
│                                      │
│  📸 Btrfs Snapshots                  │
│      ├── Automatic before updates    │
│      └── Manual before experiments   │
│                                      │
│  💾 Local Backup                     │
│      └── External encrypted drive    │
│                                      │
│  🌐 Secondary Backup                 │
│      └── NAS / remote encrypted repo │
└──────────────────────────────────────┘
```

Then your recovery scenarios become:

| Disaster                  | Recovery                      |
| ------------------------- | ----------------------------- |
| Bad package update        | Limine → Snapshot             |
| Bad kernel                | Limine → Snapshot             |
| Broken desktop            | Snapshot / repair             |
| Deleted source code       | Backup                        |
| Corrupt `/home`           | Backup                        |
| SSD failure               | Restore backup                |
| Stolen laptop             | Buy hardware → restore backup |
| Selling laptop            | Omarchy Reset Computer        |
| Ransomware                | Offline/versioned backup      |
| Snapshot mechanism broken | External boot media + backup  |

## My bottom line

**Omarchy's default security model is genuinely good for a modern Linux workstation.** The strongest defaults are LUKS encryption, firewall-on, and SSH-off. Its snapshot integration is exactly the kind of protection I want on an Arch-based daily driver.

But I would make one rule before trusting it with serious work:

> **Install it, create a snapshot, deliberately break something harmless, and prove that you can boot and restore.**

Once that test passes, add an independent encrypted backup of `/home`, and you have a much more complete security and disaster-recovery design than most Linux desktops.

[1]: https://github.com/basecamp/omarchy/issues/8047?utm_source=chatgpt.com "btrfs-overlayfs is enabled by default, which makes snapshot rollback impossible: limine-snapper-sync refuses to start inside every snapshot boot · Issue #8047 · basecamp/omarchy · GitHub"
[2]: https://github.com/basecamp/omarchy/blob/quattro/manual/48-security.md?utm_source=chatgpt.com "omarchy/manual/48-security.md at quattro · basecamp/omarchy · GitHub"
[3]: https://github.com/basecamp/omarchy/blob/quattro/manual/47-system-snapshots.md?utm_source=chatgpt.com "omarchy/manual/47-system-snapshots.md at quattro · basecamp/omarchy · GitHub"
[4]: https://github.com/basecamp/omarchy/issues/6169?utm_source=chatgpt.com "Kernel/limine update leaves boot broken until manual `limine-mkinitcpio` rerun — encrypt hook \"device not found\"; suspicious duplicate signing hash across different kernel versions · Issue #6169 · basecamp/omarchy · GitHub"
[5]: https://github.com/basecamp/omarchy/blob/quattro/manual/02-getting-started.md?utm_source=chatgpt.com "omarchy/manual/02-getting-started.md at quattro · basecamp/omarchy · GitHub"
