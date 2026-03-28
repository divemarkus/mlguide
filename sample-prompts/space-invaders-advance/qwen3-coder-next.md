
# Prompt 2
- Using local opensource ML model [Qwen3-Coder-Next](https://lmstudio.ai/models/qwen3-coder-next):
- Qwen3 Coder Next is an 80B MoE with 3B active parameters designed for coding agents and local development. Excels at long-horizon reasoning, complex tool usage, and recovery from execution failures.

## Pasted prompt
Create an advanced Space Invaders–style browser game with a retro pixel‑art aesthetic.

Requirements:
- Output a single, complete HTML file containing <html>, <head>, <style>, and <script> tags.
- Use only vanilla JavaScript, HTML5 Canvas, and CSS. No external libraries or CDNs.
- The game must include:
  • A pixel‑art player ship at the bottom that moves left/right with arrow keys or A/D.
  • A pixel‑art bullet fired with the spacebar.
  • Multiple rows of pixel‑art alien invaders with simple 8‑bit animations (e.g., 2‑frame wiggle).
  • Aliens move horizontally, reverse direction at edges, and descend gradually.
  • Collision detection between bullets and aliens.
  • Alien speed increases as fewer remain.
  • A score counter and lives system displayed in a pixel‑art font style.
  • A “Game Over” screen with retro arcade styling.
  • A “You Win” screen when all aliens are destroyed.
  • Simple retro sound effects (generated via JS AudioContext) for:
      - Player shooting
      - Alien hit
      - Player hit
  • Canvas automatically scales to fit the browser window while preserving pixel‑art crispness (use imageRendering: 'pixelated').
  • Clean, modular code with functions for:
      - Rendering
      - Input handling
      - Game loop
      - Collision detection
      - Entity updates
  • Include comments explaining each major part of the code.

Pixel Art Requirements:
- Use simple pixel‑art sprites drawn directly in JavaScript (arrays of color values) or embedded as <canvas> pixel maps.
- Player ship, aliens, and bullets must all use pixel‑art style.
- Use a limited retro palette (e.g., greens, whites, magentas, cyans).

Game Feel Requirements:
- Movement should feel responsive.
- Aliens should animate with a simple 2‑frame cycle.
- Add a brief explosion animation when an alien is destroyed.
- Add a short screen flash or shake effect when the player is hit.

Final Output:
- Provide the full HTML file with no placeholders or omissions.
- The file should run immediately when saved as index.html and opened in a browser.

---

## Boop boop, output

