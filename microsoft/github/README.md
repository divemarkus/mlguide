# GitHub Getting Started Guide (Windows + VS Code + SSH)

> **Audience:** New GitHub user with technical experience who already has a GitHub account.
>
> **Goal:** Set up Git, configure SSH authentication, connect VS Code, create your first repository, and perform your first commit and push.

---

# 1. Install Git

## Download Git

Visit or use winget:

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

# GitHub Getting Started Guide (VS Code Only)

> **Audience:** New GitHub user with some technical knowledge who already has a GitHub account.
>
> **Goal:** Use **Visual Studio Code as the primary interface** for Git and GitHub, minimizing terminal usage and leveraging built-in GitHub integration.

---

# 1. Install Git

Although VS Code provides a graphical Git interface, Git itself must still be installed.

Download:

[Git for Windows](https://git-scm.com/download/win)

Install using the default settings.

> Git runs in the background and powers VS Code's source control features.

---

# 2. Install VS Code

Download:

[Visual Studio Code](https://code.visualstudio.com)

Launch VS Code after installation.

---

# 3. Sign into GitHub from VS Code

## Open Account Menu

In the lower-left corner of VS Code:

```text
Accounts → Sign In
```

Select:

```text
Sign in with GitHub
```

A browser window will open.

Authorize VS Code to access GitHub.

After authentication, you should see your GitHub account in VS Code.

---

# 4. Create and Add an SSH Key

VS Code can help manage GitHub authentication, but SSH remains the preferred method.

## Open SSH Key Generator

Open:

```text
Ctrl+Shift+P
```

Search:

```text
GitHub: Create SSH Key
```

Select it.

---

## Generate New Key

Choose:

```text
Generate New SSH Key
```

Select:

```text
ED25519
```

Use your GitHub email address when prompted.

Example:

```text
your-email@example.com
```

---

## Save the Key

Accept the default location:

```text
~/.ssh/id_ed25519
```

Optionally create a passphrase.

---

## Add SSH Key to GitHub

VS Code will usually offer:

```text
Add SSH Key to GitHub
```

Select:

```text
Yes
```

VS Code uploads the public key directly to GitHub.

No manual copy/paste required.

---

# 5. Verify GitHub Connection

Open:

```text
Source Control
```

or press:

```text
Ctrl+Shift+G
```

If no authentication warnings appear, GitHub and VS Code are connected successfully.

---

# 6. Create Your First Repository

## Option A: Create Directly in VS Code

Open:

```text
Source Control
```

Select:

```text
Publish to GitHub
```

Choose:

```text
Publish to GitHub Public Repository
```

or

```text
Publish to GitHub Private Repository
```

Enter repository name:

```text
hello-github
```

VS Code automatically:

* Creates repository
* Initializes Git
* Creates remote repository
* Connects GitHub

---

## Option B: Create on GitHub Website

Go to:

[GitHub Repository Creation](https://github.com/new)

Create:

```text
hello-github
```

Then return to VS Code to clone it.

---

# 7. Clone a Repository

## Open Command Palette

```text
Ctrl+Shift+P
```

Search:

```text
Git: Clone
```

Select:

```text
Git: Clone
```

---

## Choose Repository

VS Code displays repositories associated with your GitHub account.

Select:

```text
hello-github
```

Choose a local folder.

Example:

```text
Documents\Projects
```

---

## Open Repository

When prompted:

```text
Open Repository
```

Click:

```text
Open
```

---

# 8. Make Your First Change

Inside VS Code:

Create:

```text
README.md
```

Example contents:

```markdown
# Hello GitHub

My first GitHub repository.
```

Save the file.

---

# 9. Commit Changes

Open:

```text
Source Control
```

You will see:

```text
README.md
```

under:

```text
Changes
```

---

## Stage Changes

Click:

```text
+
```

next to the file.

Or:

```text
Stage All Changes
```

---

## Commit

Enter commit message:

```text
Initial commit
```

Click:

```text
Commit
```

or use:

```text
Ctrl+Enter
```

---

# 10. Push Changes to GitHub

After committing:

Click:

```text
Sync Changes
```

or:

```text
Push
```

VS Code uploads your commit to GitHub automatically.

Refresh GitHub in your browser.

Your files should now appear.

---

# 11. Daily Workflow

Most development work follows:

```text
Open Repository
↓
Pull Latest Changes
↓
Edit Files
↓
Review Changes
↓
Commit
↓
Push
```

---

## Pull Changes

Bottom-left sync icon:

```text
Sync Changes
```

or:

```text
Source Control → Pull
```

---

## Review Differences

Click any modified file.

VS Code displays:

```text
Current Version
vs
Previous Version
```

side-by-side.

This is one of the most useful Git features.

---

# 12. Recommended Extensions

## Essential

| Extension                       | Purpose                 |
| ------------------------------- | ----------------------- |
| GitHub Pull Requests and Issues | GitHub Integration      |
| GitLens                         | Commit History          |
| Markdown All in One             | Documentation           |
| Error Lens                      | Better Error Visibility |

---

## Home Lab / Engineering

| Extension  | Purpose                |
| ---------- | ---------------------- |
| Docker     | Docker Integration     |
| YAML       | Compose Files          |
| Remote SSH | Manage Linux Servers   |
| Ansible    | Playbooks              |
| Terraform  | Infrastructure as Code |

---

## AI Development

| Extension      | Purpose                   |
| -------------- | ------------------------- |
| Continue       | Local AI Coding Assistant |
| Ollama         | Local LLM Integration     |
| GitHub Copilot | AI Assistance             |

---

# 13. Best Practices

## Use One Repository Per Project

Good:

```text
docker-homelab
ubuntu-dotfiles
ansible-lab
local-ai-lab
```

Avoid:

```text
everything-project
```

---

## Commit Frequently

Good:

```text
Add Docker Compose stack
```

```text
Configure monitoring service
```

```text
Add Ubuntu bootstrap script
```

Avoid:

```text
stuff
```

```text
changes
```

---

## Create README Files

Every repository should explain:

```text
Purpose
Requirements
Installation
Usage
License
```

---

## Never Upload Secrets

Never commit:

```text
.env
private keys
API keys
passwords
certificates
```

Add them to:

```text
.gitignore
```

---

# The Simplified VS Code Workflow

```text
1. Sign into GitHub
2. Generate SSH Key
3. Publish Repository
4. Edit Files
5. Commit
6. Sync Changes
7. Repeat
```

For most day-to-day work, you can spend 95% of your time inside VS Code and rarely need to touch the command line.
