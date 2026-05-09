
# Homelab Dashboard
- Google's Gemma 4
- 7GB GGUF
- LM Studio, Context Size 45,000

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
```
This dashboard uses **Bootstrap 5** via a CDN, which makes it look modern and professional while being extremely easy for you to edit simply by changing text or adding classes. Since real-time financial data requires API keys and backend setup, I have implemented **mock API functions** using JavaScript timers (`setTimeout`) that simulate the fetching process.

The entire code is provided in a single `index.html` file.
```

### 🚀 Homelab Dashboard Code (Single HTML File)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🏠 Homelab Dashboard</title>
    <!-- Bootstrap 5 CDN (Easiest way to add modern styling) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* Custom CSS for Dashboard Theme */
        body {
            background-color: #f4f7fa; /* Light, modern background */
            padding-top: 20px;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
            height: 100%; /* Ensure all cards in a row are the same height */
        }
        .card-title {
            font-weight: 600;
            color: #343a40;
        }
        .tile-link {
            display: block;
            text-decoration: none;
            color: inherit;
        }
        /* Styling for the widget price display */
        #btcPrice, #nasdaqPrice {
            font-size: 2.5rem;
            font-weight: bold;
            margin-top: 10px;
        }
        .stat-placeholder {
            min-height: 80px; /* Gives placeholder sections visible height */
            background-color: #e9ecef;
        }
    </style>
</head>
<body class="container my-5">

    <!-- Header -->
    <div class="mb-4 text-center">
        <h1 class="display-4 fw-bold text-primary">🏠 Homelab Dashboard</h1>
        <p class="lead text-muted">Your centralized control panel for home services and vital stats.</p>
    </div>

    <!-- 1. System Stats Section (Placeholder) -->
    <div class="row mb-5 g-4">
        <div class="col-md-3 col-lg-2" id="cpuStatCard">
            <div class="card p-3 border-start border-primary border-5 shadow-sm">
                <h6 class="card-title text-muted">CPU Load</h6>
                <p class="mb-0 fs-4 fw-bold text-success" id="cpuLoad">%X</p>
            </div>
        </div>
         <div class="col-md-3 col-lg-2" id="memStatCard">
            <div class="card p-3 border-start border-info border-5 shadow-sm">
                <h6 class="card-title text-muted">Memory</h6>
                <p class="mb-0 fs-4 fw-bold text-success" id="memoryLoad">%X</p>
            </div>
        </div>
         <div class="col-md-3 col-lg-2" id="diskStatCard">
            <div class="card p-3 border-start border-warning border-5 shadow-sm">
                <h6 class="card-title text-muted">Disk Space</h6>
                <p class="mb-0 fs-4 fw-bold text-success" id="diskSpace">%X</p>
            </div>
        </div>
         <div class="col-md-3 col-lg-2" id="networkStatCard">
            <div class="card p-3 border-start border-danger border-5 shadow-sm">
                <h6 class="card-title text-muted">Uptime</h6>
                <p class="mb-0 fs-4 fw-bold text-success" id="uptimeHours">X h</p>
            </div>
        </div>
    </div>

    <!-- 2. Financial Widgets (BTC & NASDAQ) -->
    <div class="row mb-5 g-4">
        <!-- Bitcoin Widget -->
        <div class="col-md-6 col-lg-5">
            <div class="card p-4 shadow-sm">
                <h5 class="card-title text-primary">💰 Bitcoin Price (BTC)</h5>
                <p class="text-muted lead">Real-time price feed.</p>
                <div id="btcPrice">$Loading...</div>
            </div>
        </div>

        <!-- NASDAQ Widget -->
        <div class="col-md-6 col-lg-5">
            <div class="card p-4 shadow-sm">
                <h5 class="card-title text-danger">📈 NASDAQ Composite</h5>
                <p class="text-muted lead">Market performance index.</p>
                <div id="nasdaqPrice">$Loading...</div>
            </div>
        </div>
    </div>

    <!-- 3. Homelab Service Tiles -->
    <div class="row mb-5 g-4">
        <h2 class="mb-3 fw-bold">🛠️ Services & Resources</h2>
        
        <!-- Tile 1: PiHole (DNS) -->
        <div class="col-lg-3 col-md-6">
            <a href="http://pihole.local/" target="_blank" class="card p-4 tile-link border-0 shadow-sm hover-zoom">
                <h5 class="mb-3 text-primary">PiHole DNS</h5>
                <p>Network ad blocking and DNS sinkholing.</p>
            </a>
        </div>

        <!-- Tile 2: Plex Media Server -->
        <div class="col-lg-3 col-md-6">
            <a href="http://plex.local/web" target="_blank" class="card p-4 tile-link border-0 shadow-sm hover-zoom">
                <h5 class="mb-3 text-info">Plex Media</h5>
                <p>Centralized movie and music streaming library.</p>
            </a>
        </div>

        <!-- Tile 3: Home Automation (e.g., Zigbee/MQTT) -->
        <div class="col-lg-3 col-md-6">
            <a href="#home_automation" target="_self" class="card p-4 tile-link border-0 shadow-sm hover-zoom">
                <h5 class="mb-3 text-warning">Home Automation</h5>
                <p>Control lights, locks, and climate devices.</p>
            </a>
        </div>

        <!-- Tile 4: NAS Storage (Samba/Nextcloud) -->
        <div class="col-lg-3 col-md-6">
            <a href="smb://nas.local/" target="_blank" class="card p-4 tile-link border-0 shadow-sm hover-zoom">
                <h5 class="mb-3 text-success">Network Storage (NAS)</h5>
                <p>Backup and shared file access point.</p>
            </a>
        </div>

    </div>


    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript Logic -->
    <script>
        // ==========================================
        // 🤖 JAVASCRIPT LOGIC START HERE
        // This section handles the dynamic data updates.
        // ==========================================

        /**
         * MOCK API function to simulate fetching the Bitcoin price.
         * In a real application, this would use `fetch('YOUR_BTC_API')`.
         */
        function fetchBitcoinPrice() {
            const btcElement = document.getElementById('btcPrice');
            let currentPrice = 68000; // Starting mock price

            // Simulate random fluctuation
            currentPrice += (Math.random() - 0.5) * 1000; 
            const formattedPrice = `$${Math.round(currentPrice / 100) * 100}.00`;

            btcElement.innerHTML = `
                <span style="color: ${Math.random() > 0.5 ? '#28a745' : '#dc3545'};">
                    ${(currentPrice > 68000) ? '▲' : '▼'}
                </span> 
                ${formattedPrice}
            `;

            // Schedule the next update (simulating real-time polling every 15 seconds)
            setTimeout(fetchBitcoinPrice, 15000); 
        }


        /**
         * MOCK API function to simulate fetching NASDAQ stock data.
         * In a real application, this would use 'financialdata' endpoints.
         */
        function fetchNasdaqStock() {
            const nasdaqElement = document.getElementById('nasdaqPrice');
            let currentValue = 15000; // Starting mock index

            // Simulate random fluctuation
            currentValue += (Math.random() - 0.5) * 50; 
            const formattedIndex = `${Math.round(currentValue)} Pts`;

            nasdaqElement.innerHTML = `
                <span style="color: ${Math.random() > 0.5 ? '#28a745' : '#dc3545'};">
                    ${(currentValue > 15000) ? '▲' : '▼'}
                </span> 
                ${formattedIndex}
            `;

             // Schedule the next update (simulating real-time polling every 15 seconds)
            setTimeout(fetchNasdaqStock, 15000);
        }


        /**
         * Placeholder function to simulate fetching system data.
         * NOTE: Reading actual hardware stats requires backend languages (Python/Node.js), not vanilla JS in the browser.
         */
        function updateSystemStats() {
            // This simply simulates changing values over time for a better visual effect.

            const cpuLoad = Math.floor(Math.random(10, 50));
            document.getElementById('cpuLoad').textContent = `${cpuLoad}%`;

            const memoryLoad = Math.floor(Math.random(30, 70));
            document.getElementById('memoryLoad').textContent = `${memoryLoad}%`;

             // Simple date calculation for uptime placeholder
            const daysAgo = Math.floor(Math.random(1, 5));
            const hours = Math.floor(Math.random(8, 22));
            document.getElementById('uptimeHours').textContent = `${hours}h`;


            // Set the interval to run this update every few seconds
             setTimeout(updateSystemStats, 3000); // Update stats every 3 seconds
        }

        /**
         * Initializes all dynamic widgets and stat updates when the page loads.
         */
        function initializeDashboard() {
            // Start data fetching/mocking functions
            fetchBitcoinPrice();
            fetchNasdaqStock();
            updateSystemStats();
        }

        // Call the initialization function when the DOM is fully loaded
        document.addEventListener('DOMContentLoaded', initializeDashboard);


        /* 
         * ==========================================
         * START EDITING HERE!
         * To change a service tile, simply update:
         * - The text inside the <h5> tag.
         * - The paragraph content <p>.
         * - The `href` attribute of the entire <a> tag (e.g., target="_blank" and href="http://new-service.local/").
         * ==========================================
        */

    </script>
</body>
</html>
```