# Space Invaders
- Using local opensource ML model [Qwen2.5-Coder-30b](https://lmstudio.ai/models/qwen/qwen2.5-coder-32b):
- Qwen2.5 Coder 32B by qwen.
- 32B version of the code-specific Qwen 2.5 for code generation, code reasoning and code fixing.
- MLX version
- 19GB Unified Memory (minimum)

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