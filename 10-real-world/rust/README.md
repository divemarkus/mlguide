
# Rust, AI coding, and the future of software development

Rust is exceptionally well suited to building fast, reliable software, and AI coding agents make it easier to use than it used to be. But there are two separate questions: whether AI can write Rust effectively, and whether Rust is the best language for a particular application. Those aren't the same thing.

The ArtCraft project we were discussing is an interesting example: an AI-assisted developer is using Rust to build desktop alternatives to parts of Adobe's creative software ecosystem. The important innovation isn't simply that AI can write Rust—it's that AI can help one developer tackle a much larger software project.

## 1. Why is Rust attractive to AI and human developers?

Rust has a distinctive combination of performance, memory safety, and compiler-enforced rules.

Memory safety without a garbage collector

Rust prevents many common memory errors—including use-after-free and data races—through its ownership and borrowing rules. Unlike languages such as Java or Python, it doesn't require a garbage collector to manage ordinary memory.

Native performance

Rust compiles to native machine code and is suitable for CPU-intensive applications: image processing, video pipelines, file handling, graphics, and systems software. Performance can be comparable to C or C++ when the implementation and workload are comparable.

A compiler that catches mistakes

Rust's type system, compiler diagnostics, and tests give a coding agent feedback it can use to correct its work. The agent can compile, inspect errors, change the code, and repeat.

A strong foundation for distributable software

Rust supports native applications across major desktop operating systems. It can also compile to WebAssembly for supported browser-based workloads. That makes it useful for cross-platform tools without requiring an entire application to run inside an Electron-style web runtime.

### Why this helps AI coding agents

An AI coding agent can produce plausible code in almost any popular language. The challenge is getting that code to work reliably.

Rust gives the agent a useful feedback loop:

1. Generate an implementation.
2. Run the compiler.
3. Examine type, ownership, and trait errors.
4. Correct the implementation.
5. Run unit tests and integration tests.
6. Repeat until the code builds and the tests pass.

The compiler acts as a strict reviewer for certain classes of mistakes. That is particularly valuable when an agent is making many changes across a codebase.

However, Rust is not necessarily easier for an AI to write in. Its ownership model, lifetimes, trait system, and asynchronous programming can be challenging. A Rust project may require more initial effort than an equivalent Python script. The benefit is that many classes of bugs can be caught before the program runs.

And a successful compilation does not prove the program is correct, secure, fast, or visually accurate. Those still require testing and engineering judgment.

## 2. Will Rust be the future of AI coding?

My assessment: Rust will become increasingly important in AI-assisted software development, but it won't replace the major programming languages. AI changes the economics of using Rust more than it changes what Rust is good at.

Consider the difference:

| Language                | Where it fits particularly well                                                         |
| ----------------------- | --------------------------------------------------------------------------------------- |
| Rust                    | Native desktop apps, systems software, secure services, high-performance processing     |
| C++                     | Graphics engines, game engines, mature desktop software, performance-critical libraries |
| Python                  | ML research, model training, data science, AI orchestration                             |
| TypeScript / JavaScript | Web apps, interfaces, interactive tools, agent front ends                               |
| C                       | Operating systems, embedded systems, low-level hardware interfaces                      |
| CUDA / GPU programming  | Custom GPU kernels and specialized compute workloads                                    |

Rust's official project emphasizes performance, memory safety, concurrency safety, and strong development tooling. Those qualities make it a compelling choice for many applications that AI agents are increasingly capable of building.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

GitHub

+1



### Why the AI coding revolution changes the equation

Traditionally, a developer might avoid Rust because learning its ownership model and satisfying the compiler take time. With an AI coding agent, you can ask for an implementation, have the agent work through compiler errors, and review the resulting code rather than manually writing every line.

That reduces some of the learning and implementation burden. But it doesn't eliminate the need to understand:

- The system's architecture and requirements.
- Whether the agent chose the right libraries.
- Whether the application behaves correctly.
- Performance, security, testing, and maintenance.

An agent can also introduce an architectural mistake that compiles perfectly. More code generated per hour doesn't automatically mean better software.

The likely direction is a multilingual software stack: AI chooses or assists with the appropriate language for each component, while humans focus more on architecture, specifications, integration, and verification.

## 3. Is Rust capable enough to replace C++?

For many applications, yes. For every application, no.

Where Rust is a strong candidate

Native desktop applications, file-format processors, image manipulation, networking, command-line tools, secure infrastructure, and concurrent processing.

Where the decision is more complicated

Mature graphics engines, GPU-heavy software, legacy C++ applications, and systems with extensive existing libraries or specialized vendor SDKs. C++ may retain advantages through its existing ecosystem and integration.

Where Rust isn't a shortcut

Reimplementing a decade-old application with thousands of features, undocumented behaviors, proprietary formats, plugins, and carefully tuned performance. The language doesn't supply that accumulated engineering work.

One important distinction: Rust's memory-safety guarantees apply to safe Rust code, not automatically to every component of an application. Unsafe code, foreign-function interfaces, and external libraries still require careful review.

## 4. What language is Adobe Photoshop written in?

Adobe does not publish a complete, authoritative breakdown of every language used inside the modern Photoshop codebase. Its exact internal implementation is proprietary. However, we can distinguish the likely native application layer from Adobe's documented extension technologies.

| Photoshop component                                 | Language / technology                                                                                                                     | Purpose                                                                 |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Core native application and image-processing engine | C++ is a major technology in this class of software; Adobe's complete current internal language inventory isn't publicly established here | Performance-intensive editing, rendering, and application functionality |
| Modern plugins and scripts (UXP)                    | JavaScript, HTML, CSS                                                                                                                     | Automation, panels, interfaces, and integrations                        |
| Native plugin integrations                          | C++ alongside JavaScript and UXP                                                                                                          | Specialized native functionality                                        |
| Older scripting and automation                      | ExtendScript (an older JavaScript implementation); platform-specific automation such as AppleScript on macOS                              | Automating established workflows                                        |
| External Photoshop API                              | Any language capable of making REST API requests                                                                                          | Connecting workflows and services to Photoshop's API                    |

Adobe explicitly documents JavaScript-based UXP scripts and plugins, C++ SDK plugins, and hybrid plugins combining native C++ with JavaScript and web technologies.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://developer.adobe.com\&sz=32)

developer.adobe.com

+2



Why does that matter? Photoshop is not merely a collection of buttons. It has to handle large images, layers, masks, color spaces, blending, filters, graphics hardware, file compatibility, and complex editing workflows. The native engine and its surrounding ecosystem have evolved over many years.

A new application written in Rust can implement similar features, but it doesn't automatically reproduce Photoshop's behavior or compatibility.

## 5. Why not just tell AI to rewrite Photoshop in Rust?

You can absolutely ask an AI agent to rewrite a program in Rust. The difficulty depends on the size of the program and what the agent can access.

### What a rewrite request actually means

Original application

Existing code, dependencies, behaviors, and tests

AI-assisted port or reimplementation

Translate logic where possible; redesign ownership, interfaces, dependencies, and architecture where necessary

Validation

Builds, tests, performance benchmarks, compatibility checks, and human review

There are two very different situations:

Scenario A — The source code is available. An agent can inspect the original implementation, port functions, reuse test cases, and compare outputs. This is much more tractable, although a large rewrite still requires substantial engineering.

Scenario B — The source code is proprietary or unavailable. The agent must implement equivalent behavior from documentation, observed results, and user requirements. This is a reimplementation, not a direct translation. The agent cannot reproduce details it doesn't know, and testing against real-world workflows becomes crucial.

That's the key to understanding projects like ArtCraft. AI can help a developer produce a native Rust application that resembles an established creative tool. But matching the interface and implementing common features is a very different achievement from matching years of professional functionality, compatibility, and polish.

## My conclusion

Rust is absolutely capable of building sophisticated applications, including creative software. AI coding agents make it more practical for small teams and individual developers to attempt projects that previously required much larger engineering teams.

But I wouldn't bet on a Rust-only future. I would bet on AI-assisted, multi-language engineering, with Rust gaining ground where native performance, memory safety, and reliability matter; Python remaining central to ML development; and C++ continuing to matter wherever its mature ecosystem is hard to replace.

For your own AI projects, Rust is worth learning if you're interested in building reliable local tools, high-performance data processing, or native applications. You can continue using Python for ML experimentation and model orchestration, and let Rust handle components where its strengths justify the added complexity.