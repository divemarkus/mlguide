# Space Invaders - Cloned - Modernized - Local Coding Agent

- Macbook Pro M1 32GB + Ollama + ClaudeCode + qwen3.5:35b-a3b-coding-nvfp4
- Runtime: 15 mins code update + 5 mins push to new github repo
- [Original write-up on local AI](../../03-the-agent/claudecode/README.md)

## Executive summary

Your `divemarkus/space_invaders` repo is, at the moment, **essentially a packaging/build modernization of the Grieverheart project rather than a new game implementation**.

The most important finding is concrete: **your `main.cpp` is byte-for-byte the same source blob as Grieverheart's `main.cpp`** — both resolve to SHA `a9007695fa0dbc502f6280981c806132976bd720`. In other words, the actual game code has not yet been changed.

What you *have* done is put a more modern development wrapper around that code:

| Area | Grieverheart | divemarkus | What changed |
|---|---|---|---|
| Game code | `main.cpp` | `main.cpp` | **No change** |
| Language standard | C++11 | **C++17** | Modernized |
| Build system | `make.sh` + raw `g++` | **CMake + build.sh** | Major improvement |
| Dependency discovery | Manual linker flags | `find_package()` | More portable |
| macOS | Explicit OpenGL framework | CMake Apple handling | Cleaner |
| Linux | Not in README build instructions | **Documented** | Expanded platform support |
| Compiler warnings | `-Wall` | `-Wall -Wextra -Wpedantic -Wconversion` | Stronger diagnostics |
| Formatting | None | **`.clang-format`** | Added |
| Build output | `./main` | `build/bin/space_invaders` | Cleaner |
| Git hygiene | Basic | CMake artifacts added | Improved |
| Documentation | Minimal Mac instructions | Mac + Linux + controls | Improved |
| Binary | Source only | A compiled binary was committed | Added artifact |

### Bottom line

I'd characterize the current state as:

> **Grieverheart Space Invaders → your modernized build/development shell**

rather than:

> **Your own Space Invaders implementation**

That's not a criticism — it's actually a good first step.

---

# What happened in your repo

Your latest commit is:

```text
47e97cbc
Initialize Space Invaders game project
2026-09-27
```

That commit added **103 lines and deleted 7**, but the changes were almost entirely project infrastructure.

The commit explicitly shows:

- `.clang-format` added
- `CMakeLists.txt` added
- `build.sh` added
- `.gitignore` updated
- `README.md` rewritten
- `main.cpp` unchanged
- compiled `build/bin/space_invaders` added

So the repository is basically a **repackaged version of the original project**.

---

# The biggest improvement: CMake

This is the strongest engineering change you've made.

Grieverheart's build script is:

```bash
g++ -Wall -std=c++11 -O0 -g -o main -lglfw -lglew -framework OpenGL main.cpp
```

Your repo now has:

```cmake
cmake_minimum_required(VERSION 3.16)

project(space_invaders
    VERSION 1.0.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
```

and:

```cmake
find_package(glfw3 REQUIRED)
find_package(GLEW REQUIRED)
find_package(OpenGL REQUIRED)
```

That is a substantially more maintainable foundation.

You've also added explicit compiler warnings:

```text
-Wall
-Wextra
-Wpedantic
-Wconversion
-Wno-sign-conversion
```

and an Apple-specific OpenGL framework linkage.

That means your repository is now much closer to a **proper C++ project** than the original single-file tutorial project.

---

# Build process is much better

Original:

```text
brew install glfw
./make.sh
./main
```

Yours:

```text
brew install glfw glew
./build.sh
build/
└── bin/
    └── space_invaders
```

And your build script automatically selects:

```bash
Release
```

unless you specify another configuration.

For example:

```bash
./build.sh Debug
```

That's a useful foundation for eventually having:

```text
Debug
Release
ASAN
UBSAN
```

build configurations.

---

# macOS support is more complete

The original README only documented GLFW installation:

```bash
brew install glfw
```

Your README correctly documents:

```bash
brew install glfw glew
```

and the CMake project explicitly handles macOS OpenGL:

```cmake
if(APPLE)
    target_link_libraries(space_invaders PRIVATE "-framework OpenGL")
endif()
```

That is an important improvement for your M1 Mac workflow.

---

# Linux support was added

Your README now includes Ubuntu/Debian:

```bash
sudo apt install libglfw3-dev libglew-dev cmake g++
./build.sh
```

The original project had a Linux build issue documented in its GitHub issues; the original `make.sh` was specifically Mac-oriented. 

Your CMake configuration consequently gives you a much cleaner path toward:

```text
macOS
Linux
Windows
```

although Windows hasn't yet been fully documented or tested in your repository.

---

# Code formatting was added

You introduced:

```text
.clang-format
```

with:

```yaml
Language: Cpp
BasedOnStyle: LLVM
IndentWidth: 4
ColumnLimit: 100
BreakBeforeBraces: allman
```

That's another sign that you're turning this from a tutorial artifact into an actual development project.

---

# But the game itself is unchanged

This is the key distinction.

The underlying game still has the original architecture:

```text
224 × 256 framebuffer
        ↓
pixel sprites
        ↓
CPU rendering
        ↓
OpenGL texture
        ↓
GLFW window
```

It still has the original:

- 55 aliens
- 3 alien types
- 2-frame animations
- player
- bullets
- alien bullets
- bullet-vs-bullet collisions
- score
- lives
- game-over state
- alien respawn
- speed changes
- pixel-font rendering

All of that is inherited from Grieverheart's `main.cpp`.

The original project's commit history shows the game evolving feature-by-feature: alien movement, bullet animation, score, bullet collisions, game over, alien bullets, speed changes, and respawning. 

---

# There's also an important repository-history detail

Your repo wasn't created entirely from scratch.

GitHub shows historical commits dating back to **2018**, including the original project's commit history, followed by your 2026 initialization commit.

So your repository currently appears to be effectively:

```text
Grieverheart historical repository
             │
             ├── original commits
             │
             └── 2026 divemarkus initialization
                       │
                       ├── CMake
                       ├── build.sh
                       ├── clang-format
                       ├── README modernization
                       └── compiled binary
```

That's useful because you've preserved the history rather than simply downloading a ZIP and starting over.

---

# One thing I would change immediately

You currently have:

```text
build/bin/space_invaders
```

committed into Git.

I would **remove the compiled binary from the repository**.

Your `.gitignore` ignores some CMake artifacts, but it doesn't currently ignore the entire `build/` directory.

I'd change it to:

```gitignore
# Build output
build/

# Legacy executable
main
main.dSYM

# Editor / OS
*.swp
.DS_Store
```

That keeps Git focused on source and project configuration.

For a source repository, I'd generally avoid storing generated executables unless you're intentionally creating releases.

---

# Where I think this project should go next

This gets especially interesting given what you've been doing with local LLM coding models.

I would make the project evolve in **four stages**.

### Stage 1 — Preserve the original

```text
main.cpp
```

Leave it untouched as your reference baseline.

Tag it:

```text
v0.1-original
```

That gives you an exact historical reference.

### Stage 2 — Refactor without changing gameplay

Break:

```text
main.cpp
```

into:

```text
src/
├── main.cpp
├── game.cpp
├── renderer.cpp
├── input.cpp
├── sprites.cpp
└── collision.cpp
```

The objective:

> Same game, cleaner architecture.

This is an excellent task for Qwen Coder / Claude Code / Codex.

### Stage 3 — Modernize the engine

Move from:

```text
C++17
```

to:

```text
C++20
```

and replace manual memory management such as:

```cpp
new
delete
```

with:

```cpp
std::vector
std::array
std::unique_ptr
```

where appropriate.

### Stage 4 — Make it **your** game

Then start adding things the original never had:

```text
Sound
Menus
Settings
High scores
Pause
Multiple levels
Boss waves
Power-ups
Shields
Particles
Gamepad
Mouse
Modern resolution scaling
```

At that point you'll have a genuinely independent implementation rather than simply a repackaged tutorial.

---

# This is also a fantastic local-LLM benchmark

This project is almost ideal for your ML experimentation because it's:

- small
- deterministic
- visually verifiable
- C++
- graphics
- state management
- algorithms
- refactoring
- build systems

You could establish a benchmark like:

```text
Task 001
Explain main.cpp

Task 002
Refactor Player

Task 003
Extract Renderer

Task 004
Convert raw arrays → std::array

Task 005
Add gamepad support

Task 006
Add sound

Task 007
Add unit tests

Task 008
Add CMake install target

Task 009
Add GitHub Actions

Task 010
Port to SDL3
```

Then test the same tasks with:

```text
Qwen3-Coder-Next
Qwen
Claude
GPT
Codex
```

That turns this little Space Invaders project into a **repeatable AI coding-agent benchmark**, which fits very nicely with the local-first development work you're documenting in your ML guide. :chatgpt-content-reference{index="2"}

## Executive assessment of your current repo

I'd document its current state as:

```text
PROJECT STATUS

Game engine:
    ✅ Functional inherited implementation

Rendering:
    ✅ OpenGL 3 / pixel framebuffer

Platform:
    ✅ macOS
    ✅ Linux documented
    ⚠️ Windows not yet validated

Build:
    ✅ CMake
    ✅ C++17
    ✅ Release/Debug build script

Code quality:
    ✅ Compiler warnings
    ✅ clang-format
    ⚠️ Monolithic main.cpp

Testing:
    ❌ No automated tests

CI/CD:
    ❌ None

Packaging:
    ⚠️ Binary currently committed

Originality:
    ⚠️ Game implementation currently identical to upstream

Documentation:
    ✅ Improved substantially

Next logical milestone:
    → Refactor main.cpp into a maintainable engine
```

So, **you've done the right first engineering move**: you took an old tutorial-style C++ project and gave it a modern, reproducible build environment. The next meaningful step is no longer build infrastructure — it's **owning the code architecture and then changing the game itself**.

[Your Space Invaders repository](https://github.com/divemarkus/space_invaders)  
[Original Grieverheart repository](https://github.com/Grieverheart/space_invaders)