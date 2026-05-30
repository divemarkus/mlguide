# GitHub Getting Started Guide (Windows + VS Code + SSH)

> **Audience:** New GitHub user with technical experience who already has a GitHub account.
>
> **Goal:** Set up Git, configure SSH authentication, connect VS Code, create your first repository, and perform your first commit and push.

---

# Table of Contents

1. Install Git
2. Configure Git
3. Create an SSH Key
4. Add SSH Key to GitHub
5. Verify SSH Authentication
6. Install and Configure VS Code
7. Create Your First Repository
8. Clone Repository with VS Code
9. Create Your First Commit
10. Push Changes to GitHub
11. Daily Git Workflow
12. Useful Git Commands
13. Recommended GitHub Practices
14. Suggested Repository Structure

---

# 1. Install Git

## Download Git

Visit:

[Git for Windows](https://git-scm.com/)

Install with mostly default settings.

Verify installation:

```bash
git --version
```

Expected output:

```bash
git version 2.x.x
```

---

# 2. Configure Git

Open:

```bash
Git Bash
```

Configure your identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

Verify:

```bash
git config --list
```

Example:

```text
user.name=John Doe
user.email=john@example.com
```

---

# 3. Create an SSH Key

SSH allows secure authentication without entering a password every time.

## Generate Key

In Git Bash:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

If prompted:

```text
Enter file in which to save the key
```

Press:

```text
ENTER
```

Default location:

```text
~/.ssh/id_ed25519
```

When prompted for passphrase:

```text
Enter passphrase (recommended)
```

---

## Start SSH Agent

```bash
eval "$(ssh-agent -s)"
```

Example:

```text
Agent pid 1234
```

---

## Add Key to Agent

```bash
ssh-add ~/.ssh/id_ed25519
```

---

# 4. Add SSH Key to GitHub

Display your public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Example output:

```text
ssh-ed25519 AAAAC3...
```

Copy the entire line.

---

## Add to GitHub

Login to:

[GitHub SSH Settings](https://github.com/settings/keys)

Select:

```text
New SSH Key
```

Fill in:

```text
Title:
My Desktop

Key:
(Paste entire SSH public key)
```

Click:

```text
Add SSH Key
```

---

# 5. Verify SSH Authentication

Run:

```bash
ssh -T git@github.com
```

First time:

```text
Are you sure you want to continue connecting?
```

Answer:

```text
yes
```

Expected result:

```text
Hi username! You've successfully authenticated.
```

---

# 6. Install and Configure VS Code

Download:

[Visual Studio Code](https://code.visualstudio.com)

---

## Recommended Extensions

Install:

| Extension            | Purpose                 |
| -------------------- | ----------------------- |
| GitHub Pull Requests | GitHub Integration      |
| GitLens              | Git History             |
| Docker               | Containers              |
| Remote SSH           | Remote Systems          |
| YAML                 | Configuration Files     |
| Markdown All in One  | Documentation           |
| Error Lens           | Better Error Visibility |

---

## Verify Git in VS Code

Open VS Code.

Open Terminal:

```text
Terminal → New Terminal
```

Run:

```bash
git --version
```

If Git is found, VS Code is ready.

---

# 7. Create Your First Repository

Navigate to GitHub:

[GitHub](https://github.com)

Click:

```text
New Repository
```

Example:

```text
Repository Name:
hello-github
```

Options:

```text
✓ Public or Private
✓ Don't Add README
✓ No License
```

Click:

```text
Create Repository
```

---

# 8. Clone Repository with VS Code

Copy SSH URL:

Example:

```text
git@github.com:username/hello-github.git
```

---

In terminal:

```bash
cd ~/Projects
```

Clone:

```bash
git clone git@github.com:username/hello-github.git
```

Enter repository:

```bash
cd hello-github
```

Launch VS Code:

```bash
code .
```

---

# 9. Create Your First Commit

Create a file:

```text
hello.txt
```

Contents:

```text
Hello GitHub
```

---

Check status:

```bash
git status
```

Example:

```text
Untracked files:
hello.txt
```

---

Stage file:

```bash
git add hello.txt
```

Or everything:

```bash
git add .
```

---

Commit:

```bash
git commit -m "Initial commit"
```

Example:

```text
[main abc1234] Initial commit
```

---

# 10. Push Changes to GitHub

Push:

```bash
git push origin main
```

You should see:

```text
Enumerating objects...
Writing objects...
```

Refresh GitHub.

Your file should now be visible.

---

# 11. Daily Git Workflow

Most developers follow:

```bash
git pull
```

Make changes.

```bash
git status
```

```bash
git add .
```

```bash
git commit -m "Describe changes"
```

```bash
git push
```

Simple workflow:

```text
Pull → Edit → Add → Commit → Push
```

---

# 12. Useful Git Commands

## View Status

```bash
git status
```

---

## View Commit History

```bash
git log
```

Compact view:

```bash
git log --oneline
```

---

## View Differences

```bash
git diff
```

---

## Create Branch

```bash
git checkout -b feature/new-feature
```

---

## Switch Branch

```bash
git checkout main
```

---

## Pull Latest Changes

```bash
git pull
```

---

## Push Branch

```bash
git push -u origin feature/new-feature
```

---

# 13. Recommended GitHub Practices

## Use SSH Instead of HTTPS

Benefits:

* More secure
* No repeated password prompts
* Works well with automation

---

## Write Meaningful Commits

Bad:

```text
fix
```

Good:

```text
Add Docker compose configuration
```

---

## Commit Frequently

Avoid:

```text
100 files changed
```

Prefer:

```text
Small logical commits
```

---

## Create README.md

Every repository should have:

```text
Purpose
Installation
Usage
Requirements
License
```

---

## Never Commit Secrets

Never upload:

```text
.env
passwords
API keys
certificates
private keys
```

Use:

```gitignore
.env
*.pem
*.key
```

---

# 14. Suggested Repository Structure

For your home-lab, automation, and engineering projects:

```text
project-name/
├── README.md
├── docs/
├── scripts/
├── docker/
├── configs/
├── assets/
├── .gitignore
└── LICENSE
```

Example:

```text
ubuntu-dotfiles/
├── README.md
├── scripts/
│   ├── install.sh
│   └── bootstrap.sh
├── configs/
│   ├── zsh/
│   ├── git/
│   └── vscode/
├── docs/
└── LICENSE
```

---
