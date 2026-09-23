# Space Invaders
- Macbook Pro M1 Pro, 32GB Unified Memory, 16c GPU
- LM Studio, Context Length 262,000 (max)
- Using Alibaba's opensource ML model

> Qwen3.5 represents a significant leap forward, integrating breakthroughs in multimodal learning, architectural efficiency, reinforcement learning scale, and global accessibility. This is a 9B parameter dense model, supporting a native context length of 262,144 tokens.

- [Qwen 3.5 9b](https://lmstudio.ai/models/qwen/qwen3.5-9b)
- 7GB Small sized LLM
- GGUF version
- 16GB Unified Memory (minimum)
- 15.81 tok/sec
- 4671 tokens

---

## Pasted prompt
```
Create a fully playable Space Invaders clone that runs directly in a web browser.

Requirements:
- Output a single HTML file containing <html>, <head>, <style>, and <script> tags.
- Use only vanilla JavaScript, HTML5 Canvas, and CSS.
- No external libraries or CDNs.
- The game must include:
  - A player ship at the bottom that moves left/right with arrow keys or A/D.
  - A fire button (spacebar) that shoots projectiles upwards.
  - Multiple rows of alien invaders that move horizontally and descend over time.
  - Collision detection between bullets and aliens.
  - Alien movement speed increasing as fewer aliens remain.
  - A score counter.
  - A “Game Over” state when aliens reach the bottom or the player is hit.
  - A “You Win” state when all aliens are destroyed.
- The canvas should automatically scale to fit the browser window.
- Keep the code clean, modular, and easy to modify.
- Include comments explaining the main functions.
- At the end, provide the complete HTML file with no placeholders.
```

---