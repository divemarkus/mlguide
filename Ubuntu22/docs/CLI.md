
# Command-Line 

## Git

Here are the **very basic steps** to create a local Git repository and push it to a brand-new GitHub repository.

> ⚠️ Prerequisites:
> *   Git installed: `git --version` (if not, install from [git-scm.com](https://git-scm.com/))
> *   A GitHub account
> *   A new, **empty** repository created on GitHub (don’t initialize with README, LICENSE, or `.gitignore` if you want to push your local files without conflicts).

---

### 🛠️ Basic Steps

#### 1. Create a folder and navigate into it
```bash
mkdir my-new-project
cd my-new-project
```

#### 2. Initialize a Git repository locally
```bash
git init
```
*(This creates the hidden `.git` folder — your repo is now ready to track changes.)*

#### 3. Add your files (e.g., `index.html`, `script.js`)
You can copy existing files into this folder, or create new ones:
```bash
echo "# My New Project" > README.md
```

#### 4. Stage and commit your files
```bash
git add .               # Adds all files in the folder
git commit -m "Initial commit"  # Saves a snapshot with a message
```

#### 5. Create the remote repository on GitHub
*   Go to [github.com](https://github.com/new)
*   Name your repo (e.g., `my-new-project`)
*   Keep it **Private or Public** as you like.
*   **DO NOT** check "Add README", "License", or ".gitignore" (unless you want to merge them later).
*   Click **Create repository**

#### 6. Connect your local repo to GitHub
Copy the commands from the GitHub page under *"…or push an existing repository from the command line"* and run them:

```bash
# Example command (replace 'your-username' and 'repo-name')
git remote add origin https://github.com/your-username/my-new-project.git

# Push your code to GitHub (set upstream branch for future pushes)
git branch -M main          # Renames current branch to 'main' (if it's not already)
git push -u origin main     # Pushes local commits to GitHub
```

✅ **Done!** Your local project is now connected and pushed to GitHub.

---

### ✅ Quick Cheatsheet
| Action | Command |
|--------|---------|
| Initialize repo | `git init` |
| Add all files | `git add .` |
| Save changes | `git commit -m "message"` |
| Add remote origin | `git remote add origin https://github.com/...` |
| Push to GitHub | `git push -u origin main` |

---

## Docker
- Most of our apps are containerized. Follow this in order to execute or call them from cli or terminal

## Ollama
- 

## OpenCode
-  

#### Overview
Gemini CLI and Anthropic Claude are powerful command-line interfaces (CLIs) designed to interact with AI models. These tools enable users to run AI models locally or via cloud APIs, offering flexibility in how they integrate AI capabilities into their projects.

- **Gemini CLI**: Developed by Google DeepSpeed, Gemini CLI allows users to execute Gemini models locally or through the cloud, supporting various model sizes for diverse tasks.
- **Claude**: Anthropic's Claude provides a CLI for accessing Claude AI models, which can be used locally or via API, enabling text generation and other NLP tasks.

#### Integration into Open Web UI
These tools can be seamlessly integrated into your project to enhance functionality. For instance, Gemini CLI can process images for analysis, while Claude can generate text content based on user prompts. Combining these tools allows you to leverage their respective strengths in different tasks.

#### Use Cases

1. **Image Analysis**
   - Utilize Gemini CLI to analyze images and generate descriptive outputs within Open Web UI.
   
2. **Text Generation**
   - Use Claude for generating text content, such as creating articles or responding to user queries through Open Web UI.

3. **Combined Workflows**
   - Integrate both tools to create comprehensive workflows, where Gemini handles image analysis and Claude generates contextual explanations based on the results.

#### Dependencies and Prerequisites

- **Gemini CLI**: Install via `pip install gemini-cli` or download from Google DeepSpeed.
- **Claude**: Install via `pip install claude`, and set up an API key through Anthropic's dashboard.

By incorporating these tools, you can enhance your project's AI capabilities, offering users a versatile and powerful interface for diverse tasks.
