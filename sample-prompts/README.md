
# Sample Prompts
Curated prompts and small examples to use with local LLMs or hosted APIs.

## Table of Contents
1. [Overview](#overview)  
2. [Files](#files)

---

## 📚 Overview
- This folder contains practical prompt templates and quick examples to help bootstrap prompt engineering workflows.
- I use "reasoning" LLMs, downloaded locally. 
- I use "coding" LLMs, downloaded locally.
- I will need to figure out "vision" next.

---

## Files
- `prompts.md`: A collection of prompt templates.  
- `examples.html`: Quick HTML viewer for prompt examples.

---

## Prompts

### Bitcoin Encryption
- This prompt compares bitcoin with industry standard CC companies

 - ```
   Using tables compare Bitcoin with industry credit card companies, focusing on encryption. Output your answer in README.md github format.
   ```

---

### Space Invaders
- This prompt create's a fully playable game

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