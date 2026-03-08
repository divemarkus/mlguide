
# Prompt 4
gpt-oss-20b

---

## Prompt
```
Build me a simple homelab dashboard using HTML, CSS, and JavaScript.
Include:
- Tiles linking to my homelab services
- A Bitcoin price widget
- A NASDAQ stock price widget
- A section for system stats (placeholder)
- Clean, modern UI using Bootstrap or Tailwind
Make the code easy for a beginner to edit.
```
---

## Response from LLM
Response...
```
Below is a single‑file example that you can copy into index.html.

Everything is in one file so a beginner only has to open the page in a browser,
edit the links or add new tiles, and change the CSS if they want a different look.

What you’ll need

A modern web browser (Chrome / Firefox / Edge) – no server required.
Internet access for the two public APIs used below:
Bitcoin price – CoinGecko
NASDAQ price – IEX Cloud “sandbox” (free tier, 5 k requests/day)
```

---

## Code
52.55 tok/sec. 1757 tokens. 0.22s.
```
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Homelab Dashboard</title>

<!-- Bootstrap 5 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet">

<style>
/* ----------------------------------------------------- */
/* 1️⃣  Custom styling – keep it short & readable         */
/* ----------------------------------------------------- */
body {
    background:#f8fafc;          /* light gray */
}
.card {                      /* all tiles */
    border: none;
    transition: transform .2s;
}
.card:hover {                /* hover effect */
    transform: translateY(-5px);
    box-shadow: 0 4px 12px rgba(0,0,0,.1);
}
.widget-card {
    background:#fff;          /* white background for widgets */
    border-radius:.75rem;
    padding:1.5rem;
}
h3 { margin-bottom: .75rem;}
</style>
</head>

<body class="p-4">

<div class="container">
  <!-- ======== 1️⃣ Tiles section ====================== -->
  <div class="row g-4 mb-5">
    <!-- Example tile – replace the link & icon as needed -->
    <div class="col-sm-6 col-md-4 col-lg-3">
      <a href="https://yourservice.local" target="_blank"
         class="card text-decoration-none text-dark h-100 p-3 d-flex flex-column align-items-center justify-content-center">
        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48"
             fill="#4a90e2" viewBox="0 0 24 24"><path d="M12 2l9 5v10l-9 5-9-5V7z"/></svg>
        <h6 class="mt-3 mb-0">Web‑UI</h6>
      </a>
    </div>

    <!-- Add more tiles here – just copy the block above -->
    <!-- ... -->
  </div>

  <!-- ======== 2️⃣ Widget section ====================== -->
  <div class="row g-4">
    <!-- Bitcoin price widget -->
    <div class="col-md-6">
      <div class="widget-card h-100">
        <h3>Bitcoin (BTC)</h3>
        <p id="btc-price" class="display-5 fw-bold">Loading…</p>
        <small id="btc-change"></small>
      </div>
    </div>

    <!-- NASDAQ stock widget -->
    <div class="col-md-6">
      <div class="widget-card h-100">
        <h3>NASDAQ Index (NDX)</h3>
        <p id="nasdaq-price" class="display-5 fw-bold">Loading…</p>
        <small id="nasdaq-change"></small>
      </div>
    </div>
  </div>

  <!-- ======== 3️⃣ System stats placeholder ====================== -->
  <div class="row mt-5">
    <div class="col">
      <h4>System Stats</h4>
      <p class="text-muted">Coming soon – you can plug in a REST endpoint that returns JSON.</p>
    </div>
  </div>
</div>

<!-- ----------------------------------------------------- -->
<!-- 2️⃣ JavaScript – fetch API data and update DOM          -->
<!-- ----------------------------------------------------- -->
<script>
// Helper to format numbers with commas
function formatNumber(n, decimals = 2) {
  return Number(n).toLocaleString(undefined, {minimumFractionDigits: decimals, maximumFractionDigits: decimals});
}

// 1️⃣ Bitcoin price (CoinGecko)
async function loadBTC() {
  try {
    const res = await fetch('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd');
    const data = await res.json();
    const price = data.bitcoin.usd;
    document.getElementById('btc-price').textContent = `$${formatNumber(price)}`;

    // Optional: show change percentage (needs extra call)
    const marketRes = await fetch('https://api.coingecko.com/api/v3/coins/bitcoin');
    const marketData = await marketRes.json();
    const change24h = marketData.market_data.price_change_percentage_24h;
    document.getElementById('btc-change').textContent =
      `${change24h >= 0 ? '+' : ''}${formatNumber(change24h,1)}% (24h)`;
  } catch(e) { console.error(e); }
}

// 2️⃣ NASDAQ price – using IEX Cloud “sandbox” endpoint
async function loadNASDAQ() {
  // Replace YOUR_API_TOKEN with a real token from https://iexcloud.io/
  const apiToken = 'YOUR_SANDBOX_TOKEN';
  const symbol = '^NDX';          // Nasdaq-100 index symbol

  try {
    const res = await fetch(`https://sandbox.iexapis.com/stable/stock/${symbol}/quote?token=${apiToken}`);
    const data = await res.json();
    document.getElementById('nasdaq-price').textContent =
      `$${formatNumber(data.latestPrice)}`;

    const changePct = data.changePercent * 100;
    document.getElementById('nasdaq-change').textContent =
      `${changePct >= 0 ? '+' : ''}${formatNumber(changePct,1)}% (today)`;
  } catch(e) { console.error(e); }
}

// Run the loaders when page loads
window.addEventListener('load', () => {
  loadBTC();
  loadNASDAQ();   // comment out if you don't have a token yet
});
</script>

<!-- Bootstrap JS bundle (includes Popper) – optional but good for future features -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

---

## Instructions
How to use / edit

| What | Where to change |
|------|-----------------|
| **Tile link & icon** | Inside the `<div class="col-sm-6 …">` block – change `href`, swap out the SVG or use an image. Copy that whole block for new tiles. |
| **Widget API keys / endpoints** | In the JavaScript section:  
  * Bitcoin uses a public CoinGecko endpoint (no key).  
  * NASDAQ needs a free IEX Cloud token – replace `YOUR_SANDBOX_TOKEN` with your real token or comment out that call if you don’t want it. |
| **System stats** | Replace the placeholder paragraph with your own fetch to an API that returns CPU, memory, etc., and populate the DOM. |
| **Styling** | Add CSS rules inside `<style>` – e.g., change colors, fonts, or use a different Bootstrap theme. |

---

### Why this is beginner‑friendly

1. **Single file** – no build tools, no server needed.  
2. **Bootstrap 5 CDN** – all layout and responsiveness comes from the library; you only need to add classes like `row`, `col-md-6`.  
3. **Minimal JavaScript** – just a few fetch calls and DOM updates.  
4. **Clear comments** – every section has a header comment explaining its purpose.

Happy hacking! If you hit any snags, feel free to ask for help.
