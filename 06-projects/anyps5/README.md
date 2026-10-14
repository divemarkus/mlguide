# AnyPS5: AI-Assisted PS5 Game Porting to Windows and Linux

![AnyPS5 loads a PS5 game menu before a crash](https://images.openai.com/static-rsc-4/tz1ToYvrYOwWuIXb3ZNjhVnnFEDwQ1QNXrpB6jKxBEjPUGhDuW3ay98MCHB3ySmh8kuFC0StNbIySaQcmxxgQM2N9eynKc0F-B_xWL9EahY1WX9oxT7fc5GZPGQKbZky12qTuI_hfTN8U9p2bgof6P-8WaaWwHOXf65_IGweN_o?purpose=inline)

*Image: [WindowsForum](https://windowsforum.com/news/anyps5-loads-ps5-game-menu-but-crashes-before-play-begins.445786/)*

This is a genuinely interesting development in game preservation and compatibility engineering. [AnyPS5](https://github.com/boykopovar/AnyPS5) takes a different approach from traditional console emulation: it attempts to convert PS5 game executables into native Linux or Windows executables, rather than running games inside a conventional emulated PS5 environment.

When checked on October 14, 2026, the public repository showed approximately 35,900 stars, 3,100 forks, and active development. Those numbers measure interest, not compatibility or the number of games that run successfully. The important question is whether actual games run correctly, with working graphics, audio, input, saves, and stable performance. That's where community game-by-game test reports matter.

## 1. What AnyPS5 Actually Does

### Step 1: Start with the PS5 game

The project expects an extracted PS5 game executable (ELF), its modules, and associated game resources. It does not extract or decrypt retail PS5 games for you.

### Step 2: Relink the executable

AnyPS5 converts the executable to the host format: Linux ELF or Windows PE. It also supplies replacement implementations for PS5 system libraries that the game imports.

### Step 3: Translate graphics

PS5 games use Sony's proprietary AGC graphics interface and AMD-specific GPU instructions. AnyPS5 reimplements graphics behavior and translates shader programs to SPIR-V for execution through Vulkan.

### Step 4: Run and debug the game

The result is a native host executable, but compatibility depends on missing system functions, graphics behavior, memory management, audio, and other services being implemented correctly.

*Technical basis: [AnyPS5 README](https://github.com/boykopovar/AnyPS5) and [Tom's Hardware technical analysis](https://www.tomshardware.com/video-games/playstation/anyps5-reaches-critical-gpu-milestone-in-race-to-enable-running-ps5-games-natively-on-pc).* 

### Why This Is Different from Emulation

| Approach | How it works |
| --- | --- |
| Conventional emulation | Recreates enough of the console's hardware and software environment to run its programs. |
| AnyPS5 | Relinks the original executable for the host and reimplements the necessary console interfaces. |
| Traditional PC port | The developer adapts source code to the PC platform. AnyPS5 does not require the original source code. |

Calling this native porting is reasonable, although the graphics and system compatibility layers still translate and reproduce console-specific behavior. It is not simply recompiling a game.

## 2. The Development Milestone: Impressive, but Easy to Misread

[Tom's Hardware reported on October 10, 2026](https://www.tomshardware.com/video-games/playstation/anyps5-reaches-critical-gpu-milestone-in-race-to-enable-running-ps5-games-natively-on-pc-still-far-off) that AnyPS5 had reached 100% decoder coverage for its tracked set of 1,166 AMD RDNA 1 and RDNA 2 shader instructions. That is an important graphics-reverse-engineering milestone, not proof that the GPU is fully supported.

There are three separate layers of progress:

| Layer | What it means |
| --- | --- |
| **Instruction recognition: 100%** | The tracked instruction set is recognized by the decoder. Recognition does not guarantee correct execution. |
| **System library coverage** | The project implements a growing set of PS5 library functions. Each function may have incomplete behavior or remain a stub; the tracked percentage is not coverage of every function in PS5 firmware. |
| **Actual game compatibility** | A game must get past initialization and render correctly, then sustain gameplay with working input, sound, and memory behavior. This is the real end-user test. |

One telling example from the technical reporting: the project's HTTP library implementation percentage does not mean games can successfully make real network requests. Coverage percentages need to be read alongside the functionality behind them.

## 3. Actual PC Testing: Which Games Work?

The best source is the community's individual [game bring-up reports on GitHub](https://github.com/boykopovar/AnyPS5/discussions/categories/game-bring-up), cross-checked against the project's [compatibility directory](https://anyps5.org/compatibility/). These are actual developer and community tests, not merely theoretical compatibility claims.

### Games with Meaningful Gameplay Evidence

| Game | Platform / test hardware | What testers reported | Assessment |
| --- | --- | --- | --- |
| Dreaming Sarah | Windows; GTX 1050 Ti and Intel i5-7500 in the project's verified baseline | Stable 60 FPS; reaches gameplay | Playable |
| Dead Cells | Windows; Ryzen 7 5800X3D, RTX 5070 Ti | Menu through gameplay, music and effects, keyboard/mouse and gamepad. Reported approximately 55–60 FPS indoors and 30–35 FPS outdoors at 4K. | Playable report |
| Animal Well | Windows, experimental build | Gameplay reported with audio fixes; community tracker reports approximately 60 FPS | Experimental |
| Balatro | Windows, experimental build | Menus and card gameplay with audio | Experimental |
| DOOM | Linux and Windows | Launcher and level gameplay; movement, aiming and shooting. More recent reports include audio and save/load work on patched builds. | Experimental |
| PAC-MAN WORLD Re-PAC | Experimental build | A community bring-up report describes the game booting and playing with audio. | Needs further validation |

Sources: [project's verified baseline](https://github.com/boykopovar/AnyPS5), [Dead Cells tester's report and gameplay video](https://www.reddit.com/r/digitalfoundry/comments/1wr7ie1/worlds_first_fully_native_ps5_game_running_on/), [community compatibility directory](https://anyps5.org/compatibility/), and [game-testing discussions](https://github.com/boykopovar/AnyPS5/discussions/categories/game-bring-up).

Dead Cells is an especially compelling demonstration because the report goes beyond a title screen: it describes actual gameplay, audio, and working controls with a stated PC configuration. But it is an individual community test of a particular PS5 game version, not a guarantee that every release or DLC combination works.

### Major Titles: Genuine Progress, but Not Yet Reliable PC Ports

![Astro Bot](https://images.openai.com/static-rsc-4/phiF536Vj_xOYeTxJHkZnrwqP0yjZSlZW87NKsLzjXyE7nRHbAiTyLajR5bfQJvCgO_OadpMBzSnuas3I2AcHueP3KaUepyoNyvBJGtThJFE8R4GhnMTqlmaLTmPiu997aemSw5X08eoOQN_urtW92iSsG0g2c38mZJH6HUMeDE?purpose=inline)

**Astro Bot: Gameplay with freezes.** Windows testers reached gameplay but reported freezes and instability. Linux reports describe some tutorial/Sky Garden progress, along with startup assertions and other blockers. This is not yet a reliably playable replacement for the PS5 version. [Community compatibility reports](https://anyps5.org/compatibility/).

![Demon's Souls](https://images.openai.com/static-rsc-4/7od7LN_uJp49r1RuVPQLJ8JVbf7oGqpNuCkEzQhGdk63lHnuKLZvaFVw5jYb7yTc3eS8HPZSdX17K1-EMcyDfKRH6sbd6vZmJDIXWCOozlRQiM1Gc-MaakzheM_KloIhKmPq-IaMYj-ydJZTHumJChS2bLgS55d-pdbQZfTUG4w?purpose=inline)

**Demon's Souls: Rendering issues.** The community has reached tutorial gameplay on Linux, but incorrect 3D rendering remains a reported issue. Reaching a scene is not equivalent to obtaining a visually correct and playable experience. [Community compatibility reports](https://anyps5.org/compatibility/).

**Grand Theft Auto V: Limited gameplay.** The compatibility tracker records North Yankton prologue gameplay on an older experimental branch. That is meaningful evidence, but it does not establish stable open-world play, long-session reliability, or compatibility with the current build. [Community compatibility reports](https://anyps5.org/compatibility/).

**God of War: Sons of Sparta: Experimental gameplay.** Reports describe gameplay and the first checkpoint on a fork, and several levels after a graphics fix on Linux. Other tests still hit black frames, and the findings do not establish a stable upstream build. [Community compatibility reports](https://anyps5.org/compatibility/).

![Ratchet & Clank: Rift Apart](https://images.openai.com/static-rsc-4/LiKplfJ3rCjsL2zJGY1BqCgeol9GsrqJ-4HmuOljITZRutDKDtNRZ6VTrraTgdOShQckoKJGJOUspsoAHLBzBkeUm8IOarpAj_XqcPDLm12nvGHPPnt99OSPN7qnEkXwccp68Y8Ipht3EQSIEsYvXkXL4Z5R9OztNpZJalcjU4s?purpose=inline)

**Ratchet & Clank: Rift Apart: Not reliably playable.** Linux reports describe initial splash frames followed by prolonged black screens, GPU/CPU synchronization stalls, and deadlocks. This illustrates why graphics instruction coverage alone does not solve the full problem. [Community compatibility reports](https://anyps5.org/compatibility/).

**Ghost of Yōtei: Early bring-up.** The reviewed Windows result describes a first frame being submitted but no frame presented. That is a much earlier stage than gameplay. [Community compatibility reports](https://anyps5.org/compatibility/).

These reports are snapshots of particular builds, patches, and hardware configurations. Community test results can improve quickly, and experimental branches may behave differently from the current main branch.

### More Noteworthy Tests: A First Mission Completed and Several Areas Explored

These tests show how quickly the project is progressing, but also how much manual engineering sometimes remains necessary:

- **STAR WARS: Dark Forces Remaster, Windows:** A tester completed the first mission using keyboard and mouse after making two local startup fixes. Intro video, menus, mission selection, and gameplay worked. The report describes a patched build, with no validation of later missions, save/load, or long-session stability. Pressing Tab caused severe frame-rate drops, and opening the PDA caused instability. [Read the full test report](https://github.com/boykopovar/AnyPS5/discussions/4310).
- **Silt, Windows:** A tester on a Radeon RX 5700 XT reported playing through several areas with sound at approximately 44–52 FPS after four local code changes. Antialiasing was disabled, and a rendering artifact remained. [Read the test report](https://github.com/boykopovar/AnyPS5/discussions/2810).
- **Wobbly Life, Linux:** On an i5-12400 and RTX 3060 Ti, the game booted into streaming arcade content and rendered, but a managed `System.FormatException` terminated runs after roughly 60–90 seconds. The issue remained under investigation. [Read the test report](https://github.com/boykopovar/AnyPS5/discussions/2211).
- **NHL 27, Windows:** A test on an AMD RX 6700 XT reached match loading but reported only about 1.3 FPS. Reaching a loading state is progress, but that performance is not practically playable. [Find the report in the project's test discussions](https://github.com/boykopovar/AnyPS5/discussions/categories/game-bring-up).

These examples are particularly useful because they document real configurations, specific blockers, and sometimes the source-code patches required, not simply a screenshot of a game logo.

## 4. Where Does Agentic Coding Fit In?

AnyPS5 is a compelling example of a project where AI-assisted engineering can accelerate work that would traditionally require a large, specialized systems-programming team. The evidence is more nuanced than saying AI built the emulator, though.

### The Agentic Engineering Loop

1. **Identify a compatibility failure.** A game crashes, hangs, renders incorrectly, or calls an unsupported function.
2. **Use an AI coding agent.** Inspect C++ code, analyze logs, trace call paths, propose fixes, and write regression tests.
3. **Compile and test.** Build the compatibility layer, rerun the game, capture errors, and compare behavior.
4. **Iterate and validate.** Refine the implementation, run regression tests, and verify actual gameplay on hardware.

This is where coding agents can change the economics of reverse engineering. Rather than having a developer manually investigate every failure and write every implementation, an agent can help explore hypotheses, make targeted changes, generate tests, and interpret results.

### We Have Direct Evidence of AI Involvement

The project's recent engineering discussions explicitly identify AI-assisted work:

| Example | Evidence |
| --- | --- |
| STAR WARS: Dark Forces Remaster | The tester identifies Codex as assisting with the investigation and fixes; manual gameplay testing followed. |
| Silt | The bring-up report identifies Claude as assisting with the investigation and patching. |
| Project-wide | Tom's Hardware reported more than 100 human contributors, alongside AI assistance from Claude and potentially other coding assistants. |

Sources: [Dark Forces Remaster test](https://github.com/boykopovar/AnyPS5/discussions/4310), [Silt test](https://github.com/boykopovar/AnyPS5/discussions/2810), and [Tom's Hardware analysis](https://www.tomshardware.com/video-games/playstation/anyps5-reaches-critical-gpu-milestone-in-race-to-enable-running-ps5-games-natively-on-pc-still-far-off).

These sources demonstrate AI-assisted engineering, but they do not establish that autonomous agents independently produced the whole project. Much of the work still requires human investigation, platform knowledge, hardware testing, and engineering judgment.

## 5. What Hardware Does It Need?

The project targets x86-64 Windows and Linux PCs. Its performance depends heavily on the game, GPU driver, memory allocation, and how well the compatibility layers support the title.

For your systems, I would prioritize the Ryzen 9 9900X3D workstation with RTX 3090 Ti:

| Your hardware | Suitability | Notes |
| --- | --- | --- |
| Ryzen 9 9900X3D + RTX 3090 Ti + 96 GB RAM | Best first test system | Strong CPU, ample system RAM, and 24 GB of GPU VRAM. |
| Lenovo Legion Go 2 | Secondary experiment | Its lower power budget and integrated GPU make demanding 3D titles less attractive; test only after confirming the project's current requirements. |
| M4 Max MacBook Pro, 36 GB unified memory | Not a first choice | The project targets Windows/Linux x86-64; macOS and Apple Silicon are not documented primary targets. |
| Ubuntu server with RTX 3070 Ti | Potential Linux test host | The 8 GB VRAM configuration is more constrained, and the server CPU is substantially older. |

The recommendation for your RTX 3090 Ti is based on hardware characteristics, not a verified AnyPS5 performance benchmark for that GPU. The project has reported GPU-specific issues, so more VRAM alone does not guarantee a successful run.

Another consideration is memory commitment. Tom's Hardware noted that some Windows game allocations can request as much as 13.5 GB of direct memory, charged against the system commit limit. This does not mean every title needs 13.5 GB of free physical RAM, but it makes an adequately sized page file and sufficient commit headroom important. [Tom's Hardware technical analysis](https://www.tomshardware.com/video-games/playstation/anyps5-reaches-critical-gpu-milestone-in-race-to-enable-running-ps5-games-natively-on-pc-still-far-off).

## 6. Is This the Beginning of PS5 Games Becoming Freely Playable on PC?

Potentially, but I would distinguish two outcomes:

### Likely Long-Term Direction: Individual Native Ports

AnyPS5 could make it increasingly practical to run selected console game versions directly on PCs, without waiting for their original developers to release Windows ports. Smaller or less demanding titles may be easier initial targets.

### Much Harder: Universal Compatibility

A universal, plug-and-play solution must handle the enormous variety of graphics behavior, system services, audio, memory semantics, and synchronization used by different games. Every newly supported game can expose additional missing functionality.

There is also an important practical caveat: AnyPS5 does not provide a shortcut from a retail PS5 disc to a working desktop game. The documented process expects game files that have already been extracted into the required format. The project does not distribute copyrighted game files or proprietary Sony libraries. Users are responsible for obtaining and using their own game data lawfully. [AnyPS5 repository](https://github.com/boykopovar/AnyPS5).

## My Verdict

AnyPS5 is worth following closely. The achievement is not that every PS5 game now works on a PC. It is that an open-source project is building the infrastructure needed to port existing PS5 executables to ordinary computer operating systems, with real games already reaching gameplay.

The combination of reverse engineering, a growing compatibility layer, GPU shader translation, and AI-assisted debugging is what makes this especially interesting. The next major milestone is not another percentage on a progress dashboard; it is a broader set of games that can be completed, with correct rendering, sound, input, saves, and stable performance, on reproducible builds.

For your RTX 3090 Ti workstation, I would start by testing Dead Cells, Dreaming Sarah, or another title with a documented PC configuration, then move to experimental 3D titles once the basic workflow is established.

## References

- [AnyPS5 GitHub repository](https://github.com/boykopovar/AnyPS5)
- [AnyPS5 community game-testing discussions](https://github.com/boykopovar/AnyPS5/discussions/categories/game-bring-up)
- [AnyPS5 compatibility directory](https://anyps5.org/compatibility/)
- [Tom's Hardware: GPU milestone and technical limitations](https://www.tomshardware.com/video-games/playstation/anyps5-reaches-critical-gpu-milestone-in-race-to-enable-running-ps5-games-natively-on-pc-still-far-off)
- [Dead Cells community demonstration and reported PC performance](https://www.reddit.com/r/digitalfoundry/comments/1wr7ie1/worlds_first_fully_native_ps5_game_running_on/)
- [Dark Forces Remaster Windows bring-up report](https://github.com/boykopovar/AnyPS5/discussions/4310)
- [Silt bring-up report](https://github.com/boykopovar/AnyPS5/discussions/2810)