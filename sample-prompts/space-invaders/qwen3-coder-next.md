
# Prompt 1
- Using local opensource ML model [Qwen3-Coder-Next](https://lmstudio.ai/models/qwen3-coder-next):
- Qwen3 Coder Next is an 80B MoE with 3B active parameters designed for coding agents and local development. Excels at long-horizon reasoning, complex tool usage, and recovery from execution failures.

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

## Output: ***prompt1.html***
- Qwen-3-Coder-Next...
- Pretty much maxed out my 64GB shared GPU RAM, offloaded to another 64GB system RAM
- This was version 5, because it got confused with my other prompt
- I need to be mindful about prompting effectively
- Copy and save file attached as qwen3-coder-next.html > double-click for Web Browsers to open
- [Open the demo](qwen3-coder-next.html)
- Completed in less than 2 mins. I need to measure in tok/secs
