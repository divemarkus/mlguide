# Docker

This guide is everything Docker related.

## Table of Contents
1. [Prerequisites](#prerequisites)  
2. [System Preparation](#system-preparation)  
3. [Monitoring Resources](#monitoring-resources)  
4. [Security Considerations](#security-considerations)  
5. [Containers](#containers)

---

## ✅ Prerequisites
- Docker installed and running.

---

## ⚙️ System Preparation

### Basic Software Installation

*Placeholder for installation instructions.*

---

## 📈 Monitoring Resources

### Additional Tools

*Placeholder for monitoring tools.*

---

## 🔒 Security Considerations

Practical, advanced, safe ways to harden and lock down a running Docker container (example: Openclaw). Use these together for strong containment.

### Filesystem Lockdown
- **Make the container root filesystem read-only**

```bash
docker run --read-only ...
```

Add writable `tmpfs` only where needed:

```bash
--tmpfs /tmp --tmpfs /var/run
```

- **Mount application directories read-only**

```bash
-v /host/app:/app:ro
```

If the app writes logs, put logs in a separate `tmpfs` or host directory with restricted permissions.

- **Drop ability to remount filesystems**

```bash
--cap-drop SYSADMIN
```

### Process & Privilege Restrictions

- **Run as non-root**

Add a user in the Dockerfile and run the container as that user, or enforce externally with:

```bash
--user 1000:1000
```

- **Drop all unnecessary Linux capabilities**

Typical minimum:

```bash
--cap-drop ALL
```

Add back only what is strictly required (often none).

- **Prevent privilege escalation**

```bash
--security-opt no-new-privileges=true
```

### Seccomp Hardening

Use Docker’s default seccomp or a custom restrictive profile:

```bash
--security-opt seccomp=profile.json
```

### AppArmor or SELinux Confinement

- AppArmor: `--security-opt apparmor=docker-default` or a custom profile
- SELinux: `--security-opt label:type:containert`

### Network Isolation

- **Remove all networking**

If Openclaw doesn’t need network access:

```bash
--network none
```

- **Restrict egress only**

Use Docker network with firewall rules or a CNI plugin supporting egress ACLs (Cilium, Calico).

- **Disable inter-container communication**

```bash
--icc=false
```

- **Use user-defined bridge networks**

Provides container‑level isolation and firewall control.

### Resource Isolation

- **Limit CPU, RAM, GPU use**

```bash
--memory 512m
--cpus 1.0
```

For GPU/OpenCL: allow only a specific device using NVIDIA Container Runtime options.

- **Restrict filesystem access by device**

```bash
--device-read-bps / --device-write-bps
```

Avoid exposing additional `/dev` entries.

### Container Runtime & Host Controls

- **Kernel namespace & capability tightening**

Avoid `--pid=host`, `--net=host`, etc. (Docker defaults to isolated namespaces).

- **Use rootless Docker**

Provides strong host isolation if compatible with your workload.

- **Enable automatic container restart only on failure**

```bash
--restart=on-failure:3
```

- **Sign and verify images**

Use Docker Content Trust or Sigstore to prevent tampered images.

### Monitoring & Audit

- **Enable auditing on container syscalls**

Use Linux `auditd` with targeted syscall monitoring.

- **Limit logging paths**

Send logs to a controlled destination outside the container.

### Summary of Strongest Minimal Lockdown

If Openclaw can operate read‑only and without networking, launch with:

```bash
docker run \
  --read-only \
  --tmpfs /tmp \
  --network none \
  --cap-drop ALL \
  --security-opt no-new-privileges=true \
  --user 1000:1000 \
  --security-opt seccomp=default.json \
  --security-opt apparmor=docker-default \
  ...
```

---

## 📦 Containers
This folder contains example container-based services and documentation for running them.

- [docker-compose.yml](docker-compose.yml): Example compose file for the example app and services.
- [Example app](example_app/): Minimal Flask app used in the Docker examples.
- [DNS Stack container guide](containers/DNS-STACKv1.md): Notes and configuration for running Pi-hole in Docker.
- [Ollama Stack container guide](containers/OLLAMA-STACKv1.md): Getting started with using Ollama.
- [Nextcloud Stack container guide](containers/NEXTCLOUD-STACKv1.md): All about Nextcloud.
