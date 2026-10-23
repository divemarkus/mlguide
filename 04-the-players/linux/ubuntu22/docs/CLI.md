
# Command-Line

Quick CLI recipes and examples used across this repo: Git, Docker, Ollama, and OpenCode workflows.

## Table of Contents
1. [Git Quickstart](#git)  
2. [Docker Notes](#docker)  
3. [Ollama](#ollama)  
4. [OpenCode / CLIs](#opencode)

---

## 🧰 Git Quickstart
Very basic steps to create a local Git repository and push to a new GitHub repository.

> Prerequisites: Git installed, a GitHub account, and an empty remote repo.

### Steps
1. Create a folder and navigate into it:
```bash
mkdir my-new-project
cd my-new-project
```

2. Initialize a Git repo:
```bash
git init
```

3. Add files and commit:
```bash
echo "# My New Project" > README.md
git add .
git commit -m "Initial commit"
```

4. Create remote on GitHub and connect (use commands provided by GitHub):
```bash
git remote add origin https://github.com/your-username/my-new-project.git
git branch -M main
git push -u origin main
```

### ✅ Cheatsheet
| Action | Command |
|--------|---------|
| Initialize repo | `git init` |
| Add all files | `git add .` |
| Save changes | `git commit -m "message"` |
| Add remote origin | `git remote add origin https://github.com/...` |
| Push to GitHub | `git push -u origin main` |

---

## 🐳 Docker
Most apps in this repo are containerized; use `docker` or `docker compose` to run services and examples. Add project-specific commands near their docs.

---

## 🐋 Ollama
Short notes and pointers for CLI-first model runs. See `ollama-setup.md` for a compact install guide.

---

## 🔧 OpenCode / CLI Tools
Overview: Gemini CLI and Anthropic Claude are example CLIs used to interact with AI models. They can be integrated into Open Web UI or custom pipelines for image analysis and text generation.

### Use Cases
1. Image analysis via Gemini CLI.  
2. Text generation via Claude.  
3. Combined workflows using both tools.

### Dependencies
- Gemini CLI: `pip install gemini-cli`  
- Claude: `pip install claude` and set an API key

---

Expand each section with more platform-specific commands where needed.
