
# Homelab Dashboard
- Qwen3-coder-30b
- Qwen3
- Medium-sized LLM

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
None

### Code
Save as index.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HomeLab Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #121212;
            color: #e0e0e0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .dashboard-container {
            padding: 20px;
        }
        
        .tile {
            background: linear-gradient(145deg, #1e1e1e, #2d2d2d);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            transition: all 0.3s ease;
            border: 1px solid #333;
        }
        
        .tile:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 100, 255, 0.2);
            border-color: #007bff;
        }
        
        .tile h3 {
            margin-bottom: 15px;
            color: #00bfff;
        }
        
        .tile i {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: #00bfff;
        }
        
        .tile a {
            text-decoration: none;
            color: inherit;
        }
        
        .tile a:hover {
            color: #00bfff;
        }
        
        .price-widget {
            background: linear-gradient(145deg, #1e1e1e, #2d2d2d);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            border: 1px solid #333;
        }
        
        .price-widget h3 {
            margin-bottom: 15px;
            color: #00bfff;
        }
        
        .price-value {
            font-size: 1.8rem;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .price-change {
            font-size: 1.2rem;
            margin-top: 5px;
        }
        
        .positive {
            color: #4caf50;
        }
        
        .negative {
            color: #f44336;
        }
        
        .stats-container {
            background: linear-gradient(145deg, #1e1e1e, #2d2d2d);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            border: 1px solid #333;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .stat-card {
            background-color: #2a2a2a;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
        }
        
        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #aaa;
        }
        
        .footer {
            text-align: center;
            padding: 20px;
            color: #aaa;
            font-size: 0.9rem;
        }
        
        .header {
            background: linear-gradient(90deg, #0a0a2a, #1a1a3a);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }
        
        .header h1 {
            color: #00bfff;
            font-weight: bold;
        }
        
        .header p {
            color: #aaa;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header text-center">
            <h1><i class="fas fa-home"></i> HomeLab Dashboard</h1>
            <p>Your personal homelab monitoring center</p>
        </div>
        
        <div class="row">
            <!-- Service Tiles -->
            <div class="col-md-4 mb-3">
                <div class="tile">
                    <a href="http://your-nas-ip:5000" target="_blank">
                        <i class="fas fa-server"></i>
                        <h3>NAS Storage</h3>
                        <p>Access your network-attached storage</p>
                    </a>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="tile">
                    <a href="http://your-home-assistant-ip:8123" target="_blank">
                        <i class="fas fa-home"></i>
                        <h3>Home Assistant</h3>
                        <p>Smart home automation dashboard</p>
                    </a>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="tile">
                    <a href="http://your-plex-ip:32400" target="_blank">
                        <i class="fas fa-film"></i>
                        <h3>Plex Media Server</h3>
                        <p>Media streaming and management</p>
                    </a>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="tile">
                    <a href="http://your-nginx-ip:80" target="_blank">
                        <i class="fas fa-globe"></i>
                        <h3>Web Server</h3>
                        <p>Public website and services</p>
                    </a>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="tile">
                    <a href="http://your-portainer-ip:9000" target="_blank">
                        <i class="fas fa-docker"></i>
                        <h3>Portainer</h3>
                        <p>Docker container management</p>
                    </a>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="tile">
                    <a href="http://your-jellyfin-ip:8096" target="_blank">
                        <i class="fas fa-music"></i>
                        <h3>Jellyfin</h3>
                        <p>Media server for music and videos</p>
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Price Widgets -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <div class="price-widget">
                    <h3><i class="fab fa-bitcoin"></i> Bitcoin Price</h3>
                    <div class="price-value">$42,123.56</div>
                    <div class="price-change positive">+2.3% (24h)</div>
                </div>
            </div>
            
            <div class="col-md-6 mb-3">
                <div class="price-widget">
                    <h3><i class="fas fa-chart-line"></i> NASDAQ Price</h3>
                    <div class="price-value">$14,256.87</div>
                    <div class="price-change negative">-0.8% (24h)</div>
                </div>
            </div>
        </div>
        
        <!-- System Stats -->
        <div class="stats-container">
            <h3><i class="fas fa-tachometer-alt"></i> System Statistics</h3>
            <div class="stats-grid">
                <div class="stat-card">
                    <i class="fas fa-microchip"></i>
                    <div class="stat-value">85%</div>
                    <div class="stat-label">CPU Usage</div>
                </div>
                
                <div class="stat-card">
                    <i class="fas fa-memory"></i>
                    <div class="stat-value">42%</div>
                    <div class="stat-label">RAM Usage</div>
                </div>
                
                <div class="stat-card">
                    <i class="fas fa-hdd"></i>
                    <div class="stat-value">68%</div>
                    <div class="stat-label">Disk Usage</div>
                </div>
                
                <div class="stat-card">
                    <i class="fas fa-temperature-high"></i>
                    <div class="stat-value">68°C</div>
                    <div class="stat-label">Temperature</div>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p>HomeLab Dashboard v1.0 | Last updated: Today</p>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Simulate live updates for price widgets
        function updatePrices() {
            // Update Bitcoin price (simulated)
            const bitcoinElement = document.querySelector('.price-widget:nth-child(1) .price-value');
            const bitcoinChange = document.querySelector('.price-widget:nth-child(1) .price-change');
            
            // Simulate small price fluctuations
            const currentPrice = parseFloat(bitcoinElement.textContent.replace(/[^0-9.]/g, ''));
            const change = (Math.random() - 0.5) * 100;
            const newPrice = currentPrice + change;
            
            bitcoinElement.textContent = '$' + newPrice.toLocaleString('en-US', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });
            
            // Update change indicator
            const changePercent = (change / currentPrice * 100).toFixed(2);
            bitcoinChange.textContent = `${changePercent > 0 ? '+' : ''}${changePercent}% (24h)`;
            bitcoinChange.className = `price-change ${changePercent > 0 ? 'positive' : 'negative'}`;
            
            // Update NASDAQ price (simulated)
            const nasdaqElement = document.querySelector('.price-widget:nth-child(2) .price-value');
            const nasdaqChange = document.querySelector('.price-widget:nth-child(2) .price-change');
            
            const currentNasdaq = parseFloat(nasdaqElement.textContent.replace(/[^0-9.]/g, ''));
            const nasdaqChangePercent = (Math.random() - 0.5) * 0.5;
            const newNasdaq = currentNasdaq + (currentNasdaq * nasdaqChangePercent / 100);
            
            nasdaqElement.textContent = '$' + newNasdaq.toLocaleString('en-US', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });
            
            // Update change indicator
            const nasdaqChangePercentText = (nasdaqChangePercent).toFixed(2);
            nasdaqChange.textContent = `${nasdaqChangePercentText > 0 ? '+' : ''}${nasdaqChangePercentText}% (24h)`;
            nasdaqChange.className = `price-change ${nasdaqChangePercentText > 0 ? 'positive' : 'negative'}`;
            
            // Update system stats (simulated)
            const cpuElement = document.querySelector('.stat-card:nth-child(1) .stat-value');
            const ramElement = document.querySelector('.stat-card:nth-child(2) .stat-value');
            const diskElement = document.querySelector('.stat-card:nth-child(3) .stat-value');
            
            // Simulate random values
            const cpuValue = Math.floor(Math.random() * 30) + 70;
            const ramValue = Math.floor(Math.random() * 20) + 30;
            const diskValue = Math.floor(Math.random() * 15) + 60;
            
            cpuElement.textContent = `${cpuValue}%`;
            ramElement.textContent = `${ramValue}%`;
            diskElement.textContent = `${diskValue}%`;
            
            // Update timestamp
            const footer = document.querySelector('.footer');
            const now = new Date();
            footer.innerHTML = `<p>HomeLab Dashboard v1.0 | Last updated: ${now.toLocaleTimeString()}</p>`;
        }
        
        // Update prices every 10 seconds
        setInterval(updatePrices, 10000);
        
        // Initial update
        updatePrices();
    </script>
</body>
</html>

```  
---

## Stats
- Qwen3-coder-30b took all 32GB Unified Memory
- tok/sec
- Notes

