
# Space Invaders - Advance
- Using gpt-oss-20b. 
- One shot prompt.
- Fits in ~16GB VRAM

---

## Instructions
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

## Output by bot

```
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Space Invaders Clone</title>
<style>
  body, html { margin:0; padding:0; overflow:hidden; background:#000; }
  canvas { display:block; background:#111; }
  #overlay {
    position:absolute;
    top:50%; left:50%;
    transform:translate(-50%,-50%);
    color:white;
    font-family:sans-serif;
    text-align:center;
    pointer-events:none;
  }
</style>
</head>
<body>
<canvas id="gameCanvas"></canvas>
<div id="overlay"></div>

<script>
// ---------- Configuration ----------
const config = {
  // Canvas scaling
  scale: 1, // will be set to window width / baseWidth
  baseWidth: 480,
  baseHeight: 640,

  // Player
  player: {
    width: 30,
    height: 10,
    speed: 200, // px per second
    color: '#0f0'
  },

  // Bullet
  bullet: {
    width: 4,
    height: 8,
    speed: 350,
    color: '#ff0',
    fireRate: 300 // ms between shots
  },

  // Alien
  alien: {
    rows: 5,
    cols: 11,
    width: 30,
    height: 20,
    paddingX: 10,
    paddingY: 10,
    offsetTop: 50,
    color: '#f00',
    baseSpeed: 30, // px per second
    descent: 15 // pixels each time they change direction
  },

  // Game
  gameOverText: 'Game Over! Press R to restart.',
  winText: 'You Win! Press R to play again.'
};
// ---------- Global Variables ----------
let canvas, ctx;
let canvasWidth, canvasHeight;
let scale;

let player = {
  x: 0,
  y: 0,
  width: config.player.width,
  height: config.player.height
};

let bullets = [];
let aliens = [];

let keys = {};
let lastFireTime = 0;
let gameState = 'playing'; // playing, win, over

// ---------- Initialization ----------
function init() {
  canvas = document.getElementById('gameCanvas');
  ctx = canvas.getContext('2d');

  resizeCanvas();
  window.addEventListener('resize', resizeCanvas);

  document.addEventListener('keydown', keyDown);
  document.addEventListener('keyup', keyUp);
  document.addEventListener('keypress', keyPress);

  resetGame();
  requestAnimationFrame(gameLoop);
}

// ---------- Resize ----------
function resizeCanvas() {
  canvasWidth = window.innerWidth;
  canvasHeight = window.innerHeight;

  scale = Math.min(canvasWidth / config.baseWidth, canvasHeight / config.baseHeight);
  canvas.width = config.baseWidth * scale;
  canvas.height = config.baseHeight * scale;

  // Reposition player to bottom center
  player.x = (config.baseWidth - player.width) / 2;
  player.y = config.baseHeight - player.height - 10;
}

// ---------- Input ----------
function keyDown(e) {
  keys[e.key] = true;
}
function keyUp(e) {
  keys[e.key] = false;
}
function keyPress(e) {
  if (gameState !== 'playing') return;
  if (e.code === 'Space' || e.key === ' ') {
    fireBullet();
  }
}

// ---------- Game Reset ----------
function resetGame() {
  player.x = (config.baseWidth - player.width) / 2;
  bullets = [];
  aliens = [];

  // Create alien grid
  const totalAlienWidth = config.alien.cols * config.alien.width + (config.alien.cols -1)*config.alien.paddingX;
  let startX = (config.baseWidth - totalAlienWidth)/2;

  for (let r=0; r<config.alien.rows; r++) {
    for (let c=0; c<config.alien.cols; c++) {
      aliens.push({
        x: startX + c*(config.alien.width+config.alien.paddingX),
        y: config.alien.offsetTop + r*(config.alien.height+config.alien.paddingY),
        width: config.alien.width,
        height: config.alien.height,
        alive: true
      });
    }
  }

  gameState = 'playing';
  document.getElementById('overlay').innerText = '';
}

// ---------- Bullet ----------
function fireBullet() {
  const now = Date.now();
  if (now - lastFireTime < config.bullet.fireRate) return;
  lastFireTime = now;

  bullets.push({
    x: player.x + player.width/2 - config.bullet.width/2,
    y: player.y - config.bullet.height,
    width: config.bullet.width,
    height: config.bullet.height
  });
}

// ---------- Alien Movement ----------
let alienDirection = 1; // 1:right, -1:left
let lastAlienMoveTime = Date.now();
function updateAliens(delta) {
  const speed = config.alien.baseSpeed + (aliens.filter(a=>a.alive).length / aliens.length) * 50;
  const moveX = alienDirection * speed * delta;

  let shouldDescend = false;

  // Check if any alien hits edge
  for (let a of aliens) {
    if (!a.alive) continue;
    const nextX = a.x + moveX;
    if (nextX < 0 || nextX + a.width > config.baseWidth) {
      shouldDescend = true;
      break;
    }
  }

  if (shouldDescend) {
    alienDirection *= -1;
    for (let a of aliens) {
      a.y += config.alien.descent;
    }
  } else {
    for (let a of aliens) {
      a.x += moveX;
    }
  }
}

// ---------- Collision ----------
function checkCollisions() {
  // Bullet vs Alien
  for (let b of bullets) {
    for (let a of aliens) {
      if (!a.alive) continue;
      if (rectIntersect(b, a)) {
        a.alive = false;
        b.y = -100; // move off screen to be removed
        break;
      }
    }
  }

  // Alien vs Player
  for (let a of aliens) {
    if (!a.alive) continue;
    if (rectIntersect(a, player)) {
      gameState = 'over';
    }
  }
}

// ---------- Helper ----------
function rectIntersect(r1, r2) {
  return !(r2.x > r1.x + r1.width ||
           r2.x + r2.width < r1.x ||
           r2.y > r1.y + r1.height ||
           r2.y + r2.height < r1.y);
}

// ---------- Update ----------
let lastTime = Date.now();
function update() {
  const now = Date.now();
  const delta = (now - lastTime)/1000; // seconds
  lastTime = now;

  if (gameState !== 'playing') return;

  // Move player
  let moveX = 0;
  if (keys['ArrowLeft'] || keys['a'] || keys['A']) moveX -= config.player.speed * delta;
  if (keys['ArrowRight'] || keys['d'] || keys['D']) moveX += config.player.speed * delta;
  player.x += moveX;
  // Clamp to screen
  if (player.x < 0) player.x = 0;
  if (player.x + player.width > config.baseWidth) player.x = config.baseWidth - player.width;

  // Update bullets
  for (let b of bullets) {
    b.y -= config.bullet.speed * delta;
  }
  // Remove off-screen bullets
  bullets = bullets.filter(b => b.y + b.height > 0);

  // Update aliens
  updateAliens(delta);

  // Collision detection
  checkCollisions();

  // Check win/lose conditions
  if (aliens.every(a=>!a.alive)) {
    gameState = 'win';
  } else {
    for (let a of aliens) {
      if (!a.alive) continue;
      if (a.y + a.height >= player.y) { // reached bottom
        gameState = 'over';
        break;
      }
    }
  }
}

// ---------- Render ----------
function render() {
  ctx.clearRect(0,0,canvas.width, canvas.height);
  ctx.save();
  ctx.scale(scale, scale);

  // Draw player
  if (gameState === 'playing' || gameState === 'win') {
    ctx.fillStyle = config.player.color;
    ctx.fillRect(player.x, player.y, player.width, player.height);
  }

  // Draw bullets
  ctx.fillStyle = config.bullet.color;
  for (let b of bullets) {
    ctx.fillRect(b.x, b.y, b.width, b.height);
  }

  // Draw aliens
  ctx.fillStyle = config.alien.color;
  for (let a of aliens) {
    if (!a.alive) continue;
    ctx.fillRect(a.x, a.y, a.width, a.height);
  }

  // Score and state text
  const aliveCount = aliens.filter(a=>a.alive).length;
  ctx.fillStyle = '#fff';
  ctx.font = '20px sans-serif';
  ctx.textAlign = 'left';
  ctx.fillText(`Score: ${config.alien.rows*config.alien.cols - aliveCount}`,10,30);

  if (gameState === 'over') {
    document.getElementById('overlay').innerText = config.gameOverText;
  } else if (gameState === 'win') {
    document.getElementById('overlay').innerText = config.winText;
  } else {
    document.getElementById('overlay').innerText = '';
  }

  ctx.restore();
}

// ---------- Game Loop ----------
function gameLoop() {
  update();
  render();
  requestAnimationFrame(gameLoop);
}

// ---------- Restart ----------
document.addEventListener('keydown', (e)=>{
  if ((gameState === 'over' || gameState === 'win') && e.key.toLowerCase()==='r') {
    resetGame();
  }
});

// ---------- Start ----------
init();
</script>
</body>
</html>
```

---
