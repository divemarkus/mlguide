
# Homelab Dashboard
- Apple Macbook Pro M1 Pro, 16c GPU
- LM Studio, Context Length 20,000
- Using OpenAI's opensource ML model
- GPT-OSS-20b by OpenAI
- 18GB Medium sized LLM
- MLX version
- 32GB Unified Memory (preferred)

---

## Prompt
Instructions
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
## Response

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Homelab Dashboard</title>
<!-- Bootstrap 5 CDN – no local files required -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet" integrity="sha384-..." crossorigin="anonymous">

<style>
/* Simple custom styling – keep it minimal so beginners can tweak */
body { background:#f8f9fa; }
.card { cursor:pointer; transition:transform .2s; }
.card:hover { transform:scale(1.02); }
.widget-title { font-size:.9rem; color:#6c757d; }
</style>
</head>

<body class="p-4">
<div class="container-fluid">

  <!-- Header -->
  <div class="row mb-3">
    <div class="col">
      <h1>Homelab Dashboard</h1>
    </div>
  </div>

  <!-- Tiles row -->
  <div class="row g-3 mb-4">
    <!-- Example tile – duplicate and edit for more services -->
    <div class="col-md-3">
      <a href="https://myservice.local" target="_blank" class="text-decoration-none">
        <div class="card text-center shadow-sm h-100 bg-white">
          <div class="card-body d-flex flex-column justify-content-center align-items-center">
            <i class="bi bi-gear" style="font-size:2rem;"></i>
            <h5 class="card-title mt-2">My Service</h5>
          </div>
        </div>
      </a>
    </div>
    <!-- Add more tiles below -->
  </div>

  <!-- Widgets row -->
  <div class="row g-3 mb-4">
    <!-- Bitcoin price widget -->
    <div class="col-md-6">
      <div class="card shadow-sm h-100 bg-white">
        <div class="card-header d-flex justify-content-between align-items-center">
          <span>Bitcoin Price (USD)</span>
          <button id="btcRefresh" class="btn btn-sm btn-outline-secondary">↻</button>
        </div>
        <div class="card-body">
          <h2 id="btcPrice" class="mb-0">$--</h2>
        </div>
      </div>
    </div>

    <!-- NASDAQ stock widget -->
    <div class="col-md-6">
      <div class="card shadow-sm h-100 bg-white">
        <div class="card-header d-flex justify-content-between align-items-center">
          <span>NASDAQ Stock (AAPL)</span>
          <button id="stockRefresh" class="btn btn-sm btn-outline-secondary">↻</button>
        </div>
        <div class="card-body">
          <h2 id="stockPrice" class="mb-0">$--</h2>
          <p id="stockChange" class="text-muted mb-0"></p>
        </div>
      </div>
    </div>
  </div>

  <!-- System stats placeholder -->
  <div class="row mb-4">
    <div class="col">
      <div class="card shadow-sm h-100 bg-white">
        <div class="card-header">System Stats (Placeholder)</div>
        <div class="card-body">
          <p>CPU: --%</p>
          <p>Memory: -- GB / -- GB</p>
          <p>Disk: -- GB free of -- GB</p>
        </div>
      </div>
    </div>
  </div>

</div>

<!-- Bootstrap Icons (for the gear icon) -->
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<script>
/* =========================
   1️⃣ Bitcoin price widget
   ========================= */
const btcPriceEl = document.getElementById('btcPrice');
const btcRefreshBtn = document.getElementById('btcRefresh');

async function fetchBitcoin() {
  try {
    const res = await fetch(
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd'
    );
    const data = await res.json();
    btcPriceEl.textContent = `$${data.bitcoin.usd.toLocaleString()}`;
  } catch (e) {
    btcPriceEl.textContent = 'Error';
  }
}
btcRefreshBtn.onclick = fetchBitcoin;
fetchBitcoin(); // initial load

/* =========================
   2️⃣ NASDAQ stock widget (Apple)
   ========================= */
const stockPriceEl = document.getElementById('stockPrice');
const stockChangeEl = document.getElementById('stockChange');
const stockRefreshBtn = document.getElementById('stockRefresh');

/*
  Alpha Vantage free API – replace YOUR_API_KEY with your key.
  For a beginner, you can use the demo key "demo" but it only works for
  AAPL and has a request limit.
*/
const ALPHA_KEY = 'demo'; // <-- Replace with your key

async function fetchStock() {
  try {
    const res = await fetch(
      `https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=AAPL&apikey=${ALPHA_KEY}`
    );
    const data = await res.json();
    const quote = data['Global Quote'];
    const price = parseFloat(quote['05. price']);
    const change = parseFloat(quote['09. change']);

    stockPriceEl.textContent = `$${price.toFixed(2)}`;
    stockChangeEl.textContent =
      `${change >= 0 ? '+' : ''}${change.toFixed(2)} (${(
        (change / price) *
        100
      ).toFixed(2)}%)`;
    stockChangeEl.className = change >= 0 ? 'text-success' : 'text-danger';
  } catch (e) {
    stockPriceEl.textContent = 'Error';
    stockChangeEl.textContent = '';
  }
}
stockRefreshBtn.onclick = fetchStock;
fetchStock(); // initial load

/* =========================
   3️⃣ System stats placeholder
   ========================= */
/*
  In a real homelab you might fetch stats from your own API or
  a monitoring service (Prometheus, Grafana, etc.). For this demo,
  the stats are static placeholders. Edit the HTML below to show
  real data when you have an endpoint.
*/
</script>
</body>
</html>
```

### How to Edit

1. **Add/Change Tiles**  
   Copy the `<div class="col-md-3"> … </div>` block inside the first row and change:
   * `href` – URL of your service
   * Icon class (`bi bi-gear`) – choose from [Bootstrap Icons](https://icons.getbootstrap.com/)
   * Title (`My Service`) – your service name

2. **Change Stock Symbol**  
   Edit the `symbol=AAPL` part in the Alpha Vantage URL to whatever ticker you want.

3. **Replace API Key**  
   Get a free key from [Alpha Vantage](https://www.alphavantage.co/) and replace `demo` with it.

4. **Add System Stats**  
   Replace the placeholder `<p>` tags in the “System Stats” card with real data or a fetch call to your monitoring endpoint.

5. **Styling**  
   Adjust the CSS in the `<style>` block for colors, fonts, or spacing.

This dashboard uses only Bootstrap 5 (via CDN) and vanilla JavaScript – no build tools or frameworks. Save the file as `index.html` and open it in any modern browser to see your homelab dashboard live!